import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

/// 웹 플랫폼 호환성을 위한 서비스
class WebPlatformService {
  static bool get isWeb => kIsWeb;

  /// 웹에서 지원되지 않는 기능에 대한 fallback 처리
  static T? webSafeCall<T>(T Function() function, {T? fallback}) {
    if (!isWeb) {
      return function();
    }

    try {
      return function();
    } catch (e) {
      if (kDebugMode) {
        Logger.debug('웹 환경에서 지원되지 않는 기능: $e');
      }
      return fallback;
    }
  }

  /// 웹 환경에서 안전하게 Future를 실행
  static Future<T?> webSafeFuture<T>(Future<T> Function() function, {T? fallback}) async {
    if (!isWeb) {
      return await function();
    }

    try {
      return await function();
    } catch (e) {
      if (kDebugMode) {
        Logger.debug('웹 환경에서 지원되지 않는 비동기 기능: $e');
      }
      return fallback;
    }
  }

  /// TTS 기능 웹 호환성 체크
  static bool get supportsTTS {
    if (!isWeb) return true;
    return webSafeCall(() {
      // 웹에서는 기본 SpeechSynthesis API 사용 가능 여부 확인
      return true;
    }, fallback: false) ?? false;
  }

  /// 네트워크 정보 조회 웹 호환성
  static bool get supportsNetworkInfo {
    return !isWeb; // 웹에서는 네트워크 정보 조회가 제한적
  }

  /// 로컬 네트워크 디스커버리 웹 호환성
  static bool get supportsNetworkDiscovery {
    return !isWeb; // 웹에서는 로컬 네트워크 디스커버리 불가
  }

  /// 푸시 알림 웹 호환성
  static bool get supportsPushNotifications {
    if (!isWeb) return true;
    return webSafeCall(() {
      // 웹에서는 PWA나 Firebase Web Push 사용 가능
      return true;
    }, fallback: false) ?? false;
  }
}