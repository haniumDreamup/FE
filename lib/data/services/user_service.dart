import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 사용자 관리 서비스
class UserService {
  final ApiClient _apiClient;

  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 현재 사용자 정보 조회
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.userMe);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '사용자 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 정보 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 현재 사용자 정보 수정
  Future<UserModel> updateCurrentUser(Map<String, dynamic> updateData) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.userMe,
        data: updateData,
      );

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '사용자 정보를 수정할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 정보 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 특정 사용자 정보 조회 (관리자 또는 보호자)
  Future<UserModel> getUserById(int userId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.userDetailPath(userId));

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '사용자 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 정보 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 전체 사용자 목록 조회 (관리자 전용)
  Future<List<UserModel>> getAllUsers({int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.users,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data['content'] != null) {
          final List<dynamic> content = data['content'];
          return content.map((json) => UserModel.fromJson(json)).toList();
        } else if (data is List) {
          return data.map((json) => UserModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? '사용자 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자 비활성화 (관리자 전용)
  Future<void> deactivateUser(int userId) async {
    try {
      final response = await _apiClient.dio.put(ApiEndpoints.deactivateUserPath(userId));

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '사용자를 비활성화할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 비활성화 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자 활성화 (관리자 전용)
  Future<void> activateUser(int userId) async {
    try {
      final response = await _apiClient.dio.put(ApiEndpoints.activateUserPath(userId));

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '사용자를 활성화할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 활성화 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자 역할 수정 (관리자 전용)
  Future<UserModel> updateUserRoles(int userId, List<int> roleIds) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateUserRolesPath(userId),
        data: {'roleIds': roleIds},
      );

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '사용자 역할을 수정할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 역할 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자 검색
  Future<List<UserModel>> searchUsers(String query, {int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.users,
        queryParameters: {
          'search': query,
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data['content'] != null) {
          final List<dynamic> content = data['content'];
          return content.map((json) => UserModel.fromJson(json)).toList();
        } else if (data is List) {
          return data.map((json) => UserModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? '사용자를 검색할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('사용자 검색 중 오류가 발생했습니다: $e');
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