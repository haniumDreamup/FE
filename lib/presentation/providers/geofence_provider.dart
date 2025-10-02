import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';

/// 지오펜스 Provider
/// Mock 데이터를 사용하여 안전 구역 관리
class GeofenceProvider extends ChangeNotifier {
  // 지오펜스 목록
  List<Map<String, dynamic>> _geofences = [];
  Map<String, dynamic>? _selectedGeofence;

  // 상태 관리
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Map<String, dynamic>> get geofences => _geofences;
  Map<String, dynamic>? get selectedGeofence => _selectedGeofence;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 활성화된 지오펜스만
  List<Map<String, dynamic>> get activeGeofences =>
      _geofences.where((g) => g['isActive'] == true).toList();

  /// 지오펜스 목록 불러오기
  Future<void> loadGeofences() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터 - 실제 API 연동 시 GeofenceService 사용
      await Future.delayed(const Duration(seconds: 1));

      _geofences = [
        {
          'id': 1,
          'name': '우리 집',
          'latitude': 37.5665,
          'longitude': 126.9780,
          'radius': 200.0,
          'isActive': true,
          'notifyOnEntry': true,
          'notifyOnExit': true,
          'address': '서울시 중구 세종대로',
          'description': '집 주변 안전 구역',
          'createdAt': DateTime.now().subtract(const Duration(days: 30)),
        },
        {
          'id': 2,
          'name': '복지관',
          'latitude': 37.5700,
          'longitude': 126.9850,
          'radius': 150.0,
          'isActive': true,
          'notifyOnEntry': false,
          'notifyOnExit': true,
          'address': '서울시 중구 복지로 123',
          'description': '자주 가는 복지관',
          'createdAt': DateTime.now().subtract(const Duration(days: 20)),
        },
        {
          'id': 3,
          'name': '병원',
          'latitude': 37.5600,
          'longitude': 126.9700,
          'radius': 100.0,
          'isActive': true,
          'notifyOnEntry': true,
          'notifyOnExit': true,
          'address': '서울시 중구 병원로 456',
          'description': '정기 검진 병원',
          'createdAt': DateTime.now().subtract(const Duration(days: 15)),
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 지오펜스 추가
  Future<bool> addGeofence(Map<String, dynamic> geofenceData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터
      await Future.delayed(const Duration(milliseconds: 500));

      final newGeofence = {
        'id': _geofences.length + 1,
        ...geofenceData,
        'createdAt': DateTime.now(),
        'isActive': true,
      };

      _geofences.add(newGeofence);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 지오펜스 수정
  Future<bool> updateGeofence(int id, Map<String, dynamic> geofenceData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _geofences.indexWhere((g) => g['id'] == id);
      if (index != -1) {
        _geofences[index] = {
          ..._geofences[index],
          ...geofenceData,
          'updatedAt': DateTime.now(),
        };
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 지오펜스 삭제
  Future<bool> deleteGeofence(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터
      await Future.delayed(const Duration(milliseconds: 500));

      _geofences.removeWhere((g) => g['id'] == id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 지오펜스 활성화/비활성화
  Future<bool> toggleGeofence(int id, bool isActive) async {
    try {
      final index = _geofences.indexWhere((g) => g['id'] == id);
      if (index != -1) {
        _geofences[index]['isActive'] = isActive;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  /// 지오펜스 선택
  void selectGeofence(int id) {
    _selectedGeofence = _geofences.firstWhere(
      (g) => g['id'] == id,
      orElse: () => {},
    );
    notifyListeners();
  }

  /// 선택 해제
  void clearSelection() {
    _selectedGeofence = null;
    notifyListeners();
  }

  /// 에러 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 현재 위치가 지오펜스 내부인지 확인 (Mock)
  bool isInsideGeofence(int geofenceId, double latitude, double longitude) {
    final geofence = _geofences.firstWhere(
      (g) => g['id'] == geofenceId,
      orElse: () => {},
    );

    if (geofence.isEmpty) return false;

    // 간단한 거리 계산 (실제로는 Haversine 공식 사용)
    final dx = latitude - geofence['latitude'];
    final dy = longitude - geofence['longitude'];
    final distance = (dx * dx + dy * dy) * 111000; // 대략적인 미터 변환

    return distance <= geofence['radius'];
  }
}
