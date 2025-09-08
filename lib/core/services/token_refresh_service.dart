import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../network/api_client.dart';
import '../constants/api_endpoints.dart';

class TokenRefreshService {
  static final TokenRefreshService _instance = TokenRefreshService._internal();
  factory TokenRefreshService() => _instance;
  TokenRefreshService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  // 토큰 갱신을 시작합니다
  Future<void> startTokenRefreshTimer() async {
    await _scheduleNextRefresh();
  }

  // 토큰 갱신 타이머를 중지합니다
  void stopTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  // 다음 갱신 시간을 계산하고 타이머를 설정합니다
  Future<void> _scheduleNextRefresh() async {
    final accessToken = await _storage.read(key: 'access_token');
    
    if (accessToken == null) {
      return;
    }

    try {
      // JWT 토큰 디코드
      final decodedToken = JwtDecoder.decode(accessToken);
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        decodedToken['exp'] * 1000,
      );
      
      // 만료 5분 전에 갱신 (안전 마진)
      final refreshTime = expiryDate.subtract(const Duration(minutes: 5));
      final now = DateTime.now();
      
      if (refreshTime.isAfter(now)) {
        final duration = refreshTime.difference(now);
        
        // 기존 타이머 취소
        _refreshTimer?.cancel();
        
        // 새 타이머 설정
        _refreshTimer = Timer(duration, () async {
          await _refreshToken();
        });
      } else {
        // 이미 갱신 시간이 지났으면 즉시 갱신
        await _refreshToken();
      }
    } catch (e) {
      print('Error scheduling token refresh: $e');
      // 토큰 파싱 실패 시 즉시 갱신 시도
      await _refreshToken();
    }
  }

  // 토큰을 갱신합니다
  Future<bool> _refreshToken() async {
    if (_isRefreshing) {
      return false;
    }

    _isRefreshing = true;
    
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      
      if (refreshToken == null) {
        _isRefreshing = false;
        return false;
      }

      final response = await ApiClient().post(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];
        
        // 새 토큰 저장
        await _storage.write(key: 'access_token', value: newAccessToken);
        await _storage.write(key: 'refresh_token', value: newRefreshToken);
        
        // API 클라이언트 토큰 업데이트
        ApiClient().updateAuthToken(newAccessToken);
        
        // 다음 갱신 스케줄링
        await _scheduleNextRefresh();
        
        _isRefreshing = false;
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    
    _isRefreshing = false;
    return false;
  }

  // 수동으로 토큰을 갱신합니다
  Future<bool> refreshTokenManually() async {
    return await _refreshToken();
  }

  // 토큰이 유효한지 확인합니다
  Future<bool> isTokenValid() async {
    final accessToken = await _storage.read(key: 'access_token');
    
    if (accessToken == null) {
      return false;
    }

    try {
      return !JwtDecoder.isExpired(accessToken);
    } catch (e) {
      return false;
    }
  }

  // 토큰 만료 시간을 가져옵니다
  Future<DateTime?> getTokenExpiryTime() async {
    final accessToken = await _storage.read(key: 'access_token');
    
    if (accessToken == null) {
      return null;
    }

    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      return DateTime.fromMillisecondsSinceEpoch(
        decodedToken['exp'] * 1000,
      );
    } catch (e) {
      return null;
    }
  }
}