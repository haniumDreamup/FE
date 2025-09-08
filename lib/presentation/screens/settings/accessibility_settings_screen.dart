import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/accessibility_provider.dart';
import '../../../core/config/toss_theme.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, provider, child) {
        final theme = provider.highContrastEnabled 
            ? _getHighContrastTheme() 
            : Theme.of(context);
            
        return Theme(
          data: theme.copyWith(
            textTheme: theme.textTheme.apply(
              fontSizeFactor: provider.textScaleFactor,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '접근성 설정',
                style: TextStyle(
                  fontSize: 24.sp * provider.textScaleFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: provider.highContrastEnabled 
                  ? Colors.black 
                  : TossTheme.primaryColor,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('시각 설정', provider),
                  _buildSettingCard(
                    title: '큰 글씨',
                    subtitle: '글씨를 크게 표시합니다',
                    icon: Icons.text_fields,
                    value: provider.largeTextEnabled,
                    onChanged: (value) {
                      provider.setLargeTextEnabled(value);
                    },
                    provider: provider,
                  ),
                  _buildSettingCard(
                    title: '고대비 모드',
                    subtitle: '색상을 더 선명하게 표시합니다',
                    icon: Icons.contrast,
                    value: provider.highContrastEnabled,
                    onChanged: (value) {
                      provider.setHighContrastEnabled(value);
                    },
                    provider: provider,
                  ),
                  _buildTextSizeSlider(provider),
                  
                  SizedBox(height: 24.h),
                  _buildSectionTitle('음성 설정', provider),
                  _buildSettingCard(
                    title: '음성 안내',
                    subtitle: '버튼과 화면을 소리로 알려드립니다',
                    icon: Icons.volume_up,
                    value: provider.voiceGuidanceEnabled,
                    onChanged: (value) async {
                      await provider.setVoiceGuidanceEnabled(value);
                    },
                    provider: provider,
                  ),
                  _buildSettingCard(
                    title: '화면 자동 읽기',
                    subtitle: '새 화면을 자동으로 읽어드립니다',
                    icon: Icons.record_voice_over,
                    value: provider.autoReadScreenEnabled,
                    onChanged: (value) {
                      provider.setAutoReadScreenEnabled(value);
                    },
                    provider: provider,
                  ),
                  if (provider.voiceGuidanceEnabled) ...[
                    _buildSpeechRateSlider(provider),
                    _buildVolumeSlider(provider),
                  ],
                  
                  SizedBox(height: 24.h),
                  _buildSectionTitle('사용 편의', provider),
                  _buildSettingCard(
                    title: '간단한 화면',
                    subtitle: '꼭 필요한 기능만 보여드립니다',
                    icon: Icons.dashboard_customize,
                    value: provider.simplifiedUIEnabled,
                    onChanged: (value) {
                      provider.setSimplifiedUIEnabled(value);
                    },
                    provider: provider,
                  ),
                  _buildSettingCard(
                    title: '진동 알림',
                    subtitle: '중요한 알림에 진동을 사용합니다',
                    icon: Icons.vibration,
                    value: provider.vibrationEnabled,
                    onChanged: (value) {
                      provider.setVibrationEnabled(value);
                    },
                    provider: provider,
                  ),
                  
                  SizedBox(height: 32.h),
                  _buildResetButton(context, provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, AccessibilityProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp * provider.textScaleFactor,
          fontWeight: FontWeight.bold,
          color: provider.highContrastEnabled ? Colors.black : TossTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required AccessibilityProvider provider,
  }) {
    return Card(
      elevation: provider.highContrastEnabled ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: provider.highContrastEnabled 
            ? BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: provider.highContrastEnabled 
                ? Colors.black 
                : TossTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 28.sp * provider.textScaleFactor,
            color: provider.highContrastEnabled 
                ? Colors.white 
                : TossTheme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp * provider.textScaleFactor,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp * provider.textScaleFactor,
            color: provider.highContrastEnabled 
                ? Colors.black87 
                : Colors.grey[600],
          ),
        ),
        trailing: Transform.scale(
          scale: 1.2 * provider.textScaleFactor,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: provider.highContrastEnabled 
                ? Colors.black 
                : TossTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTextSizeSlider(AccessibilityProvider provider) {
    return Card(
      elevation: provider.highContrastEnabled ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: provider.highContrastEnabled 
            ? BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '글자 크기',
                  style: TextStyle(
                    fontSize: 18.sp * provider.textScaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: provider.highContrastEnabled 
                        ? Colors.black 
                        : TossTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${(provider.textScaleFactor * 100).round()}%',
                    style: TextStyle(
                      fontSize: 16.sp * provider.textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: provider.highContrastEnabled 
                          ? Colors.white 
                          : TossTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text('가', style: TextStyle(fontSize: 14.sp)),
                Expanded(
                  child: Slider(
                    value: provider.textScaleFactor,
                    min: 0.8,
                    max: 2.0,
                    divisions: 12,
                    label: '${(provider.textScaleFactor * 100).round()}%',
                    activeColor: provider.highContrastEnabled 
                        ? Colors.black 
                        : TossTheme.primaryColor,
                    onChanged: (value) {
                      provider.setTextScaleFactor(value);
                    },
                  ),
                ),
                Text('가', style: TextStyle(fontSize: 24.sp)),
              ],
            ),
            Center(
              child: Text(
                '이 글자가 잘 보이시나요?',
                style: TextStyle(
                  fontSize: 16.sp * provider.textScaleFactor,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechRateSlider(AccessibilityProvider provider) {
    return Card(
      elevation: provider.highContrastEnabled ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: provider.highContrastEnabled 
            ? BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '말하기 속도',
              style: TextStyle(
                fontSize: 18.sp * provider.textScaleFactor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.speed, size: 20.sp),
                Expanded(
                  child: Slider(
                    value: provider.speechRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: _getSpeechRateLabel(provider.speechRate),
                    activeColor: provider.highContrastEnabled 
                        ? Colors.black 
                        : TossTheme.primaryColor,
                    onChanged: (value) async {
                      await provider.setSpeechRate(value);
                      provider.speak('이 속도로 말할게요');
                    },
                  ),
                ),
                Text(
                  _getSpeechRateLabel(provider.speechRate),
                  style: TextStyle(fontSize: 14.sp * provider.textScaleFactor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(AccessibilityProvider provider) {
    return Card(
      elevation: provider.highContrastEnabled ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: provider.highContrastEnabled 
            ? BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '음성 크기',
              style: TextStyle(
                fontSize: 18.sp * provider.textScaleFactor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.volume_down, size: 20.sp),
                Expanded(
                  child: Slider(
                    value: provider.volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${(provider.volume * 100).round()}%',
                    activeColor: provider.highContrastEnabled 
                        ? Colors.black 
                        : TossTheme.primaryColor,
                    onChanged: (value) async {
                      await provider.setVolume(value);
                      provider.speak('이 크기로 들리시나요?');
                    },
                  ),
                ),
                Icon(Icons.volume_up, size: 20.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton(BuildContext context, AccessibilityProvider provider) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                '설정 초기화',
                style: TextStyle(fontSize: 20.sp * provider.textScaleFactor),
              ),
              content: Text(
                '모든 접근성 설정을 처음으로 되돌릴까요?',
                style: TextStyle(fontSize: 16.sp * provider.textScaleFactor),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '취소',
                    style: TextStyle(fontSize: 16.sp * provider.textScaleFactor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await provider.resetSettings();
                    Navigator.pop(context);
                  },
                  child: Text(
                    '초기화',
                    style: TextStyle(fontSize: 16.sp * provider.textScaleFactor),
                  ),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.refresh, size: 24.sp * provider.textScaleFactor),
        label: Text(
          '설정 초기화',
          style: TextStyle(fontSize: 16.sp * provider.textScaleFactor),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          backgroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  String _getSpeechRateLabel(double rate) {
    if (rate < 0.3) return '매우 느림';
    if (rate < 0.5) return '느림';
    if (rate < 0.7) return '보통';
    if (rate < 0.9) return '빠름';
    return '매우 빠름';
  }

  ThemeData _getHighContrastTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
      ),
    );
  }
}