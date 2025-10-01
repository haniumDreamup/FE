import 'package:dio/dio.dart';
import '../models/emergency_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class EmergencyService {
  final ApiClient _apiClient;

  EmergencyService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 긴급상황 신고
  Future<void> handleEmergencyAlert(EmergencyCallRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.emergencyAlert,
        data: request.toJson(),
      );
      
      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '긴급 신고를 처리할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급 신고 처리 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 목록 조회
  Future<List<EmergencyContactModel>> getEmergencyContacts() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.emergencyContacts);
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '연락처 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  // Safety check and location sharing functionality removed
  // Use emergencyAlert with appropriate data instead

  /// 긴급 연락처 추가
  Future<EmergencyContactModel> addEmergencyContact(EmergencyContactModel contact) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.emergencyContacts,
        data: contact.toJson(),
      );
      
      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처를 추가할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 추가 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 업데이트
  Future<EmergencyContactModel> updateEmergencyContact(EmergencyContactModel contact) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiEndpoints.emergencyContacts}/${contact.id}',
        data: contact.toJson(),
      );
      
      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처를 수정할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 삭제
  Future<void> deleteEmergencyContact(int contactId) async {
    try {
      final response = await _apiClient.dio.delete(
        '${ApiEndpoints.emergencyContacts}/$contactId',
      );
      
      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '연락처를 삭제할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 상세 정보
  Future<EmergencyContactModel> getEmergencyContactDetail(int contactId) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiEndpoints.emergencyContacts}/$contactId',
      );
      
      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 정보 조회 중 오류가 발생했습니다: $e');
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