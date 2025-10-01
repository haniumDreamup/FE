import 'package:json_annotation/json_annotation.dart';

part 'behavior_log_model.g.dart';

/// 사용자 행동 로그 요청
@JsonSerializable()
class BehaviorLogRequest {
  final String sessionId;
  final String actionType;
  final String actionDetail;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  BehaviorLogRequest({
    required this.sessionId,
    required this.actionType,
    required this.actionDetail,
    required this.timestamp,
    this.metadata,
  });

  factory BehaviorLogRequest.fromJson(Map<String, dynamic> json) =>
      _$BehaviorLogRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BehaviorLogRequestToJson(this);
}

/// 페이지뷰 로그
@JsonSerializable()
class PageviewLogRequest {
  final String sessionId;
  final String pageName;
  final String pageUrl;
  final DateTime timestamp;
  final int? duration;
  final String? referrer;

  PageviewLogRequest({
    required this.sessionId,
    required this.pageName,
    required this.pageUrl,
    required this.timestamp,
    this.duration,
    this.referrer,
  });

  factory PageviewLogRequest.fromJson(Map<String, dynamic> json) =>
      _$PageviewLogRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PageviewLogRequestToJson(this);
}

/// 클릭 이벤트 로그
@JsonSerializable()
class ClickLogRequest {
  final String sessionId;
  final String elementId;
  final String elementType;
  final String? elementText;
  final DateTime timestamp;
  final Map<String, dynamic>? position;

  ClickLogRequest({
    required this.sessionId,
    required this.elementId,
    required this.elementType,
    this.elementText,
    required this.timestamp,
    this.position,
  });

  factory ClickLogRequest.fromJson(Map<String, dynamic> json) =>
      _$ClickLogRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClickLogRequestToJson(this);
}

/// 에러 로그
@JsonSerializable()
class ErrorLogRequest {
  final String sessionId;
  final String errorType;
  final String errorMessage;
  final String? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic>? context;

  ErrorLogRequest({
    required this.sessionId,
    required this.errorType,
    required this.errorMessage,
    this.stackTrace,
    required this.timestamp,
    this.context,
  });

  factory ErrorLogRequest.fromJson(Map<String, dynamic> json) =>
      _$ErrorLogRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorLogRequestToJson(this);
}

/// 행동 로그 응답
@JsonSerializable()
class BehaviorLogResponse {
  final bool success;
  final String message;
  final int? logId;

  BehaviorLogResponse({
    required this.success,
    required this.message,
    this.logId,
  });

  factory BehaviorLogResponse.fromJson(Map<String, dynamic> json) =>
      _$BehaviorLogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BehaviorLogResponseToJson(this);
}
