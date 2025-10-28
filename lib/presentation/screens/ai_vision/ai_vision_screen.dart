import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/config/toss_theme.dart';
import '../../../data/services/image_analysis_service.dart';
import '../../providers/accessibility_provider.dart';
import '../../widgets/common/accessible_button.dart';

class AiVisionScreen extends StatefulWidget {
  const AiVisionScreen({super.key});

  @override
  State<AiVisionScreen> createState() => _AiVisionScreenState();
}

class _AiVisionScreenState extends State<AiVisionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ImageAnalysisService _imageAnalysisService = ImageAnalysisService();
  bool _isProcessing = false;
  String? _lastResult;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '사진 도우미',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              _showHelpDialog();
            },
            icon: const Icon(Icons.help_outline, size: 28),
            tooltip: '도움말',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildFeatureGrid(),
            const SizedBox(height: 24),
            _buildRecentResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.blue500.withValues(alpha: 0.1),
            TossColors.purple500.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TossColors.blue200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: TossColors.blue500,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '사진 도우미가 도와드려요',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '사진을 찍어서 글자를 읽거나\n물건 이름을 알 수 있어요',
                      style: TextStyle(
                        fontSize: 14,
                        color: TossColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isProcessing) ...[
            const SizedBox(height: 20),
            _buildProcessingIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CircularProgressIndicator(
                value: _animationController.value,
                backgroundColor: TossColors.grey200,
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.blue500),
                strokeWidth: 6,
              );
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'AI가 이미지를 분석하고 있어요...',
            style: TextStyle(
              fontSize: 14,
              color: TossColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '사진 분석하기',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildMainAnalysisButton(),
      ],
    );
  }

  Widget _buildMainAnalysisButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TossColors.blue500, TossColors.purple500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: TossColors.blue500.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isProcessing ? null : _startAnalysis,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '사진 분석하기',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'AI가 사진 속 물건, 글자, 색깔을\n자동으로 분석해드려요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: TossColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '최근 결과',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        if (_lastResult != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.history,
                      color: TossColors.grey600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '마지막 분석 결과',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: TossColors.grey600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Text(
                      _lastResult!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AccessibleButton(
                  onPressed: () async {
                    final accessibility = context.read<AccessibilityProvider>();
                    await accessibility.speak(_lastResult!);
                  },
                  label: '다시 읽기',
                  backgroundColor: TossColors.blue100,
                  textColor: TossColors.blue500,
                  height: 40,
                ),
              ],
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: TossColors.grey400,
                ),
                const SizedBox(height: 16),
                const Text(
                  '아직 분석 결과가 없어요',
                  style: TextStyle(
                    fontSize: 16,
                    color: TossColors.grey600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '위의 기능을 사용해보세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: TossColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _startAnalysis() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('사진을 분석할게요');

    // 이미지 소스 선택 다이얼로그 표시
    _showImageSourceDialog('분석');
  }

  Future<void> _pickImage(ImageSource source, String featureType) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() {
        _selectedImage = image;
        _isProcessing = true;
      });

      _animationController.repeat();

      // 로딩 다이얼로그 표시
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: TossColors.blue500),
                const SizedBox(height: 16),
                const Text(
                  '사진을 분석하고 있어요...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '2-3초만 기다려주세요',
                  style: TextStyle(fontSize: 14, color: TossColors.grey600),
                ),
              ],
            ),
          ),
        );
      }

      // 실제 Google Vision API로 이미지 분석
      final imageFile = File(image.path);
      final visionResult = await _imageAnalysisService.visionAnalyze(
        imageFile: imageFile,
      );

      // 백엔드에서 제공하는 간단한 설명 사용 (모든 정보 포함)
      final simpleDescription = visionResult['simpleDescription'] as String?;

      String result = simpleDescription ?? '이미지를 분석했어요';

      String successMessage = '분석이 끝났어요';

      setState(() {
        _isProcessing = false;
        _lastResult = result;
      });

      _animationController.stop();
      _animationController.reset();

      // 로딩 다이얼로그 닫기
      if (mounted) {
        Navigator.of(context).pop();
      }

      final accessibility = context.read<AccessibilityProvider>();
      await accessibility.speak(result);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: TossColors.green500,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _animationController.stop();
      _animationController.reset();

      // 로딩 다이얼로그 닫기
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('분석 실패: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: TossColors.red500,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog(String featureType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.photo_camera, color: TossColors.blue500),
            SizedBox(width: 12),
            Text('사진 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.blue100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt, color: TossColors.blue500),
              ),
              title: const Text('카메라로 찍기', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('새로운 사진을 찍어요'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, featureType);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.purple100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.photo_library, color: TossColors.purple500),
              ),
              title: const Text('갤러리에서 선택', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('저장된 사진을 선택해요'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, featureType);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: TossColors.blue500),
            SizedBox(width: 12),
            Text('사진 도우미 사용법', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📖 글자 읽기', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 사진 속 글자를 소리로 읽어드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text('📷 물건 이름', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 물건이 무엇인지 알려드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text('🎨 색깔 찾기', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 물건의 색깔을 찾아드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text('🏃 운동 도움', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 올바른 자세를 알려드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 16),
            Text('💡 팁: 모든 결과는 소리로도 들을 수 있어요!',
                 style: TextStyle(fontSize: 12, color: TossColors.blue600)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: TossColors.blue500)),
          ),
        ],
      ),
    );
  }
}