// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guardian_relationship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuardianRelationshipDto _$GuardianRelationshipDtoFromJson(
        Map<String, dynamic> json) =>
    GuardianRelationshipDto(
      relationshipId: (json['relationshipId'] as num).toInt(),
      guardianId: (json['guardianId'] as num).toInt(),
      guardianName: json['guardianName'] as String,
      guardianEmail: json['guardianEmail'] as String,
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      relationshipType:
          $enumDecode(_$RelationshipTypeEnumMap, json['relationshipType']),
      permissionLevel:
          $enumDecode(_$PermissionLevelEnumMap, json['permissionLevel']),
      status: $enumDecode(_$RelationshipStatusEnumMap, json['status']),
      permissionSettings:
          (json['permissionSettings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      emergencyPriority: (json['emergencyPriority'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      lastActiveAt: json['lastActiveAt'] as String?,
      createdAt: json['createdAt'] as String,
      approvedAt: json['approvedAt'] as String?,
    );

Map<String, dynamic> _$GuardianRelationshipDtoToJson(
        GuardianRelationshipDto instance) =>
    <String, dynamic>{
      'relationshipId': instance.relationshipId,
      'guardianId': instance.guardianId,
      'guardianName': instance.guardianName,
      'guardianEmail': instance.guardianEmail,
      'userId': instance.userId,
      'userName': instance.userName,
      'relationshipType': _$RelationshipTypeEnumMap[instance.relationshipType]!,
      'permissionLevel': _$PermissionLevelEnumMap[instance.permissionLevel]!,
      'status': _$RelationshipStatusEnumMap[instance.status]!,
      'permissionSettings': instance.permissionSettings,
      'emergencyPriority': instance.emergencyPriority,
      'notes': instance.notes,
      'lastActiveAt': instance.lastActiveAt,
      'createdAt': instance.createdAt,
      'approvedAt': instance.approvedAt,
    };

const _$RelationshipTypeEnumMap = {
  RelationshipType.parent: 'PARENT',
  RelationshipType.spouse: 'SPOUSE',
  RelationshipType.child: 'CHILD',
  RelationshipType.sibling: 'SIBLING',
  RelationshipType.relative: 'RELATIVE',
  RelationshipType.caregiver: 'CAREGIVER',
  RelationshipType.professional: 'PROFESSIONAL',
  RelationshipType.friend: 'FRIEND',
  RelationshipType.other: 'OTHER',
};

const _$PermissionLevelEnumMap = {
  PermissionLevel.viewOnly: 'VIEW_ONLY',
  PermissionLevel.manage: 'MANAGE',
  PermissionLevel.emergency: 'EMERGENCY',
  PermissionLevel.full: 'FULL',
};

const _$RelationshipStatusEnumMap = {
  RelationshipStatus.pending: 'PENDING',
  RelationshipStatus.active: 'ACTIVE',
  RelationshipStatus.suspended: 'SUSPENDED',
  RelationshipStatus.rejected: 'REJECTED',
  RelationshipStatus.expired: 'EXPIRED',
  RelationshipStatus.terminated: 'TERMINATED',
};

GuardianInvitationRequest _$GuardianInvitationRequestFromJson(
        Map<String, dynamic> json) =>
    GuardianInvitationRequest(
      userId: (json['userId'] as num).toInt(),
      guardianName: json['guardianName'] as String,
      guardianEmail: json['guardianEmail'] as String,
      guardianPhone: json['guardianPhone'] as String?,
      relationshipType:
          $enumDecode(_$RelationshipTypeEnumMap, json['relationshipType']),
      permissionLevel:
          $enumDecode(_$PermissionLevelEnumMap, json['permissionLevel']),
      permissionSettings:
          (json['permissionSettings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      emergencyPriority: (json['emergencyPriority'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$GuardianInvitationRequestToJson(
        GuardianInvitationRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'guardianName': instance.guardianName,
      'guardianEmail': instance.guardianEmail,
      'guardianPhone': instance.guardianPhone,
      'relationshipType': _$RelationshipTypeEnumMap[instance.relationshipType]!,
      'permissionLevel': _$PermissionLevelEnumMap[instance.permissionLevel]!,
      'permissionSettings': instance.permissionSettings,
      'emergencyPriority': instance.emergencyPriority,
      'notes': instance.notes,
    };

GuardianInvitationResponse _$GuardianInvitationResponseFromJson(
        Map<String, dynamic> json) =>
    GuardianInvitationResponse(
      relationshipId: (json['relationshipId'] as num).toInt(),
      invitationToken: json['invitationToken'] as String,
      expiresAt: json['expiresAt'] as String,
      guardianEmail: json['guardianEmail'] as String,
      status: json['status'] as String,
      invitationUrl: json['invitationUrl'] as String?,
    );

Map<String, dynamic> _$GuardianInvitationResponseToJson(
        GuardianInvitationResponse instance) =>
    <String, dynamic>{
      'relationshipId': instance.relationshipId,
      'invitationToken': instance.invitationToken,
      'expiresAt': instance.expiresAt,
      'guardianEmail': instance.guardianEmail,
      'status': instance.status,
      'invitationUrl': instance.invitationUrl,
    };

PermissionUpdateRequest _$PermissionUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    PermissionUpdateRequest(
      permissionLevel: $enumDecodeNullable(
          _$PermissionLevelEnumMap, json['permissionLevel']),
      permissionSettings:
          (json['permissionSettings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
    );

Map<String, dynamic> _$PermissionUpdateRequestToJson(
        PermissionUpdateRequest instance) =>
    <String, dynamic>{
      'permissionLevel': _$PermissionLevelEnumMap[instance.permissionLevel],
      'permissionSettings': instance.permissionSettings,
    };

EmergencyContactDto _$EmergencyContactDtoFromJson(Map<String, dynamic> json) =>
    EmergencyContactDto(
      guardianId: (json['guardianId'] as num).toInt(),
      guardianName: json['guardianName'] as String,
      guardianEmail: json['guardianEmail'] as String,
      guardianPhone: json['guardianPhone'] as String?,
      emergencyPriority: (json['emergencyPriority'] as num).toInt(),
      relationshipType:
          $enumDecode(_$RelationshipTypeEnumMap, json['relationshipType']),
      canReceiveEmergencyAlerts: json['canReceiveEmergencyAlerts'] as bool,
    );

Map<String, dynamic> _$EmergencyContactDtoToJson(
        EmergencyContactDto instance) =>
    <String, dynamic>{
      'guardianId': instance.guardianId,
      'guardianName': instance.guardianName,
      'guardianEmail': instance.guardianEmail,
      'guardianPhone': instance.guardianPhone,
      'emergencyPriority': instance.emergencyPriority,
      'relationshipType': _$RelationshipTypeEnumMap[instance.relationshipType]!,
      'canReceiveEmergencyAlerts': instance.canReceiveEmergencyAlerts,
    };
