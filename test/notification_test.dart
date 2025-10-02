import 'package:flutter_test/flutter_test.dart';
import 'package:bifai_app/data/models/notification_model.dart';

void main() {
  group('Notification 모델 테스트', () {
    test('UpdateFcmTokenRequest 생성 및 직렬화 테스트', () {
      final request = UpdateFcmTokenRequest(
        deviceId: 'test-device-123',
        fcmToken: 'fcm-token-abc123xyz',
      );

      final json = request.toJson();

      expect(json['deviceId'], 'test-device-123');
      expect(json['fcmToken'], 'fcm-token-abc123xyz');
    });

    test('UpdateFcmTokenRequest 역직렬화 테스트', () {
      final json = {
        'deviceId': 'iphone-14-pro',
        'fcmToken': 'fcm-long-token-string-here',
      };

      final request = UpdateFcmTokenRequest.fromJson(json);

      expect(request.deviceId, 'iphone-14-pro');
      expect(request.fcmToken, 'fcm-long-token-string-here');
    });

    test('NotificationSettingsDto 생성 및 직렬화 테스트', () {
      final settings = NotificationSettingsDto(
        medicationReminders: true,
        scheduleReminders: true,
        emergencyAlerts: true,
        dailySummary: false,
        soundEnabled: true,
        vibrationEnabled: false,
        medicationReminderTime: '08:30',
        dailySummaryTime: '20:00',
        medicationReminderMinutesBefore: 15,
        scheduleReminderMinutesBefore: 30,
      );

      final json = settings.toJson();

      expect(json['medicationReminders'], true);
      expect(json['scheduleReminders'], true);
      expect(json['emergencyAlerts'], true);
      expect(json['dailySummary'], false);
      expect(json['soundEnabled'], true);
      expect(json['vibrationEnabled'], false);
      expect(json['medicationReminderTime'], '08:30');
      expect(json['dailySummaryTime'], '20:00');
      expect(json['medicationReminderMinutesBefore'], 15);
      expect(json['scheduleReminderMinutesBefore'], 30);
    });

    test('NotificationSettingsDto 역직렬화 테스트', () {
      final json = {
        'medicationReminders': false,
        'scheduleReminders': true,
        'emergencyAlerts': true,
        'dailySummary': true,
        'soundEnabled': false,
        'vibrationEnabled': true,
        'medicationReminderTime': '10:00',
        'dailySummaryTime': '22:00',
        'medicationReminderMinutesBefore': 20,
        'scheduleReminderMinutesBefore': 45,
      };

      final settings = NotificationSettingsDto.fromJson(json);

      expect(settings.medicationReminders, false);
      expect(settings.scheduleReminders, true);
      expect(settings.emergencyAlerts, true);
      expect(settings.dailySummary, true);
      expect(settings.soundEnabled, false);
      expect(settings.vibrationEnabled, true);
      expect(settings.medicationReminderTime, '10:00');
      expect(settings.dailySummaryTime, '22:00');
      expect(settings.medicationReminderMinutesBefore, 20);
      expect(settings.scheduleReminderMinutesBefore, 45);
    });

    test('NotificationSettingsDto 기본 설정 생성 테스트', () {
      final defaultSettings = NotificationSettingsDto.getDefault();

      expect(defaultSettings.medicationReminders, true);
      expect(defaultSettings.scheduleReminders, true);
      expect(defaultSettings.emergencyAlerts, true);
      expect(defaultSettings.dailySummary, true);
      expect(defaultSettings.soundEnabled, true);
      expect(defaultSettings.vibrationEnabled, true);
      expect(defaultSettings.medicationReminderTime, '09:00');
      expect(defaultSettings.dailySummaryTime, '21:00');
      expect(defaultSettings.medicationReminderMinutesBefore, 10);
      expect(defaultSettings.scheduleReminderMinutesBefore, 30);
    });

    test('NotificationSettingsDto copyWith 테스트', () {
      final original = NotificationSettingsDto.getDefault();

      final modified = original.copyWith(
        medicationReminders: false,
        soundEnabled: false,
        medicationReminderTime: '07:00',
        medicationReminderMinutesBefore: 5,
      );

      // 변경된 값 확인
      expect(modified.medicationReminders, false);
      expect(modified.soundEnabled, false);
      expect(modified.medicationReminderTime, '07:00');
      expect(modified.medicationReminderMinutesBefore, 5);

      // 변경되지 않은 값 확인
      expect(modified.scheduleReminders, true);
      expect(modified.emergencyAlerts, true);
      expect(modified.vibrationEnabled, true);
      expect(modified.dailySummaryTime, '21:00');
    });

    test('NotificationSettingsDto 한글 표시명 테스트', () {
      final settings = NotificationSettingsDto(
        medicationReminders: true,
        scheduleReminders: true,
        emergencyAlerts: true,
        dailySummary: true,
        soundEnabled: true,
        vibrationEnabled: true,
        medicationReminderTime: '08:00',
        dailySummaryTime: '20:30',
        medicationReminderMinutesBefore: 15,
        scheduleReminderMinutesBefore: 60,
      );

      expect(settings.medicationReminderTimeDisplay, '08:00');
      expect(settings.dailySummaryTimeDisplay, '20:30');
      expect(settings.medicationReminderDisplay, '15분 전');
      expect(settings.scheduleReminderDisplay, '60분 전');
    });

    test('TestNotificationRequest 생성 및 직렬화 테스트', () {
      final request = TestNotificationRequest(
        message: '테스트 알림입니다',
        title: '테스트 제목',
      );

      final json = request.toJson();

      expect(json['message'], '테스트 알림입니다');
      expect(json['title'], '테스트 제목');
    });

    test('TestNotificationRequest null 필드 테스트', () {
      final request = const TestNotificationRequest();

      final json = request.toJson();

      expect(json['message'], null);
      expect(json['title'], null);
    });
  });

  group('엣지 케이스 테스트', () {
    test('NotificationSettingsDto null 옵셔널 필드 처리', () {
      final json = {
        'medicationReminders': true,
        'scheduleReminders': true,
        'emergencyAlerts': true,
        'dailySummary': true,
        'soundEnabled': true,
        'vibrationEnabled': true,
        // medicationReminderTime과 dailySummaryTime null
        'medicationReminderMinutesBefore': 10,
        'scheduleReminderMinutesBefore': 30,
      };

      final settings = NotificationSettingsDto.fromJson(json);

      expect(settings.medicationReminderTime, null);
      expect(settings.dailySummaryTime, null);
      expect(settings.medicationReminderTimeDisplay, '09:00'); // 기본값
      expect(settings.dailySummaryTimeDisplay, '21:00'); // 기본값
    });

    test('알림 전 시간 경계값 테스트', () {
      final settings = NotificationSettingsDto(
        medicationReminders: true,
        scheduleReminders: true,
        emergencyAlerts: true,
        dailySummary: true,
        soundEnabled: true,
        vibrationEnabled: true,
        medicationReminderMinutesBefore: 0, // 최소값
        scheduleReminderMinutesBefore: 120, // 2시간
      );

      expect(settings.medicationReminderMinutesBefore, 0);
      expect(settings.scheduleReminderMinutesBefore, 120);
      expect(settings.medicationReminderDisplay, '0분 전');
      expect(settings.scheduleReminderDisplay, '120분 전');
    });

    test('시간 형식 패턴 테스트', () {
      final settings = NotificationSettingsDto(
        medicationReminders: true,
        scheduleReminders: true,
        emergencyAlerts: true,
        dailySummary: true,
        soundEnabled: true,
        vibrationEnabled: true,
        medicationReminderTime: '00:00', // 자정
        dailySummaryTime: '23:59', // 거의 자정
        medicationReminderMinutesBefore: 10,
        scheduleReminderMinutesBefore: 30,
      );

      expect(settings.medicationReminderTime, '00:00');
      expect(settings.dailySummaryTime, '23:59');
      expect(settings.medicationReminderTimeDisplay, '00:00');
      expect(settings.dailySummaryTimeDisplay, '23:59');
    });
  });
}
