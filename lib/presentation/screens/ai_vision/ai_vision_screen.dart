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
          'AI 도우미',
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
                      'AI 도우미가 도와드려요',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '사진을 찍어서 문자를 읽거나\n약물을 식별할 수 있어요',
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
              title: '문자 읽기',
              subtitle: '사진 속 글자를\n음성으로 읽어드려요',
              icon: Icons.text_fields,
              color: TossColors.blue500,
              onTap: () => _startTextRecognition(),
            ),
            _buildFeatureCard(
              title: '약물 식별',
              subtitle: '약의 이름과 복용법을\n알려드려요',
              icon: Icons.medication,
              color: TossColors.green500,
              onTap: () => _startMedicationRecognition(),
            ),
            _buildFeatureCard(
              title: '사물 인식',
              subtitle: '주변 사물을\n설명해드려요',
              icon: Icons.camera_alt,
              color: TossColors.orange500,
              onTap: () => _startObjectRecognition(),
            ),
            _buildFeatureCard(
              title: '색깔 구분',
              subtitle: '물건의 색깔을\n알려드려요',
              icon: Icons.palette,
              color: TossColors.purple500,
              onTap: () => _startColorRecognition(),
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
    await accessibility.speak('문자 읽기 기능을 시작합니다');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    // Mock processing delay
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _lastResult = '분석 결과: "혈압약 하루 2회 복용하세요. 아침 저녁 식후 30분"';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('문자 읽기가 완료되었습니다'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  Future<void> _startMedicationRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('약물 식별 기능을 시작합니다');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 4));

    setState(() {
      _isProcessing = false;
      _lastResult = '식별된 약물: 아스피린 100mg, 하루 1회 복용, 혈관 질환 예방용';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('약물 식별이 완료되었습니다'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  Future<void> _startObjectRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('사물 인식 기능을 시작합니다');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isProcessing = false;
      _lastResult = '인식된 사물: 파란색 물컵, 테이블 위에 놓여있음';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사물 인식이 완료되었습니다'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  Future<void> _startColorRecognition() async {
    final accessibility = context.read<AccessibilityProvider>();
    await accessibility.speak('색깔 구분 기능을 시작합니다');

    setState(() {
      _isProcessing = true;
    });

    _animationController.repeat();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _lastResult = '색깔 분석: 주된 색상은 파란색이며, 밝은 하늘색에 가깝습니다';
    });

    _animationController.stop();
    _animationController.reset();

    await accessibility.speak(_lastResult!);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('색깔 구분이 완료되었습니다'),
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
            Text('AI 도우미 사용법', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📖 문자 읽기', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 문서나 약품 설명서의 글자를 읽어드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text('💊 약물 식별', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 약의 모양과 색상으로 약품명을 알려드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text('📷 사물 인식', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 주변 사물이 무엇인지 설명해드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text('🎨 색깔 구분', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            Text('• 물건의 색깔을 자세히 알려드려요', style: TextStyle(fontSize: 13)),
            SizedBox(height: 16),
            Text('💡 팁: 모든 결과는 음성으로도 들을 수 있어요!',
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