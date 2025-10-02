import 'package:json_annotation/json_annotation.dart';

part 'guardian_dashboard_model.g.dart';

/// 오늘의 상태 요약 DTO
@JsonSerializable()
class DailyStatusSummary {
  final int userId;
  final String userName;
  final String summaryDate;
  final MedicationStatus? medicationStatus;
  final LocationStatus? locationStatus;
  final ActivityStatus? activityStatus;
  final ScheduleStatus? scheduleStatus;
  final String overallStatus; // GOOD, ATTENTION_NEEDED, WARNING
  final String statusMessage;

  const DailyStatusSummary({
    required this.userId,
    required this.userName,
    required this.summaryDate,
    this.medicationStatus,
    this.locationStatus,
    this.activityStatus,
    this.scheduleStatus,
    required this.overallStatus,
    required this.statusMessage,
  });

  factory DailyStatusSummary.fromJson(Map<String, dynamic> json) =>
      _$DailyStatusSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatusSummaryToJson(this);

  /// 전체 상태 색상
  String get statusColor {
    switch (overallStatus) {
      case 'GOOD':
        return 'green';
      case 'ATTENTION_NEEDED':
        return 'orange';
      case 'WARNING':
        return 'red';
      default:
        return 'grey';
    }
  }

  /// 전체 상태 표시명
  String get statusDisplayName {
    switch (overallStatus) {
      case 'GOOD':
        return '좋음';
      case 'ATTENTION_NEEDED':
        return '주의 필요';
      case 'WARNING':
        return '경고';
      default:
        return '알 수 없음';
    }
  }
}

/// 복약 상태
@JsonSerializable()
class MedicationStatus {
  final int totalMedications;
  final int takenMedications;
  final int missedMedications;
  final double completionRate;
  final String? nextMedicationTime;
  final String? nextMedicationName;

  const MedicationStatus({
    required this.totalMedications,
    required this.takenMedications,
    required this.missedMedications,
    required this.completionRate,
    this.nextMedicationTime,
    this.nextMedicationName,
  });

  factory MedicationStatus.fromJson(Map<String, dynamic> json) =>
      _$MedicationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationStatusToJson(this);

  /// 복약률 표시
  String get completionRateDisplay => '${completionRate.toStringAsFixed(0)}%';

  /// 복약 상태 색상
  String get statusColor {
    if (completionRate >= 80) return 'green';
    if (completionRate >= 50) return 'orange';
    return 'red';
  }
}

/// 위치 상태
@JsonSerializable()
class LocationStatus {
  final String currentLocation;
  final String lastUpdated;
  final bool isInSafeZone;
  final int minutesSinceUpdate;

  const LocationStatus({
    required this.currentLocation,
    required this.lastUpdated,
    required this.isInSafeZone,
    required this.minutesSinceUpdate,
  });

  factory LocationStatus.fromJson(Map<String, dynamic> json) =>
      _$LocationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$LocationStatusToJson(this);

  /// 위치 상태 표시
  String get safetyStatusDisplay => isInSafeZone ? '안전구역 내' : '안전구역 밖';

  /// 업데이트 경과 시간 표시
  String get updateTimeDisplay {
    if (minutesSinceUpdate < 1) {
      return '방금 전';
    } else if (minutesSinceUpdate < 60) {
      return '$minutesSinceUpdate분 전';
    } else {
      final hours = (minutesSinceUpdate / 60).floor();
      return '$hours시간 전';
    }
  }
}

/// 활동 상태
@JsonSerializable()
class ActivityStatus {
  final String lastActiveTime;
  final int totalActiveMinutes;
  final int screenTimeMinutes;
  final String activityLevel; // HIGH, NORMAL, LOW
  final bool isCurrentlyActive;

  const ActivityStatus({
    required this.lastActiveTime,
    required this.totalActiveMinutes,
    required this.screenTimeMinutes,
    required this.activityLevel,
    required this.isCurrentlyActive,
  });

  factory ActivityStatus.fromJson(Map<String, dynamic> json) =>
      _$ActivityStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityStatusToJson(this);

  /// 활동 레벨 표시명
  String get activityLevelDisplay {
    switch (activityLevel) {
      case 'HIGH':
        return '높음';
      case 'NORMAL':
        return '보통';
      case 'LOW':
        return '낮음';
      default:
        return '알 수 없음';
    }
  }

  /// 활동 시간 표시 (시간:분)
  String get activeTimeDisplay {
    final hours = (totalActiveMinutes / 60).floor();
    final minutes = totalActiveMinutes % 60;
    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }
}

/// 일정 상태
@JsonSerializable()
class ScheduleStatus {
  final int totalSchedules;
  final int completedSchedules;
  final int upcomingSchedules;
  final String? nextScheduleTime;
  final String? nextScheduleTitle;

  const ScheduleStatus({
    required this.totalSchedules,
    required this.completedSchedules,
    required this.upcomingSchedules,
    this.nextScheduleTime,
    this.nextScheduleTitle,
  });

  factory ScheduleStatus.fromJson(Map<String, dynamic> json) =>
      _$ScheduleStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleStatusToJson(this);

  /// 완료율
  double get completionRate {
    if (totalSchedules == 0) return 0;
    return (completedSchedules / totalSchedules) * 100;
  }

