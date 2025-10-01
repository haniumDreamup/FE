import 'package:json_annotation/json_annotation.dart';

part 'emergency_model.g.dart';

@JsonSerializable()
class EmergencyContactModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final String? email;
  final bool isPrimary;
  final bool isActive;
  final String? notes;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.email,
    this.isPrimary = false,
    this.isActive = true,
    this.notes,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactModelToJson(this);

  String get displayName {
    return isPrimary ? '$name (주 연락처)' : name;
  }

  String get relationshipDisplay {
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