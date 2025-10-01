/// Guardian 정보 모델
class GuardianModel {
  final int id;
  final int userId;
  final int guardianId;
  final String guardianName;
  final String guardianEmail;
  final String guardianPhone;
  final String relationship;
  final String status; // PENDING, ACTIVE, SUSPENDED, TERMINATED
  final List<String> permissions;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  GuardianModel({
    required this.id,
    required this.userId,
    required this.guardianId,
    required this.guardianName,
    required this.guardianEmail,
    required this.guardianPhone,
    required this.relationship,
    required this.status,
    required this.permissions,
    this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GuardianModel.fromJson(Map<String, dynamic> json) {
    return GuardianModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      guardianId: json['guardianId'] ?? 0,
      guardianName: json['guardianName'] ?? '',
      guardianEmail: json['guardianEmail'] ?? '',
      guardianPhone: json['guardianPhone'] ?? '',
      relationship: json['relationship'] ?? '',
      status: json['status'] ?? 'PENDING',
      permissions: List<String>.from(json['permissions'] ?? []),
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'guardianId': guardianId,
      'guardianName': guardianName,
      'guardianEmail': guardianEmail,
      'guardianPhone': guardianPhone,
      'relationship': relationship,
      'status': status,
      'permissions': permissions,
      'approvedAt': approvedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
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

/// Guardian 초대 요청 모델
class GuardianInviteRequest {
  final String guardianEmail;
  final String relationship;
  final List<String> permissions;
  final String? message;

  GuardianInviteRequest({
    required this.guardianEmail,
    required this.relationship,
    required this.permissions,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'guardianEmail': guardianEmail,
      'relationship': relationship,
      'permissions': permissions,
      'message': message,
    };
  }
}

/// Guardian 권한 업데이트 요청 모델
class GuardianPermissionUpdateRequest {
  final List<String> permissions;
  final bool canViewLocation;
  final bool canReceiveEmergencyAlerts;
  final bool canViewMedicalInfo;
  final bool canViewSchedule;
  final bool canModifySettings;

  GuardianPermissionUpdateRequest({
    required this.permissions,
    required this.canViewLocation,
    required this.canReceiveEmergencyAlerts,
    required this.canViewMedicalInfo,
    required this.canViewSchedule,
    required this.canModifySettings,
  });

  Map<String, dynamic> toJson() {
    return {
      'permissions': permissions,
      'canViewLocation': canViewLocation,
      'canReceiveEmergencyAlerts': canReceiveEmergencyAlerts,
      'canViewMedicalInfo': canViewMedicalInfo,
      'canViewSchedule': canViewSchedule,
      'canModifySettings': canModifySettings,
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