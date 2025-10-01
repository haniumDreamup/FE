class AppConfig {
  // 환경별 설정
  static const String _devBaseUrl = 'http://43.200.49.171:8080'; // AWS EC2 서버
  static const String _localBaseUrl = 'http://localhost:8080'; // 로컬 개발용
  static const String _prodBaseUrl = 'https://your-aws-domain.com'; // AWS 프로덕션 (HTTPS)

  // 현재 환경 확인 (Debug/Release 모드)
  static bool get isDev => const bool.fromEnvironment('dart.vm.product') == false;

  // API Base URL - dart-define으로 설정 가능
  static String get baseUrl {
    // dart-define으로 API_BASE_URL이 설정된 경우 우선 사용
    const String? defineUrl = String.fromEnvironment('API_BASE_URL');
    if (defineUrl.isNotEmpty) {
      return defineUrl;
    }
    // 기본값: 개발 모드에서는 프로덕션 서버, 릴리즈에서는 프로덕션 서버
    return isDev ? _devBaseUrl : _prodBaseUrl;
  }

  // 기타 설정
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // 로깅 설정
  static bool get enableLogging => isDev;
}