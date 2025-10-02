import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 모드 관리 Provider
class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  ThemeProvider() {
    _loadThemeMode();
  }

  /// SharedPreferences에서 테마 모드 로드
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);

      if (savedMode != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedMode,
          orElse: () => ThemeMode.light,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('테마 모드 로드 실패: $e');
    }
  }

  /// 테마 모드 변경
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    // SharedPreferences에 저장
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.toString());
    } catch (e) {
      debugPrint('테마 모드 저장 실패: $e');
    }
  }

  /// 다크모드 토글
  Future<void> toggleDarkMode() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// 라이트 모드로 설정
  Future<void> setLightMode() async {
    await setThemeMode(ThemeMode.light);
  }

  /// 다크 모드로 설정
  Future<void> setDarkMode() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// 시스템 설정 따르기
  Future<void> setSystemMode() async {
    await setThemeMode(ThemeMode.system);
  }

  /// 테마 모드 문자열 가져오기
  String get themeModeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return '라이트';
      case ThemeMode.dark:
        return '다크';
      case ThemeMode.system:
        return '시스템 설정';
    }
  }

  /// 테마 모드 설명
  String get themeModeDescription {
    switch (_themeMode) {
      case ThemeMode.light:
        return '밝은 테마를 사용합니다';
      case ThemeMode.dark:
        return '어두운 테마를 사용합니다';
      case ThemeMode.system:
        return '기기 설정을 따릅니다';
    }
  }

  /// 테마 모드 아이콘
  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
