import 'package:flutter/material.dart';
import '../../core/services/token_refresh_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final TokenRefreshService _tokenService = TokenRefreshService();
  
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  AuthProvider({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();
  
  User? get currentUser => _currentUser;
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
  
  @override
  void dispose() {
    // Provider 해제 시 토큰 갱신 타이머 정리
    _tokenService.stopTokenRefreshTimer();
    super.dispose();
  }
}