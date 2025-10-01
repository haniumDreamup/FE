import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 알림 API 서비스 (백엔드 NotificationController와 동기화)
class NotificationApiService {
  final ApiClient _apiClient;

  NotificationApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// FCM 토큰 업데이트 (POST /api/notifications/fcm-token)
  Future<void> updateFcmToken(String fcmToken, String deviceId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.updateFcmToken,
        data: {
          'fcmToken': fcmToken,
          'deviceId': deviceId,
          'platform': _getPlatform(),
          'appVersion': await _getAppVersion(),
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'FCM 토큰을 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('FCM 토큰 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// FCM 토큰 제거 (DELETE /api/notifications/fcm-token/{deviceId})
  Future<void> removeFcmToken(String deviceId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.removeFcmTokenPath(deviceId),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'FCM 토큰을 제거할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('FCM 토큰 제거 중 오류가 발생했습니다: $e');
    }
  }

  /// 알림 설정 조회 (GET /api/notifications/settings)
  Future<Map<String, dynamic>> getNotificationSettings() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.notificationSettings);

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '알림 설정을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('알림 설정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 알림 설정 업데이트 (PUT /api/notifications/settings)
  Future<Map<String, dynamic>> updateNotificationSettings(
    Map<String, dynamic> settings,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.notificationSettings,
        data: settings,
      );

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '알림 설정을 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('알림 설정 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// 테스트 알림 전송 (POST /api/notifications/test)
  Future<void> sendTestNotification({String? message}) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiEndpoints.apiVersion}/notifications/test',  // 백엔드 미구현 - 테스트용
        data: {
          if (message != null) 'message': message,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '테스트 알림을 전송할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('테스트 알림 전송 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 알림 전송 (POST /api/notifications/emergency)
  Future<void> sendEmergencyAlert(Map<String, dynamic> emergencyData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.emergencyNotification,
        data: emergencyData,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '긴급 알림을 전송할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급 알림 전송 중 오류가 발생했습니다: $e');
    }
  }

  /// FCM 토큰 유효성 검증 (POST /api/notifications/validate-token)
  Future<bool> validateFcmToken(String fcmToken) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.validateToken,
        data: {'fcmToken': fcmToken},
      );

      if (response.data['success'] == true) {
        return response.data['data']['isValid'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('FCM 토큰 검증 중 오류가 발생했습니다: $e');
    }
  }

  String _getPlatform() {
    // This should be implemented based on the platform
    // For now, return a default value
    return 'flutter';
  }

  Future<String> _getAppVersion() async {
    // This should be implemented using package_info_plus or similar
    // For now, return a default value
    return '1.0.0';
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('네트워크 연결이 불안정합니다. 다시 시도해주세요.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
        if (statusCode == 401) {
          return Exception('로그인이 필요합니다');
        } else if (statusCode == 403) {
          return Exception('권한이 없습니다');
        } else if (statusCode == 404) {
          return Exception('요청한 정보를 찾을 수 없습니다');
        }
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다');
      case DioExceptionType.unknown:
      default:
        if (e.error.toString().contains('SocketException')) {
          return Exception('인터넷 연결을 확인해주세요');
        }
        return Exception('알 수 없는 오류가 발생했습니다');
    }
  }
}

/// 알림 설정 모델
class NotificationSettingsModel {
  final bool emergencyAlertsEnabled;
  final bool medicationRemindersEnabled;
  final bool scheduleRemindersEnabled;
  final bool guardianNotificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String quietHoursStart;
  final String quietHoursEnd;
  final List<String> allowedContactTypes;
  final Map<String, bool> categorySettings;

  const NotificationSettingsModel({
    required this.emergencyAlertsEnabled,
    required this.medicationRemindersEnabled,
    required this.scheduleRemindersEnabled,
    required this.guardianNotificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    this.allowedContactTypes = const [],
    this.categorySettings = const {},
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      emergencyAlertsEnabled: json['emergencyAlertsEnabled'] ?? true,
      medicationRemindersEnabled: json['medicationRemindersEnabled'] ?? true,
      scheduleRemindersEnabled: json['scheduleRemindersEnabled'] ?? true,
      guardianNotificationsEnabled: json['guardianNotificationsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      quietHoursStart: json['quietHoursStart'] ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] ?? '08:00',
      allowedContactTypes: List<String>.from(json['allowedContactTypes'] ?? []),
      categorySettings: Map<String, bool>.from(json['categorySettings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emergencyAlertsEnabled': emergencyAlertsEnabled,
      'medicationRemindersEnabled': medicationRemindersEnabled,
      'scheduleRemindersEnabled': scheduleRemindersEnabled,
      'guardianNotificationsEnabled': guardianNotificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'allowedContactTypes': allowedContactTypes,
      'categorySettings': categorySettings,
    };
  }

  NotificationSettingsModel copyWith({
    bool? emergencyAlertsEnabled,
    bool? medicationRemindersEnabled,
    bool? scheduleRemindersEnabled,
    bool? guardianNotificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
    List<String>? allowedContactTypes,
    Map<String, bool>? categorySettings,
  }) {
    return NotificationSettingsModel(
      emergencyAlertsEnabled: emergencyAlertsEnabled ?? this.emergencyAlertsEnabled,
      medicationRemindersEnabled: medicationRemindersEnabled ?? this.medicationRemindersEnabled,
      scheduleRemindersEnabled: scheduleRemindersEnabled ?? this.scheduleRemindersEnabled,
      guardianNotificationsEnabled: guardianNotificationsEnabled ?? this.guardianNotificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      allowedContactTypes: allowedContactTypes ?? this.allowedContactTypes,
      categorySettings: categorySettings ?? this.categorySettings,
    );
  }
}