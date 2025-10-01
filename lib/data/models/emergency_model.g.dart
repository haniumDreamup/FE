// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyContactModel _$EmergencyContactModelFromJson(
        Map<String, dynamic> json) =>
    EmergencyContactModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      relationship: json['relationship'] as String,
      email: json['email'] as String?,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$EmergencyContactModelToJson(
        EmergencyContactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'relationship': instance.relationship,
      'email': instance.email,
      'isPrimary': instance.isPrimary,
      'isActive': instance.isActive,
      'notes': instance.notes,
    };

EmergencyCallRequest _$EmergencyCallRequestFromJson(
        Map<String, dynamic> json) =>
    EmergencyCallRequest(
      type: json['type'] as String,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      severity: json['severity'] as String?,
      imageUrl: json['imageUrl'] as String?,
      fallConfidence: (json['fallConfidence'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$EmergencyCallRequestToJson(
        EmergencyCallRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'severity': instance.severity,
      'imageUrl': instance.imageUrl,
      'fallConfidence': instance.fallConfidence,
    };
