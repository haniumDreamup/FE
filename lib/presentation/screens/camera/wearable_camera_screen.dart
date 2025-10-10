import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
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

  /// ESP32-CAM 연결 테스트
  Future<void> _connectToCamera() async {
    final ip = _ipController.text.trim();

    if (ip.isEmpty) {
      _showError('IP 주소를 입력해주세요');
      return;
    }

    try {
      // /status 엔드포인트로 연결 테스트
      final dio = Dio();
      final response = await dio.get(
        'http://$ip/status',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        await _saveIp(ip);
        setState(() {
          _esp32CamIp = ip;
          _isConnected = true;
        });

        if (mounted) {
          final accessibility = context.read<AccessibilityProvider>();
          await accessibility.speak('카메라 연결 성공');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ 카메라 연결 성공'),
              backgroundColor: TossTheme.tossGreen,
            ),
          );
        }
      }
    } catch (e) {
      _showError('카메라 연결 실패: ${e.toString()}');
    }
  }

  /// ESP32-CAM에서 사진 촬영
  Future<void> _captureAndAnalyze() async {
    if (_esp32CamIp == null) {
      _showError('먼저 카메라를 연결해주세요');
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final accessibility = context.read<AccessibilityProvider>();
      await accessibility.speak('사진을 촬영하고 분석하고 있어요');

      // ESP32-CAM에서 정지 이미지 촬영
      final dio = Dio();
      final response = await dio.get(
        'http://$_esp32CamIp/capture',
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final imageBytes = response.data as Uint8List;

        // 백엔드로 이미지 전송 및 분석
        await _analyzeImage(imageBytes);
      }
    } catch (e) {
      _showError('사진 촬영 실패: ${e.toString()}');
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

      // MultipartFile 생성
      final multipartFile = MultipartFile.fromBytes(
        imageBytes,
        filename: 'wearable_camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // FormData 생성 (수정된 부분)
      final formData = FormData.fromMap({
        'image': multipartFile,
      });

      // Dio를 사용한 직접 호출
      final dio = Dio();
      final response = await dio.post(
        'http://43.200.49.171:8080/api/images/analyze',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final description = data['situationDescription'] ?? '이미지를 분석했어요';

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
      body: _isConnected ? _buildCameraView() : _buildConnectionView(),
    );
  }

  /// 카메라 연결 화면
  Widget _buildConnectionView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 100,
            color: TossTheme.tossGray400,
          ),
          const SizedBox(height: 32),
          const Text(
            'ESP32-CAM 연결',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),
          AccessibleButton(
            onPressed: _connectToCamera,
            label: '연결하기',
            backgroundColor: TossTheme.tossBlue,
            textColor: TossTheme.tossWhite,
            height: 56,
          ),
        ],
      ),
    );
  }

  /// 카메라 뷰 화면
  Widget _buildCameraView() {
    final streamUrl = 'http://$_esp32CamIp:81/stream';

    return Column(
      children: [
        // 실시간 MJPEG 스트리밍
        Expanded(
          child: Container(
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
                onError: (context, error) {
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
        ),

        // 분석 결과 표시
        if (_lastAnalysisResult != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TossTheme.tossBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TossTheme.tossBlue.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: TossTheme.tossBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _lastAnalysisResult!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: TossTheme.tossGray900,
                      fontWeight: FontWeight.w500,
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
    );
  }
}
