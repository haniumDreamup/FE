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
  final String emergencyType;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final DateTime timestamp;

  const EmergencyCallRequest({
    required this.emergencyType,
    this.description,
    this.latitude,
    this.longitude,
    this.address,
    required this.timestamp,
  });

  factory EmergencyCallRequest.fromJson(Map<String, dynamic> json) =>
      _$EmergencyCallRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyCallRequestToJson(this);

  String get emergencyTypeDisplay {
    switch (emergencyType.toLowerCase()) {
      case 'medical':
        return '의료 응급상황';
      case 'safety':
        return '안전 문제';
      case 'lost':
        return '길을 잃음';
      case 'accident':
        return '사고 발생';
      case 'help':
        return '도움 필요';
      default:
        return '응급상황';
    }
  }

  bool get hasLocation => latitude != null && longitude != null;
}

enum EmergencyType {
  medical('medical', '의료 응급상황', '🚑'),
  safety('safety', '안전 문제', '🚨'),
  lost('lost', '길을 잃음', '🗺️'),
  accident('accident', '사고 발생', '⚠️'),
  help('help', '도움 필요', '🆘');

  const EmergencyType(this.code, this.displayName, this.emoji);
  
  final String code;
  final String displayName;
  final String emoji;

  static EmergencyType fromCode(String code) {
    return EmergencyType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => EmergencyType.help,
    );
  }
}