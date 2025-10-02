import 'package:flutter/material.dart';
import '../../data/models/emergency_model.dart';
import '../../data/services/emergency_service.dart';

class EmergencyProvider extends ChangeNotifier {
  final EmergencyService _emergencyService;

  EmergencyProvider({EmergencyService? emergencyService})
      : _emergencyService = emergencyService ?? EmergencyService();

  List<EmergencyContactModel> _emergencyContacts = [];
  bool _isLoading = false;
  String? _error;

  List<EmergencyContactModel> get emergencyContacts => _emergencyContacts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 긴급 연락처 목록 로드
  Future<void> loadEmergencyContacts() async {
    _setLoading(true);
    _error = null;

    try {
      _emergencyContacts = await _emergencyService.getEmergencyContacts();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 긴급상황 신고 처리
  Future<void> handleEmergencyCall(EmergencyCallRequest request) async {
    _setLoading(true);
    _error = null;

    try {
      await _emergencyService.handleEmergencyAlert(request);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 안전 알림 전송
  Future<void> sendSafetyCheck() async {
    _setLoading(true);
    _error = null;

    try {
      final request = EmergencyCallRequest(type: 'SAFETY');
      await _emergencyService.handleEmergencyAlert(request);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 위치 공유
  Future<void> shareLocation(double latitude, double longitude) async {
    _setLoading(true);
    _error = null;

    try {
      final request = EmergencyCallRequest(
        type: 'LOCATION_SHARE',
        latitude: latitude,
        longitude: longitude,
      );
      await _emergencyService.handleEmergencyAlert(request);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 주 연락처 찾기
  EmergencyContactModel? get primaryContact {
    try {
      return _emergencyContacts.firstWhere((contact) => contact.isPrimary);
    } catch (e) {
      return null;
    }
  }

  /// 활성화된 연락처만 필터링
  List<EmergencyContactModel> get activeContacts {
    return _emergencyContacts.where((contact) => contact.isActive).toList();
  }

  /// 관계별 연락처 그룹화
  Map<String, List<EmergencyContactModel>> get contactsByRelationship {
    final Map<String, List<EmergencyContactModel>> grouped = {};
    
    for (final contact in _emergencyContacts) {
      if (!grouped.containsKey(contact.relationship)) {
        grouped[contact.relationship] = [];
      }
      grouped[contact.relationship]!.add(contact);
    }
    
    return grouped;
  }

  /// 연락처 추가
  Future<void> addEmergencyContact(EmergencyContactModel contact) async {
    try {
      // API 호출로 연락처 추가 (실제 구현)
      // final newContact = await _emergencyService.addEmergencyContact(contact);
      
      // 임시로 로컬에 추가
      _emergencyContacts.add(contact);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 연락처 업데이트
  Future<void> updateEmergencyContact(EmergencyContactModel contact) async {
    try {
      final index = _emergencyContacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _emergencyContacts[index] = contact;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 연락처 삭제
  Future<void> deleteEmergencyContact(int contactId) async {
    try {
      _emergencyContacts.removeWhere((contact) => contact.id == contactId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// SOS 이력 조회
  Future<List<SOSHistory>> getSOSHistory() async {
    try {
      return await _emergencyService.getSOSHistory();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// 활성 긴급상황 조회
  Future<List<EmergencyResponse>> getActiveEmergencies() async {
    try {
      return await _emergencyService.getActiveEmergencies();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// SOS 발동
  Future<SOSResponse> triggerSOS(SOSRequest request) async {
    try {
      return await _emergencyService.triggerSOS(request);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// 빠른 SOS 발동
  Future<SOSResponse> quickSOS() async {
    try {
      return await _emergencyService.quickSOS();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// SOS 취소
  Future<void> cancelSOS(int emergencyId, {String? reason}) async {
    try {
      await _emergencyService.cancelSOS(emergencyId, reason: reason);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// 낙상 감지 신고
  Future<EmergencyResponse> reportFallDetection(FallDetectionRequest request) async {
    try {
      return await _emergencyService.reportFallDetection(request);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}