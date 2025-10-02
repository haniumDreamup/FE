// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guardian_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStatusSummary _$DailyStatusSummaryFromJson(Map<String, dynamic> json) =>
    DailyStatusSummary(
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      summaryDate: json['summaryDate'] as String,
      medicationStatus: json['medicationStatus'] == null
          ? null
          : MedicationStatus.fromJson(
              json['medicationStatus'] as Map<String, dynamic>),
      locationStatus: json['locationStatus'] == null
          ? null
          : LocationStatus.fromJson(
              json['locationStatus'] as Map<String, dynamic>),
      activityStatus: json['activityStatus'] == null
          ? null
          : ActivityStatus.fromJson(
              json['activityStatus'] as Map<String, dynamic>),
      scheduleStatus: json['scheduleStatus'] == null
          ? null
          : ScheduleStatus.fromJson(
              json['scheduleStatus'] as Map<String, dynamic>),
      overallStatus: json['overallStatus'] as String,
      statusMessage: json['statusMessage'] as String,
    );

Map<String, dynamic> _$DailyStatusSummaryToJson(DailyStatusSummary instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'summaryDate': instance.summaryDate,
      'medicationStatus': instance.medicationStatus,
      'locationStatus': instance.locationStatus,
      'activityStatus': instance.activityStatus,
      'scheduleStatus': instance.scheduleStatus,
      'overallStatus': instance.overallStatus,
      'statusMessage': instance.statusMessage,
    };

