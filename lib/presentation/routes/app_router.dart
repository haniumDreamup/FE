import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/schedule/schedule_screen.dart';
import '../screens/medication/medication_list_screen.dart';
import '../screens/schedule/add_schedule_screen.dart';
import '../screens/emergency/emergency_screen.dart';
import '../screens/emergency/emergency_contact_screen.dart';
import '../screens/emergency/emergency_history_screen.dart';
import '../screens/emergency/active_emergency_screen.dart';
import '../screens/guardian/guardian_list_screen.dart';
import '../screens/profile/user_profile_screen.dart';
import '../screens/geofence/geofence_list_screen.dart';
import '../screens/notifications/notification_list_screen.dart';
import '../screens/statistics/statistics_dashboard_screen.dart';
import '../screens/ai_vision/ai_vision_screen.dart';
import '../screens/camera/wearable_camera_screen.dart';
import '../screens/network/network_discovery_screen.dart';
import '../screens/settings/accessibility_settings_screen.dart';
import '../screens/settings/theme_settings_screen.dart';

class AppRouter {
  /// GoRouter 인스턴스 생성
  ///
  /// [authProvider]를 받아서 인증 상태 변경 시 자동으로 redirect 재평가
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final currentLocation = state.matchedLocation;

        // Splash 화면은 항상 허용 (인증 체크 로직이 내부에 있음)
        if (currentLocation == '/splash') {
          return null;
        }

        // 로그인 페이지인지 확인
        final isLoginPage = currentLocation == '/login';

        // 미인증 상태에서 보호된 페이지 접근 시도
        if (!isAuthenticated && !isLoginPage) {
          return '/login';
        }

        // 이미 로그인된 상태에서 로그인 페이지 접근 시도
        if (isAuthenticated && isLoginPage) {
          return '/home';
        }

        // 정상 접근
        return null;
      },
      routes: [
      // ============ 인증 관련 ============
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ============ 메인 화면 ============
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // ============ 일정 관리 ============
      GoRoute(
        path: '/schedule',
        name: 'schedule',
        builder: (context, state) => const ScheduleScreen(),
        routes: [
          // 중첩 라우트: /schedule/add
          GoRoute(
            path: 'add',
            name: 'schedule-add',
            builder: (context, state) => const AddScheduleScreen(),
          ),
        ],
      ),

      // ============ 약물 관리 ============
      GoRoute(
        path: '/medication',
        name: 'medication',
        builder: (context, state) => const MedicationListScreen(),
      ),

      // ============ 긴급 상황 ============
      GoRoute(
        path: '/emergency',
        name: 'emergency',
        builder: (context, state) => const EmergencyScreen(),
        routes: [
          // 중첩 라우트: /emergency/contacts
          GoRoute(
            path: 'contacts',
            name: 'emergency-contacts',
            builder: (context, state) => const EmergencyContactScreen(),
          ),
          // 중첩 라우트: /emergency/history
          GoRoute(
            path: 'history',
            name: 'emergency-history',
            builder: (context, state) => const EmergencyHistoryScreen(),
          ),
          // 중첩 라우트: /emergency/active
          GoRoute(
            path: 'active',
            name: 'emergency-active',
            builder: (context, state) => const ActiveEmergencyScreen(),
          ),
        ],
      ),

      // ============ 사용자 관리 ============
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: '/guardians',
        name: 'guardians',
        builder: (context, state) => const GuardianListScreen(),
      ),

      // ============ 위치 및 알림 ============
      GoRoute(
        path: '/geofence',
        name: 'geofence',
        builder: (context, state) => const GeofenceListScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationListScreen(),
      ),

      // ============ 통계 및 AI ============
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (context, state) => const StatisticsDashboardScreen(),
      ),
      GoRoute(
        path: '/ai-vision',
        name: 'ai-vision',
        builder: (context, state) => const AiVisionScreen(),
      ),
      GoRoute(
        path: '/wearable-camera',
        name: 'wearable-camera',
        builder: (context, state) => const WearableCameraScreen(),
      ),

      // ============ 설정 ============
      GoRoute(
        path: '/settings',
        name: 'settings',
        routes: [
          GoRoute(
            path: 'accessibility',
            name: 'settings-accessibility',
            builder: (context, state) => const AccessibilitySettingsScreen(),
          ),
          GoRoute(
            path: 'theme',
            name: 'settings-theme',
            builder: (context, state) => const ThemeSettingsScreen(),
          ),
          GoRoute(
            path: 'network',
            name: 'settings-network',
            builder: (context, state) => const NetworkDiscoveryScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '페이지를 찾을 수 없어요',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('홈으로 가기'),
            ),
          ],
        ),
      ),
    ),
    );
  }

  // 하위 호환성을 위한 static router getter (deprecated 예정)
  // main.dart에서 createRouter 사용 권장
  static GoRouter? _router;

  static GoRouter get router {
    if (_router == null) {
      throw StateError(
        'Router가 초기화되지 않았습니다. '
        'main.dart에서 AppRouter.createRouter(authProvider)를 사용하세요.',
      );
    }
    return _router!;
  }

  static void setRouter(GoRouter router) {
    _router = router;
  }
}