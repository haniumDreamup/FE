import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/cached_medication.dart';
import 'offline_service.dart';
import 'notification_service.dart';

/// 약물 복용 알림 스케줄러 서비스
class MedicationReminderService {
  static final MedicationReminderService _instance = 
      MedicationReminderService._internal();
  factory MedicationReminderService() => _instance;
  MedicationReminderService._internal();

  final NotificationService _notificationService = NotificationService();
  final OfflineService _offlineService = OfflineService();
  
  // 알림 설정
  bool _remindersEnabled = true;
  int _advanceMinutes = 10; // 복용 시간 10분 전 알림
  bool _persistentReminders = true; // 복용할 때까지 반복 알림
  int _snoozeMinutes = 5; // 다시 알림 간격
  
  // 예약된 알림 추적
  final Map<int, List<int>> _scheduledNotifications = {};
  Timer? _checkTimer;
  
  /// 서비스 초기화
  Future<void> initialize() async {
    tz.initializeTimeZones();
    await _loadSettings();
    await _scheduleAllMedications();
    _startPeriodicCheck();
  }
  
  /// 설정 불러오기
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _remindersEnabled = prefs.getBool('medication_reminders_enabled') ?? true;
    _advanceMinutes = prefs.getInt('medication_advance_minutes') ?? 10;
    _persistentReminders = prefs.getBool('medication_persistent') ?? true;
    _snoozeMinutes = prefs.getInt('medication_snooze_minutes') ?? 5;
  }
  
  /// 설정 저장
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('medication_reminders_enabled', _remindersEnabled);
    await prefs.setInt('medication_advance_minutes', _advanceMinutes);
    await prefs.setBool('medication_persistent', _persistentReminders);
    await prefs.setInt('medication_snooze_minutes', _snoozeMinutes);
  }
  
  /// 모든 약물에 대한 알림 예약
  Future<void> _scheduleAllMedications() async {
    if (!_remindersEnabled) return;
    
    // 기존 알림 모두 취소
    await _cancelAllNotifications();
    
    // 오늘의 약물 목록 가져오기
    final medications = _offlineService.getMedications();
    
    for (var medication in medications) {
      if (!medication.taken) {
        await _scheduleMedicationReminder(medication);
      }
    }
  }
  
  /// 개별 약물 알림 예약
  Future<void> _scheduleMedicationReminder(CachedMedication medication) async {
    final now = DateTime.now();
    final timeParts = medication.time.split(':');
    
    if (timeParts.length != 2) return;
    
    final hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    
    // 복용 시간 설정
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // 이미 지난 시간이면 다음 날로 설정
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }
    
    // 사전 알림 시간 (복용 시간 X분 전)
    final advanceTime = scheduledTime.subtract(
      Duration(minutes: _advanceMinutes),
    );
    
    final notificationIds = <int>[];
    
    // 1. 사전 알림 예약
    if (advanceTime.isAfter(now)) {
      final advanceId = _generateNotificationId(medication.id, 0);
      await _notificationService.scheduleNotification(
        id: advanceId,
        title: '💊 약 복용 시간이 다가와요',
        body: '${medication.name}을(를) ${_advanceMinutes}분 후에 드셔야 해요',
        scheduledDate: advanceTime,
        payload: 'medication_advance_${medication.id}',
      );
      notificationIds.add(advanceId);
    }
    
    // 2. 정시 알림 예약
    if (scheduledTime.isAfter(now)) {
      final mainId = _generateNotificationId(medication.id, 1);
      await _notificationService.scheduleNotification(
        id: mainId,
        title: '💊 약 복용 시간이에요!',
        body: '${medication.name} ${medication.dosage}을(를) 지금 드세요',
        scheduledDate: scheduledTime,
        payload: 'medication_main_${medication.id}',
      );
      notificationIds.add(mainId);
      
      // 3. 반복 알림 예약 (지속 알림이 켜져 있을 경우)
      if (_persistentReminders) {
        for (int i = 1; i <= 3; i++) {
          final snoozeTime = scheduledTime.add(
            Duration(minutes: _snoozeMinutes * i),
          );
          
          if (snoozeTime.isAfter(now)) {
            final snoozeId = _generateNotificationId(medication.id, i + 1);
            await _notificationService.scheduleNotification(
              id: snoozeId,
              title: '⚠️ 약을 아직 안 드셨어요!',
              body: '${medication.name}을(를) 잊지 마세요. 중요해요!',
              scheduledDate: snoozeTime,
              payload: 'medication_snooze_${medication.id}_$i',
            );
            notificationIds.add(snoozeId);
          }
        }
      }
    }
    
    // 예약된 알림 ID 저장
    _scheduledNotifications[medication.id] = notificationIds;
  }
  
  /// 약물 복용 완료 시 알림 취소
  Future<void> cancelMedicationReminders(int medicationId) async {
    final notificationIds = _scheduledNotifications[medicationId];
    
    if (notificationIds != null) {
      for (var id in notificationIds) {
        await _notificationService.cancelNotification(id);
      }
      _scheduledNotifications.remove(medicationId);
    }
  }
  
  /// 모든 알림 취소
  Future<void> _cancelAllNotifications() async {
    for (var entry in _scheduledNotifications.entries) {
      for (var id in entry.value) {
        await _notificationService.cancelNotification(id);
      }
    }
    _scheduledNotifications.clear();
  }
  
  /// 주기적으로 약물 상태 확인
  void _startPeriodicCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(Duration(minutes: 1), (_) {
      _checkMedicationStatus();
    });
  }
  
  /// 약물 복용 상태 확인 및 알림 업데이트
  Future<void> _checkMedicationStatus() async {
    final medications = _offlineService.getMedications();
    
    for (var medication in medications) {
      // 복용 완료된 약물의 알림 취소
      if (medication.taken && 
          _scheduledNotifications.containsKey(medication.id)) {
        await cancelMedicationReminders(medication.id);
      }
      // 복용하지 않은 약물의 알림 재예약
      else if (!medication.taken && 
               !_scheduledNotifications.containsKey(medication.id)) {
        await _scheduleMedicationReminder(medication);
      }
    }
  }
  
  /// 알림 ID 생성
  int _generateNotificationId(int medicationId, int type) {
    // medicationId와 type을 조합하여 고유 ID 생성
    return medicationId * 10 + type;
  }
  
  /// 알림 활성화/비활성화
  Future<void> setRemindersEnabled(bool enabled) async {
    _remindersEnabled = enabled;
    await _saveSettings();
    
    if (enabled) {
      await _scheduleAllMedications();
    } else {
      await _cancelAllNotifications();
    }
  }
  
  /// 사전 알림 시간 설정
  Future<void> setAdvanceMinutes(int minutes) async {
    _advanceMinutes = minutes;
    await _saveSettings();
    await _scheduleAllMedications(); // 재예약
  }
  
  /// 지속 알림 설정
  Future<void> setPersistentReminders(bool enabled) async {
    _persistentReminders = enabled;
    await _saveSettings();
    await _scheduleAllMedications(); // 재예약
  }
  
  /// 다시 알림 간격 설정
  Future<void> setSnoozeMinutes(int minutes) async {
    _snoozeMinutes = minutes;
    await _saveSettings();
    await _scheduleAllMedications(); // 재예약
  }
  
  /// 약물 목록 업데이트 시 알림 재예약
  Future<void> updateMedications() async {
    await _scheduleAllMedications();
  }
  
  /// 특정 약물 알림 재예약
  Future<void> rescheduleMedication(int medicationId) async {
    final medications = _offlineService.getMedications();
    final medication = medications.firstWhere(
      (m) => m.id == medicationId,
      orElse: () => throw Exception('Medication not found'),
    );
    
    await cancelMedicationReminders(medicationId);
    if (!medication.taken) {
      await _scheduleMedicationReminder(medication);
    }
  }
  
  /// 테스트 알림 발송
  Future<void> sendTestNotification() async {
    await _notificationService.showNotification(
      title: '💊 테스트 알림',
      body: '약물 알림이 정상적으로 작동해요!',
      payload: 'test_notification',
    );
  }
  
  /// 알림 설정 가져오기
  Map<String, dynamic> getSettings() {
    return {
      'enabled': _remindersEnabled,
      'advanceMinutes': _advanceMinutes,
      'persistent': _persistentReminders,
      'snoozeMinutes': _snoozeMinutes,
    };
  }
  
  /// 서비스 종료
  void dispose() {
    _checkTimer?.cancel();
  }
}