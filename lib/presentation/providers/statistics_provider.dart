import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';

/// 통계/활동 기록 Provider
/// Mock 데이터를 사용하여 활동 기록 표시
class StatisticsProvider extends ChangeNotifier {
  // 통계 데이터
  Map<String, dynamic> _dailyStats = {};
  Map<String, dynamic> _weeklyStats = {};
  Map<String, dynamic> _monthlyStats = {};

  // 상태 관리
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Map<String, dynamic> get dailyStats => _dailyStats;
  Map<String, dynamic> get weeklyStats => _weeklyStats;
  Map<String, dynamic> get monthlyStats => _monthlyStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 일일 통계 불러오기
  Future<void> loadDailyStats({DateTime? date}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터 - 실제 API 연동 시 StatisticsService 사용
      await Future.delayed(const Duration(seconds: 1));

      _dailyStats = {
        'date': date ?? DateTime.now(),
        'completedSchedules': 8,
        'totalSchedules': 10,
        'stepCount': 5432,
        'activeMinutes': 45,
        'emergencyCalls': 0,
        'safetyChecks': 3,
      };

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 주간 통계 불러오기
  Future<void> loadWeeklyStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터
      await Future.delayed(const Duration(seconds: 1));

      _weeklyStats = {
        'weekStart': DateTime.now().subtract(const Duration(days: 7)),
        'weekEnd': DateTime.now(),
        'totalSchedules': 70,
        'completedSchedules': 56,
        'completionRate': 80.0,
        'averageSteps': 4800,
        'totalActiveMinutes': 315,
        'dailyBreakdown': [
          {'day': '월', 'completed': 8, 'total': 10},
          {'day': '화', 'completed': 7, 'total': 10},
          {'day': '수', 'completed': 9, 'total': 10},
          {'day': '목', 'completed': 8, 'total': 10},
          {'day': '금', 'completed': 8, 'total': 10},
          {'day': '토', 'completed': 8, 'total': 10},
          {'day': '일', 'completed': 8, 'total': 10},
        ],
      };

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 월간 통계 불러오기
  Future<void> loadMonthlyStats({DateTime? month}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mock 데이터
      await Future.delayed(const Duration(seconds: 1));

      final now = month ?? DateTime.now();
      _monthlyStats = {
        'year': now.year,
        'month': now.month,
        'totalSchedules': 300,
        'completedSchedules': 240,
        'completionRate': 80.0,
        'bestWeek': 2,
        'perfectDays': 8,
        'emergencyCalls': 0,
        'safetyChecks': 90,
        'weeklyBreakdown': [
          {'week': 1, 'rate': 75.0},
          {'week': 2, 'rate': 85.0},
          {'week': 3, 'rate': 78.0},
          {'week': 4, 'rate': 82.0},
        ],
      };

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 안전 통계 불러오기
  Future<Map<String, dynamic>> loadSafetyStats() async {
    try {
      // Mock 데이터
      await Future.delayed(const Duration(milliseconds: 500));

      return {
        'totalEmergencyCalls': 2,
        'averageResponseTime': '3분 12초',
        'geofenceExits': 5,
        'safeReturnRate': 100.0,
        'lastEmergency': null,
      };
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      return {};
    }
  }

  /// 에러 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 통계 새로고침
  Future<void> refreshAllStats() async {
    await Future.wait([
      loadDailyStats(),
      loadWeeklyStats(),
      loadMonthlyStats(),
    ]);
  }
}
