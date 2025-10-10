import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
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
    try {
      // Sign out first to ensure account selection
      await _googleSignIn.signOut();

      // Trigger Google Sign In
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        throw Exception('Google Sign In cancelled');
      }

      // Get authentication
      final GoogleSignInAuthentication auth = await account.authentication;

      if (auth.accessToken == null) {
        throw Exception('Failed to get Google access token');
      }

      // Send to backend
      final response = await _apiClient.post(
        '/oauth2/authorization/google',
        data: {
          'accessToken': auth.accessToken,
          'idToken': auth.idToken,
        },
      );

      return {
        'accessToken': response.data['accessToken'],
        'refreshToken': response.data['refreshToken'],
        'user': response.data['user'],
      };
    } catch (e) {
      _logger.e('Google Sign In failed', error: e);
      rethrow;
    }
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
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // Get user info
      User kakaoUser = await UserApi.instance.me();

      // Send to backend
      final response = await _apiClient.post(
        '/oauth2/authorization/kakao',
        data: {
          'accessToken': token.accessToken,
          'kakaoId': kakaoUser.id.toString(),
          'email': kakaoUser.kakaoAccount?.email,
          'name': kakaoUser.kakaoAccount?.profile?.nickname,
        },
      );

      return {
        'accessToken': response.data['accessToken'],
        'refreshToken': response.data['refreshToken'],
        'user': response.data['user'],
      };
    } catch (e) {
      _logger.e('Kakao Sign In failed', error: e);
      rethrow;
    }
  }

  /// Naver Sign In (using web auth)
  Future<Map<String, dynamic>> signInWithNaver() async {
    try {
      // Get Naver OAuth URL from backend
      final urls = await getOAuth2LoginUrls();
      final naverUrl = urls['naver'];

      if (naverUrl == null) {
        throw Exception('Naver OAuth URL not available');
      }

      // Open web auth
      final result = await FlutterWebAuth2.authenticate(
        url: naverUrl,
        callbackUrlScheme: 'bifai',
      );

      // Extract token from callback URL
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];

      if (code == null) {
        throw Exception('Failed to get Naver authorization code');
      }

      // Exchange code for token via backend
      final response = await _apiClient.post(
        '/oauth2/callback/naver',
        data: {'code': code},
      );

      return {
        'accessToken': response.data['accessToken'],
        'refreshToken': response.data['refreshToken'],
        'user': response.data['user'],
      };
    } catch (e) {
      _logger.e('Naver Sign In failed', error: e);
      rethrow;
    }
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
