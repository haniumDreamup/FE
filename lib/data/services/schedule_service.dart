import 'package:dio/dio.dart';
import '../models/schedule_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class ScheduleService {
  final ApiClient _apiClient;

  ScheduleService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 오늘의 일정 목록 조회
  Future<List<ScheduleModel>> getTodaySchedules() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.schedulesToday);
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '일정 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일정 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 특정 날짜의 일정 목록 조회
  Future<List<ScheduleModel>> getSchedulesByDate(DateTime date) async {
    try {
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedules,
        queryParameters: {'date': dateString},
      );
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '일정 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일정 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 주간 일정 요약 조회
  Future<List<ScheduleModel>> getWeekSummary() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.weekSummary);
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '주간 일정을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('주간 일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 상세 정보 조회
  Future<ScheduleModel> getScheduleDetail(int scheduleId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.scheduleDetailPath(scheduleId)
      );
      
      if (response.data['success'] == true) {
        return ScheduleModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일정 상세 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 완료 체크
  Future<ScheduleModel> completeSchedule(int scheduleId, bool completed, {String? notes}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.completeSchedulePath(scheduleId),
        data: {
          'completed': completed,
          'completedAt': completed ? DateTime.now().toIso8601String() : null,
          'notes': notes,
        },
      );
      
      if (response.data['success'] == true) {
        return ScheduleModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 완료 체크를 할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일정 완료 체크 중 오류가 발생했습니다: $e');
    }
  }

  /// 카테고리별 일정 조회
  Future<List<ScheduleModel>> getSchedulesByCategory(String category) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedules,
        queryParameters: {'category': category},
      );
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '일정 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일정 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 완료율 조회 (7일)
  Future<Map<String, dynamic>> getScheduleStats() async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.schedules}/stats');
      
      if (response.data['success'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message'] ?? '통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('통계 조회 중 오류가 발생했습니다: $e');
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