import 'guardian_relationship_model.dart' show RelationshipType;

/// 보호자 승인 상태
enum ApprovalStatus {
  pending('PENDING', '대기'),
  approved('APPROVED', '승인'),
  rejected('REJECTED', '거부');

  const ApprovalStatus(this.code, this.description);
  final String code;
  final String description;

  static ApprovalStatus fromCode(String code) {
    return ApprovalStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => ApprovalStatus.pending,
    );
  }
}

/// 관계 유형 helper (백엔드와 동기화된 RelationshipType enum 사용)
class RelationshipTypeHelper {
  static String getIcon(RelationshipType type) {
    switch (type) {
      case RelationshipType.parent:
        return '👨‍👩‍👧';
      case RelationshipType.sibling:
        return '👫';
      case RelationshipType.caregiver:
        return '🤝';
      case RelationshipType.professional:
        return '👨‍⚕️';
      case RelationshipType.spouse:
        return '💑';
      case RelationshipType.child:
        return '👶';
      case RelationshipType.relative:
        return '👨‍👩‍👧‍👦';
      case RelationshipType.friend:
        return '🤝';
      case RelationshipType.other:
        return '📋';
    }
  }

  static String getDescription(RelationshipType type) {
    switch (type) {
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

  static RelationshipType fromString(String code) {
    switch (code.toUpperCase()) {
      case 'PARENT':
        return RelationshipType.parent;
      case 'SPOUSE':
        return RelationshipType.spouse;
      case 'CHILD':
        return RelationshipType.child;
      case 'SIBLING':
        return RelationshipType.sibling;
      case 'RELATIVE':
        return RelationshipType.relative;
      case 'CAREGIVER':
        return RelationshipType.caregiver;
      case 'PROFESSIONAL':
        return RelationshipType.professional;
      case 'FRIEND':
        return RelationshipType.friend;
      default:
        return RelationshipType.other;
    }
  }
}

/// Guardian 정보 모델 (백엔드 Entity와 동기화)
class GuardianModel {
  final int id;
  final String name;
  final String relationship;
  final RelationshipType? relationshipType;
  final String primaryPhone;
  final String? secondaryPhone;
  final String? email;
  final String? address;
  final int emergencyPriority;
  final String? notificationPreferences;
  final bool isPrimary;
  final bool canModifySettings;
  final bool canViewLocation;
  final bool canReceiveAlerts;
  final ApprovalStatus approvalStatus;
  final DateTime? approvedAt;
  final String? approvalNote;
  final DateTime? lastActivityAt;
  final bool isActive;
  final String? rejectionReason;
  final DateTime? terminatedAt;
  final String? terminatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // 추가 필드 (백엔드에서 받을 수 있음)
  final int? userId;
  final int? guardianUserId;

  GuardianModel({
    required this.id,
    required this.name,
    required this.relationship,
    this.relationshipType,
    required this.primaryPhone,
    this.secondaryPhone,
    this.email,
    this.address,
    this.emergencyPriority = 1,
    this.notificationPreferences,
    this.isPrimary = false,
    this.canModifySettings = false,
    this.canViewLocation = true,
    this.canReceiveAlerts = true,
    this.approvalStatus = ApprovalStatus.pending,
    this.approvedAt,
    this.approvalNote,
    this.lastActivityAt,
    this.isActive = true,
    this.rejectionReason,
    this.terminatedAt,
    this.terminatedBy,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.guardianUserId,
  });

  factory GuardianModel.fromJson(Map<String, dynamic> json) {
    return GuardianModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      relationship: json['relationship'] ?? '',
      relationshipType: json['relationshipType'] != null
          ? RelationshipTypeHelper.fromString(json['relationshipType'])
          : null,
      primaryPhone: json['primaryPhone'] ?? '',
      secondaryPhone: json['secondaryPhone'],
      email: json['email'],
      address: json['address'],
      emergencyPriority: json['emergencyPriority'] ?? 1,
      notificationPreferences: json['notificationPreferences'],
      isPrimary: json['isPrimary'] ?? false,
      canModifySettings: json['canModifySettings'] ?? false,
      canViewLocation: json['canViewLocation'] ?? true,
      canReceiveAlerts: json['canReceiveAlerts'] ?? true,
      approvalStatus: json['approvalStatus'] != null
          ? ApprovalStatus.fromCode(json['approvalStatus'])
          : ApprovalStatus.pending,
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      approvalNote: json['approvalNote'],
      lastActivityAt: json['lastActivityAt'] != null
          ? DateTime.parse(json['lastActivityAt'])
          : null,
      isActive: json['isActive'] ?? true,
      rejectionReason: json['rejectionReason'],
      terminatedAt: json['terminatedAt'] != null
          ? DateTime.parse(json['terminatedAt'])
          : null,
      terminatedBy: json['terminatedBy'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      userId: json['userId'],
      guardianUserId: json['guardianUserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'relationshipType': relationshipType?.name.toUpperCase(),
      'primaryPhone': primaryPhone,
      'secondaryPhone': secondaryPhone,
      'email': email,
      'address': address,
      'emergencyPriority': emergencyPriority,
      'notificationPreferences': notificationPreferences,
      'isPrimary': isPrimary,
      'canModifySettings': canModifySettings,
      'canViewLocation': canViewLocation,
      'canReceiveAlerts': canReceiveAlerts,
      'approvalStatus': approvalStatus.code,
      'approvedAt': approvedAt?.toIso8601String(),
      'approvalNote': approvalNote,
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'isActive': isActive,
      'rejectionReason': rejectionReason,
      'terminatedAt': terminatedAt?.toIso8601String(),
      'terminatedBy': terminatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'userId': userId,
      'guardianUserId': guardianUserId,
    };
  }

  /// 표시용 아이콘
  String get categoryIcon {
    if (relationshipType != null) {
      return RelationshipTypeHelper.getIcon(relationshipType!);
    }
    // 관계 문자열로 폴백
    final rel = relationship.toLowerCase();
    if (rel.contains('부모') || rel.contains('parent')) return '👨‍👩‍👧';
    if (rel.contains('형제') || rel.contains('자매') || rel.contains('sibling')) return '👫';
    if (rel.contains('의사') || rel.contains('doctor')) return '👨‍⚕️';
    if (rel.contains('돌봄') || rel.contains('caregiver')) return '🤝';
    return '📋';
  }

  /// 승인 상태 표시
  String get statusDisplay => approvalStatus.description;
}

/// Guardian 관계 정보 모델
class GuardianRelationshipModel {
  final int id;
  final int userId;
  final String userName;
  final int guardianId;
  final String guardianName;
  final String relationship;
  final String status;
  final List<String> permissions;
  final bool canViewLocation;
  final bool canReceiveEmergencyAlerts;
  final bool canViewMedicalInfo;
  final bool canViewSchedule;
  final bool canModifySettings;
  final DateTime? lastActivityAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  GuardianRelationshipModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.guardianId,
    required this.guardianName,
    required this.relationship,
    required this.status,
    required this.permissions,
    required this.canViewLocation,
    required this.canReceiveEmergencyAlerts,
    required this.canViewMedicalInfo,
    required this.canViewSchedule,
    required this.canModifySettings,
    this.lastActivityAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GuardianRelationshipModel.fromJson(Map<String, dynamic> json) {
    return GuardianRelationshipModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      guardianId: json['guardianId'] ?? 0,
      guardianName: json['guardianName'] ?? '',
      relationship: json['relationship'] ?? '',
      status: json['status'] ?? 'PENDING',
      permissions: List<String>.from(json['permissions'] ?? []),
      canViewLocation: json['canViewLocation'] ?? false,
      canReceiveEmergencyAlerts: json['canReceiveEmergencyAlerts'] ?? true,
      canViewMedicalInfo: json['canViewMedicalInfo'] ?? false,
      canViewSchedule: json['canViewSchedule'] ?? false,
      canModifySettings: json['canModifySettings'] ?? false,
      lastActivityAt: json['lastActivityAt'] != null
          ? DateTime.parse(json['lastActivityAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'guardianId': guardianId,
      'guardianName': guardianName,
      'relationship': relationship,
      'status': status,
      'permissions': permissions,
      'canViewLocation': canViewLocation,
      'canReceiveEmergencyAlerts': canReceiveEmergencyAlerts,
      'canViewMedicalInfo': canViewMedicalInfo,
      'canViewSchedule': canViewSchedule,
      'canModifySettings': canModifySettings,
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Guardian 등록 요청 모델 (백엔드 GuardianRequest와 동일)
class GuardianInviteRequest {
  final String guardianEmail;
  final String guardianName;
  final String relationship;
  final String primaryPhone;
  final String? secondaryPhone;
  final String? message;
  final bool canViewLocation;
  final bool canModifySettings;
  final bool canReceiveAlerts;

  GuardianInviteRequest({
    required this.guardianEmail,
    required this.guardianName,
    required this.relationship,
    required this.primaryPhone,
    this.secondaryPhone,
    this.message,
    this.canViewLocation = true,
    this.canModifySettings = false,
    this.canReceiveAlerts = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'guardianEmail': guardianEmail,
      'guardianName': guardianName,
      'relationship': relationship,
      'primaryPhone': primaryPhone,
      'secondaryPhone': secondaryPhone,
      'message': message,
      'canViewLocation': canViewLocation,
      'canModifySettings': canModifySettings,
      'canReceiveAlerts': canReceiveAlerts,
    };
  }
}

/// Guardian 권한 업데이트 요청 모델 (백엔드 GuardianPermissionRequest와 동일)
class GuardianPermissionUpdateRequest {
  final bool canViewLocation;
  final bool canModifySettings;
  final bool canReceiveAlerts;
  final int? emergencyPriority; // 1-5, 낮을수록 우선순위 높음

  GuardianPermissionUpdateRequest({
    required this.canViewLocation,
    required this.canModifySettings,
    required this.canReceiveAlerts,
    this.emergencyPriority,
  });

  Map<String, dynamic> toJson() {
    return {
      'canViewLocation': canViewLocation,
      'canModifySettings': canModifySettings,
      'canReceiveAlerts': canReceiveAlerts,
      if (emergencyPriority != null) 'emergencyPriority': emergencyPriority,
    };
  }
}

/// Guardian 대시보드 모델
class GuardianDashboardModel {
  final int userId;
  final String userName;
  final Map<String, dynamic> dailySummary;
  final Map<String, dynamic> weeklySummary;
  final List<Map<String, dynamic>> recentActivities;
  final Map<String, dynamic> safetyStatus;
  final List<Map<String, dynamic>> upcomingEvents;

  GuardianDashboardModel({
    required this.userId,
    required this.userName,
    required this.dailySummary,
    required this.weeklySummary,
    required this.recentActivities,
    required this.safetyStatus,
    required this.upcomingEvents,
  });

  factory GuardianDashboardModel.fromJson(Map<String, dynamic> json) {
    return GuardianDashboardModel(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      dailySummary: json['dailySummary'] ?? {},
      weeklySummary: json['weeklySummary'] ?? {},
      recentActivities: List<Map<String, dynamic>>.from(json['recentActivities'] ?? []),
      safetyStatus: json['safetyStatus'] ?? {},
      upcomingEvents: List<Map<String, dynamic>>.from(json['upcomingEvents'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'dailySummary': dailySummary,
      'weeklySummary': weeklySummary,
      'recentActivities': recentActivities,
      'safetyStatus': safetyStatus,
      'upcomingEvents': upcomingEvents,
    };
  }
}

/// Protected User 정보 모델 (Guardian이 보호하는 사용자)
class ProtectedUserModel {
  final int userId;
  final String userName;
  final String email;
  final String relationship;
  final String status;
  final DateTime? lastActiveAt;
  final bool isOnline;
  final Map<String, dynamic>? lastLocation;

  ProtectedUserModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.relationship,
    required this.status,
    this.lastActiveAt,
    required this.isOnline,
    this.lastLocation,
  });

  factory ProtectedUserModel.fromJson(Map<String, dynamic> json) {
    return ProtectedUserModel(
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      relationship: json['relationship'] ?? '',
      status: json['status'] ?? '',
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'])
          : null,
      isOnline: json['isOnline'] ?? false,
      lastLocation: json['lastLocation'] != null
          ? Map<String, dynamic>.from(json['lastLocation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'relationship': relationship,
      'status': status,
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'isOnline': isOnline,
      'lastLocation': lastLocation,
    };
  }
}