import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'core/config/toss_theme.dart';
import 'core/services/offline_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/tts_service.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/accessibility_provider.dart';
import 'presentation/providers/schedule_provider.dart';
import 'presentation/providers/emergency_contact_provider.dart';
import 'presentation/providers/emergency_provider.dart';
import 'presentation/providers/guardian_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/providers/statistics_provider.dart';
import 'presentation/providers/geofence_provider.dart';
import 'presentation/providers/guardian_dashboard_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/widgets/common/network_status_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Kakao SDK
  final kakaoAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  if (kakaoAppKey.isNotEmpty) {
    KakaoSdk.init(nativeAppKey: kakaoAppKey);
  }

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize offline service
  final offlineService = OfflineService();
  await offlineService.initialize();

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize TTS service
  final ttsService = TtsService();
  await ttsService.initialize();

  runApp(BifAiApp(notificationService: notificationService));
}

class BifAiApp extends StatelessWidget {
  final NotificationService notificationService;

  const BifAiApp({
    super.key,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
            ChangeNotifierProvider(create: (_) => ScheduleProvider()),
            ChangeNotifierProvider(create: (_) => EmergencyContactProvider()),
            ChangeNotifierProvider(create: (_) => EmergencyProvider()),
            ChangeNotifierProvider(create: (_) => GuardianProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => StatisticsProvider()),
            ChangeNotifierProvider(create: (_) => GeofenceProvider()),
            ChangeNotifierProvider(create: (_) => GuardianDashboardProvider()),
          ],
          child: Builder(
            builder: (context) {
              // AuthProvider와 ThemeProvider 가져오기
              final authProvider = context.read<AuthProvider>();
              final themeProvider = context.watch<ThemeProvider>();
              final router = AppRouter.createRouter(authProvider);

              // Router를 AppRouter에 설정 (static 접근용)
              AppRouter.setRouter(router);

              // NotificationService에 router 주입
              notificationService.setRouter(router);

              return NetworkStatusBanner(
                child: MaterialApp.router(
                  title: 'BIF-AI',
                  theme: TossTheme.lightTheme,
                  darkTheme: TossTheme.darkTheme,
                  themeMode: themeProvider.themeMode,
                  routerConfig: router,
                  debugShowCheckedModeBanner: false,
                ),
              );
            },
          ),
        );
      },
    );
  }
}