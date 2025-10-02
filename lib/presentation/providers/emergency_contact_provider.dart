import 'package:flutter/material.dart';
import '../../data/models/emergency_model.dart';
import '../../data/services/emergency_contact_service.dart';

/// 긴급 연락처 관리 Provider
class EmergencyContactProvider extends ChangeNotifier {
  final EmergencyContactService _service;

  List<EmergencyContactModel> _contacts = [];
  bool _isLoading = false;
  String? _errorMessage;

  EmergencyContactProvider({EmergencyContactService? service})
      : _service = service ?? EmergencyContactService();

  // Getters
  List<EmergencyContactModel> get contacts => _contacts;
  List<EmergencyContactModel> get activeContacts =>
      _contacts.where((c) => c.isActive).toList();
  List<EmergencyContactModel> get medicalContacts =>
      _contacts.where((c) => c.isMedicalProfessional == true).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 전체 연락처 목록 조회
  Future<void> loadContacts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contacts = await _service.getAllContacts();
      // 우선순위로 정렬
      _contacts.sort((a, b) => a.priority.compareTo(b.priority));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 활성 연락처만 조회
  Future<void> loadActiveContacts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contacts = await _service.getActiveContacts();
      _contacts.sort((a, b) => a.priority.compareTo(b.priority));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 의료진 연락처만 조회
  Future<void> loadMedicalContacts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contacts = await _service.getMedicalContacts();
      _contacts.sort((a, b) => a.priority.compareTo(b.priority));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 연락처 활성화/비활성화
  Future<bool> toggleContactActive(int contactId) async {
    try {
      final updated = await _service.toggleContactActive(contactId);

      // 로컬 목록 업데이트
      final index = _contacts.indexWhere((c) => c.id == contactId);
      if (index != -1) {
        _contacts[index] = updated;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 연락처 삭제
  Future<bool> deleteContact(int contactId) async {
    try {
      await _service.deleteContact(contactId);

      // 로컬 목록에서 제거
      _contacts.removeWhere((c) => c.id == contactId);
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
