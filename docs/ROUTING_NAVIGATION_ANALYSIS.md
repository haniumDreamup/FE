# 라우팅 및 네비게이션 분석 보고서

## 📋 개요
Flutter 앱의 라우팅 설정과 네비게이션 동작을 분석한 결과를 정리합니다.

## ✅ 잘 구현된 부분

### 1. GoRouter 기반 라우팅 구조
- **위치**: `lib/presentation/routes/app_router.dart`
- GoRouter를 사용한 선언적 라우팅 구현
- 인증 상태 기반 자동 리다이렉트 구현
- Splash → Login → Home 플로우 정상 작동

### 2. 라우트 상수 관리
- **위치**: `lib/presentation/routes/route_names.dart`
- 라우트 경로를 상수로 관리하여 타입 안전성 확보
- `AppNavigation` extension으로 편리한 네비게이션 헬퍼 제공

### 3. 중첩 라우트 구조
- 일정, 긴급상황, 설정 등에서 중첩 라우트 활용
- 예: `/schedule/add`, `/emergency/contacts`, `/emergency/history`

### 4. 에러 핸들링
- 404 페이지를 위한 `errorBuilder` 구현
- 사용자 친화적인 에러 화면 제공

## ⚠️ 발견된 문제점

### 1. **[심각]** main.dart 라우터 초기화 오류
**파일**: `lib/main.dart:76`

```dart
// 현재 코드 (잘못됨)
routerConfig: AppRouter.router,
```

**문제점**:
- `AppRouter.router`는 초기화되지 않은 상태에서는 `StateError` 예외 발생
- `_router` 변수가 null이면 런타임 에러 발생

**해결방법**:
```dart
// 수정 필요
final authProvider = Provider.of<AuthProvider>(context, listen: false);
routerConfig: AppRouter.createRouter(authProvider),
```

---

### 2. **[중요]** BottomNavBar 인덱스 불일치
**파일**: `lib/presentation/screens/schedule/schedule_screen.dart:17`

```dart
int _selectedIndex = 2;  // 잘못됨 - 일정은 index 1이어야 함
```

**문제점**:
- BottomNavBar에서 일정 탭은 index 1인데, ScheduleScreen에서는 2로 설정
- 네비게이션 바의 선택 상태가 잘못 표시됨

**BottomNavBar 구조**:
- 0: 홈
- 1: 일정
- 2: 알림
- 3: 내 정보

---

### 3. **[중요]** BottomNavBar 네비게이션 동작 누락
**파일**: `lib/presentation/screens/schedule/schedule_screen.dart:236-242`

```dart
bottomNavigationBar: BottomNavBar(
  selectedIndex: _selectedIndex,
  onItemSelected: (index) {
    setState(() {
      _selectedIndex = index;
    });
    // 네비게이션 로직이 없음!
  },
),
```

**문제점**:
- `onItemSelected`에서 상태만 변경하고 실제 화면 전환이 없음
- HomeScreen(line 148-161)에는 제대로 구현되어 있음

**해결방법**:
```dart
onItemSelected: (index) {
  setState(() {
    _selectedIndex = index;
  });
  switch (index) {
    case 0:
      AppNavigation.toHome(context);
      break;
    case 1:
      // 현재 화면이므로 아무것도 하지 않음
      break;
    case 2:
      AppNavigation.toNotifications(context);
      break;
    case 3:
      AppNavigation.toProfile(context);
      break;
  }
},
```

---

### 4. **[중요]** 네비게이션 방식 혼용
**파일**: `lib/presentation/screens/schedule/schedule_screen.dart`

**발견된 문제**:
- Line 39-44: `Navigator.push` 사용 (전통적 방식)
- Line 329-334: `Navigator.push` 사용 (전통적 방식)
- 다른 화면들은 GoRouter의 `context.go()` 또는 `AppNavigation` 사용

**문제점**:
- 라우팅 방식이 일관되지 않음
- GoRouter의 브라우저 히스토리 관리 기능 미활용
- 딥링크 지원에 문제 발생 가능

**해결방법**:
```dart
// 현재 코드
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddScheduleScreen(),
  ),
);

// 수정 권장
AppNavigation.toScheduleAdd(context);
```

---

### 5. **[보통]** RouteNames 불완전
**파일**: `lib/presentation/routes/route_names.dart`

**누락된 라우트**:
- `/emergency/history` (app_router.dart:104에 정의됨)
- `/emergency/active` (app_router.dart:110에 정의됨)

**추가 필요**:
```dart
static const String emergencyHistory = '/emergency/history';
static const String emergencyActive = '/emergency/active';
```

---

### 6. **[보통]** /settings 라우트에 builder 누락
**파일**: `lib/presentation/routes/app_router.dart:154-169`

```dart
GoRoute(
  path: '/settings',
  name: 'settings',
  // builder가 없음!
  routes: [
    GoRoute(
      path: 'accessibility',
      name: 'settings-accessibility',
      builder: (context, state) => const AccessibilitySettingsScreen(),
    ),
    // ...
  ],
),
```

**문제점**:
- `/settings`로 직접 접근하면 에러 발생
- 서브 라우트만 정의되어 있음

