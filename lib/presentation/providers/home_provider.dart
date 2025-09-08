import 'package:flutter/material.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/services/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService _homeService;

  HomeProvider({HomeService? homeService})
      : _homeService = homeService ?? HomeService();

  DashboardModel? _dashboard;
  String _greeting = '';
  bool _isLoading = false;
  String? _error;

  DashboardModel? get dashboard => _dashboard;
  String get greeting => _greeting;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 대시보드 데이터 로드
  Future<void> loadDashboard() async {
    _setLoading(true);
    _error = null;

    try {
      _dashboard = await _homeService.getDashboard();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 인사말 로드
  Future<void> loadGreeting() async {
    try {
      _greeting = await _homeService.getGreeting();
      notifyListeners();
    } catch (e) {
      _greeting = _getDefaultGreeting();
      notifyListeners();
    }
  }

  /// 대시보드 새로고침
  Future<void> refreshDashboard() async {
    await Future.wait([
      loadDashboard(),
      loadGreeting(),
    ]);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _getDefaultGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '좋은 아침이에요!';
    } else if (hour < 18) {
      return '좋은 오후에요!';
    } else {
      return '좋은 저녁이에요!';
    }
  }

  /// 요약 정보 getter들
  int get totalTasks => 
      (_dashboard?.summary.totalMedications ?? 0) + 
      (_dashboard?.summary.totalSchedules ?? 0);

  int get completedTasks => 
      (_dashboard?.summary.completedMedications ?? 0) + 
      (_dashboard?.summary.completedSchedules ?? 0);

  double get overallCompletionRate => 
      totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0;

  int get pendingMedications => 
      _dashboard?.summary.pendingMedications ?? 0;

  int get pendingSchedules => 
      _dashboard?.summary.pendingSchedules ?? 0;

  bool get allTasksCompleted => 
      totalTasks > 0 && completedTasks == totalTasks;

  /// 다음 할 일 찾기
  String? get nextTask {
    if (_dashboard == null) return null;

    // 오늘의 약물 중 복용하지 않은 것 찾기
    final pendingMed = _dashboard!.todayMedications
        .where((med) => !med.isTaken)
        .toList();
    
    if (pendingMed.isNotEmpty) {
      final med = pendingMed.first;
      return '${med.times.first} ${med.name} 복용';
    }

    // 오늘의 일정 중 완료하지 않은 것 찾기
    final pendingSchedule = _dashboard!.todaySchedules
        .where((schedule) => !schedule.isCompleted)
        .toList();
    
    if (pendingSchedule.isNotEmpty) {
      final schedule = pendingSchedule.first;
      return '${schedule.timeString} ${schedule.title}';
    }

    return null;
  }

  /// 건강 상태 요약
  String get healthSummary {
    if (_dashboard == null) return '정보 없음';
    
    final medicationRate = _dashboard!.summary.completionRate;
    
    if (medicationRate >= 90) {
      return '매우 좋음';
    } else if (medicationRate >= 70) {
      return '좋음';
    } else if (medicationRate >= 50) {
      return '보통';
    } else {
      return '주의 필요';
    }
  }

  /// 오늘의 기분 (임시)
  String get todayMood {
    final completionRate = overallCompletionRate;
    
    if (completionRate >= 90) {
      return '😊';
    } else if (completionRate >= 70) {
      return '🙂';
    } else if (completionRate >= 50) {
      return '😐';
    } else {
      return '😟';
    }
  }
}