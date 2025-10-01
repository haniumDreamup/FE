import 'package:json_annotation/json_annotation.dart';

part 'pose_model.g.dart';

/// MediaPipe Pose 데이터 DTO
@JsonSerializable()
class PoseDataModel {
  final int userId;
  final DateTime timestamp;
  final List<PoseLandmark> landmarks;
  final double confidence;
  final Map<String, dynamic>? metadata;

  PoseDataModel({
    required this.userId,
    required this.timestamp,
    required this.landmarks,
    required this.confidence,
    this.metadata,
  });

  factory PoseDataModel.fromJson(Map<String, dynamic> json) =>
      _$PoseDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PoseDataModelToJson(this);
}

/// Pose Landmark (관절 좌표)
@JsonSerializable()
class PoseLandmark {
  final String name;
  final double x;
  final double y;
  final double z;
  final double visibility;

  PoseLandmark({
    required this.name,
    required this.x,
    required this.y,
    required this.z,
    required this.visibility,
  });

  factory PoseLandmark.fromJson(Map<String, dynamic> json) =>
      _$PoseLandmarkFromJson(json);

  Map<String, dynamic> toJson() => _$PoseLandmarkToJson(this);
}

/// Pose 처리 응답
@JsonSerializable()
class PoseResponseModel {
  final bool success;
  final String message;
  final bool fallDetected;
  final double? fallProbability;
  final String? fallType;
  final DateTime? processedAt;

  PoseResponseModel({
    required this.success,
    required this.message,
    required this.fallDetected,
    this.fallProbability,
    this.fallType,
    this.processedAt,
  });

  factory PoseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PoseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PoseResponseModelToJson(this);
}

/// 낙상 상태 조회 응답
@JsonSerializable()
class FallStatusModel {
  final int userId;
  final bool currentlyFallen;
  final DateTime? lastFallTime;
  final int fallCountToday;
  final int fallCountThisWeek;
  final List<FallEventModel>? recentFalls;
  final String status;

  FallStatusModel({
    required this.userId,
    required this.currentlyFallen,
    this.lastFallTime,
    required this.fallCountToday,
    required this.fallCountThisWeek,
    this.recentFalls,
    required this.status,
  });

  factory FallStatusModel.fromJson(Map<String, dynamic> json) =>
      _$FallStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$FallStatusModelToJson(this);
}

/// 낙상 이벤트
@JsonSerializable()
class FallEventModel {
  final int id;
  final DateTime timestamp;
  final String fallType;
  final double probability;
  final bool resolved;
  final String? resolution;
  final DateTime? resolvedAt;

  FallEventModel({
    required this.id,
    required this.timestamp,
    required this.fallType,
    required this.probability,
    required this.resolved,
    this.resolution,
    this.resolvedAt,
  });

  factory FallEventModel.fromJson(Map<String, dynamic> json) =>
      _$FallEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$FallEventModelToJson(this);
}

/// 낙상 피드백 요청
@JsonSerializable()
class FallFeedbackRequest {
  final bool wasActualFall;
  final String? userComment;
  final String? correctionType;

  FallFeedbackRequest({
    required this.wasActualFall,
    this.userComment,
    this.correctionType,
  });

  factory FallFeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$FallFeedbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FallFeedbackRequestToJson(this);
}
