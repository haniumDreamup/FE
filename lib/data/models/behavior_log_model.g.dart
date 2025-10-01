// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'behavior_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BehaviorLogRequest _$BehaviorLogRequestFromJson(Map<String, dynamic> json) =>
    BehaviorLogRequest(
      sessionId: json['sessionId'] as String,
      actionType: json['actionType'] as String,
      actionDetail: json['actionDetail'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BehaviorLogRequestToJson(BehaviorLogRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'actionType': instance.actionType,
      'actionDetail': instance.actionDetail,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
    };

PageviewLogRequest _$PageviewLogRequestFromJson(Map<String, dynamic> json) =>
    PageviewLogRequest(
      sessionId: json['sessionId'] as String,
      pageName: json['pageName'] as String,
      pageUrl: json['pageUrl'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      referrer: json['referrer'] as String?,
    );

Map<String, dynamic> _$PageviewLogRequestToJson(PageviewLogRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'pageName': instance.pageName,
      'pageUrl': instance.pageUrl,
      'timestamp': instance.timestamp.toIso8601String(),
      'duration': instance.duration,
      'referrer': instance.referrer,
    };

ClickLogRequest _$ClickLogRequestFromJson(Map<String, dynamic> json) =>
    ClickLogRequest(
      sessionId: json['sessionId'] as String,
      elementId: json['elementId'] as String,
      elementType: json['elementType'] as String,
      elementText: json['elementText'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      position: json['position'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ClickLogRequestToJson(ClickLogRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'elementId': instance.elementId,
      'elementType': instance.elementType,
      'elementText': instance.elementText,
      'timestamp': instance.timestamp.toIso8601String(),
      'position': instance.position,
    };

ErrorLogRequest _$ErrorLogRequestFromJson(Map<String, dynamic> json) =>
    ErrorLogRequest(
      sessionId: json['sessionId'] as String,
      errorType: json['errorType'] as String,
      errorMessage: json['errorMessage'] as String,
      stackTrace: json['stackTrace'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      context: json['context'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ErrorLogRequestToJson(ErrorLogRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'errorType': instance.errorType,
      'errorMessage': instance.errorMessage,
      'stackTrace': instance.stackTrace,
      'timestamp': instance.timestamp.toIso8601String(),
      'context': instance.context,
    };

BehaviorLogResponse _$BehaviorLogResponseFromJson(Map<String, dynamic> json) =>
    BehaviorLogResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      logId: (json['logId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BehaviorLogResponseToJson(
        BehaviorLogResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'logId': instance.logId,
    };
