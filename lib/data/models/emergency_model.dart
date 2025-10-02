import 'package:json_annotation/json_annotation.dart';

part 'emergency_model.g.dart';

/// 연락처 유형
enum ContactType {
  @JsonValue('FAMILY') family('가족', '👨‍👩‍👧‍👦'),
  @JsonValue('GUARDIAN') guardian('보호자', '🛡️'),
  @JsonValue('DOCTOR') doctor('의사', '👨‍⚕️'),
  @JsonValue('NURSE') nurse('간호사', '👩‍⚕️'),
  @JsonValue('CAREGIVER') caregiver('요양보호사', '🤝'),
  @JsonValue('EMERGENCY_SERVICE') emergencyService('응급서비스', '🚑'),
  @JsonValue('FRIEND') friend('친구', '🙋'),
  @JsonValue('NEIGHBOR') neighbor('이웃', '🏘️'),
  @JsonValue('OTHER') other('기타', '📋');

  const ContactType(this.description, this.icon);
  final String description;
  final String icon;
}

/// 선호 연락 방법
enum ContactMethod {
  @JsonValue('PHONE') phone('전화', '📞'),
  @JsonValue('SMS') sms('문자', '💬'),
  @JsonValue('EMAIL') email('이메일', '📧'),
  @JsonValue('APP') app('앱 알림', '🔔'),
  @JsonValue('ALL') all('모두', '📱');

  const ContactMethod(this.description, this.icon);
  final String description;
  final String icon;
}

@JsonSerializable()
class EmergencyContactModel {
  final int id;
  final String name;
  final String relationship;
  final String phoneNumber;
  final String? email;
  final ContactType? contactType;
  final int priority;
  final bool isPrimary;
  final bool isActive;
  final bool? canReceiveAlerts;
  final bool? canAccessLocation;
  final bool? canAccessHealthData;
  final bool? canMakeDecisions;
  final String? availableStartTime;
  final String? availableEndTime;
  final String? availableDays;
  final ContactMethod? preferredContactMethod;
  final String? languagePreference;
  final String? notes;
  final bool? isMedicalProfessional;
  final String? specialization;
  final String? hospitalName;
  final String? licenseNumber;
  final String? lastContactedAt;
  final int? contactCount;
  final double? responseRate;
  final int? averageResponseTimeMinutes;
  final bool? verified;
  final String? verifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final bool? isAvailable;
  final bool? isMedicalStaff;
  final String? permissionSummary;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    this.email,
    this.contactType,
    this.priority = 999,
    this.isPrimary = false,
    this.isActive = true,
    this.canReceiveAlerts,
    this.canAccessLocation,
    this.canAccessHealthData,
    this.canMakeDecisions,
    this.availableStartTime,
    this.availableEndTime,
    this.availableDays,
    this.preferredContactMethod,
    this.languagePreference,
    this.notes,
    this.isMedicalProfessional,
    this.specialization,
    this.hospitalName,
    this.licenseNumber,
    this.lastContactedAt,
    this.contactCount,
    this.responseRate,
    this.averageResponseTimeMinutes,
    this.verified,
    this.verifiedAt,
    this.createdAt,
    this.updatedAt,
    this.isAvailable,
    this.isMedicalStaff,
    this.permissionSummary,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactModelToJson(this);

  String get displayName {
    return isPrimary ? '$name (주 연락처)' : name;
  }

  String get categoryIcon {
    if (contactType != null) {
      return contactType!.icon;
    }
    // Fallback for old data
    switch (relationship.toLowerCase()) {
      case 'parent':
      case 'family':
        return '👨‍👩‍👧‍👦';
      case 'guardian':
        return '🛡️';
      case 'doctor':
        return '👨‍⚕️';
      case 'nurse':
        return '👩‍⚕️';
      case 'caregiver':
        return '🤝';
      case 'friend':
        return '🙋';
      default:
        return '📋';
    }
  }

  String get relationshipDisplay {
    if (contactType != null) {
      return contactType!.description;
    }
    // Fallback for old data
    switch (relationship.toLowerCase()) {
      case 'parent':
        return '부모';
      case 'sibling':
        return '형제/자매';
      case 'guardian':
        return '보호자';
      case 'caregiver':
        return '돌봄이';
      case 'friend':
        return '친구';
      case 'doctor':
        return '의사';
      case 'nurse':
        return '간호사';
      default:
        return relationship;
    }
  }

