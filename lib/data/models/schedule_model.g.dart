// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      category: json['category'] as String,
      priority: json['priority'] as String? ?? 'medium',
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      notes: json['notes'] as String?,
      color: json['color'] as String,
      icon: json['icon'] as String,
      hasReminder: json['hasReminder'] as bool? ?? true,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'category': instance.category,
      'priority': instance.priority,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
      'color': instance.color,
      'icon': instance.icon,
      'hasReminder': instance.hasReminder,
      'tags': instance.tags,
    };
