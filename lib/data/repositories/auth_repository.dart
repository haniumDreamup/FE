import 'package:dio/dio.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../services/oauth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;
  final DeviceInfoPlugin _deviceInfo;
  late final OAuthService _oauthService;

  AuthRepository({
    ApiClient? apiClient,
    FlutterSecureStorage? storage,
    DeviceInfoPlugin? deviceInfo,
  }) : _apiClient = apiClient ?? ApiClient(),
       _storage = storage ?? const FlutterSecureStorage(),
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin() {
    _oauthService = OAuthService(_apiClient);
  }

  /// 회원가입 (POST /api/v1/auth/register)
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // Get device info
      String deviceId = await _getDeviceId();
      String deviceType = Platform.isIOS ? 'ios' : 'android';

      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
          'name': name,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'deviceId': deviceId,
          'deviceType': deviceType,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];

        // Save tokens (자동 로그인)
        await _storage.write(key: 'access_token', value: data['accessToken']);
        await _storage.write(key: 'refresh_token', value: data['refreshToken']);

        // Update API client token
        _apiClient.updateAuthToken(data['accessToken']);

        // Return user
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception(response.data['error']['message'] ?? '회원가입 실패');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['error'] != null) {
        throw Exception(e.response!.data['error']['message']);
      }
      throw Exception('네트워크 오류가 발생했어요');
    } catch (e) {
      throw Exception('회원가입 중 오류가 발생했어요');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      // Get device info
      String deviceId = await _getDeviceId();
      String deviceType = Platform.isIOS ? 'ios' : 'android';

      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'usernameOrEmail': email,
          'password': password,
          'deviceId': deviceId,
          'deviceType': deviceType,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];

        // Save tokens
        await _storage.write(key: 'access_token', value: data['accessToken']);
        await _storage.write(key: 'refresh_token', value: data['refreshToken']);

        // Update API client token
        _apiClient.updateAuthToken(data['accessToken']);

        // Return user
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception(response.data['error']['message'] ?? '로그인 실패');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['error'] != null) {
        throw Exception(e.response!.data['error']['message']);
      }
      throw Exception('네트워크 오류가 발생했어요');
    } catch (e) {
      throw Exception('로그인 중 오류가 발생했어요');
    }
  }
  
  Future<void> logout() async {
    try {
      String? deviceId = await _getDeviceId();

      await _apiClient.post(
        ApiEndpoints.logout,
        options: Options(
          headers: {
            'X-Device-Id': deviceId,
          },
        ),
      );
    } catch (e) {
      // Ignore logout errors
    } finally {
      // Sign out from OAuth providers
      await _oauthService.signOut();

      // Clear local storage
      await _storage.deleteAll();
      _apiClient.clearAuthToken();
    }
  }

  /// Google 소셜 로그인
  Future<UserModel> loginWithGoogle() async {
    try {
      final result = await _oauthService.signInWithGoogle();

      // Save tokens
      await _storage.write(key: 'access_token', value: result['accessToken']);
      await _storage.write(key: 'refresh_token', value: result['refreshToken']);

      // Update API client token
      _apiClient.updateAuthToken(result['accessToken']);

      // Return user
      return UserModel.fromJson(result['user']);
    } catch (e) {
      throw Exception('Google 로그인 실패: ${e.toString()}');
    }
  }

  /// Kakao 소셜 로그인
  Future<UserModel> loginWithKakao() async {
    try {
      final result = await _oauthService.signInWithKakao();

      // Save tokens
      await _storage.write(key: 'access_token', value: result['accessToken']);
      await _storage.write(key: 'refresh_token', value: result['refreshToken']);

      // Update API client token
      _apiClient.updateAuthToken(result['accessToken']);

      // Return user
      return UserModel.fromJson(result['user']);
    } catch (e) {
      throw Exception('Kakao 로그인 실패: ${e.toString()}');
    }
  }

  /// Naver 소셜 로그인
  Future<UserModel> loginWithNaver() async {
    try {
      final result = await _oauthService.signInWithNaver();

      // Save tokens
      await _storage.write(key: 'access_token', value: result['accessToken']);
      await _storage.write(key: 'refresh_token', value: result['refreshToken']);

      // Update API client token
      _apiClient.updateAuthToken(result['accessToken']);

      // Return user
      return UserModel.fromJson(result['user']);
    } catch (e) {
      throw Exception('Naver 로그인 실패: ${e.toString()}');
    }
  }
  
  Future<UserModel?> checkAuthStatus() async {
    try {
      final token = await _storage.read(key: 'access_token');
      
      if (token == null) {
        return null;
      }
      
      // Update API client token
      _apiClient.updateAuthToken(token);

      // Get user info (from /api/v1/users/me)
      final response = await _apiClient.get(ApiEndpoints.userMe);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      }

      return null;
    } catch (e) {
      // Try to refresh token
      return await _refreshToken();
    }
  }
  
  Future<UserModel?> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      final deviceId = await _getDeviceId();
      
      if (refreshToken == null) {
        return null;
      }
      
      final response = await _apiClient.post(
        ApiEndpoints.refresh,
        data: {
          'refreshToken': refreshToken,
          'deviceId': deviceId,
        },
      );
      
      if (response.data['success'] == true) {
        final data = response.data['data'];
        
        // Save new tokens
        await _storage.write(key: 'access_token', value: data['accessToken']);
        await _storage.write(key: 'refresh_token', value: data['refreshToken']);
        
        // Update API client token
        _apiClient.updateAuthToken(data['accessToken']);
        
        return UserModel.fromJson(data['user']);
      }
      
      return null;
    } catch (e) {
      await _storage.deleteAll();
      return null;
    }
  }
  
  Future<String> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (e) {
      // Fallback
    }
    return 'unknown_device';
  }
}