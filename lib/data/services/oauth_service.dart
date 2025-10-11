import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import 'package:logger/logger.dart';

class OAuthService {
  final ApiClient _apiClient;
  final Logger _logger = Logger();

  // Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  OAuthService(this._apiClient);

  /// Get OAuth2 login URLs from backend
  Future<Map<String, String>> getOAuth2LoginUrls() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.oauth2LoginUrls);
      return Map<String, String>.from(response.data);
    } catch (e) {
      _logger.e('Failed to get OAuth2 login URLs', error: e);
      rethrow;
    }
  }

  /// Google Sign In
  Future<Map<String, dynamic>> signInWithGoogle() async {
    // TODO: 백엔드에서 Google 모바일 로그인 구현 필요
    throw UnsupportedOperationException('Google 로그인은 현재 지원되지 않습니다');

    // try {
    //   // Sign out first to ensure account selection
    //   await _googleSignIn.signOut();

    //   // Trigger Google Sign In
    //   final GoogleSignInAccount? account = await _googleSignIn.signIn();

    //   if (account == null) {
    //     throw Exception('Google Sign In cancelled');
    //   }

    //   // Get authentication
    //   final GoogleSignInAuthentication auth = await account.authentication;

    //   if (auth.accessToken == null) {
    //     throw Exception('Failed to get Google access token');
    //   }

    //   // Send to backend
    //   final response = await _apiClient.post(
    //     '/api/v1/auth/oauth2/authorization/google',
    //     data: {
    //       'accessToken': auth.accessToken,
    //       'idToken': auth.idToken,
    //     },
    //   );

    //   // 백엔드 응답 구조 파싱
    //   if (response.data['success'] == true) {
    //     final data = response.data['data'];
    //     return {
    //       'accessToken': data['accessToken'],
    //       'refreshToken': data['refreshToken'],
    //       'user': data['user'],
    //     };
    //   } else {
    //     throw Exception(response.data['error']?['message'] ?? 'Google 로그인 실패');
    //   }
    // } catch (e) {
    //   _logger.e('Google Sign In failed', error: e);
    //   rethrow;
    // }
  }

  /// Kakao Sign In
  Future<Map<String, dynamic>> signInWithKakao() async {
    try {
      // Check if Kakao Talk is installed
      bool kakaoInstalled = await isKakaoTalkInstalled();

      OAuthToken token;
      if (kakaoInstalled) {
        // Login via Kakao Talk
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        // Login via Kakao Account (web)
        token = await UserApi.instance.loginWithKakaoAccount(
          prompts: [Prompt.login],
        );
      }

      // Get user info
      User kakaoUser = await UserApi.instance.me();

      // Send to backend
      final response = await _apiClient.post(
        '/api/v1/auth/oauth2/authorization/kakao',
        data: {
          'accessToken': token.accessToken,
          'kakaoId': kakaoUser.id.toString(),
          'email': kakaoUser.kakaoAccount?.email,
          'name': kakaoUser.kakaoAccount?.profile?.nickname,
        },
      );

      // 백엔드 응답 구조: { success: true, data: { accessToken, refreshToken, user, accessTokenExpiresIn, refreshTokenExpiresIn, ... } }
      if (response.data['success'] == true) {
        final data = response.data['data'];
        return {
          'accessToken': data['accessToken'],
          'refreshToken': data['refreshToken'],
          'user': data['user'],
          'accessTokenExpiresIn': data['accessTokenExpiresIn'],
          'refreshTokenExpiresIn': data['refreshTokenExpiresIn'],
        };
      } else {
        // 백엔드 에러 응답 파싱
        final error = response.data['error'];
        final message = error?['message'] ?? 'Kakao 로그인 실패';
        final userAction = error?['userAction'];
        throw Exception(userAction != null ? '$message\n$userAction' : message);
      }
    } catch (e) {
      _logger.e('Kakao Sign In failed', error: e);
      rethrow;
    }
  }

  /// Naver Sign In (not implemented - requires flutter_web_auth_2)
  Future<Map<String, dynamic>> signInWithNaver() async {
    throw UnimplementedError('Naver login not implemented yet');
  }

  /// Sign out from all providers
  Future<void> signOut() async {
    try {
      // Google Sign Out
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // Kakao Sign Out
      try {
        await UserApi.instance.logout();
      } catch (e) {
        _logger.w('Kakao logout failed (user might not be logged in)', error: e);
      }
    } catch (e) {
      _logger.e('Sign out failed', error: e);
      rethrow;
    }
  }
}