  @override
  String toString() {
    return 'EmergencyContactModel(id: $id, name: $name, relationship: $relationship)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmergencyContactModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class EmergencyCallRequest {
  final String type;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? severity;
  final String? imageUrl;
  final double? fallConfidence;

  const EmergencyCallRequest({
    required this.type,
    this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.severity,
    this.imageUrl,
    this.fallConfidence,
  });

  factory EmergencyCallRequest.fromJson(Map<String, dynamic> json) =>
      _$EmergencyCallRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyCallRequestToJson(this);

  String get emergencyTypeDisplay {
    switch (type.toUpperCase()) {
      case 'MEDICAL':
        return '의료 응급상황';
      case 'SAFETY':
        return '안전 문제';
      case 'LOST':
        return '길을 잃음';
      case 'ACCIDENT':
        return '사고 발생';
      case 'FALL':
        return '낙상';
      case 'OTHER':
        return '기타';
      default:
        return '응급상황';
    }
  }

  bool get hasLocation => latitude != null && longitude != null;
}

enum EmergencyType {
  fallDetected('FALL_DETECTED', '낙상 감지', '🚨'),
  fallDetection('FALL_DETECTION', '낙상 감지', '🚨'),
  panicButton('PANIC_BUTTON', '긴급 버튼', '🆘'),
  manualAlert('MANUAL_ALERT', '수동 호출', '📞'),
  lost('LOST', '길 잃음', '🗺️'),
  medical('MEDICAL', '의료 긴급', '🚑'),
  geofenceExit('GEOFENCE_EXIT', '안전구역 이탈', '⚠️'),
  deviceOffline('DEVICE_OFFLINE', '기기 오프라인', '📱'),
  medicationMissed('MEDICATION_MISSED', '약물 미복용', '💊'),
  abnormalPattern('ABNORMAL_PATTERN', '비정상 패턴', '⚡'),
  other('OTHER', '기타', '📋');

  const EmergencyType(this.code, this.displayName, this.emoji);

  final String code;
  final String displayName;
  final String emoji;

  static EmergencyType fromCode(String code) {
    return EmergencyType.values.firstWhere(
      (type) => type.code == code.toUpperCase(),
      orElse: () => EmergencyType.other,
    );
  }
}

/// 긴급 상황 상태
enum EmergencyStatus {
  @JsonValue('PENDING') pending,
  @JsonValue('TRIGGERED') triggered,
  @JsonValue('NOTIFIED') notified,
  @JsonValue('RESPONDED') responded,
  @JsonValue('RESOLVED') resolved,
  @JsonValue('CANCELLED') cancelled,
}

/// 긴급 상황 심각도
enum EmergencySeverity {
  @JsonValue('LOW') low,
  @JsonValue('MEDIUM') medium,
  @JsonValue('HIGH') high,
  @JsonValue('CRITICAL') critical,
}

/// 발동 소스
enum TriggerSource {
  @JsonValue('USER') user,
  @JsonValue('GUARDIAN') guardian,
  @JsonValue('SYSTEM') system,
  @JsonValue('SENSOR') sensor,
  @JsonValue('MANUAL') manual,
  @JsonValue('AUTO') auto,
}

/// 긴급 상황 응답 DTO
@JsonSerializable()
class EmergencyResponse {
  final int id;
  final int userId;
  final String userName;
  final EmergencyType type;
  final String typeDescription;
  final EmergencyStatus status;
  final String statusDescription;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? description;
  final EmergencySeverity? severity;
  final String? severityDescription;
  final TriggerSource? triggeredBy;
  final double? fallConfidence;
  final String? imageUrl;
  final String createdAt;
  final String? resolvedAt;
  final String? resolvedBy;
  final String? resolutionNotes;
  final int? responseTimeSeconds;
  final List<String>? notifiedGuardians;
  final bool notificationSent;
  final int? responderCount;

  const EmergencyResponse({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    required this.typeDescription,
    required this.status,
    required this.statusDescription,
    this.latitude,
    this.longitude,
    this.address,
    this.description,
    this.severity,
    this.severityDescription,
    this.triggeredBy,
    this.fallConfidence,
    this.imageUrl,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
    this.responseTimeSeconds,
    this.notifiedGuardians,
    this.notificationSent = false,
    this.responderCount,
  });

