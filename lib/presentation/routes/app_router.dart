import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/schedule/schedule_screen.dart';
import '../screens/schedule/add_schedule_screen.dart';
import '../screens/schedule/schedule_detail_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/emergency/add_emergency_contact_screen.dart';
import '../screens/guardian/add_guardian_screen.dart';
import '../screens/geofence/add_geofence_screen.dart';
import '../screens/settings/main_settings_screen.dart';
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
import '../screens/schedule/schedule_edit_screen.dart';
import '../screens/emergency/edit_emergency_contact_screen.dart';
import '../screens/guardian/guardian_detail_screen.dart';
import '../screens/guardian/guardian_invitations_screen.dart';
import '../screens/geofence/geofence_detail_screen.dart';

class AppRouter {
  /// GoRouter 인스턴스 생성
  ///
  /// [authProvider]를 받아서 인증 상태 변경 시 자동으로 redirect 재평가
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      onException: (BuildContext context, GoRouterState state, GoRouter router) {
        // Kakao OAuth 딥링크 에러 무시 (Kakao SDK가 자동 처리)
        if (state.uri.scheme.startsWith('kakao') || state.uri.scheme == 'kakaotalk') {
          debugPrint('[DEBUG] Kakao OAuth 딥링크 에러 무시: ${state.uri}');
          return; // 에러를 무시하고 그대로 진행
        }
        // 다른 에러는 404 페이지로
        router.go('/login');
      },
      redirect: (BuildContext context, GoRouterState state) async {
        final isAuthenticated = authProvider.isAuthenticated;
        final currentLocation = state.matchedLocation;

        // OAuth 콜백 딥링크는 무시 (Kakao SDK가 자동 처리)
        final uri = state.uri;
        if (uri.scheme.startsWith('kakao') || uri.scheme == 'kakaotalk') {
          return null;
        }

        // Splash 화면은 항상 허용 (인증 체크 로직이 내부에 있음)
        if (currentLocation == '/splash') {
          return null;
        }

        // 로그인/회원가입 페이지
        final isAuthPage = currentLocation == '/login' || currentLocation == '/register' || currentLocation == '/onboarding';

        // 미인증 상태에서 보호된 페이지 접근 시도
        // (하지만 토큰이 있으면 허용 - checkAuthStatus가 실패해도 토큰만 있으면 됨)
        if (!isAuthenticated && !isAuthPage) {
          // 토큰이 있는지 확인
          final hasToken = await authProvider.validateToken();
          if (!hasToken) {
            return '/login';
          }
          // 토큰이 있으면 접근 허용
        }

        // 이미 로그인된 상태에서 로그인 페이지 접근 시도
        if (isAuthenticated && isAuthPage) {
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
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
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
          GoRoute(
            path: 'add',
            name: 'schedule-add',
            builder: (context, state) => const AddScheduleScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'schedule-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ScheduleDetailScreen(scheduleId: id);
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'schedule-edit',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ScheduleEditScreen(scheduleId: id);
                },
              ),
            ],
          ),
        ],
      ),

      // ============ 긴급 상황 ============
      GoRoute(
        path: '/emergency',
        name: 'emergency',
        builder: (context, state) => const EmergencyScreen(),
        routes: [
          GoRoute(
            path: 'contacts',
            name: 'emergency-contacts',
            builder: (context, state) => const EmergencyContactScreen(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'emergency-contact-add',
                builder: (context, state) => const AddEmergencyContactScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'emergency-contact-edit',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return EditEmergencyContactScreen(contactId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'history',
            name: 'emergency-history',
            builder: (context, state) => const EmergencyHistoryScreen(),
          ),
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
        routes: [
          GoRoute(
            path: 'edit',
            name: 'profile-edit',
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/guardians',
        name: 'guardians',
        builder: (context, state) => const GuardianListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'guardian-add',
            builder: (context, state) => const AddGuardianScreen(),
          ),
          GoRoute(
            path: 'invitations',
            name: 'guardian-invitations',
            builder: (context, state) => const GuardianInvitationsScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'guardian-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GuardianDetailScreen(guardianId: id);
            },
          ),
        ],
      ),

      // ============ 위치 및 알림 ============
      GoRoute(
        path: '/geofence',
        name: 'geofence',
        builder: (context, state) => const GeofenceListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'geofence-add',
            builder: (context, state) => const AddGeofenceScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'geofence-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return GeofenceDetailScreen(geofenceId: id);
            },
          ),
        ],
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
        builder: (context, state) => const MainSettingsScreen(),
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