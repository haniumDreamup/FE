// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateFcmTokenRequest _$UpdateFcmTokenRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateFcmTokenRequest(
      deviceId: json['deviceId'] as String,
      fcmToken: json['fcmToken'] as String,
    );

Map<String, dynamic> _$UpdateFcmTokenRequestToJson(
        UpdateFcmTokenRequest instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
    };

NotificationSettingsDto _$NotificationSettingsDtoFromJson(
        Map<String, dynamic> json) =>
    NotificationSettingsDto(
      medicationReminders: json['medicationReminders'] as bool,
      scheduleReminders: json['scheduleReminders'] as bool,
      emergencyAlerts: json['emergencyAlerts'] as bool,
      dailySummary: json['dailySummary'] as bool,
      soundEnabled: json['soundEnabled'] as bool,
      vibrationEnabled: json['vibrationEnabled'] as bool,
      medicationReminderTime: json['medicationReminderTime'] as String?,
      dailySummaryTime: json['dailySummaryTime'] as String?,
      medicationReminderMinutesBefore:
          (json['medicationReminderMinutesBefore'] as num).toInt(),
      scheduleReminderMinutesBefore:
          (json['scheduleReminderMinutesBefore'] as num).toInt(),
    );

Map<String, dynamic> _$NotificationSettingsDtoToJson(
        NotificationSettingsDto instance) =>
    <String, dynamic>{
      'medicationReminders': instance.medicationReminders,
      'scheduleReminders': instance.scheduleReminders,
      'emergencyAlerts': instance.emergencyAlerts,
      'dailySummary': instance.dailySummary,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'medicationReminderTime': instance.medicationReminderTime,
      'dailySummaryTime': instance.dailySummaryTime,
      'medicationReminderMinutesBefore':
          instance.medicationReminderMinutesBefore,
      'scheduleReminderMinutesBefore': instance.scheduleReminderMinutesBefore,
    };

TestNotificationRequest _$TestNotificationRequestFromJson(
        Map<String, dynamic> json) =>
    TestNotificationRequest(
      message: json['message'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$TestNotificationRequestToJson(
        TestNotificationRequest instance) =>
    <String, dynamic>{
      'message': instance.message,
      'title': instance.title,
    };
