// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoseDataModel _$PoseDataModelFromJson(Map<String, dynamic> json) =>
    PoseDataModel(
      userId: (json['userId'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      landmarks: (json['landmarks'] as List<dynamic>)
          .map((e) => PoseLandmark.fromJson(e as Map<String, dynamic>))
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PoseDataModelToJson(PoseDataModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'timestamp': instance.timestamp.toIso8601String(),
      'landmarks': instance.landmarks,
      'confidence': instance.confidence,
      'metadata': instance.metadata,
    };

PoseLandmark _$PoseLandmarkFromJson(Map<String, dynamic> json) => PoseLandmark(
      name: json['name'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      visibility: (json['visibility'] as num).toDouble(),
    );

Map<String, dynamic> _$PoseLandmarkToJson(PoseLandmark instance) =>
    <String, dynamic>{
      'name': instance.name,
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'visibility': instance.visibility,
    };

PoseResponseModel _$PoseResponseModelFromJson(Map<String, dynamic> json) =>
    PoseResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      fallDetected: json['fallDetected'] as bool,
      fallProbability: (json['fallProbability'] as num?)?.toDouble(),
      fallType: json['fallType'] as String?,
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
    );

Map<String, dynamic> _$PoseResponseModelToJson(PoseResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'fallDetected': instance.fallDetected,
      'fallProbability': instance.fallProbability,
      'fallType': instance.fallType,
      'processedAt': instance.processedAt?.toIso8601String(),
    };

FallStatusModel _$FallStatusModelFromJson(Map<String, dynamic> json) =>
    FallStatusModel(
      userId: (json['userId'] as num).toInt(),
      currentlyFallen: json['currentlyFallen'] as bool,
      lastFallTime: json['lastFallTime'] == null
          ? null
          : DateTime.parse(json['lastFallTime'] as String),
      fallCountToday: (json['fallCountToday'] as num).toInt(),
      fallCountThisWeek: (json['fallCountThisWeek'] as num).toInt(),
      recentFalls: (json['recentFalls'] as List<dynamic>?)
          ?.map((e) => FallEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$FallStatusModelToJson(FallStatusModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'currentlyFallen': instance.currentlyFallen,
      'lastFallTime': instance.lastFallTime?.toIso8601String(),
      'fallCountToday': instance.fallCountToday,
      'fallCountThisWeek': instance.fallCountThisWeek,
      'recentFalls': instance.recentFalls,
      'status': instance.status,
    };

FallEventModel _$FallEventModelFromJson(Map<String, dynamic> json) =>
    FallEventModel(
      id: (json['id'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      fallType: json['fallType'] as String,
      probability: (json['probability'] as num).toDouble(),
      resolved: json['resolved'] as bool,
      resolution: json['resolution'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
    );

Map<String, dynamic> _$FallEventModelToJson(FallEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'fallType': instance.fallType,
      'probability': instance.probability,
      'resolved': instance.resolved,
      'resolution': instance.resolution,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
    };

FallFeedbackRequest _$FallFeedbackRequestFromJson(Map<String, dynamic> json) =>
    FallFeedbackRequest(
      wasActualFall: json['wasActualFall'] as bool,
      userComment: json['userComment'] as String?,
      correctionType: json['correctionType'] as String?,
    );

Map<String, dynamic> _$FallFeedbackRequestToJson(
        FallFeedbackRequest instance) =>
    <String, dynamic>{
      'wasActualFall': instance.wasActualFall,
      'userComment': instance.userComment,
      'correctionType': instance.correctionType,
    };
