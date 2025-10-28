import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/services/image_analysis_service.dart';
import '../../providers/accessibility_provider.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/camera/mjpeg_viewer.dart';

/// 웨어러블 카메라 실시간 스트리밍 화면
/// ESP32-CAM에서 MJPEG 스트리밍 수신 및 이미지 분석
class WearableCameraScreen extends StatefulWidget {
  const WearableCameraScreen({super.key});

  @override
  State<WearableCameraScreen> createState() => _WearableCameraScreenState();
}

class _WearableCameraScreenState extends State<WearableCameraScreen> {
  String? _esp32CamIp;
  bool _isConnected = false;
  bool _isAnalyzing = false;
  String? _lastAnalysisResult;
  bool _useLocalCamera = false; // 로컬 카메라 사용 여부
  XFile? _selectedLocalImage;
  Uint8List? _lastFrame; // ESP32-CAM에서 받은 최신 프레임

  // 자동 촬영 관련
  bool _isAutoCapturing = false;
  Timer? _autoCaptureTimer;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  final TextEditingController _ipController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
    _initializeCamera();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _autoCaptureTimer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  /// 카메라 초기화
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras!.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('카메라 초기화 실패: $e');
    }
  }

  /// 자동 촬영 시작
  void _startAutoCapture() {
    setState(() {
      _isAutoCapturing = true;
    });

    _autoCaptureTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_isAutoCapturing || !_isCameraInitialized) {
        timer.cancel();
        return;
      }
      await _captureAndSend();
    });

    // 즉시 첫 촬영
    _captureAndSend();
  }

  /// 자동 촬영 중지
  void _stopAutoCapture() {
    setState(() {
      _isAutoCapturing = false;
    });
    _autoCaptureTimer?.cancel();
  }

  /// 카메라로 촬영하고 서버로 전송
  Future<void> _captureAndSend() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      final imageBytes = await image.readAsBytes();

      // 백엔드로 이미지 전송 및 분석
      await _analyzeImage(imageBytes);
    } catch (e) {
      print('자동 촬영 실패: $e');
    }
  }

  /// 저장된 ESP32-CAM IP 주소 불러오기
  Future<void> _loadSavedIp() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('esp32_cam_ip');
    if (savedIp != null && savedIp.isNotEmpty) {
      setState(() {
        _esp32CamIp = savedIp;
        _isConnected = true;
        _ipController.text = savedIp;
      });
    }
  }

  /// ESP32-CAM IP 주소 저장
  Future<void> _saveIp(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('esp32_cam_ip', ip);
  }

  /// ESP32-CAM 연결 (IP 저장 및 스트리밍 시작)
  Future<void> _connectToCamera() async {
    final ip = _ipController.text.trim();

    if (ip.isEmpty) {
      _showError('IP 주소를 입력해주세요');
      return;
    }

    print('[웨어러블 카메라] 연결 시도: $ip');

    try {
      // IP 저장하고 바로 스트리밍 화면으로 전환
      // (ESP32-CAM은 루트 경로에 응답하지 않을 수 있으므로 스트리밍으로 직접 확인)
      await _saveIp(ip);

      setState(() {
        _esp32CamIp = ip;
        _isConnected = true;
      });

      print('[웨어러블 카메라] IP 저장 완료, 스트리밍 시작: $ip');

      if (mounted) {
        final accessibility = context.read<AccessibilityProvider>();
        await accessibility.speak('카메라에 연결합니다');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 카메라 스트리밍을 시작합니다'),
            backgroundColor: TossTheme.tossBlue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('[웨어러블 카메라] 예상치 못한 에러: $e');
      _showError('카메라 연결 실패: ${e.toString()}');
    }
  }

  /// ESP32-CAM에서 사진 촬영 (스트림에서 받은 최신 프레임 사용)
  Future<void> _captureAndAnalyze() async {
    if (_esp32CamIp == null) {
      _showError('먼저 카메라를 연결해주세요');
      return;
    }

    if (_lastFrame == null) {
      _showError('프레임을 받지 못했습니다. 잠시 후 다시 시도해주세요');
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final accessibility = context.read<AccessibilityProvider>();
      await accessibility.speak('사진을 분석하고 있어요');

      print('[웨어러블 카메라] 저장된 프레임으로 분석 시작: ${_lastFrame!.length} bytes');

      // 백엔드로 이미지 전송 및 분석
      await _analyzeImage(_lastFrame!);
    } catch (e) {
      print('[웨어러블 카메라] 사진 분석 실패: $e');
      _showError('사진 분석 실패: ${e.toString()}');
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  /// 백엔드 이미지 분석 API 호출
  Future<void> _analyzeImage(Uint8List imageBytes) async {
    try {
      final imageService = ImageAnalysisService();

      // 임시 파일 생성
      final tempDir = await Directory.systemTemp.createTemp('wearable_camera_');
      final tempFile = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(imageBytes);

      // ImageAnalysisService를 통해 Vision API 호출
      final visionResult = await imageService.visionAnalyze(
        imageFile: tempFile,
      );

      // 임시 파일 삭제
      await tempFile.delete();
      await tempDir.delete();

      // 백엔드에서 제공하는 간단한 설명 사용
      final simpleDescription = visionResult['simpleDescription'] as String?;
      final description = simpleDescription ?? '이미지를 분석했어요';

      setState(() {
        _lastAnalysisResult = description;
      });

      // TTS 음성 안내
      if (mounted) {
        final accessibility = context.read<AccessibilityProvider>();
        await accessibility.speak(description);
      }

      // 성공 메시지
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 분석 완료'),
            backgroundColor: TossTheme.tossGreen,
          ),
        );
      }
    } catch (e) {
      _showError('이미지 분석 실패: ${e.toString()}');
    }
  }

  /// 에러 메시지 표시
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: TossTheme.tossRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossTheme.tossGray50,
      appBar: AppBar(
        title: const Text(
          '웨어러블 카메라',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TossTheme.tossWhite,
        actions: [
          if (_isConnected)
            IconButton(
              onPressed: () {
                setState(() {
                  _isConnected = false;
                  _esp32CamIp = null;
                });
              },
              icon: const Icon(Icons.settings),
              tooltip: '설정',
            ),
        ],
      ),
      body: _buildCameraSelectionView(),
    );
  }

  /// 카메라 소스 선택 및 뷰
  Widget _buildCameraSelectionView() {
    return Column(
      children: [
        // 카메라 소스 토글
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: TossTheme.tossGray200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _useLocalCamera = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_useLocalCamera
                          ? TossTheme.tossWhite
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: !_useLocalCamera
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.router,
                          color: !_useLocalCamera
                              ? TossTheme.tossBlue
                              : TossTheme.tossGray600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '외부 카메라',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: !_useLocalCamera
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: !_useLocalCamera
                                ? TossTheme.tossBlue
                                : TossTheme.tossGray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _useLocalCamera = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _useLocalCamera
                          ? TossTheme.tossWhite
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: _useLocalCamera
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone_android,
                          color: _useLocalCamera
                              ? TossTheme.tossBlue
                              : TossTheme.tossGray600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '로컬 카메라',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _useLocalCamera
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _useLocalCamera
                                ? TossTheme.tossBlue
                                : TossTheme.tossGray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 선택된 카메라 뷰 표시
        Expanded(
          child: _useLocalCamera
              ? _buildLocalCameraView()
              : (_isConnected ? _buildCameraView() : _buildConnectionView()),
        ),
      ],
    );
  }

  /// 로컬 카메라 뷰
  Widget _buildLocalCameraView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 카메라 프리뷰
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: TossTheme.tossGray100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: TossTheme.tossShadowMedium,
              ),
              child: _isCameraInitialized && _cameraController != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_cameraController!),
                          if (_isAutoCapturing)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: TossTheme.tossRed,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: TossTheme.tossWhite,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      '촬영 중',
                                      style: TextStyle(
                                        color: TossTheme.tossWhite,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt,
                            size: 64,
                            color: TossTheme.tossGray400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '카메라를 초기화하는 중...',
                            style: TextStyle(
                              fontSize: 16,
                              color: TossTheme.tossGray600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // 분석 결과 표시
            if (_lastAnalysisResult != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: TossTheme.tossWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: TossTheme.tossBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: TossTheme.tossBlue,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'AI 분석 결과',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TossTheme.tossGray900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: TossTheme.tossGray50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _lastAnalysisResult!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: TossTheme.tossGray900,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // 제어 버튼
            AccessibleButton(
              onPressed: _isCameraInitialized
                  ? (_isAutoCapturing ? _stopAutoCapture : _startAutoCapture)
                  : null,
              label: _isAutoCapturing ? '자동 촬영 중지' : '10초마다 자동 촬영 시작',
              backgroundColor: _isAutoCapturing
                  ? TossTheme.tossRed
                  : TossTheme.tossGreen,
              textColor: TossTheme.tossWhite,
              height: 56,
              icon: _isAutoCapturing ? Icons.stop : Icons.play_arrow,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 로컬 이미지 선택
  Future<void> _pickLocalImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedLocalImage = image;
          _lastAnalysisResult = null; // 새 이미지 선택 시 이전 결과 초기화
        });

        final accessibility = context.read<AccessibilityProvider>();
        await accessibility.speak('사진을 선택했어요');
      }
    } catch (e) {
      _showError('사진 선택 실패: ${e.toString()}');
    }
  }

  /// 로컬 이미지 분석
  Future<void> _analyzeLocalImage() async {
    if (_selectedLocalImage == null) {
      _showError('먼저 사진을 선택해주세요');
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final accessibility = context.read<AccessibilityProvider>();
      await accessibility.speak('사진을 분석하고 있어요');

      // 이미지 파일을 바이트로 읽기
      final imageBytes = await _selectedLocalImage!.readAsBytes();

      // 백엔드로 이미지 전송 및 분석
      await _analyzeImage(imageBytes);
    } catch (e) {
      _showError('이미지 분석 실패: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  /// 카메라 연결 화면
  Widget _buildConnectionView() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: TossTheme.tossGray400,
            ),
            const SizedBox(height: 24),
            const Text(
              'ESP32-CAM 연결',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ESP32-CAM의 IP 주소를 입력하세요',
              style: TextStyle(
                fontSize: 16,
                color: TossTheme.tossGray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                hintText: '예: 192.168.1.100',
                prefixIcon: const Icon(Icons.wifi),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            AccessibleButton(
              onPressed: _connectToCamera,
              label: '연결하기',
              backgroundColor: TossTheme.tossBlue,
              textColor: TossTheme.tossWhite,
              height: 56,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 카메라 뷰 화면
  Widget _buildCameraView() {
    final streamUrl = 'http://$_esp32CamIp/';

    return SingleChildScrollView(
      child: Column(
        children: [
          // 실시간 MJPEG 스트리밍
          Container(
            height: 400,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossTheme.tossBlack,
              borderRadius: BorderRadius.circular(20),
              boxShadow: TossTheme.tossShadowMedium,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MjpegViewer(
                streamUrl: streamUrl,
                onFrameReceived: (frame) {
                  // 스트림에서 받은 최신 프레임 저장
                  setState(() {
                    _lastFrame = frame;
                  });
                },
                onError: (context, error) {
                  print('[웨어러블 카메라] MJPEG 스트리밍 에러: $error');
                  print('[웨어러블 카메라] 스트리밍 URL: $streamUrl');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: TossTheme.tossGray400,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '카메라 스트리밍 오류',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TossTheme.tossWhite,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: TossTheme.tossGray400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 분석 결과 표시
          if (_lastAnalysisResult != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TossTheme.tossWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: TossTheme.tossBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: TossTheme.tossBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AI 분석 결과',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TossTheme.tossGray900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TossTheme.tossGray50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _lastAnalysisResult!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: TossTheme.tossGray900,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // 제어 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: AccessibleButton(
                    onPressed: _isAnalyzing ? null : _captureAndAnalyze,
                    label: _isAnalyzing ? '분석 중...' : '사진 분석',
                    backgroundColor: _isAnalyzing
                        ? TossTheme.tossGray300
                        : TossTheme.tossBlue,
                    textColor: TossTheme.tossWhite,
                    height: 56,
                    icon: _isAnalyzing
                        ? Icons.hourglass_empty
                        : Icons.camera_alt,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 연결 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TossTheme.tossGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: TossTheme.tossGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '연결됨: $_esp32CamIp',
                    style: const TextStyle(
                      fontSize: 14,
                      color: TossTheme.tossGray700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
