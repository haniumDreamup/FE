import '../models/guardian_relationship_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 보호자 관계 서비스
class GuardianRelationshipService {
  final ApiClient _apiClient;

  GuardianRelationshipService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 보호자 초대
  Future<GuardianInvitationResponse> inviteGuardian(
      GuardianInvitationRequest request) async {
    final response = await _apiClient.post(
      ApiEndpoints.inviteGuardian,
      data: request.toJson(),
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return GuardianInvitationResponse.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? '보호자 초대에 실패했습니다');
    }
  }

  /// 초대 수락
  Future<GuardianRelationshipDto> acceptInvitation(
      String token, int guardianId) async {
    final response = await _apiClient.post(
      ApiEndpoints.acceptInvitation,
      queryParameters: {
        'token': token,
        'guardianId': guardianId,
      },
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return GuardianRelationshipDto.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? '초대 수락에 실패했습니다');
    }
  }

  /// 초대 거부
  Future<void> rejectInvitation(String token, int guardianId) async {
    await _apiClient.post(
      ApiEndpoints.rejectInvitation,
      queryParameters: {
        'token': token,
        'guardianId': guardianId,
      },
    );
  }

  /// 권한 수정
  Future<GuardianRelationshipDto> updatePermissions(
      int relationshipId, PermissionUpdateRequest request) async {
    final response = await _apiClient.put(
      ApiEndpoints.updateRelationshipPermissionsPath(relationshipId),
      data: request.toJson(),
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return GuardianRelationshipDto.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? '권한 수정에 실패했습니다');
    }
  }

  /// 관계 일시 중지
  Future<void> suspendRelationship(int relationshipId) async {
    await _apiClient.post(
      ApiEndpoints.suspendRelationshipPath(relationshipId),
    );
  }

  /// 관계 재활성화
  Future<void> reactivateRelationship(int relationshipId) async {
    await _apiClient.post(
      ApiEndpoints.reactivateRelationshipPath(relationshipId),
    );
  }

  /// 관계 종료
  Future<void> terminateRelationship(int relationshipId,
      {String? reason}) async {
    await _apiClient.delete(
      ApiEndpoints.terminateRelationshipPath(relationshipId),
      queryParameters: reason != null ? {'reason': reason} : null,
    );
  }

  /// 사용자의 보호자 목록 조회
  Future<List<GuardianRelationshipDto>> getUserGuardians(int userId,
      {bool activeOnly = true}) async {
    final response = await _apiClient.get(
      ApiEndpoints.getUserGuardiansPath(userId),
      queryParameters: {'activeOnly': activeOnly},
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((json) => GuardianRelationshipDto.fromJson(json))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? '보호자 목록 조회에 실패했습니다');
    }
  }

  /// 보호자의 피보호자 목록 조회
  Future<List<GuardianRelationshipDto>> getGuardianUsers(
      int guardianId) async {
    final response = await _apiClient.get(
      ApiEndpoints.getGuardianUsersPath(guardianId),
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((json) => GuardianRelationshipDto.fromJson(json))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? '피보호자 목록 조회에 실패했습니다');
    }
  }

  /// 긴급 연락 보호자 목록 조회
  Future<List<EmergencyContactDto>> getEmergencyContacts(int userId) async {
    final response = await _apiClient.get(
      ApiEndpoints.getEmergencyContactsFromRelationshipPath(userId),
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return (response.data['data'] as List)
          .map((json) => EmergencyContactDto.fromJson(json))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? '긴급 연락처 조회에 실패했습니다');
    }
  }

  /// 권한 확인
  Future<bool> checkPermission(
      int guardianId, int userId, String permissionType) async {
    final response = await _apiClient.get(
      ApiEndpoints.checkPermission,
      queryParameters: {
        'guardianId': guardianId,
        'userId': userId,
        'permissionType': permissionType,
      },
    );
    // 통일된 ApiResponse 구조 사용
    
    if (response.data['success'] == true) {
      return response.data['data'] as bool;
    } else {
      throw Exception(response.data['message'] ?? '권한 확인에 실패했습니다');
    }
  }

  /// 활동 시간 업데이트
  Future<void> updateActivity(int guardianId, int userId) async {
    await _apiClient.post(
      ApiEndpoints.updateActivity,
      queryParameters: {
        'guardianId': guardianId,
        'userId': userId,
      },
    );
  }
}
