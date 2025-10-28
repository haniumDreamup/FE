import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth for login and refresh endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh') ||
        options.path.contains('/oauth2/authorization')) {
      return handler.next(options);
    }

    // Get token from secure storage
    final token = await _storage.read(key: 'access_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print('[AuthInterceptor] ✅ Authorization 헤더 추가: Bearer ${token.substring(0, 20)}...');
    } else {
      print('[AuthInterceptor] ⚠️ 토큰 없음 - 인증 필요');
    }

    return handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshToken = await _storage.read(key: 'refresh_token');
      
      if (refreshToken != null) {
        try {
          // Create new dio instance for refresh request
          final dio = Dio(BaseOptions(
            baseUrl: err.requestOptions.baseUrl,
          ));
          
          final response = await dio.post(
            '/api/v1/auth/refresh',
            data: {'refreshToken': refreshToken},
          );
          
          if (response.statusCode == 200) {
            // Save new tokens
            // 통일된 ApiResponse 구조: {success: true, data: {accessToken: "...", refreshToken: "..."}}
            if (response.data['success'] == true) {
              final newAccessToken = response.data['data']['accessToken'];
              final newRefreshToken = response.data['data']['refreshToken'];

              await _storage.write(key: 'access_token', value: newAccessToken);
              await _storage.write(key: 'refresh_token', value: newRefreshToken);

              // Retry original request with new token
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              final cloneReq = await dio.request(
                err.requestOptions.path,
                options: Options(
                  method: err.requestOptions.method,
                  headers: err.requestOptions.headers,
                ),
                data: err.requestOptions.data,
                queryParameters: err.requestOptions.queryParameters,
              );

              return handler.resolve(cloneReq);
            }
          }
        } catch (e) {
          // Refresh failed, clear tokens and redirect to login
          await _storage.deleteAll();
          // 로그인 화면으로 리다이렉트는 AuthProvider에서 처리
        }
      }
    }
    
    return handler.next(err);
  }
}