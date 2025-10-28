// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAnalysisResponse _$ImageAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    ImageAnalysisResponse(
      analysisId: (json['analysisId'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      analysisStatus: json['analysisStatus'] as String?,
      situationDescription: json['situationDescription'] as String?,
      actionSuggestion: json['actionSuggestion'] as String?,
      safetyLevel: json['safetyLevel'] as String?,
      detectedObjects: (json['detectedObjects'] as List<dynamic>?)
          ?.map((e) => DetectedObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      extractedText: json['extractedText'] as String?,
      emergencyDetected: json['emergencyDetected'] as bool?,
      voiceGuidanceSent: json['voiceGuidanceSent'] as bool?,
      processingTimeMs: (json['processingTimeMs'] as num?)?.toInt(),
      analyzedAt: json['analyzedAt'] == null
          ? null
          : DateTime.parse(json['analyzedAt'] as String),
    );

Map<String, dynamic> _$ImageAnalysisResponseToJson(
        ImageAnalysisResponse instance) =>
    <String, dynamic>{
      'analysisId': instance.analysisId,
      'imageUrl': instance.imageUrl,
      'analysisStatus': instance.analysisStatus,
      'situationDescription': instance.situationDescription,
      'actionSuggestion': instance.actionSuggestion,
      'safetyLevel': instance.safetyLevel,
      'detectedObjects': instance.detectedObjects,
      'extractedText': instance.extractedText,
      'emergencyDetected': instance.emergencyDetected,
      'voiceGuidanceSent': instance.voiceGuidanceSent,
      'processingTimeMs': instance.processingTimeMs,
      'analyzedAt': instance.analyzedAt?.toIso8601String(),
    };

DetectedObject _$DetectedObjectFromJson(Map<String, dynamic> json) =>
    DetectedObject(
      label: json['label'] as String?,
      englishLabel: json['englishLabel'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      bbox: json['bbox'] == null
          ? null
          : BoundingBox.fromJson(json['bbox'] as Map<String, dynamic>),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DetectedObjectToJson(DetectedObject instance) =>
    <String, dynamic>{
      'label': instance.label,
      'englishLabel': instance.englishLabel,
      'confidence': instance.confidence,
      'bbox': instance.bbox,
      'description': instance.description,
    };

BoundingBox _$BoundingBoxFromJson(Map<String, dynamic> json) => BoundingBox(
      x: (json['x'] as num?)?.toInt(),
      y: (json['y'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BoundingBoxToJson(BoundingBox instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
    };

ImageUploadRequest _$ImageUploadRequestFromJson(Map<String, dynamic> json) =>
    ImageUploadRequest(
      description: json['description'] as String?,
      location: json['location'] as String?,
      urgent: json['urgent'] as bool?,
      analysisType: json['analysisType'] as String?,
    );

Map<String, dynamic> _$ImageUploadRequestToJson(ImageUploadRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'location': instance.location,
      'urgent': instance.urgent,
      'analysisType': instance.analysisType,
    };

QuickAnalysisResponse _$QuickAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    QuickAnalysisResponse(
      hasDanger: json['hasDanger'] as bool,
      dangerTypes: (json['dangerTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      confidence: (json['confidence'] as num).toDouble(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$QuickAnalysisResponseToJson(
        QuickAnalysisResponse instance) =>
    <String, dynamic>{
      'hasDanger': instance.hasDanger,
      'dangerTypes': instance.dangerTypes,
      'confidence': instance.confidence,
      'message': instance.message,
    };
