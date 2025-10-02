import '../models/guardian_relationship_model.dart';
import '../../core/network/api_client.dart';

/// 보호자 관계 서비스
class GuardianRelationshipService {
  final ApiClient _apiClient;

  GuardianRelationshipService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 보호자 초대
  Future<GuardianInvitationResponse> inviteGuardian(
      GuardianInvitationRequest request) async {
    final response = await _apiClient.post(
      '/guardian-relationships/invite',
      data: request.toJson(),
    );
    return GuardianInvitationResponse.fromJson(response.data['data']);
  }

  /// 초대 수락
  Future<GuardianRelationshipDto> acceptInvitation(
      String token, int guardianId) async {
    final response = await _apiClient.post(
      '/guardian-relationships/accept-invitation',
      queryParameters: {
        'token': token,
        'guardianId': guardianId,
      },
    );
    return GuardianRelationshipDto.fromJson(response.data['data']);
  }

  /// 초대 거부
  Future<void> rejectInvitation(String token, int guardianId) async {
    await _apiClient.post(
      '/guardian-relationships/reject-invitation',
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
      '/guardian-relationships/$relationshipId/permissions',
      data: request.toJson(),
    );
    return GuardianRelationshipDto.fromJson(response.data['data']);
  }

  /// 관계 일시 중지
  Future<void> suspendRelationship(int relationshipId) async {
    await _apiClient.post(
      '/guardian-relationships/$relationshipId/suspend',
    );
  }

  /// 관계 재활성화
  Future<void> reactivateRelationship(int relationshipId) async {
    await _apiClient.post(
      '/guardian-relationships/$relationshipId/reactivate',
    );
  }

  /// 관계 종료
  Future<void> terminateRelationship(int relationshipId,
      {String? reason}) async {
    await _apiClient.delete(
      '/guardian-relationships/$relationshipId',
      queryParameters: reason != null ? {'reason': reason} : null,
    );
  }

  /// 사용자의 보호자 목록 조회
  Future<List<GuardianRelationshipDto>> getUserGuardians(int userId,
      {bool activeOnly = true}) async {
    final response = await _apiClient.get(
      '/guardian-relationships/user/$userId',
      queryParameters: {'activeOnly': activeOnly},
    );
    return (response.data['data'] as List)
        .map((json) => GuardianRelationshipDto.fromJson(json))
        .toList();
  }

  /// 보호자의 피보호자 목록 조회
  Future<List<GuardianRelationshipDto>> getGuardianUsers(
      int guardianId) async {
    final response = await _apiClient.get(
      '/guardian-relationships/guardian/$guardianId',
    );
    return (response.data['data'] as List)
        .map((json) => GuardianRelationshipDto.fromJson(json))
        .toList();
  }

  /// 긴급 연락 보호자 목록 조회
  Future<List<EmergencyContactDto>> getEmergencyContacts(int userId) async {
    final response = await _apiClient.get(
      '/guardian-relationships/user/$userId/emergency-contacts',
    );
    return (response.data['data'] as List)
        .map((json) => EmergencyContactDto.fromJson(json))
        .toList();
  }

  /// 권한 확인
  Future<bool> checkPermission(
      int guardianId, int userId, String permissionType) async {
    final response = await _apiClient.get(
      '/guardian-relationships/check-permission',
      queryParameters: {
        'guardianId': guardianId,
        'userId': userId,
        'permissionType': permissionType,
      },
    );
    return response.data['data'] as bool;
  }

  /// 활동 시간 업데이트
  Future<void> updateActivity(int guardianId, int userId) async {
    await _apiClient.post(
      '/guardian-relationships/update-activity',
      queryParameters: {
        'guardianId': guardianId,
        'userId': userId,
      },
    );
  }
}
