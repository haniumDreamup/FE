import 'package:json_annotation/json_annotation.dart';

part 'image_analysis_model.g.dart';

/// 이미지 분석 응답 (백엔드 DTO와 일치)
@JsonSerializable()
class ImageAnalysisResponse {
  final int? analysisId;
  final String? imageUrl;
  final String? analysisStatus; // UPLOADED, PROCESSING, COMPLETED, FAILED
  final String? situationDescription; // 상황 설명
  final String? actionSuggestion; // 추천 행동
  final String? safetyLevel; // SAFE, CAUTION, WARNING, DANGER
  final List<DetectedObject>? detectedObjects;
  final String? extractedText; // 추출된 텍스트
  final bool? emergencyDetected; // 긴급 상황 여부
  final bool? voiceGuidanceSent; // 음성 안내 전송 여부
  final int? processingTimeMs; // 처리 시간
  final DateTime? analyzedAt;

  ImageAnalysisResponse({
    this.analysisId,
    this.imageUrl,
    this.analysisStatus,
    this.situationDescription,
    this.actionSuggestion,
    this.safetyLevel,
    this.detectedObjects,
    this.extractedText,
    this.emergencyDetected,
    this.voiceGuidanceSent,
    this.processingTimeMs,
    this.analyzedAt,
  });

  factory ImageAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ImageAnalysisResponseToJson(this);
}

/// 감지된 객체 (백엔드 DTO와 일치)
@JsonSerializable()
class DetectedObject {
  final String? label; // 객체 이름 (한국어)
  final String? englishLabel; // 객체 이름 (영어)
  final double? confidence; // 확신도 (0.0 ~ 1.0)
  final BoundingBox? bbox; // 바운딩 박스
  final String? description; // 간단한 설명

  DetectedObject({
    this.label,
    this.englishLabel,
    this.confidence,
    this.bbox,
    this.description,
  });

  factory DetectedObject.fromJson(Map<String, dynamic> json) =>
      _$DetectedObjectFromJson(json);

  Map<String, dynamic> toJson() => _$DetectedObjectToJson(this);
}

/// 바운딩 박스 (객체 위치, 백엔드 DTO와 일치)
@JsonSerializable()
class BoundingBox {
  final int? x; // 시작 X 좌표
  final int? y; // 시작 Y 좌표
  final int? width; // 너비
  final int? height; // 높이

  BoundingBox({
    this.x,
    this.y,
    this.width,
    this.height,
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
