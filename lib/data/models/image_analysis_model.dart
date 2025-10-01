import 'package:json_annotation/json_annotation.dart';

part 'image_analysis_model.g.dart';

/// 이미지 분석 응답
@JsonSerializable()
class ImageAnalysisResponse {
  final int id;
  final String status;
  final String? analysisType;
  final Map<String, dynamic>? result;
  final List<DetectedObject>? detectedObjects;
  final List<String>? detectedLabels;
  final String? detectedText;
  final bool? hasDanger;
  final List<String>? dangerTypes;
  final double? confidence;
  final DateTime createdAt;
  final DateTime? completedAt;

  ImageAnalysisResponse({
    required this.id,
    required this.status,
    this.analysisType,
    this.result,
    this.detectedObjects,
    this.detectedLabels,
    this.detectedText,
    this.hasDanger,
    this.dangerTypes,
    this.confidence,
    required this.createdAt,
    this.completedAt,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAnalysisResponseToJson(this);
}

/// 감지된 객체
@JsonSerializable()
class DetectedObject {
  final String name;
  final double confidence;
  final BoundingBox? boundingBox;

  DetectedObject({
    required this.name,
    required this.confidence,
    this.boundingBox,
  });

  factory DetectedObject.fromJson(Map<String, dynamic> json) =>
      _$DetectedObjectFromJson(json);

  Map<String, dynamic> toJson() => _$DetectedObjectToJson(this);
}

/// 바운딩 박스 (객체 위치)
@JsonSerializable()
class BoundingBox {
  final double x;
  final double y;
  final double width;
  final double height;

  BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) =>
      _$BoundingBoxFromJson(json);

  Map<String, dynamic> toJson() => _$BoundingBoxToJson(this);
}

/// 이미지 업로드 요청
@JsonSerializable()
class ImageUploadRequest {
  final String? description;
  final String? location;
  final bool? urgent;
  final String? analysisType;

  ImageUploadRequest({
    this.description,
    this.location,
    this.urgent,
    this.analysisType,
  });

  factory ImageUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUploadRequestToJson(this);
}

/// 빠른 분석 응답
@JsonSerializable()
class QuickAnalysisResponse {
  final bool hasDanger;
  final List<String> dangerTypes;
  final double confidence;
  final String message;

  QuickAnalysisResponse({
    required this.hasDanger,
    required this.dangerTypes,
    required this.confidence,
    required this.message,
  });

  factory QuickAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$QuickAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuickAnalysisResponseToJson(this);
}
