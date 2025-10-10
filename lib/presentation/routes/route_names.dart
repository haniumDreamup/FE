/// 라우트 이름 상수
///
/// 네비게이션 시 문자열 대신 상수를 사용하여 타입 안전성 확보
class RouteNames {
  // 인증
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // 메인
  static const String home = '/home';

  // 일정
  static const String schedule = '/schedule';
  static const String scheduleAdd = '/schedule/add';

  // 약물
  static const String medication = '/medication';

  // 긴급
  static const String emergency = '/emergency';
  static const String emergencyContacts = '/emergency/contacts';

  // 사용자
  static const String profile = '/profile';
  static const String guardians = '/guardians';

  // 위치 및 알림
  static const String geofence = '/geofence';
  static const String notifications = '/notifications';

  // 통계 및 AI
  static const String statistics = '/statistics';
  static const String aiVision = '/ai-vision';
  static const String wearableCamera = '/wearable-camera';

  // 설정
  static const String settingsAccessibility = '/settings/accessibility';
  static const String settingsTheme = '/settings/theme';
  static const String settingsNetwork = '/settings/network';
}

/// 네비게이션 헬퍼
///
/// context.go(RouteNames.home) 대신
/// AppNavigation.toHome(context) 사용
extension AppNavigation on Object {
  // 인증
  static void toSplash(context) => context.go(RouteNames.splash);
  static void toLogin(context) => context.go(RouteNames.login);
  static void toRegister(context) => context.push(RouteNames.register);

  // 메인
  static void toHome(context) => context.go(RouteNames.home);

  // 일정
  static void toSchedule(context) => context.go(RouteNames.schedule);
  static void toScheduleAdd(context) => context.push(RouteNames.scheduleAdd);

  // 약물
  static void toMedication(context) => context.push(RouteNames.medication);

  // 긴급
  static void toEmergency(context) => context.go(RouteNames.emergency);
  static void toEmergencyContacts(context) => context.push(RouteNames.emergencyContacts);

  // 사용자
  static void toProfile(context) => context.go(RouteNames.profile); // 메인 탭이므로 go 사용
  static void toGuardians(context) => context.push(RouteNames.guardians);

  // 위치 및 알림
  static void toGeofence(context) => context.push(RouteNames.geofence);
  static void toNotifications(context) => context.go(RouteNames.notifications); // 메인 탭이므로 go 사용

  // 통계 및 AI
  static void toStatistics(context) => context.push(RouteNames.statistics);
  static void toAiVision(context) => context.push(RouteNames.aiVision);
  static void toWearableCamera(context) => context.push(RouteNames.wearableCamera);

  // 설정
  static void toAccessibilitySettings(context) => context.push(RouteNames.settingsAccessibility);
  static void toThemeSettings(context) => context.push(RouteNames.settingsTheme);
  static void toNetworkSettings(context) => context.push(RouteNames.settingsNetwork);

  // 뒤로가기
  static void goBack(context) => context.pop();
}
