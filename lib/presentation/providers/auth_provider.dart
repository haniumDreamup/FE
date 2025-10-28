import 'package:flutter/material.dart';
import '../../core/services/token_refresh_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final TokenRefreshService _tokenService = TokenRefreshService();
  final NotificationService _notificationService = NotificationService();

  UserModel? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();
  
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  /// 회원가입
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.register(
        username: username,
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      _isAuthenticated = true;

      // 토큰 자동 갱신 시작
      await _tokenService.startTokenRefreshTimer();

      // FCM 토큰 백엔드 등록
      await _registerFcmToken();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.login(email, password);
      _isAuthenticated = true;

      // 토큰 자동 갱신 시작
      await _tokenService.startTokenRefreshTimer();

      // FCM 토큰 백엔드 등록
      await _registerFcmToken();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  /// Google 소셜 로그인
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginWithGoogle();
      _isAuthenticated = true;

      // 토큰 자동 갱신 시작
      await _tokenService.startTokenRefreshTimer();

      // FCM 토큰 백엔드 등록
      await _registerFcmToken();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  /// Kakao 소셜 로그인
  Future<bool> loginWithKakao() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginWithKakao();
      _isAuthenticated = true;

      // 토큰 자동 갱신 시작
      await _tokenService.startTokenRefreshTimer();

      // FCM 토큰 백엔드 등록
      await _registerFcmToken();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }

  /// Naver 소셜 로그인
  Future<bool> loginWithNaver() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginWithNaver();
      _isAuthenticated = true;

      // 토큰 자동 갱신 시작
      await _tokenService.startTokenRefreshTimer();

      // FCM 토큰 백엔드 등록
      await _registerFcmToken();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 토큰 자동 갱신 중지
      _tokenService.stopTokenRefreshTimer();

      // FCM 토큰 백엔드에서 제거
      await _notificationService.removeTokenFromBackend();

      await _authRepository.logout();

      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      // Handle error silently
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _currentUser = await _authRepository.checkAuthStatus();
      _isAuthenticated = _currentUser != null;
      
      // 인증된 경우 토큰 갱신 타이머 시작
      if (_isAuthenticated) {
        await _tokenService.startTokenRefreshTimer();
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    
    return _isAuthenticated;
  }
  
  // 토큰 유효성 확인
  Future<bool> validateToken() async {
    return await _tokenService.isTokenValid();
  }
  
  // 수동 토큰 갱신
  Future<bool> refreshToken() async {
    final success = await _tokenService.refreshTokenManually();
    if (!success) {
      // 토큰 갱신 실패 시 로그아웃 처리
      await logout();
    }
    return success;
  }
  
  /// FCM 토큰을 백엔드에 등록
  Future<void> _registerFcmToken() async {
    try {
      final fcmToken = _notificationService.fcmToken;
      if (fcmToken != null) {
        // NotificationService가 이미 초기화 시 백엔드에 전송하므로
        // 여기서는 별도 처리 불필요
        // 만약 토큰이 없다면 재시도
      }
    } catch (e) {
      // FCM 등록 실패해도 로그인은 성공으로 처리
    }
  }

  @override
  void dispose() {
    // Provider 해제 시 토큰 갱신 타이머 정리
    _tokenService.stopTokenRefreshTimer();
    super.dispose();
  }
}