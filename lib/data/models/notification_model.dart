import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

/// FCM 토큰 업데이트 요청 DTO
/// Backend: UpdateFcmTokenRequest
@JsonSerializable()
class UpdateFcmTokenRequest {
  final String deviceId;
  final String fcmToken;

  const UpdateFcmTokenRequest({
    required this.deviceId,
    required this.fcmToken,
  });

  factory UpdateFcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFcmTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFcmTokenRequestToJson(this);
}

/// 알림 설정 DTO
/// Backend: NotificationSettingsDto
@JsonSerializable()
class NotificationSettingsDto {
  // 알림 ON/OFF 설정
  final bool medicationReminders;
  final bool scheduleReminders;
  final bool emergencyAlerts;
  final bool dailySummary;
  final bool soundEnabled;
  final bool vibrationEnabled;

  // 알림 시간 설정 (HH:mm 형식)
  final String? medicationReminderTime;
  final String? dailySummaryTime;

  // 알림 빈도 설정 (분 단위)
  final int medicationReminderMinutesBefore; // 약 복용 몇 분 전
  final int scheduleReminderMinutesBefore; // 일정 몇 분 전

  const NotificationSettingsDto({
    required this.medicationReminders,
    required this.scheduleReminders,
    required this.emergencyAlerts,
    required this.dailySummary,
    required this.soundEnabled,
    required this.vibrationEnabled,
    this.medicationReminderTime,
    this.dailySummaryTime,
    required this.medicationReminderMinutesBefore,
    required this.scheduleReminderMinutesBefore,
  });

  factory NotificationSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsDtoToJson(this);

  /// 기본 설정 생성
  factory NotificationSettingsDto.getDefault() {
    return const NotificationSettingsDto(
      medicationReminders: true,
      scheduleReminders: true,
      emergencyAlerts: true,
      dailySummary: true,
      soundEnabled: true,
      vibrationEnabled: true,
      medicationReminderTime: '09:00',
      dailySummaryTime: '21:00',
      medicationReminderMinutesBefore: 10,
      scheduleReminderMinutesBefore: 30,
    );
  }

  /// 설정 복사 (일부 값 변경)
  NotificationSettingsDto copyWith({
    bool? medicationReminders,
    bool? scheduleReminders,
    bool? emergencyAlerts,
    bool? dailySummary,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? medicationReminderTime,
    String? dailySummaryTime,
    int? medicationReminderMinutesBefore,
    int? scheduleReminderMinutesBefore,
  }) {
    return NotificationSettingsDto(
      medicationReminders: medicationReminders ?? this.medicationReminders,
      scheduleReminders: scheduleReminders ?? this.scheduleReminders,
      emergencyAlerts: emergencyAlerts ?? this.emergencyAlerts,
      dailySummary: dailySummary ?? this.dailySummary,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      medicationReminderTime:
          medicationReminderTime ?? this.medicationReminderTime,
      dailySummaryTime: dailySummaryTime ?? this.dailySummaryTime,
      medicationReminderMinutesBefore: medicationReminderMinutesBefore ??
          this.medicationReminderMinutesBefore,
      scheduleReminderMinutesBefore: scheduleReminderMinutesBefore ??
          this.scheduleReminderMinutesBefore,
    );
  }

  /// 한글 표시명
  String get medicationReminderTimeDisplay =>
      medicationReminderTime ?? '09:00';
  String get dailySummaryTimeDisplay => dailySummaryTime ?? '21:00';

  /// 알림 전 시간 한글 표시
  String get medicationReminderDisplay =>
      '$medicationReminderMinutesBefore분 전';
  String get scheduleReminderDisplay => '$scheduleReminderMinutesBefore분 전';
}

/// 테스트 알림 요청 DTO
/// Backend: TestNotificationRequest
@JsonSerializable()
class TestNotificationRequest {
  final String? message;
  final String? title;

  const TestNotificationRequest({
    this.message,
    this.title,
  });

  factory TestNotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$TestNotificationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TestNotificationRequestToJson(this);
}