  factory EmergencyResponse.fromJson(Map<String, dynamic> json) =>
      _$EmergencyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyResponseToJson(this);
}

/// 낙상 감지 요청 DTO
@JsonSerializable()
class FallDetectionRequest {
  final double confidence;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String? additionalInfo;
  final String? deviceId;
  final String? timestamp;
  final int? userId;
  final double? bodyAngle;
  final double? velocity;

  const FallDetectionRequest({
    required this.confidence,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.additionalInfo,
    this.deviceId,
    this.timestamp,
    this.userId,
    this.bodyAngle,
    this.velocity,
  });

  factory FallDetectionRequest.fromJson(Map<String, dynamic> json) =>
      _$FallDetectionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FallDetectionRequestToJson(this);
}

/// SOS 요청 DTO
@JsonSerializable()
class SOSRequest {
  final double latitude;
  final double longitude;
  final String? address;
  final String? message;
  final String? emergencyType;
  final bool notifyAllContacts;
  final bool requestAmbulance;
  final bool shareLocation;
  final String? additionalInfo;

  const SOSRequest({
    required this.latitude,
    required this.longitude,
    this.address,
    this.message,
    this.emergencyType,
    this.notifyAllContacts = true,
    this.requestAmbulance = false,
    this.shareLocation = true,
    this.additionalInfo,
  });

  factory SOSRequest.fromJson(Map<String, dynamic> json) =>
      _$SOSRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SOSRequestToJson(this);
}

/// SOS 응답 DTO
@JsonSerializable()
class SOSResponse {
  final int emergencyId;
  final String status;
  final String message;
  final String triggeredAt;
  final int? notifiedContacts;
  final List<String>? notifiedContactNames;
  final bool? locationShared;
  final String? estimatedResponseTime;
  final String? emergencyNumber;
  final String? simpleInstruction;
  final bool success;

  const SOSResponse({
    required this.emergencyId,
    required this.status,
    required this.message,
    required this.triggeredAt,
    this.notifiedContacts,
    this.notifiedContactNames,
    this.locationShared,
    this.estimatedResponseTime,
    this.emergencyNumber,
    this.simpleInstruction,
    this.success = true,
  });

  factory SOSResponse.fromJson(Map<String, dynamic> json) =>
      _$SOSResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SOSResponseToJson(this);
}

/// SOS 이력 응답 DTO
@JsonSerializable()
class SOSHistory {
  final int emergencyId;
  final String? emergencyType;
  final String? status;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? description;
  final String? severity;
  final String? triggeredBy;
  final String triggeredAt;
  final String? resolvedAt;
  final String? resolvedBy;
  final String? resolutionNotes;
  final int? responseTimeSeconds;
  final bool notificationSent;
  final int? notificationCount;

  const SOSHistory({
    required this.emergencyId,
    this.emergencyType,
    this.status,
    this.latitude,
    this.longitude,
    this.address,
    this.description,
    this.severity,
    this.triggeredBy,
    required this.triggeredAt,
    this.resolvedAt,
    this.resolvedBy,
    this.resolutionNotes,
    this.responseTimeSeconds,
    this.notificationSent = false,
    this.notificationCount,
  });

  factory SOSHistory.fromJson(Map<String, dynamic> json) =>
      _$SOSHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SOSHistoryToJson(this);

  String get statusDisplay {
    switch (status?.toUpperCase()) {
      case 'PENDING':
        return '대기중';
      case 'TRIGGERED':
        return '발동됨';
      case 'NOTIFIED':
        return '알림 전송됨';
      case 'RESPONDED':
        return '응답함';
      case 'RESOLVED':
        return '해결됨';
      case 'CANCELLED':
        return '취소됨';
      default:
        return '알 수 없음';
    }
  }

  String get severityDisplay {
    switch (severity?.toUpperCase()) {
      case 'LOW':
        return '낮음';
      case 'MEDIUM':
        return '보통';
      case 'HIGH':
        return '높음';
      case 'CRITICAL':
        return '매우 위급';
      default:
        return '알 수 없음';
    }
  }
}