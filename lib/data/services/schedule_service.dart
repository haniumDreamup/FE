import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/schedule_model.dart';

/// 일정 관리 서비스
class ScheduleService {
  final ApiClient _apiClient;

  ScheduleService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  // ============ CRUD 기본 API ============

  /// 일정 생성 (POST /api/v1/schedules)
  Future<ScheduleResponse> createSchedule(ScheduleRequest request) async {
    print('🟡 [ScheduleService] 일정 생성 요청: ${request.toJson()}');
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.schedules,
        data: request.toJson(),
      );
      print('✅ [ScheduleService] 일정 생성 응답: ${response.data}');

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 생성에 실패했습니다');
      }
    } on DioException catch (e) {
      print('❌ [ScheduleService] DioException: ${e.response?.statusCode} - ${e.response?.data}');
      throw _handleDioException(e, '일정 생성');
    } catch (e) {
      print('❌ [ScheduleService] 일반 에러: $e');
      throw Exception('일정 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 상세 조회 (GET /api/v1/schedules/{id})
  Future<ScheduleResponse> getSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.scheduleDetailPath(scheduleId),
      );

      // 통일된 ApiResponse 구조
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 정보를 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 조회');
    } catch (e) {
      throw Exception('일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 목록 조회 (페이징) (GET /api/v1/schedules)
  Future<SchedulePageResponse> getSchedules({int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedules,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      // 통일된 ApiResponse 구조
      if (response.data['success'] == true) {
        return SchedulePageResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 목록을 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 목록 조회');
    } catch (e) {
      throw Exception('일정 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 수정 (PUT /api/v1/schedules/{id})
  Future<ScheduleResponse> updateSchedule(int scheduleId, ScheduleRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.scheduleDetailPath(scheduleId),
        data: request.toJson(),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 수정에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 수정');
    } catch (e) {
      throw Exception('일정 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 삭제 (DELETE /api/v1/schedules/{id})
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.scheduleDetailPath(scheduleId),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '일정 삭제에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 삭제');
    } catch (e) {
      throw Exception('일정 삭제 중 오류가 발생했습니다: $e');
    }
  }

  // ============ 조회 필터 API ============

  /// 오늘의 일정 조회 (GET /api/v1/schedules/today)
  Future<List<ScheduleResponse>> getTodaySchedules() async {
    print('🟡 [ScheduleService] 오늘의 일정 조회 요청');
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedulesToday,
      );
      print('✅ [ScheduleService] 오늘의 일정 응답: ${response.data}');

      // 응답 구조: {s: true, d: {success: true, data: [...], message: "...", timestamp: [...]}, t: [...]}
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        print('📋 [ScheduleService] 조회된 일정 개수: ${data.length}');
        return data.map((json) => ScheduleResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '오늘의 일정을 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      print('❌ [ScheduleService] DioException: ${e.response?.statusCode} - ${e.response?.data}');
      throw _handleDioException(e, '오늘의 일정 조회');
    } catch (e) {
      print('❌ [ScheduleService] 일반 에러: $e');
      throw Exception('오늘의 일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 다가오는 일정 조회 (GET /api/v1/schedules/upcoming)
  Future<List<ScheduleResponse>> getUpcomingSchedules({int days = 7}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedulesUpcoming,
        queryParameters: {'days': days},
      );

      // 응답 구조: {s: true, d: {success: true, data: [...], message: "...", timestamp: [...]}, t: [...]}
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ScheduleResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '다가오는 일정을 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '다가오는 일정 조회');
    } catch (e) {
      throw Exception('다가오는 일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 특정 날짜 일정 조회 (GET /api/v1/schedules/date)
  Future<List<ScheduleResponse>> getSchedulesByDate(DateTime date) async {
    final formattedDate = _formatDate(date);
    print('🟡 [ScheduleService] 날짜별 일정 조회 요청: $formattedDate');
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedulesDate,
        queryParameters: {
          'date': formattedDate, // YYYY-MM-DD
        },
      );
      print('✅ [ScheduleService] 날짜별 일정 응답: ${response.data}');

      // 응답 구조: {s: true, d: {success: true, data: [...], message: "...", timestamp: [...]}, t: [...]}
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        print('📋 [ScheduleService] 조회된 일정 개수: ${data.length}');
        return data.map((json) => ScheduleResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '일정을 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      print('❌ [ScheduleService] DioException: ${e.response?.statusCode} - ${e.response?.data}');
      throw _handleDioException(e, '특정 날짜 일정 조회');
    } catch (e) {
      print('❌ [ScheduleService] 일반 에러: $e');
      throw Exception('일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 기간별 일정 조회 (GET /api/v1/schedules/range)
  Future<List<ScheduleResponse>> getSchedulesByRange(DateTime startDate, DateTime endDate) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.schedulesRange,
        queryParameters: {
          'startDate': _formatDate(startDate),
          'endDate': _formatDate(endDate),
        },
      );

      // 응답 구조: {s: true, d: {success: true, data: [...], message: "...", timestamp: [...]}, t: [...]}
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ScheduleResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '기간 내 일정을 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '기간별 일정 조회');
    } catch (e) {
      throw Exception('기간별 일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  // ============ 상태 관리 API ============

  /// 일정 완료 처리 (POST /api/v1/schedules/{id}/complete)
  Future<ScheduleResponse> completeSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.scheduleCompletePath(scheduleId),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 완료 처리에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 완료 처리');
    } catch (e) {
      throw Exception('일정 완료 처리 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 완료 취소 (POST /api/v1/schedules/{id}/uncomplete)
  Future<ScheduleResponse> uncompleteSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.scheduleUncompletePath(scheduleId),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '완료 취소에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '완료 취소');
    } catch (e) {
      throw Exception('완료 취소 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 활성화 (PUT /api/v1/schedules/{id}/activate)
  Future<ScheduleResponse> activateSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.scheduleActivatePath(scheduleId),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 활성화에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 활성화');
    } catch (e) {
      throw Exception('일정 활성화 중 오류가 발생했습니다: $e');
    }
  }

  /// 일정 비활성화 (PUT /api/v1/schedules/{id}/deactivate)
  Future<ScheduleResponse> deactivateSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.scheduleDeactivatePath(scheduleId),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '일정 비활성화에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 비활성화');
    } catch (e) {
      throw Exception('일정 비활성화 중 오류가 발생했습니다: $e');
    }
  }

  // ============ 반복 일정 API ============

  /// 다음 실행 건너뛰기 (POST /api/v1/schedules/{id}/skip-next)
  Future<ScheduleResponse> skipNextSchedule(int scheduleId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.scheduleSkipNextPath(scheduleId),
      );

      // 통일된 ApiResponse 구조: {success: true, data: {...}, message: "...", timestamp: "..."}
      
      if (response.data['success'] == true) {
        return ScheduleResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '건너뛰기에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '일정 건너뛰기');
    } catch (e) {
      throw Exception('일정 건너뛰기 중 오류가 발생했습니다: $e');
    }
  }

  /// 반복 일정 목록 조회 (GET /api/v1/schedules/{id}/occurrences)
  Future<List<String>> getScheduleOccurrences(int scheduleId, {int count = 10}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.scheduleOccurrencesPath(scheduleId),
        queryParameters: {'count': count},
      );

      // 응답 구조: {s: true, d: {success: true, data: [...], message: "...", timestamp: [...]}, t: [...]}
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((item) => item.toString()).toList();
      } else {
        throw Exception(response.data['message'] ?? '반복 일정을 가져올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, '반복 일정 조회');
    } catch (e) {
      throw Exception('반복 일정 조회 중 오류가 발생했습니다: $e');
    }
  }

  // ============ Helper Methods ============

  /// DateTime을 YYYY-MM-DD 형식으로 변환
  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// DioException 처리
  Exception _handleDioException(DioException e, String operation) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('네트워크 연결이 불안정합니다. 다시 시도해주세요.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.response?.data?['error']?['message'] ?? '$operation 실패';
        if (statusCode == 401) {
          return Exception('로그인이 필요합니다');
        } else if (statusCode == 403) {
          return Exception('권한이 없습니다');
        } else if (statusCode == 404) {
          return Exception('일정을 찾을 수 없습니다');
        }
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다');
      case DioExceptionType.unknown:
      default:
        if (e.error.toString().contains('SocketException')) {
          return Exception('인터넷 연결을 확인해주세요');
        }
        return Exception('$operation 중 오류가 발생했습니다');
    }
  }
}