**해결방법**:
1. 설정 메인 화면을 만들거나
2. 리다이렉트를 추가하거나
3. 라우트를 분리

---

### 7. **[낮음]** NotificationListScreen과 UserProfileScreen의 네비게이션 누락
**파일**: 
- `lib/presentation/screens/notifications/notification_list_screen.dart`
- `lib/presentation/screens/profile/user_profile_screen.dart`

**문제점**:
- 두 화면 모두 BottomNavBar가 없음
- 다른 탭으로 이동할 수 없음
- 뒤로가기 버튼으로만 이동 가능

**참고**: 
- HomeScreen과 ScheduleScreen에는 BottomNavBar가 있음

---

## 📊 화면별 라우팅 현황

| 화면 | 라우트 경로 | 네비게이션 방식 | BottomNavBar | 상태 |
|------|------------|----------------|--------------|------|
| SplashScreen | /splash | GoRouter | ❌ | ✅ |
| LoginScreen | /login | GoRouter | ❌ | ✅ |
| HomeScreen | /home | GoRouter | ✅ | ✅ |
| ScheduleScreen | /schedule | GoRouter | ✅ | ⚠️ (인덱스 오류) |
| AddScheduleScreen | /schedule/add | Navigator.push | ❌ | ⚠️ (혼용) |
| EmergencyScreen | /emergency | GoRouter | ❌ | ✅ |
| EmergencyContactScreen | /emergency/contacts | GoRouter | ❌ | ✅ |
| EmergencyHistoryScreen | /emergency/history | GoRouter | ❌ | ⚠️ (RouteNames 누락) |
| ActiveEmergencyScreen | /emergency/active | GoRouter | ❌ | ⚠️ (RouteNames 누락) |
| GuardianListScreen | /guardians | GoRouter | ❌ | ✅ |
| UserProfileScreen | /profile | GoRouter | ❌ | ⚠️ (NavBar 없음) |
| NotificationListScreen | /notifications | GoRouter | ❌ | ⚠️ (NavBar 없음) |
| GeofenceListScreen | /geofence | GoRouter | ❌ | ✅ |
| StatisticsDashboardScreen | /statistics | GoRouter | ❌ | ✅ |
| AiVisionScreen | /ai-vision | GoRouter | ❌ | ✅ |
| AccessibilitySettingsScreen | /settings/accessibility | GoRouter | ❌ | ✅ |
| NetworkDiscoveryScreen | /settings/network | GoRouter | ❌ | ✅ |

---

## 🔧 권장 수정 사항

### 우선순위 1 (즉시 수정 필요)
1. ✅ main.dart의 라우터 초기화 수정
2. ✅ ScheduleScreen의 BottomNavBar 인덱스 수정
3. ✅ ScheduleScreen의 BottomNavBar 네비게이션 로직 추가

### 우선순위 2 (조만간 수정)
4. ✅ 네비게이션 방식 통일 (GoRouter로)
5. ✅ RouteNames에 누락된 라우트 추가
6. ✅ NotificationListScreen과 UserProfileScreen에 BottomNavBar 추가

### 우선순위 3 (선택적)
7. ⚪ /settings 라우트 구조 개선
8. ⚪ 라우트 transition 애니메이션 커스터마이징

---

## 💡 개선 제안

### 1. Shell Route 패턴 적용
BottomNavBar가 있는 화면들을 Shell Route로 묶어서 관리:

```dart
ShellRoute(
  builder: (context, state, child) {
    return ScaffoldWithNavBar(child: child);
  },
  routes: [
    GoRoute(path: '/home', builder: ...),
    GoRoute(path: '/schedule', builder: ...),
    GoRoute(path: '/notifications', builder: ...),
    GoRoute(path: '/profile', builder: ...),
  ],
),
```

**장점**:
- BottomNavBar를 중복 구현하지 않아도 됨
- 네비게이션 상태 관리가 간편함
- 코드 중복 감소

### 2. 명명된 라우트 사용 확대
```dart
// context.go('/emergency/contacts') 대신
context.goNamed('emergency-contacts');
```

**장점**:
- 경로 변경 시 한 곳만 수정
- 타입 안전성 향상

### 3. 페이지 전환 애니메이션 커스터마이징
```dart
GoRoute(
  path: '/emergency',
  pageBuilder: (context, state) {
    return CustomTransitionPage(
      child: const EmergencyScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  },
),
```

---

## 📝 결론

### 현재 상태: ⚠️ 부분적으로 작동

**긍정적인 면**:
- GoRouter 기반의 현대적인 라우팅 구조
- 인증 플로우가 잘 구현됨
- 라우트 상수 관리가 체계적임

**개선이 필요한 면**:
- 라우터 초기화 오류 (치명적)
- BottomNavBar 동작 불일치
- 네비게이션 방식 혼용
- 일부 화면에서 네비게이션 바 누락

**종합 평가**: 기본 구조는 훌륭하나, 몇 가지 버그와 일관성 문제로 인해 사용자 경험에 영향을 줄 수 있습니다. 우선순위 1 항목들을 수정하면 안정적으로 작동할 것입니다.

---

생성일: 2025-10-02
작성자: AI Assistant

