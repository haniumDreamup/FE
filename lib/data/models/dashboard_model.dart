import 'package:json_annotation/json_annotation.dart';
import 'medication_model.dart';
import 'schedule_model.dart';

part 'dashboard_model.g.dart';

@JsonSerializable()
class DashboardModel {
  final String greeting;
  final DashboardSummary summary;
  final List<MedicationModel> todayMedications;
  final List<ScheduleModel> todaySchedules;
  final List<DashboardNotification> notifications;
  final WeatherInfo? weather;

  const DashboardModel({
    required this.greeting,
    required this.summary,
    required this.todayMedications,
    required this.todaySchedules,
    required this.notifications,
    this.weather,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardModelToJson(this);
}

@JsonSerializable()
class DashboardSummary {
  final int totalMedications;
  final int completedMedications;
  final int totalSchedules;
  final int completedSchedules;
  final int unreadNotifications;
  final double completionRate;

  const DashboardSummary({
    required this.totalMedications,
    required this.completedMedications,
    required this.totalSchedules,
    required this.completedSchedules,
    required this.unreadNotifications,
    required this.completionRate,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryToJson(this);

  bool get allMedicationsTaken => totalMedications > 0 && completedMedications == totalMedications;
  bool get allSchedulesCompleted => totalSchedules > 0 && completedSchedules == totalSchedules;
  int get pendingMedications => totalMedications - completedMedications;
  int get pendingSchedules => totalSchedules - completedSchedules;
}

@JsonSerializable()
class DashboardNotification {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? actionUrl;

  const DashboardNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.actionUrl,
  });

  factory DashboardNotification.fromJson(Map<String, dynamic> json) =>
      _$DashboardNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardNotificationToJson(this);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${createdAt.month}/${createdAt.day}';
    }
  }

  bool get isImportant => type == 'emergency' || type == 'medication_missed';
}

@JsonSerializable()
class WeatherInfo {
  final String location;
  final double temperature;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  const WeatherInfo({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);

  String get temperatureString => '${temperature.round()}°C';
}