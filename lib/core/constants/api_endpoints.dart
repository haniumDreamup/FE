class ApiEndpoints {
  // Base paths
  static const String apiVersion = '/api';
  static const String apiV1 = '/api/v1';

  // Auth endpoints
  static const String register = '$apiV1/auth/register';
  static const String login = '$apiV1/auth/login';
  static const String refresh = '$apiV1/auth/refresh';
  static const String logout = '$apiV1/auth/logout';
  static const String oauth2LoginUrls = '$apiV1/auth/oauth2/login-urls';

  // User endpoints
  static const String userMe = '$apiV1/users/me';
  static const String users = '$apiV1/users';
  static const String userDetail = '$apiV1/users/{id}';
  static const String deactivateUser = '$apiV1/users/{id}/deactivate';
  static const String activateUser = '$apiV1/users/{id}/activate';
  static const String updateUserRoles = '$apiV1/users/{id}/roles';

  // Emergency endpoints
  static const String emergencyAlert = '$apiV1/emergency/alert';
  static const String fallDetection = '$apiV1/emergency/fall-detection';
  static const String emergencyStatus = '$apiV1/emergency/status/{id}';
  static const String emergencyHistory = '$apiV1/emergency/history/{userId}';
  static const String activeEmergencies = '$apiV1/emergency/active';
  static const String resolveEmergency = '$apiV1/emergency/{id}/resolve';
  static const String triggerSos = '$apiV1/emergency/sos/trigger';
  static const String cancelSos = '$apiV1/emergency/sos/{emergencyId}/cancel';
  static const String sosHistory = '$apiV1/emergency/sos/history';
  static const String quickSos = '$apiV1/emergency/sos/quick';

  // Emergency Contact endpoints
  static const String emergencyContacts = '$apiVersion/emergency-contacts';
  static const String emergencyContactDetail = '$apiVersion/emergency-contacts/{id}';

  // Notification endpoints
  static const String updateFcmToken = '$apiVersion/notifications/fcm-token';
  static const String removeFcmToken = '$apiVersion/notifications/fcm-token/{deviceId}';
  static const String notificationSettings = '$apiVersion/notifications/settings';
  static const String emergencyNotification = '$apiVersion/notifications/emergency';
  static const String validateToken = '$apiVersion/notifications/validate-token';

  // Guardian endpoints
  static const String guardians = '$apiVersion/guardians';
  static const String myGuardians = '$apiVersion/guardians/my';
  static const String protectedUsers = '$apiVersion/guardians/protected-users';
  static const String approveGuardian = '$apiVersion/guardians/{id}/approve';
  static const String rejectGuardian = '$apiVersion/guardians/{id}/reject';
  static const String updateGuardianPermissions = '$apiVersion/guardians/{id}/permissions';
  static const String removeGuardian = '$apiVersion/guardians/{id}';
  static const String removeGuardianRelationship = '$apiVersion/guardians/relationships/{id}';

  // Guardian Relationship endpoints
  static const String inviteGuardian = '$apiVersion/guardian-relationships/invite';
  static const String acceptInvitation = '$apiVersion/guardian-relationships/accept-invitation';
  static const String rejectInvitation = '$apiVersion/guardian-relationships/reject-invitation';
  static const String updateRelationshipPermissions = '$apiVersion/guardian-relationships/{id}/permissions';
  static const String suspendRelationship = '$apiVersion/guardian-relationships/{id}/suspend';
  static const String reactivateRelationship = '$apiVersion/guardian-relationships/{id}/reactivate';
  static const String terminateRelationship = '$apiVersion/guardian-relationships/{id}';
  static const String getUserGuardians = '$apiVersion/guardian-relationships/user/{userId}';
  static const String getGuardianUsers = '$apiVersion/guardian-relationships/guardian/{guardianId}';
  static const String getEmergencyContactsFromRelationship = '$apiVersion/guardian-relationships/user/{userId}/emergency-contacts';
  static const String checkPermission = '$apiVersion/guardian-relationships/check-permission';
  static const String updateActivity = '$apiVersion/guardian-relationships/update-activity';

  // Guardian Dashboard endpoints
  static const String dailySummary = '$apiVersion/guardian/dashboard/daily-summary/{userId}';
  static const String weeklySummary = '$apiVersion/guardian/dashboard/weekly-summary/{userId}';
  static const String integratedDashboard = '$apiVersion/guardian/dashboard/integrated/{userId}';

  // Accessibility endpoints
  static const String voiceGuidance = '$apiV1/accessibility/voice-guidance';
  static const String ariaLabel = '$apiV1/accessibility/aria-label';
  static const String screenReaderHint = '$apiV1/accessibility/screen-reader-hint';
  static const String accessibilitySettings = '$apiV1/accessibility/settings';
  static const String applyProfile = '$apiV1/accessibility/settings/apply-profile';
  static const String colorSchemes = '$apiV1/accessibility/color-schemes';
  static const String currentColorScheme = '$apiV1/accessibility/color-schemes/current';
  static const String simplifiedNavigation = '$apiV1/accessibility/simplified-navigation';
  static const String touchTargets = '$apiV1/accessibility/touch-targets';
  static const String simplifyText = '$apiV1/accessibility/simplify-text';
  static const String syncSettings = '$apiV1/accessibility/settings/sync';
  static const String accessibilityStatistics = '$apiV1/accessibility/statistics';

  // Pose endpoints
  static const String poseData = '$apiV1/pose/data';
  static const String poseHistory = '$apiV1/pose/history/{userId}';
  static const String poseStatistics = '$apiV1/pose/statistics/{userId}';
  static const String poseAlert = '$apiV1/pose/alert';

  // Geofence endpoints
  static const String geofences = '$apiVersion/geofences';
  static const String geofenceDetail = '$apiVersion/geofences/{id}';
  static const String userGeofences = '$apiVersion/geofences/user/{userId}';
  static const String geofenceViolations = '$apiVersion/geofences/user/{userId}/violations';
  static const String currentGeofence = '$apiVersion/geofences/user/{userId}/current';
  static const String activateGeofence = '$apiVersion/geofences/{id}/activate';
  static const String deactivateGeofence = '$apiVersion/geofences/{id}/deactivate';
  static const String checkGeofence = '$apiVersion/geofences/check';
  static const String geofenceHistory = '$apiVersion/geofences/{id}/history';

  // Statistics endpoints
  static const String userStatistics = '$apiVersion/statistics/user/{userId}';
  static const String emergencyStatistics = '$apiVersion/statistics/emergency/{userId}';
  static const String dailyActivity = '$apiVersion/statistics/activity/daily/{userId}';
  static const String weeklyActivity = '$apiVersion/statistics/activity/weekly/{userId}';
  static const String monthlyActivity = '$apiVersion/statistics/activity/monthly/{userId}';

  // Image Analysis endpoints
  static const String analyzeImage = '$apiVersion/images/analyze';
  static const String detectObjects = '$apiVersion/images/detect-objects';
  static const String extractText = '$apiVersion/images/extract-text';
  static const String analyzeScene = '$apiVersion/images/analyze-scene';
  static const String analyzeSafety = '$apiVersion/images/analyze-safety';

  // Admin endpoints
  static const String adminUsers = '$apiVersion/admin/users';
  static const String adminUserDetail = '$apiVersion/admin/users/{id}';
  static const String adminStatistics = '$apiVersion/admin/statistics';
  static const String adminSystemHealth = '$apiVersion/admin/system/health';
  static const String adminSystemLogs = '$apiVersion/admin/system/logs';
  static const String adminEmergencies = '$apiVersion/admin/emergencies';
  static const String adminEmergencyDetail = '$apiVersion/admin/emergencies/{id}';
  static const String adminResolveEmergency = '$apiVersion/admin/emergencies/{id}/resolve';

  // User Behavior endpoints
  static const String userBehavior = '$apiVersion/user-behavior/{userId}';
  static const String behaviorPatterns = '$apiVersion/user-behavior/{userId}/patterns';
  static const String behaviorAnomalies = '$apiVersion/user-behavior/{userId}/anomalies';
  static const String behaviorPredictions = '$apiVersion/user-behavior/{userId}/predictions';
  static const String behaviorReport = '$apiVersion/user-behavior/{userId}/report';

  // Health endpoints
  static const String health = '$apiVersion/health';
  static const String healthCheck = '$apiVersion/health/check';

  // Test endpoints
  static const String test = '$apiVersion/test';

  // Utility methods for path parameters
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

  static String emergencyContactDetailPath(int id) =>
      emergencyContactDetail.replaceAll('{id}', id.toString());

  static String approveGuardianPath(int id) =>
      approveGuardian.replaceAll('{id}', id.toString());

  static String rejectGuardianPath(int id) =>
      rejectGuardian.replaceAll('{id}', id.toString());

  static String updateGuardianPermissionsPath(int id) =>
      updateGuardianPermissions.replaceAll('{id}', id.toString());

  static String removeGuardianPath(int id) =>
      removeGuardian.replaceAll('{id}', id.toString());

  static String removeGuardianRelationshipPath(int id) =>
      removeGuardianRelationship.replaceAll('{id}', id.toString());

  static String updateRelationshipPermissionsPath(int id) =>
      updateRelationshipPermissions.replaceAll('{id}', id.toString());

  static String suspendRelationshipPath(int id) =>
      suspendRelationship.replaceAll('{id}', id.toString());

  static String reactivateRelationshipPath(int id) =>
      reactivateRelationship.replaceAll('{id}', id.toString());

  static String terminateRelationshipPath(int id) =>
      terminateRelationship.replaceAll('{id}', id.toString());

  static String getUserGuardiansPath(int userId) =>
      getUserGuardians.replaceAll('{userId}', userId.toString());

  static String getGuardianUsersPath(int guardianId) =>
      getGuardianUsers.replaceAll('{guardianId}', guardianId.toString());

  static String getEmergencyContactsFromRelationshipPath(int userId) =>
      getEmergencyContactsFromRelationship.replaceAll('{userId}', userId.toString());

  static String dailySummaryPath(int userId) =>
      dailySummary.replaceAll('{userId}', userId.toString());

  static String weeklySummaryPath(int userId) =>
      weeklySummary.replaceAll('{userId}', userId.toString());

  static String integratedDashboardPath(int userId) =>
      integratedDashboard.replaceAll('{userId}', userId.toString());

  static String poseHistoryPath(int userId) =>
      poseHistory.replaceAll('{userId}', userId.toString());

  static String poseStatisticsPath(int userId) =>
      poseStatistics.replaceAll('{userId}', userId.toString());

  static String geofenceDetailPath(int id) =>
      geofenceDetail.replaceAll('{id}', id.toString());

  static String userGeofencesPath(int userId) =>
      userGeofences.replaceAll('{userId}', userId.toString());

  static String geofenceViolationsPath(int userId) =>
      geofenceViolations.replaceAll('{userId}', userId.toString());

  static String currentGeofencePath(int userId) =>
      currentGeofence.replaceAll('{userId}', userId.toString());

  static String activateGeofencePath(int id) =>
      activateGeofence.replaceAll('{id}', id.toString());

  static String deactivateGeofencePath(int id) =>
      deactivateGeofence.replaceAll('{id}', id.toString());

  static String geofenceHistoryPath(int id) =>
      geofenceHistory.replaceAll('{id}', id.toString());

  static String userStatisticsPath(int userId) =>
      userStatistics.replaceAll('{userId}', userId.toString());

  static String emergencyStatisticsPath(int userId) =>
      emergencyStatistics.replaceAll('{userId}', userId.toString());

  static String dailyActivityPath(int userId) =>
      dailyActivity.replaceAll('{userId}', userId.toString());

  static String weeklyActivityPath(int userId) =>
      weeklyActivity.replaceAll('{userId}', userId.toString());

  static String monthlyActivityPath(int userId) =>
      monthlyActivity.replaceAll('{userId}', userId.toString());

  static String adminUserDetailPath(int id) =>
      adminUserDetail.replaceAll('{id}', id.toString());

  static String adminEmergencyDetailPath(int id) =>
      adminEmergencyDetail.replaceAll('{id}', id.toString());

  static String adminResolveEmergencyPath(int id) =>
      adminResolveEmergency.replaceAll('{id}', id.toString());

  static String userBehaviorPath(int userId) =>
      userBehavior.replaceAll('{userId}', userId.toString());

  static String behaviorPatternsPath(int userId) =>
      behaviorPatterns.replaceAll('{userId}', userId.toString());

  static String behaviorAnomaliesPath(int userId) =>
      behaviorAnomalies.replaceAll('{userId}', userId.toString());

  static String behaviorPredictionsPath(int userId) =>
      behaviorPredictions.replaceAll('{userId}', userId.toString());

  static String behaviorReportPath(int userId) =>
      behaviorReport.replaceAll('{userId}', userId.toString());
}
