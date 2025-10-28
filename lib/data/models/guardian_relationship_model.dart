import 'package:json_annotation/json_annotation.dart';

part 'guardian_relationship_model.g.dart';

/// 관계 유형 - 백엔드와 동기화됨
enum RelationshipType {
  @JsonValue('PARENT') parent,
  @JsonValue('SPOUSE') spouse,
  @JsonValue('CHILD') child,
  @JsonValue('SIBLING') sibling,
  @JsonValue('RELATIVE') relative,
  @JsonValue('CAREGIVER') caregiver,
  @JsonValue('PROFESSIONAL') professional,
  @JsonValue('FRIEND') friend,
  @JsonValue('OTHER') other,
}

/// 권한 레벨
enum PermissionLevel {
  @JsonValue('VIEW_ONLY') viewOnly,
  @JsonValue('MANAGE') manage,
  @JsonValue('EMERGENCY') emergency,
  @JsonValue('FULL') full,
}

/// 관계 상태
enum RelationshipStatus {
  @JsonValue('PENDING') pending,
  @JsonValue('ACTIVE') active,
  @JsonValue('SUSPENDED') suspended,
  @JsonValue('REJECTED') rejected,
  @JsonValue('EXPIRED') expired,
  @JsonValue('TERMINATED') terminated,
}

/// 보호자 관계 DTO
@JsonSerializable()
class GuardianRelationshipDto {
  final int relationshipId;
  final int guardianId;
  final String guardianName;
  final String guardianEmail;
  final int userId;
  final String userName;
  final RelationshipType relationshipType;
  final PermissionLevel permissionLevel;
  final RelationshipStatus status;
  final Map<String, bool>? permissionSettings;
  final int? emergencyPriority;
  final String? notes;
  final String? lastActiveAt;
  final String createdAt;
  final String? approvedAt;

  const GuardianRelationshipDto({
    required this.relationshipId,
    required this.guardianId,
    required this.guardianName,
    required this.guardianEmail,
    required this.userId,
    required this.userName,
    required this.relationshipType,
    required this.permissionLevel,
    required this.status,
    this.permissionSettings,
    this.emergencyPriority,
    this.notes,
    this.lastActiveAt,
    required this.createdAt,
    this.approvedAt,
  });

  factory GuardianRelationshipDto.fromJson(Map<String, dynamic> json) =>
      _$GuardianRelationshipDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GuardianRelationshipDtoToJson(this);

  /// 관계 타입 한글 표시
  String get relationshipTypeDisplay {
    switch (relationshipType) {
      case RelationshipType.parent:
        return '부모';
      case RelationshipType.spouse:
        return '배우자';
      case RelationshipType.child:
        return '자녀';
      case RelationshipType.sibling:
        return '형제자매';
      case RelationshipType.relative:
        return '친척';
      case RelationshipType.caregiver:
        return '간병인';
      case RelationshipType.professional:
        return '전문가';
      case RelationshipType.friend:
        return '친구';
      case RelationshipType.other:
        return '기타';
    }
  }

  /// 권한 레벨 한글 표시
  String get permissionLevelDisplay {
    switch (permissionLevel) {
      case PermissionLevel.viewOnly:
        return '읽기 전용';
      case PermissionLevel.manage:
        return '관리';
      case PermissionLevel.emergency:
        return '긴급 상황만';
      case PermissionLevel.full:
        return '전체 권한';
    }
  }

  /// 상태 한글 표시
  String get statusDisplay {
    switch (status) {
      case RelationshipStatus.pending:
        return '대기 중';
      case RelationshipStatus.active:
        return '활성';
      case RelationshipStatus.suspended:
        return '일시 중지';
      case RelationshipStatus.rejected:
        return '거부됨';
      case RelationshipStatus.expired:
        return '만료됨';
      case RelationshipStatus.terminated:
        return '종료됨';
    }
  }

  /// 활성 상태 여부
  bool get isActive => status == RelationshipStatus.active;
}

/// 보호자 초대 요청 DTO
@JsonSerializable()
class GuardianInvitationRequest {
  final int userId;
  final String guardianName;
  final String guardianEmail;
  final String? guardianPhone;
  final RelationshipType relationshipType;
  final PermissionLevel permissionLevel;
  final Map<String, bool>? permissionSettings;
  final int? emergencyPriority;
  final String? notes;

  const GuardianInvitationRequest({
    required this.userId,
    required this.guardianName,
    required this.guardianEmail,
    this.guardianPhone,
    required this.relationshipType,
    required this.permissionLevel,
    this.permissionSettings,
    this.emergencyPriority,
    this.notes,
  });

  factory GuardianInvitationRequest.fromJson(Map<String, dynamic> json) =>
      _$GuardianInvitationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GuardianInvitationRequestToJson(this);
}

/// 보호자 초대 응답 DTO
@JsonSerializable()
class GuardianInvitationResponse {
  final int relationshipId;
  final String invitationToken;
  final String expiresAt;
  final String guardianEmail;
  final String status;
  final String? invitationUrl;

  const GuardianInvitationResponse({
    required this.relationshipId,
    required this.invitationToken,
    required this.expiresAt,
    required this.guardianEmail,
    required this.status,
    this.invitationUrl,
  });

  factory GuardianInvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$GuardianInvitationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GuardianInvitationResponseToJson(this);
}

/// 권한 업데이트 요청 DTO
@JsonSerializable()
class PermissionUpdateRequest {
  final PermissionLevel? permissionLevel;
  final Map<String, bool>? permissionSettings;

  const PermissionUpdateRequest({
    this.permissionLevel,
    this.permissionSettings,
  });

  factory PermissionUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$PermissionUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionUpdateRequestToJson(this);
}

/// 긴급 연락처 DTO
@JsonSerializable()
class EmergencyContactDto {
  final int guardianId;
  final String guardianName;
  final String guardianEmail;
  final String? guardianPhone;
  final int emergencyPriority;
  final RelationshipType relationshipType;
  final bool canReceiveEmergencyAlerts;

  const EmergencyContactDto({
    required this.guardianId,
    required this.guardianName,
    required this.guardianEmail,
    this.guardianPhone,
    required this.emergencyPriority,
    required this.relationshipType,
    required this.canReceiveEmergencyAlerts,
  });

  factory EmergencyContactDto.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyContactDtoToJson(this);
}
