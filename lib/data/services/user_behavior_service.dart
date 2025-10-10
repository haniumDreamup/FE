import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/utils/logger.dart';
import '../models/behavior_log_model.dart';

/// 사용자 행동 로깅 서비스
/// UserBehaviorController와 동기화
class UserBehaviorService {
  final ApiClient _apiClient;
  final String _sessionId;

  UserBehaviorService({
    ApiClient? apiClient,
    String? sessionId,
  })  : _apiClient = apiClient ?? ApiClient(),
        _sessionId = sessionId ?? _generateSessionId();

  /// 세션 ID 생성
  static String _generateSessionId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch % 1000}';
  }

  /// 일반 행동 로그 전송 (POST /api/behavior/log)
  Future<void> logBehavior({
    required String actionType,
    required String actionDetail,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final request = BehaviorLogRequest(
        sessionId: _sessionId,
        actionType: actionType,
        actionDetail: actionDetail,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      await _apiClient.dio.post(
        ApiEndpoints.behaviorLog,
        data: request.toJson(),
      );
      // 비동기 로깅이므로 응답을 기다리지 않음
    } catch (e) {
      // 로깅 실패는 무시 (사용자 경험에 영향 없음)
      Logger.debug('행동 로그 전송 실패: $e');
    }
  }

  /// 배치 로그 전송 (POST /api/behavior/batch)
  Future<void> logBatch(List<BehaviorLogRequest> logs) async {
    try {
      await _apiClient.dio.post(
        ApiEndpoints.behaviorBatch,
        data: logs.map((e) => e.toJson()).toList(),
      );
    } catch (e) {
      Logger.debug('배치 로그 전송 실패: $e');
    }
  }

  /// 페이지뷰 로그 (POST /api/behavior/pageview)
  Future<void> logPageview({
    required String pageName,
    required String pageUrl,
    int? duration,
    String? referrer,
  }) async {
    try {
      final request = PageviewLogRequest(
        sessionId: _sessionId,
        pageName: pageName,
        pageUrl: pageUrl,
        timestamp: DateTime.now(),
        duration: duration,
        referrer: referrer,
      );

      await _apiClient.dio.post(
        ApiEndpoints.behaviorPageview,
        data: request.toJson(),
      );
    } catch (e) {
      Logger.debug('페이지뷰 로그 전송 실패: $e');
    }
  }

  /// 클릭 이벤트 로그 (POST /api/behavior/click)
  Future<void> logClick({
    required String elementId,
    required String elementType,
    String? elementText,
    Map<String, dynamic>? position,
  }) async {
    try {
      final request = ClickLogRequest(
        sessionId: _sessionId,
        elementId: elementId,
        elementType: elementType,
        elementText: elementText,
        timestamp: DateTime.now(),
        position: position,
      );

      await _apiClient.dio.post(
        ApiEndpoints.behaviorClick,
        data: request.toJson(),
      );
    } catch (e) {
      Logger.debug('클릭 로그 전송 실패: $e');
    }
  }

  /// 에러 로그 (POST /api/behavior/error)
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    try {
      final request = ErrorLogRequest(
        sessionId: _sessionId,
        errorType: errorType,
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        timestamp: DateTime.now(),
        context: context,
      );

      await _apiClient.dio.post(
        ApiEndpoints.behaviorError,
        data: request.toJson(),
      );
    } catch (e) {
      Logger.debug('에러 로그 전송 실패: $e');
    }
  }

  /// 화면 진입 로그 (편의 메서드)
  Future<void> logScreenEnter(String screenName) async {
    await logPageview(
      pageName: screenName,
      pageUrl: '/screen/$screenName',
    );
  }

  /// 화면 종료 로그 (편의 메서드)
  Future<void> logScreenExit(String screenName, {required int durationSeconds}) async {
    await logPageview(
      pageName: screenName,
      pageUrl: '/screen/$screenName',
      duration: durationSeconds,
    );
  }

  /// 버튼 클릭 로그 (편의 메서드)
  Future<void> logButtonClick(String buttonId, {String? buttonText}) async {
    await logClick(
      elementId: buttonId,
      elementType: 'button',
      elementText: buttonText,
    );
  }

  /// 앱 오류 로그 (편의 메서드)
  Future<void> logAppError(
    Exception error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalInfo,
  }) async {
    await logError(
      errorType: error.runtimeType.toString(),
      errorMessage: error.toString(),
      stackTrace: stackTrace?.toString(),
      context: additionalInfo,
    );
  }

  String get sessionId => _sessionId;
}