MedicationStatus _$MedicationStatusFromJson(Map<String, dynamic> json) =>
    MedicationStatus(
      totalMedications: (json['totalMedications'] as num).toInt(),
      takenMedications: (json['takenMedications'] as num).toInt(),
      missedMedications: (json['missedMedications'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      nextMedicationTime: json['nextMedicationTime'] as String?,
      nextMedicationName: json['nextMedicationName'] as String?,
    );

Map<String, dynamic> _$MedicationStatusToJson(MedicationStatus instance) =>
    <String, dynamic>{
      'totalMedications': instance.totalMedications,
      'takenMedications': instance.takenMedications,
      'missedMedications': instance.missedMedications,
      'completionRate': instance.completionRate,
      'nextMedicationTime': instance.nextMedicationTime,
      'nextMedicationName': instance.nextMedicationName,
    };

LocationStatus _$LocationStatusFromJson(Map<String, dynamic> json) =>
    LocationStatus(
      currentLocation: json['currentLocation'] as String,
      lastUpdated: json['lastUpdated'] as String,
      isInSafeZone: json['isInSafeZone'] as bool,
      minutesSinceUpdate: (json['minutesSinceUpdate'] as num).toInt(),
    );

Map<String, dynamic> _$LocationStatusToJson(LocationStatus instance) =>
    <String, dynamic>{
      'currentLocation': instance.currentLocation,
      'lastUpdated': instance.lastUpdated,
      'isInSafeZone': instance.isInSafeZone,
      'minutesSinceUpdate': instance.minutesSinceUpdate,
    };

ActivityStatus _$ActivityStatusFromJson(Map<String, dynamic> json) =>
    ActivityStatus(
      lastActiveTime: json['lastActiveTime'] as String,
      totalActiveMinutes: (json['totalActiveMinutes'] as num).toInt(),
      screenTimeMinutes: (json['screenTimeMinutes'] as num).toInt(),
      activityLevel: json['activityLevel'] as String,
      isCurrentlyActive: json['isCurrentlyActive'] as bool,
    );

Map<String, dynamic> _$ActivityStatusToJson(ActivityStatus instance) =>
    <String, dynamic>{
      'lastActiveTime': instance.lastActiveTime,
      'totalActiveMinutes': instance.totalActiveMinutes,
      'screenTimeMinutes': instance.screenTimeMinutes,
      'activityLevel': instance.activityLevel,
      'isCurrentlyActive': instance.isCurrentlyActive,
    };

ScheduleStatus _$ScheduleStatusFromJson(Map<String, dynamic> json) =>
    ScheduleStatus(
      totalSchedules: (json['totalSchedules'] as num).toInt(),
      completedSchedules: (json['completedSchedules'] as num).toInt(),
      upcomingSchedules: (json['upcomingSchedules'] as num).toInt(),
      nextScheduleTime: json['nextScheduleTime'] as String?,
      nextScheduleTitle: json['nextScheduleTitle'] as String?,
    );

Map<String, dynamic> _$ScheduleStatusToJson(ScheduleStatus instance) =>
    <String, dynamic>{
      'totalSchedules': instance.totalSchedules,
      'completedSchedules': instance.completedSchedules,
      'upcomingSchedules': instance.upcomingSchedules,
      'nextScheduleTime': instance.nextScheduleTime,
      'nextScheduleTitle': instance.nextScheduleTitle,
    };

WeeklySummary _$WeeklySummaryFromJson(Map<String, dynamic> json) =>
    WeeklySummary(
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      weekStartDate: json['weekStartDate'] as String,
      weekEndDate: json['weekEndDate'] as String,
      medicationSummary: json['medicationSummary'] == null
          ? null
          : MedicationWeeklySummary.fromJson(
              json['medicationSummary'] as Map<String, dynamic>),
      activitySummary: json['activitySummary'] == null
          ? null
          : ActivityWeeklySummary.fromJson(
              json['activitySummary'] as Map<String, dynamic>),
      locationSummary: json['locationSummary'] == null
          ? null
          : LocationWeeklySummary.fromJson(
              json['locationSummary'] as Map<String, dynamic>),
      scheduleSummary: json['scheduleSummary'] == null
          ? null
          : ScheduleWeeklySummary.fromJson(
              json['scheduleSummary'] as Map<String, dynamic>),
      weeklyTrend: json['weeklyTrend'] as String,
      concerns:
          (json['concerns'] as List<dynamic>).map((e) => e as String).toList(),
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WeeklySummaryToJson(WeeklySummary instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'weekStartDate': instance.weekStartDate,
      'weekEndDate': instance.weekEndDate,
      'medicationSummary': instance.medicationSummary,
      'activitySummary': instance.activitySummary,
      'locationSummary': instance.locationSummary,
      'scheduleSummary': instance.scheduleSummary,
      'weeklyTrend': instance.weeklyTrend,
      'concerns': instance.concerns,
      'achievements': instance.achievements,
    };

MedicationWeeklySummary _$MedicationWeeklySummaryFromJson(
        Map<String, dynamic> json) =>
    MedicationWeeklySummary(
      overallCompletionRate: (json['overallCompletionRate'] as num).toDouble(),
      dailyRates: (json['dailyRates'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalMedications: (json['totalMedications'] as num).toInt(),
      missedMedications: (json['missedMedications'] as num).toInt(),
      frequentlyMissed: (json['frequentlyMissed'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bestDay: json['bestDay'] as String?,
      worstDay: json['worstDay'] as String?,
    );

Map<String, dynamic> _$MedicationWeeklySummaryToJson(
        MedicationWeeklySummary instance) =>
    <String, dynamic>{
      'overallCompletionRate': instance.overallCompletionRate,
      'dailyRates': instance.dailyRates,
      'totalMedications': instance.totalMedications,
      'missedMedications': instance.missedMedications,
      'frequentlyMissed': instance.frequentlyMissed,
      'bestDay': instance.bestDay,
      'worstDay': instance.worstDay,
    };

ActivityWeeklySummary _$ActivityWeeklySummaryFromJson(
        Map<String, dynamic> json) =>
    ActivityWeeklySummary(
      totalActiveMinutes: (json['totalActiveMinutes'] as num).toInt(),
      dailyAverageMinutes: (json['dailyAverageMinutes'] as num).toDouble(),
      dailyActivity: Map<String, int>.from(json['dailyActivity'] as Map),
      mostActiveDay: json['mostActiveDay'] as String?,
      leastActiveDay: json['leastActiveDay'] as String?,
      inactiveDays: (json['inactiveDays'] as num).toInt(),
      activityPatterns: (json['activityPatterns'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ActivityWeeklySummaryToJson(
        ActivityWeeklySummary instance) =>
    <String, dynamic>{
      'totalActiveMinutes': instance.totalActiveMinutes,
      'dailyAverageMinutes': instance.dailyAverageMinutes,
      'dailyActivity': instance.dailyActivity,
      'mostActiveDay': instance.mostActiveDay,
      'leastActiveDay': instance.leastActiveDay,
      'inactiveDays': instance.inactiveDays,
      'activityPatterns': instance.activityPatterns,
    };

LocationWeeklySummary _$LocationWeeklySummaryFromJson(
        Map<String, dynamic> json) =>
    LocationWeeklySummary(
      frequentLocations:
          Map<String, int>.from(json['frequentLocations'] as Map),
      safeZoneExits: (json['safeZoneExits'] as num).toInt(),
      mostVisitedPlace: json['mostVisitedPlace'] as String?,
      uniquePlacesVisited: (json['uniquePlacesVisited'] as num).toInt(),
      unusualLocations: (json['unusualLocations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LocationWeeklySummaryToJson(
        LocationWeeklySummary instance) =>
    <String, dynamic>{
      'frequentLocations': instance.frequentLocations,
      'safeZoneExits': instance.safeZoneExits,
      'mostVisitedPlace': instance.mostVisitedPlace,
      'uniquePlacesVisited': instance.uniquePlacesVisited,
      'unusualLocations': instance.unusualLocations,
    };

ScheduleWeeklySummary _$ScheduleWeeklySummaryFromJson(
        Map<String, dynamic> json) =>
    ScheduleWeeklySummary(
      totalSchedules: (json['totalSchedules'] as num).toInt(),
      completedSchedules: (json['completedSchedules'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      dailySchedules: Map<String, int>.from(json['dailySchedules'] as Map),
      missedImportantSchedules:
          (json['missedImportantSchedules'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$ScheduleWeeklySummaryToJson(
        ScheduleWeeklySummary instance) =>
    <String, dynamic>{
      'totalSchedules': instance.totalSchedules,
      'completedSchedules': instance.completedSchedules,
      'completionRate': instance.completionRate,
      'dailySchedules': instance.dailySchedules,
      'missedImportantSchedules': instance.missedImportantSchedules,
    };

IntegratedDashboard _$IntegratedDashboardFromJson(Map<String, dynamic> json) =>
    IntegratedDashboard(
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      dailySummary: DailyStatusSummary.fromJson(
          json['dailySummary'] as Map<String, dynamic>),
      weeklySummary:
          WeeklySummary.fromJson(json['weeklySummary'] as Map<String, dynamic>),
      lastUpdated: json['lastUpdated'] as String,
    );

Map<String, dynamic> _$IntegratedDashboardToJson(
        IntegratedDashboard instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'dailySummary': instance.dailySummary,
      'weeklySummary': instance.weeklySummary,
      'lastUpdated': instance.lastUpdated,
    };
