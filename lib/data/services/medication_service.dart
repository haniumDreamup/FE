import 'package:dio/dio.dart';
import '../models/medication_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class MedicationService {
  final ApiClient _apiClient;

  MedicationService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 오늘의 약물 목록 조회
  Future<List<MedicationModel>> getTodayMedications() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.medicationsToday);
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => MedicationModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '약물 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('약물 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 특정 날짜의 약물 목록 조회
  Future<List<MedicationModel>> getMedicationsByDate(DateTime date) async {
    try {
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _apiClient.dio.get(
        ApiEndpoints.medications,
        queryParameters: {'date': dateString},
      );
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => MedicationModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '약물 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('약물 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 약물 상세 정보 조회
  Future<MedicationModel> getMedicationDetail(int medicationId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.medicationDetailPath(medicationId)
      );
      
      if (response.data['success'] == true) {
        return MedicationModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '약물 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('약물 상세 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 약물 복용 체크
  Future<MedicationModel> takeMedication(int medicationId, bool taken, {String? notes}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.takeMedicationPath(medicationId),
        data: {
          'taken': taken,
          'takenAt': taken ? DateTime.now().toIso8601String() : null,
          'notes': notes,
        },
      );
      
      if (response.data['success'] == true) {
        return MedicationModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '복용 체크를 할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('복용 체크 중 오류가 발생했습니다: $e');
    }
  }

  /// 약물 복용률 조회 (7일)
  Future<Map<String, dynamic>> getMedicationStats() async {
    try {
      final response = await _apiClient.dio.get('${ApiEndpoints.medications}/stats');
      
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