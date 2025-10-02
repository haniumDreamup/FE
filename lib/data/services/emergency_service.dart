import 'package:dio/dio.dart';
import '../models/emergency_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class EmergencyService {
  final ApiClient _apiClient;

  EmergencyService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 긴급상황 신고 (POST /api/v1/emergency/alert)
  Future<EmergencyResponse> handleEmergencyAlert(EmergencyCallRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.emergencyAlert,
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        return EmergencyResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '긴급 신고를 처리할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급 신고 처리 중 오류가 발생했습니다: $e');
    }
  }

  /// 낙상 감지 신고 (POST /api/v1/emergency/fall-detection)
  Future<EmergencyResponse> reportFallDetection(FallDetectionRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiEndpoints.apiVersion}/emergency/fall-detection',
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        return EmergencyResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '낙상 감지를 처리할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('낙상 감지 처리 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급상황 상태 조회 (GET /api/v1/emergency/status/{id})
  Future<EmergencyResponse> getEmergencyStatus(int emergencyId) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiEndpoints.apiVersion}/emergency/status/$emergencyId',
      );

      if (response.data['success'] == true) {
        return EmergencyResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '긴급상황 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급상황 상태 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 전체 긴급상황 목록 조회 (GET /api/v1/emergency)
  Future<List<EmergencyResponse>> getAllEmergencies() async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiEndpoints.apiVersion}/emergency',
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '긴급상황 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급상황 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자 긴급상황 이력 조회 (GET /api/v1/emergency/history/{userId})
  Future<List<EmergencyResponse>> getEmergencyHistory({int? userId}) async {
    try {
      final url = userId != null
          ? '${ApiEndpoints.apiVersion}/emergency/history/$userId'
          : '${ApiEndpoints.apiVersion}/emergency/history';

      final response = await _apiClient.dio.get(url);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '긴급상황 이력을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급상황 이력 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 활성 긴급상황 목록 (GET /api/v1/emergency/active)
  Future<List<EmergencyResponse>> getActiveEmergencies() async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiEndpoints.apiVersion}/emergency/active',
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyResponse.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '활성 긴급상황 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('활성 긴급상황 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급상황 해결 (PUT /api/v1/emergency/{id}/resolve)
  Future<EmergencyResponse> resolveEmergency(
    int emergencyId, {
    required String resolvedBy,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiEndpoints.apiVersion}/emergency/$emergencyId/resolve',
        queryParameters: {
          'resolvedBy': resolvedBy,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.data['success'] == true) {
        return EmergencyResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '긴급상황을 해결할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('긴급상황 해결 처리 중 오류가 발생했습니다: $e');
    }
  }

  /// SOS 긴급 발동 (POST /api/v1/emergency/sos/trigger)
  Future<SOSResponse> triggerSOS(SOSRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiEndpoints.apiVersion}/emergency/sos/trigger',
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        return SOSResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'SOS를 발동할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 발동 중 오류가 발생했습니다: $e');
    }
  }

  /// SOS 빠른 발동 (POST /api/v1/emergency/sos/quick)
  Future<SOSResponse> quickSOS({required double latitude, required double longitude}) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiEndpoints.apiVersion}/emergency/sos/quick',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.data['success'] == true) {
        return SOSResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'SOS를 발동할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 발동 중 오류가 발생했습니다: $e');
    }
  }

  /// SOS 취소 (PUT /api/v1/emergency/sos/{emergencyId}/cancel)
  Future<void> cancelSOS(int emergencyId, {String? reason}) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiEndpoints.apiVersion}/emergency/sos/$emergencyId/cancel',
        data: {
          if (reason != null) 'reason': reason,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'SOS를 취소할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 취소 중 오류가 발생했습니다: $e');
    }
  }

  /// SOS 이력 조회 (GET /api/v1/emergency/sos/history)
  Future<List<SOSHistory>> getSOSHistory() async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiEndpoints.apiVersion}/emergency/sos/history',
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => SOSHistory.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'SOS 이력을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 이력 조회 중 오류가 발생했습니다: $e');
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