import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/emergency_model.dart';

/// 긴급 연락처 관리 서비스
/// EmergencyContactController와 동기화
class EmergencyContactService {
  final ApiClient _apiClient;

  EmergencyContactService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 긴급 연락처 추가 (POST /api/emergency-contacts)
  Future<EmergencyContactModel> createContact(
      EmergencyContactModel contact) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.emergencyContacts,
        data: contact.toJson(),
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 추가에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 추가 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 수정 (PUT /api/emergency-contacts/{id})
  Future<EmergencyContactModel> updateContact(
    int contactId,
    EmergencyContactModel contact,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.emergencyContactDetailPath(contactId),
        data: contact.toJson(),
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 수정에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 삭제 (DELETE /api/emergency-contacts/{id})
  Future<void> deleteContact(int contactId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.emergencyContactDetailPath(contactId),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '연락처 삭제에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 상세 조회 (GET /api/emergency-contacts/{id})
  Future<EmergencyContactModel> getContact(int contactId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.emergencyContactDetailPath(contactId),
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 조회에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자의 모든 긴급 연락처 조회 (GET /api/emergency-contacts)
  Future<List<EmergencyContactModel>> getAllContacts() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.emergencyContacts,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '연락처 목록 조회에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 활성화된 연락처만 조회 (GET /api/emergency-contacts/active)
  Future<List<EmergencyContactModel>> getActiveContacts() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.activeContacts,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '활성 연락처 조회에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('활성 연락처 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 현재 연락 가능한 연락처 조회 (GET /api/emergency-contacts/available)
  Future<List<Map<String, dynamic>>> getAvailableContacts() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.availableContacts,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return List<Map<String, dynamic>>.from(
            data.map((e) => Map<String, dynamic>.from(e)));
      } else {
        throw Exception(
            response.data['message'] ?? '연락 가능한 연락처 조회에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락 가능한 연락처 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 의료진 연락처 조회 (GET /api/emergency-contacts/medical)
  Future<List<EmergencyContactModel>> getMedicalContacts() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.medicalContacts,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '의료진 연락처 조회에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('의료진 연락처 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 연락처 검증 (POST /api/emergency-contacts/{id}/verify)
  Future<EmergencyContactModel> verifyContact(
    int contactId,
    String verificationCode,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.verifyContactPath(contactId, verificationCode),
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 검증에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 검증 중 오류가 발생했습니다: $e');
    }
  }

  /// 연락처 활성화/비활성화 토글 (PATCH /api/emergency-contacts/{id}/toggle-active)
  Future<EmergencyContactModel> toggleContactActive(int contactId) async {
    try {
      final response = await _apiClient.dio.patch(
        ApiEndpoints.toggleContactActivePath(contactId),
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 상태 변경에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 상태 변경 중 오류가 발생했습니다: $e');
    }
  }

  /// 우선순위 변경 (PUT /api/emergency-contacts/priorities)
  Future<void> updateContactPriorities(List<int> contactIds) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateContactPriorities,
        data: contactIds,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '우선순위 변경에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('우선순위 변경 중 오류가 발생했습니다: $e');
    }
  }

  /// 연락 기록 업데이트 (POST /api/emergency-contacts/{id}/contact-record)
  Future<void> updateContactRecord(
    int contactId, {
    required bool responded,
    int responseTimeMinutes = 0,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.updateContactRecordPath(contactId),
        queryParameters: {
          'responded': responded,
          'responseTimeMinutes': responseTimeMinutes,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '연락 기록 업데이트에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락 기록 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// DioException 처리
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('서버 연결 시간이 초과되었습니다');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('인증이 필요합니다. 다시 로그인해주세요');
        } else if (statusCode == 403) {
          return Exception('접근 권한이 없습니다');
        } else if (statusCode == 404) {
          return Exception('요청한 연락처를 찾을 수 없습니다');
        }
        return Exception(
            e.response?.data['message'] ?? '서버 오류가 발생했습니다 (${statusCode})');
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다');
      case DioExceptionType.connectionError:
        return Exception('인터넷 연결을 확인해주세요');
      default:
        return Exception('알 수 없는 오류가 발생했습니다: ${e.message}');
    }
  }
}
