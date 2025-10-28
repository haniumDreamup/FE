import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 통계 서비스 (백엔드 StatisticsController와 동기화)
class StatisticsService {
  final ApiClient _apiClient;

  StatisticsService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 지오펜스 통계 조회 (GET /api/statistics/geofence)
  Future<GeofenceStatisticsModel> getGeofenceStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.geofenceStatistics,
        queryParameters: {
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
        },
      );

      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음
      if (response.data['success'] == true) {
        return GeofenceStatisticsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 통계 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 일일 활동 통계 조회 (GET /api/statistics/daily-activity)
  Future<DailyActivityStatisticsModel> getDailyActivityStatistics({
    DateTime? date,
    int? userId,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.dailyActivityList,
        queryParameters: {
          if (date != null) 'date': date.toIso8601String().split('T')[0],
          if (userId != null) 'userId': userId,
        },
      );

      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음
      if (response.data['success'] == true) {
        return DailyActivityStatisticsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일일 활동 통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일일 활동 통계 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 단일 날짜 활동 통계 조회 (GET /api/statistics/daily-activity/single)
  Future<SingleDayActivityModel> getSingleDayActivity(DateTime date, {int? userId}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.dailyActivitySingle,
        queryParameters: {
          'date': date.toIso8601String().split('T')[0],
          if (userId != null) 'userId': userId,
        },
      );

      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음
      if (response.data['success'] == true) {
        return SingleDayActivityModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '단일 날짜 활동 통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('단일 날짜 활동 통계 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 안전 통계 조회 (GET /api/statistics/safety)
  Future<SafetyStatisticsModel> getSafetyStatistics({
    DateTime? startDate,
    DateTime? endDate,
    int? userId,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.safetyStatistics,
        queryParameters: {
          if (startDate != null) 'startDate': startDate.toIso8601String(),
          if (endDate != null) 'endDate': endDate.toIso8601String(),
          if (userId != null) 'userId': userId,
        },
      );

      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음
      if (response.data['success'] == true) {
        return SafetyStatisticsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '안전 통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('안전 통계 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 통계 요약 조회 (GET /api/statistics/summary)
  Future<StatisticsSummaryModel> getStatisticsSummary({
    String period = 'week', // week, month, year
    int? userId,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.summaryStatistics,
        queryParameters: {
          'period': period,
          if (userId != null) 'userId': userId,
        },
      );

      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음
      if (response.data['success'] == true) {
        return StatisticsSummaryModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '통계 요약을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('통계 요약 조회 중 오류가 발생했습니다: $e');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('네트워크 연결이 불안정합니다. 다시 시도해주세요.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
        if (statusCode == 401) {
          return Exception('로그인이 필요합니다');
        } else if (statusCode == 403) {
          return Exception('권한이 없습니다');
        } else if (statusCode == 404) {
          return Exception('요청한 정보를 찾을 수 없습니다');
        }
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다');
      case DioExceptionType.unknown:
      default:
        if (e.error.toString().contains('SocketException')) {
          return Exception('인터넷 연결을 확인해주세요');
        }
        return Exception('알 수 없는 오류가 발생했습니다');
    }
  }
}

/// 지오펜스 통계 모델
class GeofenceStatisticsModel {
  final int totalGeofences;
  final int activeGeofences;
  final int totalEvents;
  final int entryEvents;
  final int exitEvents;
  final double averageTimeInside;
  final List<GeofenceEventModel> recentEvents;
  final Map<String, int> eventsByType;
  final Map<String, double> timeByGeofence;

  const GeofenceStatisticsModel({
    required this.totalGeofences,
    required this.activeGeofences,
    required this.totalEvents,
    required this.entryEvents,
    required this.exitEvents,
    required this.averageTimeInside,
    required this.recentEvents,
    required this.eventsByType,
    required this.timeByGeofence,
  });

  factory GeofenceStatisticsModel.fromJson(Map<String, dynamic> json) {
    return GeofenceStatisticsModel(
      totalGeofences: json['totalGeofences'] ?? 0,
      activeGeofences: json['activeGeofences'] ?? 0,
      totalEvents: json['totalEvents'] ?? 0,
      entryEvents: json['entryEvents'] ?? 0,
      exitEvents: json['exitEvents'] ?? 0,
      averageTimeInside: (json['averageTimeInside'] ?? 0.0).toDouble(),
      recentEvents: (json['recentEvents'] as List? ?? [])
          .map((e) => GeofenceEventModel.fromJson(e))
          .toList(),
      eventsByType: Map<String, int>.from(json['eventsByType'] ?? {}),
      timeByGeofence: Map<String, double>.from(json['timeByGeofence'] ?? {}),
    );
  }
}

/// 지오펜스 이벤트 모델
class GeofenceEventModel {
  final int id;
  final String geofenceName;
  final String eventType;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;

  const GeofenceEventModel({
    required this.id,
    required this.geofenceName,
    required this.eventType,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  factory GeofenceEventModel.fromJson(Map<String, dynamic> json) {
    return GeofenceEventModel(
      id: json['id'] ?? 0,
      geofenceName: json['geofenceName'] ?? '',
      eventType: json['eventType'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}

/// 일일 활동 통계 모델
class DailyActivityStatisticsModel {
  final DateTime date;
  final int totalSteps;
  final int medicationsTaken;
  final int schedulesCompleted;
  final int emergencyAlerts;
  final double activeTime;
  final Map<String, int> activityByHour;
  final List<ActivityEventModel> events;

  const DailyActivityStatisticsModel({
    required this.date,
    required this.totalSteps,
    required this.medicationsTaken,
    required this.schedulesCompleted,
    required this.emergencyAlerts,
    required this.activeTime,
    required this.activityByHour,
    required this.events,
  });

  factory DailyActivityStatisticsModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityStatisticsModel(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      totalSteps: json['totalSteps'] ?? 0,
      medicationsTaken: json['medicationsTaken'] ?? 0,
      schedulesCompleted: json['schedulesCompleted'] ?? 0,
      emergencyAlerts: json['emergencyAlerts'] ?? 0,
      activeTime: (json['activeTime'] ?? 0.0).toDouble(),
      activityByHour: Map<String, int>.from(json['activityByHour'] ?? {}),
      events: (json['events'] as List? ?? [])
          .map((e) => ActivityEventModel.fromJson(e))
          .toList(),
    );
  }
}

/// 활동 이벤트 모델
class ActivityEventModel {
  final String type;
  final DateTime timestamp;
  final String description;
  final Map<String, dynamic>? metadata;

  const ActivityEventModel({
    required this.type,
    required this.timestamp,
    required this.description,
    this.metadata,
  });

  factory ActivityEventModel.fromJson(Map<String, dynamic> json) {
    return ActivityEventModel(
      type: json['type'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      description: json['description'] ?? '',
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
    );
  }
}

/// 단일 날짜 활동 모델
class SingleDayActivityModel {
  final DateTime date;
  final bool isActive;
  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> hourlyData;

  const SingleDayActivityModel({
    required this.date,
    required this.isActive,
    required this.summary,
    required this.hourlyData,
  });

  factory SingleDayActivityModel.fromJson(Map<String, dynamic> json) {
    return SingleDayActivityModel(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? false,
      summary: Map<String, dynamic>.from(json['summary'] ?? {}),
      hourlyData: List<Map<String, dynamic>>.from(json['hourlyData'] ?? []),
    );
  }
}

/// 안전 통계 모델
class SafetyStatisticsModel {
  final int totalEmergencies;
  final int resolvedEmergencies;
  final int activeEmergencies;
  final double averageResponseTime;
  final int fallDetections;
  final int geofenceViolations;
  final int sosActivations;
  final Map<String, int> emergencyTypes;
  final List<EmergencyTrendModel> trends;

  const SafetyStatisticsModel({
    required this.totalEmergencies,
    required this.resolvedEmergencies,
    required this.activeEmergencies,
    required this.averageResponseTime,
    required this.fallDetections,
    required this.geofenceViolations,
    required this.sosActivations,
    required this.emergencyTypes,
    required this.trends,
  });

  factory SafetyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return SafetyStatisticsModel(
      totalEmergencies: json['totalEmergencies'] ?? 0,
      resolvedEmergencies: json['resolvedEmergencies'] ?? 0,
      activeEmergencies: json['activeEmergencies'] ?? 0,
      averageResponseTime: (json['averageResponseTime'] ?? 0.0).toDouble(),
      fallDetections: json['fallDetections'] ?? 0,
      geofenceViolations: json['geofenceViolations'] ?? 0,
      sosActivations: json['sosActivations'] ?? 0,
      emergencyTypes: Map<String, int>.from(json['emergencyTypes'] ?? {}),
      trends: (json['trends'] as List? ?? [])
          .map((e) => EmergencyTrendModel.fromJson(e))
          .toList(),
    );
  }
}

/// 긴급상황 트렌드 모델
class EmergencyTrendModel {
  final DateTime date;
  final int count;
  final String type;

  const EmergencyTrendModel({
    required this.date,
    required this.count,
    required this.type,
  });

  factory EmergencyTrendModel.fromJson(Map<String, dynamic> json) {
    return EmergencyTrendModel(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      count: json['count'] ?? 0,
      type: json['type'] ?? '',
    );
  }
}

/// 통계 요약 모델
class StatisticsSummaryModel {
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> overall;
  final Map<String, dynamic> safety;
  final Map<String, dynamic> activity;
  final Map<String, dynamic> medication;
  final Map<String, dynamic> schedule;
  final List<Map<String, dynamic>> dailySummaries;

  const StatisticsSummaryModel({
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.overall,
    required this.safety,
    required this.activity,
    required this.medication,
    required this.schedule,
    required this.dailySummaries,
  });

  factory StatisticsSummaryModel.fromJson(Map<String, dynamic> json) {
    return StatisticsSummaryModel(
      period: json['period'] ?? '',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      overall: Map<String, dynamic>.from(json['overall'] ?? {}),
      safety: Map<String, dynamic>.from(json['safety'] ?? {}),
      activity: Map<String, dynamic>.from(json['activity'] ?? {}),
      medication: Map<String, dynamic>.from(json['medication'] ?? {}),
      schedule: Map<String, dynamic>.from(json['schedule'] ?? {}),
      dailySummaries: List<Map<String, dynamic>>.from(json['dailySummaries'] ?? []),
    );
  }
}