  /// 완료율 표시
  String get completionRateDisplay => '${completionRate.toStringAsFixed(0)}%';
}

/// 주간 요약 리포트 DTO
@JsonSerializable()
class WeeklySummary {
  final int userId;
  final String userName;
  final String weekStartDate;
  final String weekEndDate;
  final MedicationWeeklySummary? medicationSummary;
  final ActivityWeeklySummary? activitySummary;
  final LocationWeeklySummary? locationSummary;
  final ScheduleWeeklySummary? scheduleSummary;
  final String weeklyTrend; // IMPROVING, STABLE, DECLINING
  final List<String> concerns;
  final List<String> achievements;

  const WeeklySummary({
    required this.userId,
    required this.userName,
    required this.weekStartDate,
    required this.weekEndDate,
    this.medicationSummary,
    this.activitySummary,
    this.locationSummary,
    this.scheduleSummary,
    required this.weeklyTrend,
    required this.concerns,
    required this.achievements,
  });

  factory WeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklySummaryToJson(this);

  /// 트렌드 표시명
  String get trendDisplayName {
    switch (weeklyTrend) {
      case 'IMPROVING':
        return '개선 중';
      case 'STABLE':
        return '안정적';
      case 'DECLINING':
        return '주의 필요';
      default:
        return '알 수 없음';
    }
  }

  /// 트렌드 아이콘
  String get trendIcon {
    switch (weeklyTrend) {
      case 'IMPROVING':
        return '📈';
      case 'STABLE':
        return '➡️';
      case 'DECLINING':
        return '📉';
      default:
        return '❓';
    }
  }
}

/// 복약 주간 요약
@JsonSerializable()
class MedicationWeeklySummary {
  final double overallCompletionRate;
  final Map<String, double> dailyRates;
  final int totalMedications;
  final int missedMedications;
  final List<String> frequentlyMissed;
  final String? bestDay;
  final String? worstDay;

  const MedicationWeeklySummary({
    required this.overallCompletionRate,
    required this.dailyRates,
    required this.totalMedications,
    required this.missedMedications,
    required this.frequentlyMissed,
    this.bestDay,
    this.worstDay,
  });

  factory MedicationWeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$MedicationWeeklySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationWeeklySummaryToJson(this);

  /// 완료율 표시
  String get completionRateDisplay =>
      '${overallCompletionRate.toStringAsFixed(0)}%';
}

/// 활동 주간 요약
@JsonSerializable()
class ActivityWeeklySummary {
  final int totalActiveMinutes;
  final double dailyAverageMinutes;
  final Map<String, int> dailyActivity;
  final String? mostActiveDay;
  final String? leastActiveDay;
  final int inactiveDays;
  final List<String> activityPatterns;

  const ActivityWeeklySummary({
    required this.totalActiveMinutes,
    required this.dailyAverageMinutes,
    required this.dailyActivity,
    this.mostActiveDay,
    this.leastActiveDay,
    required this.inactiveDays,
    required this.activityPatterns,
  });

  factory ActivityWeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$ActivityWeeklySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityWeeklySummaryToJson(this);

  /// 일평균 시간 표시
  String get averageTimeDisplay {
    final hours = (dailyAverageMinutes / 60).floor();
    final minutes = (dailyAverageMinutes % 60).toInt();
    if (hours > 0) {
      return '$hours시간 $minutes분';
    }
    return '$minutes분';
  }
}

/// 위치 주간 요약
@JsonSerializable()
class LocationWeeklySummary {
  final Map<String, int> frequentLocations;
  final int safeZoneExits;
  final String? mostVisitedPlace;
  final int uniquePlacesVisited;
  final List<String> unusualLocations;

  const LocationWeeklySummary({
    required this.frequentLocations,
    required this.safeZoneExits,
    this.mostVisitedPlace,
    required this.uniquePlacesVisited,
    required this.unusualLocations,
  });

  factory LocationWeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$LocationWeeklySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$LocationWeeklySummaryToJson(this);
}

/// 일정 주간 요약
@JsonSerializable()
class ScheduleWeeklySummary {
  final int totalSchedules;
  final int completedSchedules;
  final double completionRate;
  final Map<String, int> dailySchedules;
  final List<String> missedImportantSchedules;

  const ScheduleWeeklySummary({
    required this.totalSchedules,
    required this.completedSchedules,
    required this.completionRate,
    required this.dailySchedules,
    required this.missedImportantSchedules,
  });

  factory ScheduleWeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$ScheduleWeeklySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleWeeklySummaryToJson(this);

  /// 완료율 표시
  String get completionRateDisplay => '${completionRate.toStringAsFixed(0)}%';
}

/// 통합 대시보드 DTO
@JsonSerializable()
class IntegratedDashboard {
  final int userId;
  final String userName;
  final DailyStatusSummary dailySummary;
  final WeeklySummary weeklySummary;
  final String lastUpdated;

  const IntegratedDashboard({
    required this.userId,
    required this.userName,
    required this.dailySummary,
    required this.weeklySummary,
    required this.lastUpdated,
  });

  factory IntegratedDashboard.fromJson(Map<String, dynamic> json) =>
      _$IntegratedDashboardFromJson(json);

  Map<String, dynamic> toJson() => _$IntegratedDashboardToJson(this);
}
