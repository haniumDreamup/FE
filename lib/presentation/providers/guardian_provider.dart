import 'package:flutter/material.dart';
import '../../data/models/guardian_model.dart';
import '../../data/services/guardian_service.dart';

/// 보호자 관리 Provider
class GuardianProvider extends ChangeNotifier {
  final GuardianService _service;

  List<GuardianModel> _guardians = [];
  List<ProtectedUserModel> _protectedUsers = [];
  bool _isLoading = false;
  String? _errorMessage;

  GuardianProvider({GuardianService? service})
      : _service = service ?? GuardianService();

  // Getters
  List<GuardianModel> get guardians => _guardians;
  List<GuardianModel> get activeGuardians =>
      _guardians.where((g) => g.isActive && g.approvalStatus == ApprovalStatus.approved).toList();
  List<GuardianModel> get pendingGuardians =>
      _guardians.where((g) => g.approvalStatus == ApprovalStatus.pending).toList();
  List<ProtectedUserModel> get protectedUsers => _protectedUsers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 내 보호자 목록 조회 (BIF 사용자)
  Future<void> loadMyGuardians() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _guardians = await _service.getMyGuardians();
      // 우선순위로 정렬
      _guardians.sort((a, b) {
        if (a.isPrimary && !b.isPrimary) return -1;
        if (!a.isPrimary && b.isPrimary) return 1;
        return a.emergencyPriority.compareTo(b.emergencyPriority);
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 내가 보호하는 사용자 목록 조회 (보호자)
  Future<void> loadProtectedUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _protectedUsers = await _service.getProtectedUsers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 보호자 등록 요청
  Future<bool> requestGuardian(GuardianInviteRequest request) async {
    try {
      final guardian = await _service.requestGuardian(request);
      _guardians.add(guardian);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 보호자 요청 승인 (보호자가 승인)
  Future<bool> approveGuardian(int guardianId, {String? message}) async {
    try {
      final updated = await _service.approveGuardianRequest(guardianId, message: message);

      final index = _guardians.indexWhere((g) => g.id == guardianId);
      if (index != -1) {
        _guardians[index] = updated;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 보호자 요청 거절
  Future<bool> rejectGuardian(int guardianId, {String? reason}) async {
    try {
      await _service.rejectGuardianRequest(guardianId, reason: reason);

      _guardians.removeWhere((g) => g.id == guardianId);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 보호자 권한 업데이트
  Future<bool> updatePermissions(
    int guardianId,
    GuardianPermissionUpdateRequest request,
  ) async {
    try {
      final updated = await _service.updateGuardianPermissions(guardianId, request);

      final index = _guardians.indexWhere((g) => g.id == guardianId);
      if (index != -1) {
        _guardians[index] = updated;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 보호자 제거 (사용자가 제거)
  Future<bool> removeGuardian(int guardianId) async {
    try {
      await _service.removeGuardian(guardianId);

      _guardians.removeWhere((g) => g.id == guardianId);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 보호 관계 제거 (보호자가 제거)
  Future<bool> removeRelationship(int guardianId) async {
    try {
      await _service.removeGuardianRelationship(guardianId);

      _guardians.removeWhere((g) => g.id == guardianId);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
