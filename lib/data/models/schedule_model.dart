import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  final int id;
  final String title;
  final String description;
  final DateTime scheduledTime;
  final String category;
  final String priority;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;
  final String color;
  final String icon;
  final bool hasReminder;
  final List<String>? tags;

  const ScheduleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.category,
    this.priority = 'medium',
    required this.isCompleted,
    this.completedAt,
    this.notes,
    required this.color,
    required this.icon,
    this.hasReminder = true,
    this.tags,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  ScheduleModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? scheduledTime,
    String? category,
    String? priority,
    bool? isCompleted,
    DateTime? completedAt,
    String? notes,
    String? color,
    String? icon,
    bool? hasReminder,
    List<String>? tags,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      hasReminder: hasReminder ?? this.hasReminder,
      tags: tags ?? this.tags,
    );
  }

  String get timeString {
    final hour = scheduledTime.hour.toString().padLeft(2, '0');
    final minute = scheduledTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get isOverdue {
    return !isCompleted && scheduledTime.isBefore(DateTime.now());
  }

  bool get isToday {
    final now = DateTime.now();
    return scheduledTime.year == now.year &&
           scheduledTime.month == now.month &&
           scheduledTime.day == now.day;
  }

  @override
  String toString() {
    return 'ScheduleModel(id: $id, title: $title, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduleModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}