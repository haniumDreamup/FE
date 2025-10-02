/// 인지 수준 Enum
enum CognitiveLevel {
  mild('MILD', '경증'),
  moderate('MODERATE', '중등도'),
  severe('SEVERE', '중증'),
  unknown('UNKNOWN', '미평가');

  const CognitiveLevel(this.code, this.description);
  final String code;
  final String description;

  static CognitiveLevel fromCode(String code) {
    return CognitiveLevel.values.firstWhere(
      (level) => level.code == code,
      orElse: () => CognitiveLevel.moderate,
    );
  }
}

/// 성별 Enum
enum Gender {
  male('MALE', '남성'),
  female('FEMALE', '여성'),
  other('OTHER', '기타');

  const Gender(this.code, this.description);
  final String code;
  final String description;

  static Gender fromCode(String code) {
    return Gender.values.firstWhere(
      (gender) => gender.code == code,
      orElse: () => Gender.other,
    );
  }
}

/// 사용자 모델 (백엔드 User Entity와 동기화)
class UserModel {
  final int userId;
  final String username;
  final String email;
  final String? passwordHash;
  final String name;
  final String? fullName;
  final String? nickname;
  final String? phoneNumber;
  final CognitiveLevel cognitiveLevel;
  final String? profileImageUrl;
  final String timezone;
  final String languagePreference;
  final String? languagePreferenceSecondary;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final bool emailVerified;
  final bool phoneVerified;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final bool isActive;
  final bool emergencyModeEnabled;
  final DateTime? lastLoginAt;
  final DateTime? lastActivityAt;
  final String? provider; // OAuth2 provider (google, kakao, etc.)
  final String? providerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.userId,
    required this.username,
    required this.email,
    this.passwordHash,
    required this.name,
    this.fullName,
    this.nickname,
    this.phoneNumber,
    this.cognitiveLevel = CognitiveLevel.moderate,
    this.profileImageUrl,
    this.timezone = 'Asia/Seoul',
    this.languagePreference = 'ko',
    this.languagePreferenceSecondary,
    this.dateOfBirth,
    this.gender,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.isActive = true,
    this.emergencyModeEnabled = false,
    this.lastLoginAt,
    this.lastActivityAt,
    this.provider,
    this.providerId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['passwordHash'],
      name: json['name'] ?? '',
      fullName: json['fullName'],
      nickname: json['nickname'],
      phoneNumber: json['phoneNumber'],
      cognitiveLevel: json['cognitiveLevel'] != null
          ? CognitiveLevel.fromCode(json['cognitiveLevel'])
          : CognitiveLevel.moderate,
      profileImageUrl: json['profileImageUrl'],
      timezone: json['timezone'] ?? 'Asia/Seoul',
      languagePreference: json['languagePreference'] ?? 'ko',
      languagePreferenceSecondary: json['languagePreferenceSecondary'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'] != null ? Gender.fromCode(json['gender']) : null,
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      emergencyContactName: json['emergencyContactName'],
      emergencyContactPhone: json['emergencyContactPhone'],
      isActive: json['isActive'] ?? true,
      emergencyModeEnabled: json['emergencyModeEnabled'] ?? false,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      lastActivityAt: json['lastActivityAt'] != null
          ? DateTime.parse(json['lastActivityAt'])
          : null,
      provider: json['provider'],
      providerId: json['providerId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'name': name,
      'fullName': fullName,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'cognitiveLevel': cognitiveLevel.code,
      'profileImageUrl': profileImageUrl,
      'timezone': timezone,
      'languagePreference': languagePreference,
      'languagePreferenceSecondary': languagePreferenceSecondary,
      'dateOfBirth': dateOfBirth?.toIso8601String().split('T')[0], // yyyy-MM-dd
      'gender': gender?.code,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'isActive': isActive,
      'emergencyModeEnabled': emergencyModeEnabled,
      'provider': provider,
      'providerId': providerId,
    };
  }

  /// 인지 수준 표시용 텍스트
  String get cognitiveLevelDisplay => cognitiveLevel.description;

  /// 성별 표시용 텍스트
  String get genderDisplay => gender?.description ?? '미설정';
}

/// 사용자 정보 수정 요청 DTO (백엔드 UserUpdateRequest와 동일)
class UserUpdateRequest {
  final String? name;
  final String? nickname;
  final String? phoneNumber;
  final String? address;
  final String? languagePreference;
  final String? profileImageUrl;

  UserUpdateRequest({
    this.name,
    this.nickname,
    this.phoneNumber,
    this.address,
    this.languagePreference,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (nickname != null) 'nickname': nickname,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
      if (languagePreference != null) 'languagePreference': languagePreference,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    };
  }
}