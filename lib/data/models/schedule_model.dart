import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

/// 일정 유형 (ScheduleType)
enum ScheduleType {
  @JsonValue('MEDICATION')
  medication('약물 복용'),
  @JsonValue('MEAL')
  meal('식사'),
  @JsonValue('EXERCISE')
  exercise('운동'),
  @JsonValue('APPOINTMENT')
  appointment('약속/병원'),
  @JsonValue('REMINDER')
  reminder('알림'),
  @JsonValue('THERAPY')
  therapy('치료'),
  @JsonValue('HYGIENE')
  hygiene('위생 관리'),
  @JsonValue('SAFETY_CHECK')
  safetyCheck('안전 확인'),
  @JsonValue('SOCIAL_ACTIVITY')
  socialActivity('사회 활동'),
  @JsonValue('PERSONAL_CARE')
  personalCare('개인 관리');

  const ScheduleType(this.description);
  final String description;
}

/// 반복 패턴 (RecurrenceType)
enum RecurrenceType {
  @JsonValue('ONCE')
  once('한 번만'),
  @JsonValue('DAILY')
  daily('매일'),
  @JsonValue('WEEKLY')
  weekly('매주'),
  @JsonValue('MONTHLY')
  monthly('매월'),
  @JsonValue('CUSTOM_DAYS')
  customDays('요일 선택'),
  @JsonValue('INTERVAL_DAYS')
  intervalDays('N일마다'),
  @JsonValue('INTERVAL_WEEKS')
  intervalWeeks('N주마다');

  const RecurrenceType(this.description);
  final String description;
}

/// 요일
enum DayOfWeek {
  @JsonValue('MONDAY')
  monday('월'),
  @JsonValue('TUESDAY')
  tuesday('화'),
  @JsonValue('WEDNESDAY')
  wednesday('수'),
  @JsonValue('THURSDAY')
  thursday('목'),
  @JsonValue('FRIDAY')
  friday('금'),
  @JsonValue('SATURDAY')
  saturday('토'),
  @JsonValue('SUNDAY')
  sunday('일');

  const DayOfWeek(this.korean);
  final String korean;
}

/// 일정 생성/수정 요청 모델
@JsonSerializable()
class ScheduleRequest {
  final String title;
  final String? description;
  final ScheduleType scheduleType;
  final RecurrenceType recurrenceType;
  final String executionTime; // "HH:mm" 형식
  final String startDate; // ISO 8601
  final String? endDate; // ISO 8601
  final List<DayOfWeek>? selectedDays;
  final int? dayOfMonth;
  final int intervalValue;
  final int priority; // 1~4
  final String? visualIndicator;
  final int? reminderMinutesBefore;
  final bool requiresConfirmation;
  final bool isActive;

  ScheduleRequest({
    required this.title,
    this.description,
    required this.scheduleType,
    required this.recurrenceType,
    required this.executionTime,
    required this.startDate,
    this.endDate,
    this.selectedDays,
    this.dayOfMonth,
    this.intervalValue = 1,
    this.priority = 2,
    this.visualIndicator,
    this.reminderMinutesBefore,
    this.requiresConfirmation = false,
    this.isActive = true,
  });

  factory ScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$ScheduleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleRequestToJson(this);
}

/// 일정 응답 모델
@JsonSerializable()
class ScheduleResponse {
  final int id;
  final int userId;
  final String userName;
  final String title;
  final String? description;
  final ScheduleType scheduleType;
  final String scheduleTypeDescription;
  final RecurrenceType recurrenceType;
  final String recurrenceTypeDescription;
  final String executionTime;
  final String? nextExecutionTime; // ISO 8601
  final String? lastExecutionTime; // ISO 8601
  final String startDate; // ISO 8601
  final String? endDate; // ISO 8601
  final List<DayOfWeek>? selectedDays;
  final int? dayOfMonth;
  final int intervalValue;
  final bool isActive;
  final int priority;
  final String? visualIndicator;
  final int? reminderMinutesBefore;
  final bool requiresConfirmation;
  final String createdByType;
  final String createdByTypeDescription;
  final String createdAt; // ISO 8601
  final String updatedAt; // ISO 8601
  final bool isDueSoon;
  final bool isHighPriority;
  final String simpleDescription;

  ScheduleResponse({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    this.description,
    required this.scheduleType,
    required this.scheduleTypeDescription,
    required this.recurrenceType,
    required this.recurrenceTypeDescription,
    required this.executionTime,
    this.nextExecutionTime,
    this.lastExecutionTime,
    required this.startDate,
    this.endDate,
    this.selectedDays,
    this.dayOfMonth,
    required this.intervalValue,
    required this.isActive,
    required this.priority,
    this.visualIndicator,
    this.reminderMinutesBefore,
    required this.requiresConfirmation,
    required this.createdByType,
    required this.createdByTypeDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.isDueSoon,
    required this.isHighPriority,
    required this.simpleDescription,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);

  /// 우선순위 색상
  String get priorityColor {
    switch (priority) {
      case 4:
        return 'red'; // 매우 높음
      case 3:
        return 'orange'; // 높음
      case 1:
        return 'grey'; // 낮음
      default:
        return 'blue'; // 보통
    }
  }

  /// DateTime으로 파싱
  DateTime? get nextExecutionDateTime {
    if (nextExecutionTime == null) return null;
    return DateTime.tryParse(nextExecutionTime!);
  }

  DateTime? get lastExecutionDateTime {
    if (lastExecutionTime == null) return null;
    return DateTime.tryParse(lastExecutionTime!);
  }

  DateTime get startDateTime {
    return DateTime.parse(startDate);
  }

  DateTime? get endDateTime {
    if (endDate == null) return null;
    return DateTime.tryParse(endDate!);
  }
}

/// 페이징된 일정 목록 응답
@JsonSerializable()
class SchedulePageResponse {
  final List<ScheduleResponse> content;
  final PageableInfo pageable;
  final int totalElements;
  final int totalPages;
  final bool last;

  SchedulePageResponse({
    required this.content,
    required this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory SchedulePageResponse.fromJson(Map<String, dynamic> json) =>
      _$SchedulePageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SchedulePageResponseToJson(this);
}

/// 페이지 정보
@JsonSerializable()
class PageableInfo {
  final int pageNumber;
  final int pageSize;

  PageableInfo({
    required this.pageNumber,
    required this.pageSize,
  });

  factory PageableInfo.fromJson(Map<String, dynamic> json) =>
      _$PageableInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PageableInfoToJson(this);
}
