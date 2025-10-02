import 'package:flutter/material.dart';
import '../../data/models/guardian_dashboard_model.dart';
import '../../data/services/guardian_dashboard_service.dart';

/// 보호자 대시보드 Provider
class GuardianDashboardProvider extends ChangeNotifier {
  final GuardianDashboardService _service;

  GuardianDashboardProvider({GuardianDashboardService? service})
      : _service = service ?? GuardianDashboardService();

  DailyStatusSummary? _dailySummary;
  WeeklySummary? _weeklySummary;
  IntegratedDashboard? _integratedDashboard;
  bool _isLoading = false;
  String? _error;

  DailyStatusSummary? get dailySummary => _dailySummary;
  WeeklySummary? get weeklySummary => _weeklySummary;
  IntegratedDashboard? get integratedDashboard => _integratedDashboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 오늘의 상태 요약 조회
  Future<void> loadDailySummary({
    required int userId,
    required int guardianId,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _dailySummary = await _service.getDailySummary(
        userId: userId,
        guardianId: guardianId,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 주간 요약 리포트 조회
  Future<void> loadWeeklySummary({
    required int userId,
    required int guardianId,
    int weekOffset = 0,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _weeklySummary = await _service.getWeeklySummary(
        userId: userId,
        guardianId: guardianId,
        weekOffset: weekOffset,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// 통합 대시보드 조회
  Future<void> loadIntegratedDashboard({
    required int userId,
    required int guardianId,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      _integratedDashboard = await _service.getIntegratedDashboard(
        userId: userId,
        guardianId: guardianId,
      );

      // 통합 대시보드에서 개별 요약도 업데이트
      _dailySummary = _integratedDashboard!.dailySummary;
      _weeklySummary = _integratedDashboard!.weeklySummary;

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
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

  /// 데이터 새로고침
  Future<void> refresh({
    required int userId,
    required int guardianId,
  }) async {
    await loadIntegratedDashboard(
      userId: userId,
      guardianId: guardianId,
    );
  }
}
