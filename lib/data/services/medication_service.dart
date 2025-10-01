import 'package:dio/dio.dart';
import '../models/medication_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

// TODO: 백엔드에 Medication API 구현 필요
// 현재 백엔드에 MedicationController가 없어서 모든 메서드가 UnimplementedError를 던집니다.
// 백엔드 API 구현 후 주석을 해제하고 사용하세요.

class MedicationService {
  final ApiClient _apiClient;

  MedicationService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 오늘의 약물 목록 조회
  Future<List<MedicationModel>> getTodayMedications() async {
    // TODO: 백엔드 API 구현 대기중
    throw UnimplementedError('Medication API not implemented yet');
  }

  /// 특정 날짜의 약물 목록 조회
  Future<List<MedicationModel>> getMedicationsByDate(DateTime date) async {
    throw UnimplementedError('Medication API not implemented yet');
  }

  /// 약물 상세 정보 조회
  Future<MedicationModel> getMedicationDetail(int medicationId) async {
    throw UnimplementedError('Medication API not implemented yet');
  }

  /// 약물 복용 체크
  Future<MedicationModel> takeMedication(int medicationId, bool taken, {String? notes}) async {
    throw UnimplementedError('Medication API not implemented yet');
  }

  /// 약물 복용률 조회 (7일)
  Future<Map<String, dynamic>> getMedicationStats() async {
    throw UnimplementedError('Medication API not implemented yet');
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
