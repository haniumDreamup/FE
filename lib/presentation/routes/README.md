# 네비게이션 가이드

## 📱 라우트 구조

### 계층적 URL 구조
```
/
├─ splash                    (스플래시)
├─ login                     (로그인)
├─ home                      (홈)
├─ schedule                  (일정 목록)
│  └─ add                    (일정 추가)
├─ emergency                 (긴급 상황)
│  └─ contacts               (긴급 연락처)
├─ profile                   (프로필)
├─ guardians                 (보호자)
├─ geofence                  (지오펜스)
├─ notifications             (알림)
├─ statistics                (통계)
├─ ai-vision                 (AI 비전)
└─ settings                  (설정)
   ├─ accessibility          (접근성)
   └─ network                (네트워크)
```

## 🚀 사용법

### 방법 1: 문자열 직접 사용 (권장하지 않음)
```dart
// ❌ 오타 가능성, IDE 지원 없음
onPressed: () => context.push('/emergency/contacts')
```

### 방법 2: RouteNames 상수 사용 (권장)
```dart
import '../../routes/route_names.dart';

// ✅ 자동완성 지원, 오타 방지
onPressed: () => context.push(RouteNames.emergencyContacts)
```

### 방법 3: AppNavigation 헬퍼 사용 (가장 권장)
```dart
import '../../routes/route_names.dart';

// ✅ 가장 간결하고 안전
onPressed: () => AppNavigation.toEmergencyContacts(context)
```

## 📋 전체 라우트 목록

### 인증
```dart
AppNavigation.toSplash(context)        // /splash
AppNavigation.toLogin(context)         // /login
```

### 메인
```dart
AppNavigation.toHome(context)          // /home
```

### 일정
```dart
AppNavigation.toSchedule(context)      // /schedule
AppNavigation.toScheduleAdd(context)   // /schedule/add
```

### 긴급
```dart
AppNavigation.toEmergency(context)           // /emergency
AppNavigation.toEmergencyContacts(context)   // /emergency/contacts
```

### 사용자
```dart
AppNavigation.toProfile(context)       // /profile
AppNavigation.toGuardians(context)     // /guardians
```

### 위치 및 알림
```dart
AppNavigation.toGeofence(context)        // /geofence
AppNavigation.toNotifications(context)   // /notifications
```

### 통계 및 AI
```dart
AppNavigation.toStatistics(context)    // /statistics
AppNavigation.toAiVision(context)      // /ai-vision
```

### 설정
```dart
AppNavigation.toAccessibilitySettings(context)  // /settings/accessibility
AppNavigation.toNetworkSettings(context)        // /settings/network
```

### 뒤로가기
```dart
AppNavigation.goBack(context)          // Navigator.pop()
```

## 🔄 context.go vs context.push 차이

### context.go (스택 교체)
- 현재 화면을 **대체**
- 뒤로가기 불가
- 주로 하단 네비게이션 바에서 사용

```dart
// 예: 하단 탭 전환
bottomNavigationBar: BottomNavigationBar(
  onTap: (index) {
    switch (index) {
      case 0: context.go('/home');        // 홈으로 이동 (기존 화면 대체)
      case 1: context.go('/schedule');    // 일정으로 이동 (기존 화면 대체)
      case 2: context.go('/emergency');   // 긴급으로 이동 (기존 화면 대체)
    }
  },
)
```

### context.push (스택에 추가)
- 현재 화면 **위에** 새 화면 추가
- 뒤로가기 가능
- 주로 상세 화면, 추가 화면에서 사용

```dart
// 예: 일정 추가 버튼
FloatingActionButton(
  onPressed: () => context.push('/schedule/add'),  // 일정 추가 화면 열기 (뒤로가기 가능)
)
```

## 📝 실전 예제

### 예제 1: 홈 화면 카드 클릭
```dart
// lib/presentation/screens/home/home_screen.dart
import '../../routes/route_names.dart';

GestureDetector(
  onTap: () => AppNavigation.toSchedule(context),
  child: Card(
    child: Text('내 일정 보기'),
  ),
)
```

### 예제 2: 긴급 연락처 버튼
```dart
// lib/presentation/screens/emergency/emergency_screen.dart
import '../../routes/route_names.dart';

ElevatedButton(
  onPressed: () => AppNavigation.toEmergencyContacts(context),
  child: Text('긴급 연락처 보기'),
)
```

### 예제 3: 설정 메뉴
```dart
// lib/presentation/screens/settings/settings_screen.dart
import '../../routes/route_names.dart';

ListTile(
  title: Text('접근성'),
  onTap: () => AppNavigation.toAccessibilitySettings(context),
)
```

## ⚠️ 주의사항

### ❌ 하지 말아야 할 것
```dart
// 문자열 오타 위험
context.push('/emergancy/contacts')  // 오타!

// 잘못된 경로
context.push('/emergency-contacts')  // 옛날 경로!
```

### ✅ 해야 할 것
```dart
// 상수 사용
context.push(RouteNames.emergencyContacts)

// 또는 헬퍼 함수 사용
AppNavigation.toEmergencyContacts(context)
```

## 🎯 BIF 사용자 고려사항

1. **단순한 URL**: `/home`, `/schedule` (이해하기 쉬움)
2. **논리적 그룹**: 관련 기능끼리 묶음 (`/settings/*`)
3. **일관된 패턴**: 모든 추가/편집 화면은 상위 경로 아래 (`/schedule/add`)

## 🔧 URL 변경 이력

| 기능 | 변경 전 | 변경 후 |
|---|---|---|
| 일정 추가 | `/add-schedule` | `/schedule/add` |
| 긴급 연락처 | `/emergency-contacts` | `/emergency/contacts` |
| 접근성 설정 | `/accessibility-settings` | `/settings/accessibility` |
| 네트워크 설정 | `/network-discovery` | `/settings/network` |
