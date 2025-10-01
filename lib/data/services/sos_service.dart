import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/emergency_model.dart';

/// SOS 서비스 (백엔드 EmergencyController와 동기화)
class SosService {
  final ApiClient _apiClient;

  SosService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// SOS 신호 발동 (POST /api/v1/emergency/sos/trigger)
  Future<Map<String, dynamic>> triggerSos({
    String? message,
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.triggerSos,
        data: {
          if (message != null) 'message': message,
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
          if (address != null) 'address': address,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'SOS 신호를 발동할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 신호 발동 중 오류가 발생했습니다: $e');
    }
  }

  /// SOS 신호 취소 (PUT /api/sos/{emergencyId}/cancel)
  Future<Map<String, dynamic>> cancelSos(int emergencyId, {String? reason}) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.cancelSosPath(emergencyId),
        data: {
          if (reason != null) 'reason': reason,
        },
      );

      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'SOS 신호를 취소할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 신호 취소 중 오류가 발생했습니다: $e');
    }
  }

  /// SOS 신호 이력 조회 (GET /api/sos/history)
  Future<List<Map<String, dynamic>>> getSosHistory({int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.sosHistory,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data['content'] != null) {
          final List<dynamic> content = data['content'];
          return content.map((json) => Map<String, dynamic>.from(json)).toList();
        } else if (data is List) {
          return data.map((json) => Map<String, dynamic>.from(json)).toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? 'SOS 이력을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('SOS 이력 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 빠른 SOS 신호 (POST /api/sos/quick)
  Future<Map<String, dynamic>> quickSos() async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.quickSos);

      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '빠른 SOS 신호를 발동할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('빠른 SOS 신호 발동 중 오류가 발생했습니다: $e');
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

/// Enhanced Emergency Contact 서비스 (백엔드 EmergencyContactController와 동기화)
class EnhancedEmergencyContactService {
  final ApiClient _apiClient;

  EnhancedEmergencyContactService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 긴급 연락처 생성 (POST /api/emergency-contacts)
  Future<EmergencyContactModel> createEmergencyContact(EmergencyContactModel contact) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.emergencyContacts,
        data: contact.toJson(),
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처를 생성할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 긴급 연락처 수정 (PUT /api/emergency-contacts/{id})
  Future<EmergencyContactModel> updateEmergencyContact(EmergencyContactModel contact) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.emergencyContactDetailPath(contact.id),
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

  /// 긴급 연락처 삭제 (DELETE /api/emergency-contacts/{id})
  Future<void> deleteEmergencyContact(int contactId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.emergencyContactDetailPath(contactId),
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

  /// 긴급 연락처 상세 조회 (GET /api/emergency-contacts/{id})
  Future<EmergencyContactModel> getEmergencyContactDetail(int contactId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.emergencyContactDetailPath(contactId),
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

  /// 전체 긴급 연락처 목록 조회 (GET /api/emergency-contacts)
  Future<List<EmergencyContactModel>> getAllEmergencyContacts() async {
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

  /// 활성 연락처 목록 조회 (GET /api/emergency-contacts/active)
  Future<List<EmergencyContactModel>> getActiveContacts() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.activeContacts);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '활성 연락처 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('활성 연락처 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 이용 가능한 연락처 목록 조회 (GET /api/emergency-contacts/available)
  Future<List<EmergencyContactModel>> getAvailableContacts() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.availableContacts);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '이용 가능한 연락처 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('이용 가능한 연락처 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 의료진 연락처 목록 조회 (GET /api/emergency-contacts/medical)
  Future<List<EmergencyContactModel>> getMedicalContacts() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.medicalContacts);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '의료진 연락처 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('의료진 연락처 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 연락처 검증 (POST /api/emergency-contacts/{id}/verify)
  Future<EmergencyContactModel> verifyContact(int contactId, String verificationCode) async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.verifyContactPath(contactId, verificationCode));

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처를 검증할 수 없습니다');
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
      final response = await _apiClient.dio.patch(ApiEndpoints.toggleContactActivePath(contactId));

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 상태를 변경할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 상태 변경 중 오류가 발생했습니다: $e');
    }
  }

  /// 연락처 우선순위 업데이트 (PUT /api/emergency-contacts/priorities)
  Future<List<EmergencyContactModel>> updateContactPriorities(
    List<Map<String, dynamic>> priorities,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateContactPriorities,
        data: {'priorities': priorities},
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => EmergencyContactModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '연락처 우선순위를 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 우선순위 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// 연락처 통화 기록 업데이트 (POST /api/emergency-contacts/{id}/contact-record)
  Future<EmergencyContactModel> updateContactRecord(
    int contactId,
    Map<String, dynamic> recordData,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.updateContactRecordPath(contactId),
        data: recordData,
      );

      if (response.data['success'] == true) {
        return EmergencyContactModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '연락처 기록을 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('연락처 기록 업데이트 중 오류가 발생했습니다: $e');
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