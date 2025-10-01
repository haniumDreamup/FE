class ApiEndpoints {
  // Base paths
  static const String apiVersion = '/api/v1';
  static const String basePath = '$apiVersion';

  // Auth endpoints
  static const String login = '$basePath/auth/login';
  static const String logout = '$basePath/auth/logout';
  static const String refresh = '$basePath/auth/refresh';

  // Emergency endpoints
  static const String emergencyAlert = '$basePath/emergency/alert';
  static const String fallDetection = '$basePath/emergency/fall-detection';
  static const String emergencyStatus = '$basePath/emergency/status/{id}';
  static const String emergencyHistory = '$basePath/emergency/history/{userId}';
  static const String activeEmergencies = '$basePath/emergency/active';
  static const String resolveEmergency = '$basePath/emergency/{id}/resolve';
  static const String triggerSos = '$basePath/emergency/sos/trigger';
  static const String cancelSos = '$basePath/emergency/sos/{emergencyId}/cancel';
  static const String sosHistory = '$basePath/emergency/sos/history';
  static const String quickSos = '$basePath/emergency/sos/quick';

  // Emergency Contact endpoints
  static const String emergencyContacts = '/api/emergency-contacts';

  // Notification endpoints
  static const String updateFcmToken = '/api/notifications/fcm-token';
  static const String removeFcmToken = '/api/notifications/fcm-token/{deviceId}';
  static const String notificationSettings = '/api/notifications/settings';
  static const String emergencyNotification = '/api/notifications/emergency';
  static const String validateToken = '/api/notifications/validate-token';

  // User endpoints
  static const String userMe = '$basePath/users/me';
  static const String users = '$basePath/users';
  static const String userDetail = '$basePath/users/{id}';
  static const String deactivateUser = '$basePath/users/{id}/deactivate';
  static const String activateUser = '$basePath/users/{id}/activate';
  static const String updateUserRoles = '$basePath/users/{id}/roles';
  
  // Utility methods
  static String userDetailPath(int id) =>
      userDetail.replaceAll('{id}', id.toString());

  static String deactivateUserPath(int id) =>
      deactivateUser.replaceAll('{id}', id.toString());

  static String activateUserPath(int id) =>
      activateUser.replaceAll('{id}', id.toString());

  static String updateUserRolesPath(int id) =>
      updateUserRoles.replaceAll('{id}', id.toString());

  static String emergencyStatusPath(int id) =>
      emergencyStatus.replaceAll('{id}', id.toString());

  static String emergencyHistoryPath(int userId) =>
      emergencyHistory.replaceAll('{userId}', userId.toString());

  static String resolveEmergencyPath(int id) =>
      resolveEmergency.replaceAll('{id}', id.toString());

  static String cancelSosPath(int emergencyId) =>
      cancelSos.replaceAll('{emergencyId}', emergencyId.toString());

  static String removeFcmTokenPath(String deviceId) =>
      removeFcmToken.replaceAll('{deviceId}', deviceId);
}