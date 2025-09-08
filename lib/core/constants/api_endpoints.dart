class ApiEndpoints {
  // Base paths
  static const String apiVersion = '/api/v1';
  static const String basePath = '$apiVersion/mobile';
  
  // Auth endpoints
  static const String login = '$basePath/auth/login';
  static const String logout = '$basePath/auth/logout';
  static const String refresh = '$basePath/auth/refresh';
  static const String checkAutoLogin = '$basePath/auth/check';
  
  // Home endpoints
  static const String dashboard = '$basePath/home/dashboard';
  static const String greeting = '$basePath/home/greeting';
  
  // Medication endpoints
  static const String medicationsToday = '$basePath/medications/today';
  static const String medications = '$basePath/medications';
  static const String medicationDetail = '$basePath/medications/{id}';
  static const String takeMedication = '$basePath/medications/{id}/take';
  
  // Schedule endpoints
  static const String schedulesToday = '$basePath/schedules/today';
  static const String schedules = '$basePath/schedules';
  static const String scheduleDetail = '$basePath/schedules/{id}';
  static const String completeSchedule = '$basePath/schedules/{id}/complete';
  static const String weekSummary = '$basePath/schedules/week-summary';
  
  // Emergency endpoints
  static const String emergencyCall = '$basePath/emergency/call';
  static const String emergencyContacts = '$basePath/emergency/contacts';
  static const String safetyCheck = '$basePath/emergency/safety-check';
  static const String shareLocation = '$basePath/emergency/share-location';
  
  // Notification endpoints (기존 유지)
  static const String registerToken = '$basePath/notifications/register';
  static const String notificationSettings = '$basePath/notifications/settings';
  static const String notificationHistory = '$basePath/notifications/history';
  
  // User endpoints (기존 유지)
  static const String userProfile = '$basePath/user/profile';
  static const String updateProfile = '$basePath/user/profile';
  
  // Utility methods
  static String medicationDetailPath(int id) => 
      medicationDetail.replaceAll('{id}', id.toString());
      
  static String takeMedicationPath(int id) => 
      takeMedication.replaceAll('{id}', id.toString());
      
  static String scheduleDetailPath(int id) => 
      scheduleDetail.replaceAll('{id}', id.toString());
      
  static String completeSchedulePath(int id) => 
      completeSchedule.replaceAll('{id}', id.toString());
}