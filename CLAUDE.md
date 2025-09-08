# BIF-AI Flutter Frontend 프로젝트 가이드

## 프로젝트 개요
**BIF-AI**는 경계선 지적 기능(IQ 70-85) 성인을 위한 인지 지원 모바일 애플리케이션입니다. 이 앱은 사용자가 일상생활을 독립적으로 수행할 수 있도록 돕는 것을 목표로 합니다.

### 핵심 특징
- **단순하고 직관적인 UI/UX**: 인지 부담을 최소화한 디자인
- **토스 디자인 시스템**: 깔끔하고 모던한 UI 구현
- **접근성 중심 설계**: TTS, 큰 글씨, 명확한 시각적 피드백
- **오프라인 지원**: 네트워크 연결이 불안정해도 기본 기능 사용 가능

## 기술 스택

### 프레임워크 및 언어
- **Flutter**: 3.8.1+
- **Dart**: SDK 3.8.1+

### 상태 관리
- **Provider**: 6.1.1 - 전역 상태 관리
- **ChangeNotifier**: 인증, 접근성 설정 등 관리

### 네트워킹
- **Dio**: 5.4.0 - HTTP 클라이언트
- **Pretty Dio Logger**: 1.3.1 - API 디버깅
- **Connectivity Plus**: 5.0.2 - 네트워크 상태 모니터링

### 로컬 저장소
- **Hive**: 2.2.3 - NoSQL 데이터베이스 (오프라인 캐싱)
- **Shared Preferences**: 2.2.2 - 간단한 키-값 저장
- **Flutter Secure Storage**: 9.0.0 - 민감한 정보 보안 저장

### UI/UX
- **Flutter ScreenUtil**: 5.9.0 - 반응형 디자인
- **Go Router**: 13.0.1 - 선언적 라우팅
- **Lottie**: 3.0.0 - 애니메이션
- **Shimmer**: 3.0.0 - 로딩 효과

### 디바이스 기능
- **Flutter TTS**: 4.2.3 - 텍스트 음성 변환
- **Flutter Local Notifications**: 19.4.0 - 로컬 알림
- **Network Discovery**: multicast_dns, flutter_nsd, bonsoir - 로컬 네트워크 서비스 탐색
- **Firebase**: Core & Messaging - 푸시 알림 (준비 중)

## 프로젝트 구조

```
lib/
├── core/                      # 핵심 기능 및 유틸리티
│   ├── config/               # 앱 설정
│   │   ├── theme_config.dart # 기본 테마
│   │   └── toss_theme.dart   # 토스 디자인 시스템
│   ├── constants/            # 상수 정의
│   │   ├── api_endpoints.dart # API 엔드포인트
│   │   └── app_constants.dart # 앱 전역 상수
│   ├── network/              # 네트워킹
│   │   ├── api_client.dart   # Dio 클라이언트 설정
│   │   └── interceptors/     # HTTP 인터셉터
│   └── services/             # 서비스 레이어
│       ├── network_discovery_service.dart # 로컬 네트워크 탐색
│       ├── notification_service.dart      # 알림 서비스
│       ├── offline_service.dart          # 오프라인 지원
│       └── tts_service.dart              # TTS 서비스
│
├── data/                     # 데이터 레이어
│   ├── models/              # 데이터 모델
│   │   ├── cached_medication.dart # Hive 모델
│   │   └── user_model.dart       # 사용자 모델
│   └── repositories/        # 데이터 저장소
│       ├── auth_repository.dart      # 인증 관련
│       └── medication_repository.dart # 약물 관련
│
├── domain/                  # 도메인 레이어
│   └── entities/           # 비즈니스 엔티티
│       ├── medication.dart # 약물 엔티티
│       └── user.dart       # 사용자 엔티티
│
├── presentation/           # UI 레이어
│   ├── providers/         # 상태 관리
│   │   ├── accessibility_provider.dart # 접근성 설정
│   │   └── auth_provider.dart         # 인증 상태
│   ├── routes/           # 라우팅
│   │   └── app_router.dart # Go Router 설정
│   ├── screens/          # 화면
│   │   ├── auth/        # 인증 화면
│   │   ├── emergency/   # 긴급 상황
│   │   ├── home/        # 홈 화면
│   │   │   ├── home_screen.dart      # 기본 홈
│   │   │   └── toss_home_screen.dart # 토스 스타일 홈
│   │   ├── medication/  # 약물 관리
│   │   ├── network/     # 네트워크 설정
│   │   └── schedule/    # 일정 관리
│   └── widgets/         # 재사용 위젯
│       ├── common/      # 공통 위젯
│       └── home/        # 홈 화면 위젯
│
└── main.dart           # 앱 진입점
```

## API 연동

### 백엔드 서버
- **개발**: `http://localhost:8080`
- **Base Path**: `/mobile`

