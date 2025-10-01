// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAnalysisResponse _$ImageAnalysisResponseFromJson(
        Map<String, dynamic> json) =>
    ImageAnalysisResponse(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      analysisType: json['analysisType'] as String?,
      result: json['result'] as Map<String, dynamic>?,
      detectedObjects: (json['detectedObjects'] as List<dynamic>?)
          ?.map((e) => DetectedObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      detectedLabels: (json['detectedLabels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      detectedText: json['detectedText'] as String?,
      hasDanger: json['hasDanger'] as bool?,
      dangerTypes: (json['dangerTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$ImageAnalysisResponseToJson(
        ImageAnalysisResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'analysisType': instance.analysisType,
      'result': instance.result,
      'detectedObjects': instance.detectedObjects,
      'detectedLabels': instance.detectedLabels,
      'detectedText': instance.detectedText,
      'hasDanger': instance.hasDanger,
      'dangerTypes': instance.dangerTypes,
      'confidence': instance.confidence,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

DetectedObject _$DetectedObjectFromJson(Map<String, dynamic> json) =>
    DetectedObject(
      name: json['name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      boundingBox: json['boundingBox'] == null
          ? null
          : BoundingBox.fromJson(json['boundingBox'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetectedObjectToJson(DetectedObject instance) =>
    <String, dynamic>{
      'name': instance.name,
      'confidence': instance.confidence,
      'boundingBox': instance.boundingBox,
    };

BoundingBox _$BoundingBoxFromJson(Map<String, dynamic> json) => BoundingBox(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
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
