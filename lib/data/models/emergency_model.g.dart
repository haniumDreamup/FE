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
      relationship: json['relationship'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      contactType:
          $enumDecodeNullable(_$ContactTypeEnumMap, json['contactType']),
      priority: (json['priority'] as num?)?.toInt() ?? 999,
      isPrimary: json['isPrimary'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      canReceiveAlerts: json['canReceiveAlerts'] as bool?,
      canAccessLocation: json['canAccessLocation'] as bool?,
      canAccessHealthData: json['canAccessHealthData'] as bool?,
      canMakeDecisions: json['canMakeDecisions'] as bool?,
      availableStartTime: json['availableStartTime'] as String?,
      availableEndTime: json['availableEndTime'] as String?,
      availableDays: json['availableDays'] as String?,
      preferredContactMethod: $enumDecodeNullable(
          _$ContactMethodEnumMap, json['preferredContactMethod']),
      languagePreference: json['languagePreference'] as String?,
      notes: json['notes'] as String?,
      isMedicalProfessional: json['isMedicalProfessional'] as bool?,
      specialization: json['specialization'] as String?,
      hospitalName: json['hospitalName'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      lastContactedAt: json['lastContactedAt'] as String?,
      contactCount: (json['contactCount'] as num?)?.toInt(),
      responseRate: (json['responseRate'] as num?)?.toDouble(),
      averageResponseTimeMinutes:
          (json['averageResponseTimeMinutes'] as num?)?.toInt(),
      verified: json['verified'] as bool?,
      verifiedAt: json['verifiedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      isMedicalStaff: json['isMedicalStaff'] as bool?,
      permissionSummary: json['permissionSummary'] as String?,
    );

Map<String, dynamic> _$EmergencyContactModelToJson(
        EmergencyContactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'relationship': instance.relationship,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'contactType': _$ContactTypeEnumMap[instance.contactType],
      'priority': instance.priority,
      'isPrimary': instance.isPrimary,
      'isActive': instance.isActive,
      'canReceiveAlerts': instance.canReceiveAlerts,
      'canAccessLocation': instance.canAccessLocation,
      'canAccessHealthData': instance.canAccessHealthData,
      'canMakeDecisions': instance.canMakeDecisions,
      'availableStartTime': instance.availableStartTime,
      'availableEndTime': instance.availableEndTime,
      'availableDays': instance.availableDays,
      'preferredContactMethod':
          _$ContactMethodEnumMap[instance.preferredContactMethod],
      'languagePreference': instance.languagePreference,
      'notes': instance.notes,
      'isMedicalProfessional': instance.isMedicalProfessional,
      'specialization': instance.specialization,
      'hospitalName': instance.hospitalName,
      'licenseNumber': instance.licenseNumber,
      'lastContactedAt': instance.lastContactedAt,
      'contactCount': instance.contactCount,
      'responseRate': instance.responseRate,
      'averageResponseTimeMinutes': instance.averageResponseTimeMinutes,
      'verified': instance.verified,
      'verifiedAt': instance.verifiedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isAvailable': instance.isAvailable,
      'isMedicalStaff': instance.isMedicalStaff,
      'permissionSummary': instance.permissionSummary,
    };

const _$ContactTypeEnumMap = {
  ContactType.family: 'FAMILY',
  ContactType.guardian: 'GUARDIAN',
  ContactType.doctor: 'DOCTOR',
  ContactType.nurse: 'NURSE',
  ContactType.caregiver: 'CAREGIVER',
  ContactType.emergencyService: 'EMERGENCY_SERVICE',
  ContactType.friend: 'FRIEND',
  ContactType.neighbor: 'NEIGHBOR',
  ContactType.other: 'OTHER',
};

const _$ContactMethodEnumMap = {
  ContactMethod.phone: 'PHONE',
  ContactMethod.sms: 'SMS',
  ContactMethod.email: 'EMAIL',
  ContactMethod.app: 'APP',
  ContactMethod.all: 'ALL',
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

EmergencyResponse _$EmergencyResponseFromJson(Map<String, dynamic> json) =>
    EmergencyResponse(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      type: $enumDecode(_$EmergencyTypeEnumMap, json['type']),
      typeDescription: json['typeDescription'] as String,
      status: $enumDecode(_$EmergencyStatusEnumMap, json['status']),
      statusDescription: json['statusDescription'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      description: json['description'] as String?,
      severity:
          $enumDecodeNullable(_$EmergencySeverityEnumMap, json['severity']),
      severityDescription: json['severityDescription'] as String?,
      triggeredBy:
          $enumDecodeNullable(_$TriggerSourceEnumMap, json['triggeredBy']),
      fallConfidence: (json['fallConfidence'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String,
      resolvedAt: json['resolvedAt'] as String?,
      resolvedBy: json['resolvedBy'] as String?,
      resolutionNotes: json['resolutionNotes'] as String?,
      responseTimeSeconds: (json['responseTimeSeconds'] as num?)?.toInt(),
      notifiedGuardians: (json['notifiedGuardians'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notificationSent: json['notificationSent'] as bool? ?? false,
      responderCount: (json['responderCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmergencyResponseToJson(EmergencyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'type': _$EmergencyTypeEnumMap[instance.type]!,
      'typeDescription': instance.typeDescription,
      'status': _$EmergencyStatusEnumMap[instance.status]!,
      'statusDescription': instance.statusDescription,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'description': instance.description,
      'severity': _$EmergencySeverityEnumMap[instance.severity],
      'severityDescription': instance.severityDescription,
      'triggeredBy': _$TriggerSourceEnumMap[instance.triggeredBy],
      'fallConfidence': instance.fallConfidence,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
      'resolvedAt': instance.resolvedAt,
      'resolvedBy': instance.resolvedBy,
      'resolutionNotes': instance.resolutionNotes,
      'responseTimeSeconds': instance.responseTimeSeconds,
      'notifiedGuardians': instance.notifiedGuardians,
      'notificationSent': instance.notificationSent,
      'responderCount': instance.responderCount,
    };

const _$EmergencyTypeEnumMap = {
  EmergencyType.fallDetected: 'fallDetected',
  EmergencyType.fallDetection: 'fallDetection',
  EmergencyType.panicButton: 'panicButton',
  EmergencyType.manualAlert: 'manualAlert',
  EmergencyType.lost: 'lost',
  EmergencyType.medical: 'medical',
  EmergencyType.geofenceExit: 'geofenceExit',
  EmergencyType.deviceOffline: 'deviceOffline',
  EmergencyType.medicationMissed: 'medicationMissed',
  EmergencyType.abnormalPattern: 'abnormalPattern',
  EmergencyType.other: 'other',
};

const _$EmergencyStatusEnumMap = {
  EmergencyStatus.pending: 'PENDING',
  EmergencyStatus.triggered: 'TRIGGERED',
  EmergencyStatus.notified: 'NOTIFIED',
  EmergencyStatus.responded: 'RESPONDED',
  EmergencyStatus.resolved: 'RESOLVED',
  EmergencyStatus.cancelled: 'CANCELLED',
};

const _$EmergencySeverityEnumMap = {
  EmergencySeverity.low: 'LOW',
  EmergencySeverity.medium: 'MEDIUM',
  EmergencySeverity.high: 'HIGH',
  EmergencySeverity.critical: 'CRITICAL',
};

const _$TriggerSourceEnumMap = {
  TriggerSource.user: 'USER',
  TriggerSource.guardian: 'GUARDIAN',
  TriggerSource.system: 'SYSTEM',
  TriggerSource.sensor: 'SENSOR',
  TriggerSource.manual: 'MANUAL',
  TriggerSource.auto: 'AUTO',
};

FallDetectionRequest _$FallDetectionRequestFromJson(
        Map<String, dynamic> json) =>
    FallDetectionRequest(
      confidence: (json['confidence'] as num).toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
      deviceId: json['deviceId'] as String?,
      timestamp: json['timestamp'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      bodyAngle: (json['bodyAngle'] as num?)?.toDouble(),
      velocity: (json['velocity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FallDetectionRequestToJson(
        FallDetectionRequest instance) =>
    <String, dynamic>{
      'confidence': instance.confidence,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'additionalInfo': instance.additionalInfo,
      'deviceId': instance.deviceId,
      'timestamp': instance.timestamp,
      'userId': instance.userId,
      'bodyAngle': instance.bodyAngle,
      'velocity': instance.velocity,
    };

SOSRequest _$SOSRequestFromJson(Map<String, dynamic> json) => SOSRequest(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String?,
      message: json['message'] as String?,
      emergencyType: json['emergencyType'] as String?,
      notifyAllContacts: json['notifyAllContacts'] as bool? ?? true,
      requestAmbulance: json['requestAmbulance'] as bool? ?? false,
      shareLocation: json['shareLocation'] as bool? ?? true,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$SOSRequestToJson(SOSRequest instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'message': instance.message,
      'emergencyType': instance.emergencyType,
      'notifyAllContacts': instance.notifyAllContacts,
      'requestAmbulance': instance.requestAmbulance,
      'shareLocation': instance.shareLocation,
      'additionalInfo': instance.additionalInfo,
    };

SOSResponse _$SOSResponseFromJson(Map<String, dynamic> json) => SOSResponse(
      emergencyId: (json['emergencyId'] as num).toInt(),
      status: json['status'] as String,
      message: json['message'] as String,
      triggeredAt: json['triggeredAt'] as String,
      notifiedContacts: (json['notifiedContacts'] as num?)?.toInt(),
      notifiedContactNames: (json['notifiedContactNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      locationShared: json['locationShared'] as bool?,
      estimatedResponseTime: json['estimatedResponseTime'] as String?,
      emergencyNumber: json['emergencyNumber'] as String?,
      simpleInstruction: json['simpleInstruction'] as String?,
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$SOSResponseToJson(SOSResponse instance) =>
    <String, dynamic>{
      'emergencyId': instance.emergencyId,
      'status': instance.status,
      'message': instance.message,
      'triggeredAt': instance.triggeredAt,
      'notifiedContacts': instance.notifiedContacts,
      'notifiedContactNames': instance.notifiedContactNames,
      'locationShared': instance.locationShared,
      'estimatedResponseTime': instance.estimatedResponseTime,
      'emergencyNumber': instance.emergencyNumber,
      'simpleInstruction': instance.simpleInstruction,
      'success': instance.success,
    };

SOSHistory _$SOSHistoryFromJson(Map<String, dynamic> json) => SOSHistory(
      emergencyId: (json['emergencyId'] as num).toInt(),
      emergencyType: json['emergencyType'] as String?,
      status: json['status'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      description: json['description'] as String?,
      severity: json['severity'] as String?,
      triggeredBy: json['triggeredBy'] as String?,
      triggeredAt: json['triggeredAt'] as String,
      resolvedAt: json['resolvedAt'] as String?,
      resolvedBy: json['resolvedBy'] as String?,
      resolutionNotes: json['resolutionNotes'] as String?,
      responseTimeSeconds: (json['responseTimeSeconds'] as num?)?.toInt(),
      notificationSent: json['notificationSent'] as bool? ?? false,
      notificationCount: (json['notificationCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SOSHistoryToJson(SOSHistory instance) =>
    <String, dynamic>{
      'emergencyId': instance.emergencyId,
      'emergencyType': instance.emergencyType,
      'status': instance.status,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'description': instance.description,
      'severity': instance.severity,
      'triggeredBy': instance.triggeredBy,
      'triggeredAt': instance.triggeredAt,
      'resolvedAt': instance.resolvedAt,
      'resolvedBy': instance.resolvedBy,
      'resolutionNotes': instance.resolutionNotes,
      'responseTimeSeconds': instance.responseTimeSeconds,
      'notificationSent': instance.notificationSent,
      'notificationCount': instance.notificationCount,
    };