### 주요 엔드포인트
```dart
// 인증
POST   /mobile/auth/login       # 로그인
POST   /mobile/auth/logout      # 로그아웃
POST   /mobile/auth/refresh     # 토큰 갱신

// 홈 대시보드
GET    /mobile/home/dashboard   # 대시보드 정보

// 약물 관리
GET    /mobile/medications/today         # 오늘의 약물
GET    /mobile/medications/{id}          # 약물 상세
POST   /mobile/medications/{id}/take     # 복용 체크

// 일정 관리  
GET    /mobile/schedules/today           # 오늘의 일정
POST   /mobile/schedules/{id}/complete   # 일정 완료

// 긴급 상황
POST   /mobile/guardians/emergency       # 긴급 호출
```

## 개발 가이드

### 환경 설정
1. `.env` 파일 생성 및 설정
```
API_BASE_URL=http://localhost:8080
```

2. 의존성 설치
```bash
flutter pub get
```

3. 코드 생성 (필요시)
```bash
flutter pub run build_runner build
```

### 실행 명령어
```bash
# iOS 실행
flutter run -d ios

# Android 실행  
flutter run -d android

# 모든 디바이스 리스트
flutter devices

# 특정 디바이스 실행
flutter run -d [device_id]
```

### 빌드 명령어
```bash
# Android APK (릴리즈)
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (릴리즈)
flutter build ios --release
```

### 테스트
```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일 실행
flutter test test/widget_test.dart
```

## 주요 기능 구현 위치

### 인증 시스템
- Provider: `lib/presentation/providers/auth_provider.dart`
- Repository: `lib/data/repositories/auth_repository.dart`
- 로그인 화면: `lib/presentation/screens/auth/login_screen.dart`

### 약물 관리
- 화면: `lib/presentation/screens/medication/medication_list_screen.dart`
- 오프라인 캐싱: `lib/data/models/cached_medication.dart`
- Repository: `lib/data/repositories/medication_repository.dart`

### 네트워크 상태 관리
- Banner Widget: `lib/presentation/widgets/common/network_status_banner.dart`
- Discovery Service: `lib/core/services/network_discovery_service.dart`
- Offline Service: `lib/core/services/offline_service.dart`

### 접근성 기능
- TTS Service: `lib/core/services/tts_service.dart`
- Provider: `lib/presentation/providers/accessibility_provider.dart`
- Accessible Button: `lib/presentation/widgets/common/accessible_button.dart`

### 토스 디자인 시스템
- Theme: `lib/core/config/toss_theme.dart`
- Home Screen: `lib/presentation/screens/home/toss_home_screen.dart`

## 코딩 컨벤션

### 파일 명명 규칙
- 소문자와 언더스코어 사용: `user_model.dart`
- 화면 파일은 `_screen` 접미사: `login_screen.dart`
- 위젯 파일은 용도 표시: `accessible_button.dart`

### 클래스 명명 규칙
- PascalCase 사용: `UserModel`, `AuthProvider`
- Provider는 `Provider` 접미사: `AuthProvider`
- Repository는 `Repository` 접미사: `AuthRepository`

### 상태 관리 패턴
- Provider + ChangeNotifier 패턴 사용
- 전역 상태는 Provider로 관리
- 지역 상태는 StatefulWidget 사용

### API 응답 처리
```dart
// 성공/실패 처리 패턴
try {
  final response = await apiClient.get(endpoint);
  // 성공 처리
} on DioException catch (e) {
  // 에러 처리
}
```

## 보안 고려사항
- 민감한 정보는 Flutter Secure Storage 사용
- API 토큰은 AuthInterceptor에서 자동 처리
- 환경 변수는 `.env` 파일로 관리 (git 제외)

## 성능 최적화
- 이미지 캐싱: CachedNetworkImage 사용
- 리스트 최적화: ListView.builder 사용
- 오프라인 지원: Hive로 로컬 캐싱
- 화면 크기 대응: ScreenUtil 사용

## 디버깅 팁
- API 로깅: Pretty Dio Logger 자동 활성화
- 네트워크 상태: NetworkStatusBanner로 확인
- Provider 상태: Flutter Inspector 활용

## 주의사항
1. **접근성 우선**: 모든 UI 요소는 충분히 크고 명확해야 함
2. **단순한 플로우**: 복잡한 네비게이션 피하기
3. **시각적 피드백**: 모든 액션에 즉각적인 피드백 제공
4. **에러 처리**: 사용자 친화적인 에러 메시지 표시
5. **오프라인 지원**: 핵심 기능은 오프라인에서도 동작

## 관련 프로젝트
- **백엔드**: `/Users/ihojun/Desktop/javaWorkSpace/BE`
- **API 문서**: 백엔드 프로젝트의 Swagger UI 참조

## 문제 해결
- **빌드 에러**: `flutter clean` 후 재빌드
- **의존성 충돌**: `pubspec.lock` 삭제 후 `flutter pub get`
- **iOS 빌드 실패**: `cd ios && pod install`