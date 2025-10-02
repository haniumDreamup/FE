import 'package:flutter/material.dart';
import '../../data/services/notification_api_service.dart';
import '../../core/utils/error_handler.dart';

/// 알림 Provider
/// 알림 설정 관리 및 FCM 토큰 관리
class NotificationProvider extends ChangeNotifier {
  final NotificationApiService _service;

  // 알림 설정
  Map<String, dynamic> _settings = {};
  bool _isLoading = false;
  String? _errorMessage;

  NotificationProvider({NotificationApiService? service})
      : _service = service ?? NotificationApiService();

  // Getters
  Map<String, dynamic> get settings => _settings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 개별 설정 Getters (편의성)
  bool get scheduleEnabled => _settings['scheduleEnabled'] ?? true;
  bool get medicationEnabled => _settings['medicationEnabled'] ?? true;
  bool get emergencyEnabled => _settings['emergencyEnabled'] ?? true;
  bool get guardianEnabled => _settings['guardianEnabled'] ?? true;
  bool get soundEnabled => _settings['soundEnabled'] ?? true;
  bool get vibrationEnabled => _settings['vibrationEnabled'] ?? true;

  /// 알림 설정 불러오기
  Future<void> loadSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = await _service.getNotificationSettings();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 알림 설정 업데이트
  Future<bool> updateSettings(Map<String, dynamic> newSettings) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = await _service.updateNotificationSettings(newSettings);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 개별 설정 토글
  Future<bool> toggleSetting(String key, bool value) async {
    final newSettings = Map<String, dynamic>.from(_settings);
    newSettings[key] = value;
    return await updateSettings(newSettings);
  }

  /// FCM 토큰 업데이트
  Future<bool> updateFcmToken(String fcmToken, String deviceId) async {
    try {
      await _service.updateFcmToken(fcmToken, deviceId);
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// FCM 토큰 제거
  Future<bool> removeFcmToken(String deviceId) async {
    try {
      await _service.removeFcmToken(deviceId);
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// 테스트 알림 전송
  Future<bool> sendTestNotification({String? message}) async {
    try {
      await _service.sendTestNotification(message: message);
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// 에러 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
