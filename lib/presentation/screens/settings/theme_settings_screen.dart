import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../providers/theme_provider.dart';

/// 테마 설정 화면
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 설정'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 현재 테마 미리보기
              _CurrentThemePreview(themeProvider: themeProvider),
              const SizedBox(height: 24),

              // 테마 선택 카드
              _ThemeOptionCard(
                title: '라이트 모드',
                description: '밝은 테마를 사용합니다',
                icon: Icons.light_mode,
                isSelected: themeProvider.isLightMode,
                onTap: () => themeProvider.setLightMode(),
                color: TossTheme.tossBlue,
              ),
              const SizedBox(height: 12),

              _ThemeOptionCard(
                title: '다크 모드',
                description: '어두운 테마를 사용합니다',
                icon: Icons.dark_mode,
                isSelected: themeProvider.isDarkMode,
                onTap: () => themeProvider.setDarkMode(),
                color: TossTheme.tossGray800,
              ),
              const SizedBox(height: 12),

              _ThemeOptionCard(
                title: '시스템 설정',
                description: '기기 설정을 따릅니다',
                icon: Icons.brightness_auto,
                isSelected: themeProvider.isSystemMode,
                onTap: () => themeProvider.setSystemMode(),
                color: TossTheme.tossPurple,
              ),
              const SizedBox(height: 32),

              // 추가 정보
              _ThemeInfo(),
            ],
          );
        },
      ),
    );
  }
}

/// 현재 테마 미리보기
class _CurrentThemePreview extends StatelessWidget {
  final ThemeProvider themeProvider;

  const _CurrentThemePreview({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? TossTheme.tossGray800 : TossTheme.tossWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TossTheme.tossGray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            themeProvider.themeModeIcon,
            size: 64,
            color: TossTheme.tossBlue,
          ),
          const SizedBox(height: 16),
          Text(
            '현재: ${themeProvider.themeModeString}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            themeProvider.themeModeDescription,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? TossTheme.tossGray400 : TossTheme.tossGray600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 테마 옵션 카드
class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _ThemeOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? TossTheme.tossGray800 : TossTheme.tossGray50)
                : (isDark ? TossTheme.tossGray900 : TossTheme.tossWhite),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? TossTheme.tossBlue : TossTheme.tossGray200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withOpacity(0.2)
                      : (isDark ? TossTheme.tossGray800 : TossTheme.tossGray100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? color : TossTheme.tossGray500,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? (isDark ? TossTheme.tossWhite : TossTheme.tossGray900)
                            : TossTheme.tossGray700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? TossTheme.tossGray400 : TossTheme.tossGray600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: TossTheme.tossBlue,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 테마 정보
class _ThemeInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TossTheme.tossBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: TossTheme.tossBlue,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                '테마 안내',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• 라이트 모드: 밝은 환경에서 편안한 사용\n'
            '• 다크 모드: 어두운 환경에서 눈의 피로 감소\n'
            '• 시스템 설정: 기기 설정에 맞춰 자동 변경',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? TossTheme.tossGray300 : TossTheme.tossGray700,
            ),
          ),
        ],
      ),
    );
  }
}
