import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../firebase_options.dart';
import '../utils/logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseMessaging? _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  GoRouter? _router;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// GoRouter 설정 (main.dart에서 호출)
  void setRouter(GoRouter router) {
    _router = router;
    Logger.debug('GoRouter가 NotificationService에 주입되었습니다');
  }

  Future<void> initialize() async {
    try {
      // 웹에서는 Firebase 초기화를 건너뜀
      if (kIsWeb) {
        if (kDebugMode) {
          Logger.debug('웹 환경에서는 Firebase 알림이 제한적입니다');
        }
        await _initializeWebNotifications();
        return;
      }
      
      // Initialize Firebase (중복 초기화 방지)
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      
      // Request notification permissions
      await _requestPermissions();
      
      // Initialize local notifications
      await _initializeLocalNotifications();
      
      // Get FCM token
      await _getToken();
      
      // Setup message handlers
      _setupMessageHandlers();
      
      // Handle token refresh
      _firebaseMessaging?.onTokenRefresh?.listen(_onTokenRefresh);
      
      Logger.debug('알림 서비스 초기화 완료');
    } catch (e) {
      Logger.error("Error occurred", e);
    }
  }
  
  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging?.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    Logger.debug('알림 권한 상태: ${settings?.authorizationStatus}');
  }
  
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'bif_ai_channel',
        'BIF-AI 알림',
        description: '약 복용 및 일정 알림',
        importance: Importance.high,
        playSound: true,
      );
      
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }
  
  Future<void> _getToken() async {
    try {
      _fcmToken = await _firebaseMessaging?.getToken();
      if (_fcmToken != null) {
        Logger.debug('FCM 토큰: $_fcmToken');
        await _saveToken(_fcmToken!);
      }
    } catch (e) {
      Logger.error("Error occurred", e);
    }
  }
  
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }
  
  void _onTokenRefresh(String newToken) async {
    _fcmToken = newToken;
    await _saveToken(newToken);
    Logger.debug('FCM 토큰 갱신됨: $newToken');
    // TODO: Send new token to backend
  }
  
  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    
    // Message opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    
    // Check if app was opened from notification
    _checkInitialMessage();
  }
  
  Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging?.getInitialMessage();
    if (message != null) {
      _handleMessageOpenedApp(message);
    }
  }
  
  void _handleForegroundMessage(RemoteMessage message) {
    Logger.debug('포그라운드 메시지 수신: ${message.messageId}');
    
    // Parse message data
    final type = message.data['type'] ?? 'GENERAL';
    final title = message.notification?.title ?? '알림';
    final body = message.notification?.body ?? '';
    
    // Show local notification
    _showLocalNotification(
      title: title,
      body: body,
      payload: message.data.toString(),
      type: type,
    );
    
    // Handle specific message types
    _handleMessageByType(type, message.data);
  }
  
  void _handleMessageOpenedApp(RemoteMessage message) {
    Logger.debug('알림으로 앱 열림: ${message.messageId}');
    
    final type = message.data['type'] ?? 'GENERAL';
    
    // Navigate based on message type
    switch (type) {
      case 'MEDICATION_REMINDER':
        // Navigate to medications page
        _navigateToMedications(message.data);
        break;
      case 'SCHEDULE_REMINDER':
        // Navigate to schedule page
        _navigateToSchedule(message.data);
        break;
      case 'EMERGENCY_ALERT':
        // Navigate to emergency page
        _navigateToEmergency(message.data);
        break;
      case 'DAILY_SUMMARY':
        // Navigate to summary page
        _navigateToSummary(message.data);
        break;
      default:
        // Navigate to home
        break;
    }
  }
  
  void _handleMessageByType(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'MEDICATION_REMINDER':
        _handleMedicationReminder(data);
        break;
      case 'SCHEDULE_REMINDER':
        _handleScheduleReminder(data);
        break;
      case 'EMERGENCY_ALERT':
        _handleEmergencyAlert(data);
        break;
      case 'ACTIVITY_COMPLETION':
        _handleActivityCompletion(data);
        break;
      case 'DAILY_SUMMARY':
        _handleDailySummary(data);
        break;
    }
  }
  
  void _handleMedicationReminder(Map<String, dynamic> data) {
    final medicationName = data['medicationName'] ?? '';
    final time = data['time'] ?? '';
    
    Logger.debug('약 복용 알림: $medicationName at $time');
    
    // Update UI or local storage if needed
  }
  
  void _handleScheduleReminder(Map<String, dynamic> data) {
    final scheduleName = data['scheduleName'] ?? '';
    final time = data['time'] ?? '';
    final location = data['location'] ?? '';
    
    Logger.debug('일정 알림: $scheduleName at $time ($location)');
  }
  
  void _handleEmergencyAlert(Map<String, dynamic> data) {
    final userName = data['userName'] ?? '';
    final message = data['message'] ?? '';
    // final latitude = data['latitude'];
    // final longitude = data['longitude'];

    Logger.debug('긴급 알림: $userName - $message');
    
    // Show urgent notification
    _showUrgentNotification(
      title: '🚨 긴급 알림',
      body: '$userName님이 도움을 요청했어요',
    );
  }
  
  void _handleActivityCompletion(Map<String, dynamic> data) {
    final activityType = data['activityType'] ?? '';
    final details = data['details'] ?? '';
    
    Logger.debug('활동 완료: $activityType - $details');
  }
  
  void _handleDailySummary(Map<String, dynamic> data) {
    final medicationsTaken = data['medicationsTaken'] ?? '0';
    final schedulesCompleted = data['schedulesCompleted'] ?? '0';
    
    Logger.debug('일일 요약: 약 $medicationsTaken개, 일정 $schedulesCompleted개');
  }
  
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String type = 'GENERAL',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'bif_ai_channel',
      'BIF-AI 알림',
      channelDescription: '약 복용 및 일정 알림',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification.aiff',
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
  
  Future<void> _showUrgentNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'emergency_channel',
      '긴급 알림',
      channelDescription: '긴급 상황 알림',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      fullScreenIntent: true,
      ongoing: true,
      autoCancel: false,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      0, // Use fixed ID for emergency
      title,
      body,
      details,
    );
  }
  
  void _onNotificationTapped(NotificationResponse response) {
    Logger.debug('알림 탭: ${response.payload}');
    // Handle notification tap
  }
  
  // Navigation methods - 딥링크 처리
  void _navigateToMedications(Map<String, dynamic> data) {
    if (_router == null) {
      Logger.error('Router is null', Exception('Router가 초기화되지 않았습니다'));
      return;
    }

    // 약물 관리 화면이 없으므로 일정 화면으로 이동
    Logger.debug('약물 알림 - 일정 페이지로 이동');
    _router!.go('/schedule');
  }

  void _navigateToSchedule(Map<String, dynamic> data) {
    if (_router == null) {
      Logger.error('Router is null', Exception('Router가 초기화되지 않았습니다'));
      return;
    }

    final scheduleId = data['scheduleId'];
    Logger.debug('일정 페이지로 이동 - scheduleId: $scheduleId');

    // scheduleId가 있으면 상세 화면으로, 없으면 목록 화면으로
    _router!.go('/schedule');
  }

  void _navigateToEmergency(Map<String, dynamic> data) {
    if (_router == null) {
      Logger.error('Router is null', Exception('Router가 초기화되지 않았습니다'));
      return;
    }

    final emergencyId = data['emergencyId'];
    final isActive = data['isActive'] ?? true;

    Logger.debug('긴급 페이지로 이동 - emergencyId: $emergencyId, isActive: $isActive');

    // 활성 긴급상황이면 active 화면으로, 아니면 history 화면으로
    if (isActive) {
      _router!.go('/emergency/active');
    } else {
      _router!.go('/emergency/history');
    }
  }

  void _navigateToSummary(Map<String, dynamic> data) {
    if (_router == null) {
      Logger.error('Router is null', Exception('Router가 초기화되지 않았습니다'));
      return;
    }

    Logger.debug('요약(통계) 페이지로 이동');
    _router!.go('/statistics');
  }
  
  // Schedule local notifications
  Future<void> scheduleMedicationReminder({
    required int id,
    required String medicationName,
    required DateTime scheduledTime,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'medication_reminder',
      '약 복용 알림',
      channelDescription: '정기 약 복용 알림',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.zonedSchedule(
      id,
      '💊 약 먹을 시간이에요!',
      '$medicationName을(를) 드실 시간이에요',
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
  
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
  
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
  
  // Public wrapper methods for medication reminder service
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      if (kDebugMode) {
        Logger.debug('웹 알림: $title - $body');
      }
      return;
    }
    await _showLocalNotification(title: title, body: body, payload: payload, type: 'GENERAL');
  }

  /// 웹 환경용 알림 초기화
  Future<void> _initializeWebNotifications() async {
    try {
      if (kDebugMode) {
        Logger.debug('웹 알림 서비스 초기화 완료 (제한적 기능)');
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error("Error occurred", e);
      }
    }
  }
  
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_notification',
      '예약 알림',
      channelDescription: '예약된 알림',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Firebase가 이미 초기화되어 있는지 확인
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  Logger.debug('백그라운드 메시지 수신: ${message.messageId}');

  // Handle background message
  // Note: Can't update UI directly here
}