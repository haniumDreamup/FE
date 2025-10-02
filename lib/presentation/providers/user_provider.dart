import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';

/// 사용자 프로필 관리 Provider
class UserProvider extends ChangeNotifier {
  final UserService _service;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProvider({UserService? service})
      : _service = service ?? UserService();

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  /// 현재 사용자 정보 조회
  Future<void> loadCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _service.getCurrentUser();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _currentUser = null;
      notifyListeners();
    }
  }

  /// 현재 사용자 정보 수정
  Future<bool> updateCurrentUser(UserUpdateRequest request) async {
    try {
      final updated = await _service.updateCurrentUser(request);
      _currentUser = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 사용자 정보 초기화 (로그아웃 시)
  void clearUser() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// 에러 메시지 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
