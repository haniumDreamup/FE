import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
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
  bool _isProcessing = false;
  String? _lastResult;

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
          '기능 선택',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureCard(
              title: '글자 읽기',
              subtitle: '사진 속 글자를\n소리로 읽어드려요',
              icon: Icons.text_fields,
              color: TossColors.blue500,
              onTap: () => _startTextRecognition(),
            ),
            _buildFeatureCard(
              title: '물건 이름',
              subtitle: '물건 이름을\n알려드려요',
              icon: Icons.camera_alt,
              color: TossColors.orange500,
              onTap: () => _startObjectRecognition(),
            ),
            _buildFeatureCard(
              title: '색깔 찾기',
              subtitle: '물건의 색깔을\n알려드려요',
              icon: Icons.palette,
              color: TossColors.purple500,
              onTap: () => _startColorRecognition(),
            ),
            _buildFeatureCard(
              title: '운동 도움',
              subtitle: '올바른 자세를\n알려드려요',
              icon: Icons.accessibility_new,
              color: TossColors.green500,
              onTap: () => _startPoseRecognition(),
            ),
          ],
        ),
      ],
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
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: TossColors.grey600,
                  ),
                  textAlign: TextAlign.center,
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
                Text(
                  _lastResult!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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

  Future<void> _startTextRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('글자 읽기를 시작해요');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    // Mock processing delay
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _lastResult = '읽은 글자: "하루 2번 아침 저녁으로 드세요"';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('글자 읽기가 끝났어요'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  Future<void> _startObjectRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('물건 이름을 찾고 있어요');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _lastResult = '찾은 물건: 파란색 물컵';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('물건 이름을 찾았어요'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  Future<void> _startColorRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('색깔을 찾고 있어요');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _lastResult = '찾은 색깔: 밝은 파란색';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('색깔을 찾았어요'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  Future<void> _startPoseRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('자세를 확인하고 있어요');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _lastResult = '자세 확인: 등이 조금 구부러졌어요. 허리를 펴보세요';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('자세 확인이 끝났어요'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
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