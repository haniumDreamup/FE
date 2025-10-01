// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardModel _$DashboardModelFromJson(Map<String, dynamic> json) =>
    DashboardModel(
      greeting: json['greeting'] as String,
      summary:
          DashboardSummary.fromJson(json['summary'] as Map<String, dynamic>),
      todayMedications: (json['todayMedications'] as List<dynamic>)
          .map((e) => MedicationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      todaySchedules: (json['todaySchedules'] as List<dynamic>)
          .map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => DashboardNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      weather: json['weather'] == null
          ? null
          : WeatherInfo.fromJson(json['weather'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DashboardModelToJson(DashboardModel instance) =>
    <String, dynamic>{
      'greeting': instance.greeting,
      'summary': instance.summary,
      'todayMedications': instance.todayMedications,
      'todaySchedules': instance.todaySchedules,
      'notifications': instance.notifications,
      'weather': instance.weather,
    };

DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    DashboardSummary(
      totalMedications: (json['totalMedications'] as num).toInt(),
      completedMedications: (json['completedMedications'] as num).toInt(),
      totalSchedules: (json['totalSchedules'] as num).toInt(),
      completedSchedules: (json['completedSchedules'] as num).toInt(),
      unreadNotifications: (json['unreadNotifications'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardSummaryToJson(DashboardSummary instance) =>
    <String, dynamic>{
      'totalMedications': instance.totalMedications,
      'completedMedications': instance.completedMedications,
      'totalSchedules': instance.totalSchedules,
      'completedSchedules': instance.completedSchedules,
      'unreadNotifications': instance.unreadNotifications,
      'completionRate': instance.completionRate,
    };

DashboardNotification _$DashboardNotificationFromJson(
        Map<String, dynamic> json) =>
    DashboardNotification(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      actionUrl: json['actionUrl'] as String?,
    );

Map<String, dynamic> _$DashboardNotificationToJson(
        DashboardNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'actionUrl': instance.actionUrl,
    };

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
      location: json['location'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
    );

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) =>
    <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'condition': instance.condition,
      'description': instance.description,
      'icon': instance.icon,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
    };
