// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleRequest _$ScheduleRequestFromJson(Map<String, dynamic> json) =>
    ScheduleRequest(
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduleType: $enumDecode(_$ScheduleTypeEnumMap, json['scheduleType']),
      recurrenceType:
          $enumDecode(_$RecurrenceTypeEnumMap, json['recurrenceType']),
      executionTime: json['executionTime'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      selectedDays: (json['selectedDays'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DayOfWeekEnumMap, e))
          .toList(),
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      intervalValue: (json['intervalValue'] as num?)?.toInt() ?? 1,
      priority: (json['priority'] as num?)?.toInt() ?? 2,
      visualIndicator: json['visualIndicator'] as String?,
      reminderMinutesBefore: (json['reminderMinutesBefore'] as num?)?.toInt(),
      requiresConfirmation: json['requiresConfirmation'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ScheduleRequestToJson(ScheduleRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'scheduleType': _$ScheduleTypeEnumMap[instance.scheduleType]!,
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType]!,
      'executionTime': instance.executionTime,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'selectedDays':
          instance.selectedDays?.map((e) => _$DayOfWeekEnumMap[e]!).toList(),
      'dayOfMonth': instance.dayOfMonth,
      'intervalValue': instance.intervalValue,
      'priority': instance.priority,
      'visualIndicator': instance.visualIndicator,
      'reminderMinutesBefore': instance.reminderMinutesBefore,
      'requiresConfirmation': instance.requiresConfirmation,
      'isActive': instance.isActive,
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.medication: 'MEDICATION',
  ScheduleType.meal: 'MEAL',
  ScheduleType.exercise: 'EXERCISE',
  ScheduleType.appointment: 'APPOINTMENT',
  ScheduleType.reminder: 'REMINDER',
  ScheduleType.emergencyCheck: 'EMERGENCY_CHECK',
  ScheduleType.healthCheck: 'HEALTH_CHECK',
  ScheduleType.socialActivity: 'SOCIAL_ACTIVITY',
  ScheduleType.personalCare: 'PERSONAL_CARE',
};

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.once: 'ONCE',
  RecurrenceType.daily: 'DAILY',
  RecurrenceType.weekly: 'WEEKLY',
  RecurrenceType.monthly: 'MONTHLY',
  RecurrenceType.customDays: 'CUSTOM_DAYS',
  RecurrenceType.intervalDays: 'INTERVAL_DAYS',
  RecurrenceType.intervalWeeks: 'INTERVAL_WEEKS',
};

const _$DayOfWeekEnumMap = {
  DayOfWeek.monday: 'MONDAY',
  DayOfWeek.tuesday: 'TUESDAY',
  DayOfWeek.wednesday: 'WEDNESDAY',
  DayOfWeek.thursday: 'THURSDAY',
  DayOfWeek.friday: 'FRIDAY',
  DayOfWeek.saturday: 'SATURDAY',
  DayOfWeek.sunday: 'SUNDAY',
};

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduleType: $enumDecode(_$ScheduleTypeEnumMap, json['scheduleType']),
      scheduleTypeDescription: json['scheduleTypeDescription'] as String,
      recurrenceType:
          $enumDecode(_$RecurrenceTypeEnumMap, json['recurrenceType']),
      recurrenceTypeDescription: json['recurrenceTypeDescription'] as String,
      executionTime: json['executionTime'] as String,
      nextExecutionTime: json['nextExecutionTime'] as String?,
      lastExecutionTime: json['lastExecutionTime'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      selectedDays: (json['selectedDays'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$DayOfWeekEnumMap, e))
          .toList(),
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      intervalValue: (json['intervalValue'] as num).toInt(),
      isActive: json['isActive'] as bool,
      priority: (json['priority'] as num).toInt(),
      visualIndicator: json['visualIndicator'] as String?,
      reminderMinutesBefore: (json['reminderMinutesBefore'] as num?)?.toInt(),
      requiresConfirmation: json['requiresConfirmation'] as bool,
      createdByType: json['createdByType'] as String,
      createdByTypeDescription: json['createdByTypeDescription'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isDueSoon: json['isDueSoon'] as bool,
      isHighPriority: json['isHighPriority'] as bool,
      simpleDescription: json['simpleDescription'] as String,
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'title': instance.title,
      'description': instance.description,
      'scheduleType': _$ScheduleTypeEnumMap[instance.scheduleType]!,
      'scheduleTypeDescription': instance.scheduleTypeDescription,
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType]!,
      'recurrenceTypeDescription': instance.recurrenceTypeDescription,
      'executionTime': instance.executionTime,
      'nextExecutionTime': instance.nextExecutionTime,
      'lastExecutionTime': instance.lastExecutionTime,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'selectedDays':
          instance.selectedDays?.map((e) => _$DayOfWeekEnumMap[e]!).toList(),
      'dayOfMonth': instance.dayOfMonth,
      'intervalValue': instance.intervalValue,
      'isActive': instance.isActive,
      'priority': instance.priority,
      'visualIndicator': instance.visualIndicator,
      'reminderMinutesBefore': instance.reminderMinutesBefore,
      'requiresConfirmation': instance.requiresConfirmation,
      'createdByType': instance.createdByType,
      'createdByTypeDescription': instance.createdByTypeDescription,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isDueSoon': instance.isDueSoon,
      'isHighPriority': instance.isHighPriority,
      'simpleDescription': instance.simpleDescription,
    };

SchedulePageResponse _$SchedulePageResponseFromJson(
        Map<String, dynamic> json) =>
    SchedulePageResponse(
      content: (json['content'] as List<dynamic>)
          .map((e) => ScheduleResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageable: PageableInfo.fromJson(json['pageable'] as Map<String, dynamic>),
      totalElements: (json['totalElements'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      last: json['last'] as bool,
    );

Map<String, dynamic> _$SchedulePageResponseToJson(
        SchedulePageResponse instance) =>
    <String, dynamic>{
      'content': instance.content,
      'pageable': instance.pageable,
      'totalElements': instance.totalElements,
      'totalPages': instance.totalPages,
      'last': instance.last,
    };

PageableInfo _$PageableInfoFromJson(Map<String, dynamic> json) => PageableInfo(
      pageNumber: (json['pageNumber'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$PageableInfoToJson(PageableInfo instance) =>
    <String, dynamic>{
      'pageNumber': instance.pageNumber,
      'pageSize': instance.pageSize,
    };
