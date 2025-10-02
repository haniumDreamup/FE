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
  static const String updateUserMe = '$apiV1/users/me';  // PUT /me (프로필 수정)
  static const String users = '$apiV1/users';
  static const String userDetail = '$apiV1/users/{id}';
  static const String deactivateUser = '$apiV1/users/{id}/deactivate';
  static const String activateUser = '$apiV1/users/{id}/activate';
  static const String updateUserRoles = '$apiV1/users/{id}/roles';

  // Emergency endpoints
  static const String emergencies = '$apiV1/emergency';  // GET 전체 목록
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
  static const String activeContacts = '$apiVersion/emergency-contacts/active';
  static const String availableContacts = '$apiVersion/emergency-contacts/available';
  static const String medicalContacts = '$apiVersion/emergency-contacts/medical';
  static const String verifyContact = '$apiVersion/emergency-contacts/{id}/verify';
  static const String toggleContactActive = '$apiVersion/emergency-contacts/{id}/toggle-active';
  static const String updateContactPriorities = '$apiVersion/emergency-contacts/priorities';
  static const String updateContactRecord = '$apiVersion/emergency-contacts/{id}/contact-record';

  // Notification endpoints
  static const String updateFcmToken = '$apiVersion/notifications/fcm-token';
  static const String removeFcmToken = '$apiVersion/notifications/fcm-token/{deviceId}';
  static const String notificationSettings = '$apiVersion/notifications/settings';  // GET/PUT
  static const String updateNotificationSettings = '$apiVersion/notifications/settings';  // PUT
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

  // Pose endpoints (백엔드 구현: POST /api/v1/pose/data, POST batch, GET fall-status, POST feedback)
  static const String poseData = '$apiV1/pose/data';
  static const String poseBatch = '$apiV1/pose/data/batch';
  static const String fallStatus = '$apiV1/pose/fall-status/{userId}';
  static const String fallFeedback = '$apiV1/pose/fall-event/{eventId}/feedback';

  // Geofence endpoints (백엔드 구현: GET/POST/PUT/DELETE /api/geofences 및 다양한 조회)
  static const String geofences = '$apiVersion/geofences';
  static const String geofenceDetail = '$apiVersion/geofences/{id}';
  static const String geofencePaged = '$apiVersion/geofences/paged';
  static const String geofenceByType = '$apiVersion/geofences/type/{type}';
  static const String toggleGeofence = '$apiVersion/geofences/{id}/toggle';
  static const String updateGeofencePriorities = '$apiVersion/geofences/priorities';
  static const String geofenceStats = '$apiVersion/geofences/stats';

  // Statistics endpoints (백엔드 구현: geofence, daily-activity, safety, summary)
  static const String geofenceStatistics = '$apiVersion/statistics/geofence';
  static const String dailyActivityList = '$apiVersion/statistics/daily-activity';
  static const String dailyActivitySingle = '$apiVersion/statistics/daily-activity/single';
  static const String safetyStatistics = '$apiVersion/statistics/safety';
  static const String summaryStatistics = '$apiVersion/statistics/summary';

  // Image Analysis endpoints (백엔드 구현: analyze, quick-analyze, vision-analyze, detect-danger)
  static const String analyzeImage = '$apiVersion/images/analyze';
  static const String analysisResult = '$apiVersion/images/analysis/{id}';
  static const String quickAnalyze = '$apiVersion/images/quick-analyze';
  static const String visionAnalyze = '$apiVersion/images/vision-analyze';
  static const String detectDanger = '$apiVersion/images/detect-danger';

  // Admin endpoints (백엔드 구현: statistics, sessions, auth-logs, settings, backup, cache)
  static const String adminStatistics = '$apiVersion/admin/statistics';
  static const String adminSessions = '$apiVersion/admin/sessions';
  static const String adminSessionDetail = '$apiVersion/admin/sessions/{userId}';
  static const String adminAuthLogs = '$apiVersion/admin/auth-logs';
  static const String adminSettings = '$apiVersion/admin/settings';  // GET/PUT
  static const String updateAdminSettings = '$apiVersion/admin/settings';  // PUT
  static const String adminBackup = '$apiVersion/admin/backup';
  static const String adminCacheClear = '$apiVersion/admin/cache';

  // User Behavior endpoints (백엔드 구현: POST /api/behavior/*)
  static const String behaviorLog = '$apiVersion/behavior/log';
  static const String behaviorBatch = '$apiVersion/behavior/batch';
  static const String behaviorPageview = '$apiVersion/behavior/pageview';
  static const String behaviorClick = '$apiVersion/behavior/click';
  static const String behaviorError = '$apiVersion/behavior/error';

  // Schedule endpoints (일정 관리)
  static const String schedules = '$apiV1/schedules';
  static const String scheduleDetail = '$apiV1/schedules/{id}';
  static const String schedulesToday = '$apiV1/schedules/today';
  static const String schedulesUpcoming = '$apiV1/schedules/upcoming';
  static const String schedulesDate = '$apiV1/schedules/date';
  static const String schedulesRange = '$apiV1/schedules/range';
  static const String scheduleComplete = '$apiV1/schedules/{id}/complete';
  static const String scheduleUncomplete = '$apiV1/schedules/{id}/uncomplete';
  static const String scheduleActivate = '$apiV1/schedules/{id}/activate';
  static const String scheduleDeactivate = '$apiV1/schedules/{id}/deactivate';
  static const String scheduleSkipNext = '$apiV1/schedules/{id}/skip-next';
  static const String scheduleOccurrences = '$apiV1/schedules/{id}/occurrences';

  // Health endpoints (백엔드 구현: /api/health만 존재)
  static const String health = '$apiVersion/health';

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

  // Pose utility methods
  static String fallStatusPath(int userId) =>
      fallStatus.replaceAll('{userId}', userId.toString());

  static String fallFeedbackPath(int eventId) =>
      fallFeedback.replaceAll('{eventId}', eventId.toString());

  // Geofence utility methods
  static String geofenceDetailPath(int id) =>
      geofenceDetail.replaceAll('{id}', id.toString());

  static String geofenceByTypePath(String type) =>
      geofenceByType.replaceAll('{type}', type);

  static String toggleGeofencePath(int id) =>
      toggleGeofence.replaceAll('{id}', id.toString());

  // Image Analysis utility methods
  static String analysisResultPath(int id) =>
      analysisResult.replaceAll('{id}', id.toString());

  // Admin utility methods
  static String adminSessionDetailPath(int userId) =>
      adminSessionDetail.replaceAll('{userId}', userId.toString());

  // Emergency Contact utility methods
  static String verifyContactPath(int id, String verificationCode) =>
      '${verifyContact.replaceAll('{id}', id.toString())}?verificationCode=$verificationCode';

  static String toggleContactActivePath(int id) =>
      toggleContactActive.replaceAll('{id}', id.toString());

  static String updateContactRecordPath(int id) =>
      updateContactRecord.replaceAll('{id}', id.toString());

  // Schedule utility methods
  static String scheduleDetailPath(int id) =>
      scheduleDetail.replaceAll('{id}', id.toString());

  static String scheduleCompletePath(int id) =>
      scheduleComplete.replaceAll('{id}', id.toString());

  static String scheduleUncompletePath(int id) =>
      scheduleUncomplete.replaceAll('{id}', id.toString());

  static String scheduleActivatePath(int id) =>
      scheduleActivate.replaceAll('{id}', id.toString());

  static String scheduleDeactivatePath(int id) =>
      scheduleDeactivate.replaceAll('{id}', id.toString());

  static String scheduleSkipNextPath(int id) =>
      scheduleSkipNext.replaceAll('{id}', id.toString());

  static String scheduleOccurrencesPath(int id) =>
      scheduleOccurrences.replaceAll('{id}', id.toString());
}
