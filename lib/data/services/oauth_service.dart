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
    serverClientId: '361112360154-j0mt17u4p3ti9end0en5oih5740e7n8d.apps.googleusercontent.com',
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
      _logger.i('🟡 Google 로그인 시작');

      // Sign out first to ensure account selection
      await _googleSignIn.signOut();

      // Trigger Google Sign In
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        _logger.w('⚠️ Google 로그인 취소됨');
        throw Exception('Google 로그인이 취소되었습니다');
      }

      _logger.i('✅ Google 계정 선택 완료: ${account.email}');

      // Get authentication
      final GoogleSignInAuthentication auth = await account.authentication;

      if (auth.accessToken == null) {
        _logger.e('❌ Google 액세스 토큰을 가져올 수 없음');
        throw Exception('Google 액세스 토큰을 가져올 수 없습니다');
      }

      _logger.i('✅ Google 토큰 획득 성공: ${auth.accessToken?.substring(0, 20)}...');
      _logger.i('🟡 백엔드로 로그인 요청 전송: /api/v1/auth/oauth2/authorization/google');

      // Send to backend
      final response = await _apiClient.post(
        '/api/v1/auth/oauth2/authorization/google',
        data: {
          'accessToken': auth.accessToken,
          'idToken': auth.idToken,
        },
      );

      _logger.i('✅ 백엔드 응답 받음: ${response.statusCode}');
      _logger.i('🟡 백엔드 응답 데이터: ${response.data}');

      // 통일된 ApiResponse 구조: {success: true, data: { accessToken, ... }, message: "...", timestamp: "..."}
      if (response.data['success'] == true) {
        final data = response.data['data'];
        _logger.i('✅ Google 로그인 성공! userId=${data['user']['userId']}');

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
        final message = error?['message'] ?? 'Google 로그인 실패';
        final userAction = error?['userAction'];
        _logger.e('❌ 백엔드 에러: $message');
        throw Exception(userAction != null ? '$message\n$userAction' : message);
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Google 로그인 실패', error: e, stackTrace: stackTrace);

      // API Exception 10 에러는 SHA-1 미등록 문제
      if (e.toString().contains('ApiException: 10')) {
        throw Exception(
          'Google 로그인 설정이 완료되지 않았습니다.\n'
          '개발자에게 문의하세요.\n\n'
          '(SHA-1 인증서를 Google Cloud Console에 등록해야 합니다)'
        );
      }

      rethrow;
    }
  }

  /// Kakao Sign In
  Future<Map<String, dynamic>> signInWithKakao() async {
    try {
      _logger.i('🟡 Kakao 로그인 시작');

      // Check if Kakao Talk is installed
      bool kakaoInstalled = await isKakaoTalkInstalled();
      _logger.i('🟡 Kakao Talk 설치 여부: $kakaoInstalled');

      OAuthToken token;
      if (kakaoInstalled) {
        _logger.i('🟡 Kakao Talk 앱으로 로그인 시도');
        // Login via Kakao Talk
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        _logger.i('🟡 Kakao 계정으로 웹 로그인 시도');
        // Login via Kakao Account (web)
        token = await UserApi.instance.loginWithKakaoAccount(
          prompts: [Prompt.login],
        );
      }

      _logger.i('✅ Kakao 토큰 획득 성공: ${token.accessToken.substring(0, 20)}...');

      // Get user info
      _logger.i('🟡 Kakao 사용자 정보 조회 중...');
      User kakaoUser = await UserApi.instance.me();
      _logger.i('✅ Kakao 사용자 정보: id=${kakaoUser.id}, email=${kakaoUser.kakaoAccount?.email}');

      // Send to backend
      _logger.i('🟡 백엔드로 로그인 요청 전송: /api/v1/auth/oauth2/authorization/kakao');
      final response = await _apiClient.post(
        '/api/v1/auth/oauth2/authorization/kakao',
        data: {
          'accessToken': token.accessToken,
          'kakaoId': kakaoUser.id.toString(),
          'email': kakaoUser.kakaoAccount?.email,
          'name': kakaoUser.kakaoAccount?.profile?.nickname,
        },
      );
      _logger.i('✅ 백엔드 응답 받음: ${response.statusCode}');

      // 백엔드 응답 구조: {s: true, d: { success: true, data: { accessToken, ... } }}
      _logger.i('🟡 백엔드 응답 데이터: ${response.data}');

      // 백엔드가 응답을 {s: true, d: {...}} 형태로 감싸서 보냄
      

      if (response.data['success'] == true) {
        final data = response.data['data'];
        _logger.i('✅ Kakao 로그인 성공! userId=${data['user']['userId']}');
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
        _logger.e('❌ 백엔드 에러: $message');
        throw Exception(userAction != null ? '$message\n$userAction' : message);
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Kakao 로그인 실패', error: e, stackTrace: stackTrace);
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
