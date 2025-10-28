import 'package:dio/dio.dart';
import '../models/guardian_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// Guardian 관리 서비스
class GuardianService {
  final ApiClient _apiClient;

  GuardianService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 내 Guardian 목록 조회 (사용자)
  Future<List<GuardianModel>> getMyGuardians() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.myGuardians);
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      // data가 비어있는 경우 빈 리스트 반환 (에러가 아님)
      final List<dynamic> data = response.data['data'] ?? [];
      if (data.isEmpty) {
        return [];
      }

      if (response.data['success'] == true) {
        return data.map((json) => GuardianModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '보호자 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 보호하는 사용자 목록 조회 (Guardian)
  Future<List<ProtectedUserModel>> getProtectedUsers() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.protectedUsers);
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      // data가 비어있는 경우 빈 리스트 반환 (에러가 아님)
      final List<dynamic> data = response.data['data'] ?? [];
      if (data.isEmpty) {
        return [];
      }

      if (response.data['success'] == true) {
        return data.map((json) => ProtectedUserModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '보호 사용자 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호 사용자 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian 요청 (사용자)
  Future<GuardianModel> requestGuardian(GuardianInviteRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.guardians,
        data: request.toJson(),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '보호자 요청을 보낼 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 요청 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian 요청 승인
  Future<GuardianModel> approveGuardianRequest(int guardianId, {String? message}) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.approveGuardianPath(guardianId),
        data: message != null ? {'message': message} : null,
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '보호자 요청을 승인할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 요청 승인 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian 요청 거절
  Future<void> rejectGuardianRequest(int guardianId, {String? reason}) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.rejectGuardianPath(guardianId),
        data: reason != null ? {'reason': reason} : null,
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '보호자 요청을 거절할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 요청 거절 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian 권한 업데이트
  Future<GuardianModel> updateGuardianPermissions(
    int guardianId,
    GuardianPermissionUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateGuardianPermissionsPath(guardianId),
        data: request.toJson(),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '보호자 권한을 수정할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 권한 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian 제거
  Future<void> removeGuardian(int guardianId) async {
    try {
      final response = await _apiClient.dio.delete(ApiEndpoints.removeGuardianPath(guardianId));
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '보호자를 제거할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 제거 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian 관계 제거 (Guardian 측에서)
  Future<void> removeGuardianRelationship(int guardianId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.removeGuardianRelationshipPath(guardianId),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '보호 관계를 제거할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호 관계 제거 중 오류가 발생했습니다: $e');
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

/// Guardian 관계 관리 서비스
class GuardianRelationshipService {
  final ApiClient _apiClient;

  GuardianRelationshipService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Guardian 초대
  Future<GuardianRelationshipModel> inviteGuardian(GuardianInviteRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.inviteGuardian,
        data: request.toJson(),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianRelationshipModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '보호자 초대를 보낼 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호자 초대 중 오류가 발생했습니다: $e');
    }
  }

  /// 받은 초대 목록 조회
  Future<List<GuardianRelationshipModel>> getMyInvitations() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.myInvitations);

      // 빈 목록도 정상 처리
      final List<dynamic> data = response.data['data'] ?? [];
      if (data.isEmpty) {
        return [];
      }

      if (response.data['success'] == true) {
        return data.map((json) => GuardianRelationshipModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '초대 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('초대 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  Future<GuardianRelationshipModel> acceptInvitation(String invitationToken) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.acceptInvitation,
        data: {'invitationToken': invitationToken},
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianRelationshipModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '초대를 수락할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('초대 수락 중 오류가 발생했습니다: $e');
    }
  }

  /// 초대 거절
  Future<void> rejectInvitation(String invitationToken, {String? reason}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.rejectInvitation,
        data: {
          'invitationToken': invitationToken,
          if (reason != null) 'reason': reason,
        },
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '초대를 거절할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('초대 거절 중 오류가 발생했습니다: $e');
    }
  }

  /// 관계 권한 업데이트
  Future<GuardianRelationshipModel> updateRelationshipPermissions(
    int relationshipId,
    GuardianPermissionUpdateRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateRelationshipPermissionsPath(relationshipId),
        data: request.toJson(),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianRelationshipModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '권한을 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('권한 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// 관계 일시정지
  Future<GuardianRelationshipModel> suspendRelationship(int relationshipId, {String? reason}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.suspendRelationshipPath(relationshipId),
        data: reason != null ? {'reason': reason} : null,
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianRelationshipModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '관계를 일시정지할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('관계 일시정지 중 오류가 발생했습니다: $e');
    }
  }

  /// 관계 재활성화
  Future<GuardianRelationshipModel> reactivateRelationship(int relationshipId) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.reactivateRelationshipPath(relationshipId),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianRelationshipModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '관계를 재활성화할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('관계 재활성화 중 오류가 발생했습니다: $e');
    }
  }

  /// 관계 종료
  Future<void> terminateRelationship(int relationshipId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiEndpoints.terminateRelationshipPath(relationshipId),
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '관계를 종료할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('관계 종료 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자의 Guardian 목록 조회
  Future<List<GuardianRelationshipModel>> getUserGuardians(int userId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getUserGuardiansPath(userId));
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => GuardianRelationshipModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '사용자 보호자 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 보호자 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// Guardian이 보호하는 사용자 목록 조회
  Future<List<GuardianRelationshipModel>> getGuardianUsers(int guardianId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.getGuardianUsersPath(guardianId));
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => GuardianRelationshipModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '보호 사용자 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('보호 사용자 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 권한 확인
  Future<bool> checkPermission(int userId, String permission) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.checkPermission,
        queryParameters: {
          'userId': userId,
          'permission': permission,
        },
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return response.data['data'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('권한 확인 중 오류가 발생했습니다: $e');
    }
  }

  /// 활동 업데이트
  Future<void> updateActivity(int userId, Map<String, dynamic> activityData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.updateActivity,
        data: {
          'userId': userId,
          ...activityData,
        },
      );
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '활동을 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('활동 업데이트 중 오류가 발생했습니다: $e');
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

/// Guardian 대시보드 서비스
class GuardianDashboardService {
  final ApiClient _apiClient;

  GuardianDashboardService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 일일 요약 조회
  Future<Map<String, dynamic>> getDailySummary(int userId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.dailySummaryPath(userId));
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '일일 요약을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('일일 요약 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 주간 요약 조회
  Future<Map<String, dynamic>> getWeeklySummary(int userId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.weeklySummaryPath(userId));
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '주간 요약을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('주간 요약 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 통합 대시보드 조회
  Future<GuardianDashboardModel> getIntegratedDashboard(int userId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.integratedDashboardPath(userId));
      // ApiResponse는 OptimizedApiResponse로 래핑되지 않음

      if (response.data['success'] == true) {
        return GuardianDashboardModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '대시보드를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('대시보드 조회 중 오류가 발생했습니다: $e');
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