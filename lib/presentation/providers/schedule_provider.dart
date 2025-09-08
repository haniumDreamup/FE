import 'package:flutter/material.dart';
import '../../data/models/schedule_model.dart';
import '../../data/services/schedule_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleService _scheduleService;

  ScheduleProvider({ScheduleService? scheduleService})
      : _scheduleService = scheduleService ?? ScheduleService();

  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> _weekSchedules = [];
  bool _isLoading = false;
  String? _error;

  List<ScheduleModel> get schedules => _schedules;
  List<ScheduleModel> get weekSchedules => _weekSchedules;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalSchedules => _schedules.length;
  int get completedSchedules => _schedules.where((schedule) => schedule.isCompleted).length;
  int get overdueSchedules => _schedules.where((schedule) => schedule.isOverdue).length;
  double get completionRate => totalSchedules > 0 ? (completedSchedules / totalSchedules * 100) : 0;

  /// 오늘의 일정 목록 로드
  Future<void> loadTodaySchedules() async {
    _setLoading(true);
    _error = null;

    try {
      _schedules = await _scheduleService.getTodaySchedules();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 특정 날짜의 일정 목록 로드
  Future<void> loadSchedulesByDate(DateTime date) async {
    _setLoading(true);
    _error = null;

    try {
      _schedules = await _scheduleService.getSchedulesByDate(date);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 주간 일정 요약 로드
  Future<void> loadWeekSummary() async {
    _setLoading(true);
    _error = null;

    try {
      _weekSchedules = await _scheduleService.getWeekSummary();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 일정 완료 상태 토글
  Future<void> toggleSchedule(int scheduleId, bool completed) async {
    // 낙관적 업데이트
    final index = _schedules.indexWhere((schedule) => schedule.id == scheduleId);
    if (index == -1) return;

    final oldSchedule = _schedules[index];
    _schedules[index] = oldSchedule.copyWith(
      isCompleted: completed,
      completedAt: completed ? DateTime.now() : null,
    );
    notifyListeners();

    try {
      final updatedSchedule = await _scheduleService.completeSchedule(
        scheduleId,
        completed,
      );
      
      _schedules[index] = updatedSchedule;
      notifyListeners();
    } catch (e) {
      // 실패 시 롤백
      _schedules[index] = oldSchedule;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 일정 상세 정보 로드
  Future<ScheduleModel?> getScheduleDetail(int scheduleId) async {
    try {
      return await _scheduleService.getScheduleDetail(scheduleId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// 카테고리별 일정 로드
  Future<void> loadSchedulesByCategory(String category) async {
    _setLoading(true);
    _error = null;

    try {
      _schedules = await _scheduleService.getSchedulesByCategory(category);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 일정 통계 로드
  Future<Map<String, dynamic>?> loadScheduleStats() async {
    try {
      return await _scheduleService.getScheduleStats();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
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

  /// 특정 일정 찾기
  ScheduleModel? findSchedule(int id) {
    try {
      return _schedules.firstWhere((schedule) => schedule.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 카테고리별 일정 그룹화
  Map<String, List<ScheduleModel>> get schedulesByCategory {
    final Map<String, List<ScheduleModel>> grouped = {};
    
    for (final schedule in _schedules) {
      if (!grouped.containsKey(schedule.category)) {
        grouped[schedule.category] = [];
      }
      grouped[schedule.category]!.add(schedule);
    }
    
    return grouped;
  }

  /// 우선순위별 일정 그룹화
  Map<String, List<ScheduleModel>> get schedulesByPriority {
    final Map<String, List<ScheduleModel>> grouped = {
      'high': [],
      'medium': [],
      'low': [],
    };
    
    for (final schedule in _schedules) {
      final priority = schedule.priority.toLowerCase();
      if (grouped.containsKey(priority)) {
        grouped[priority]!.add(schedule);
      }
    }
    
    return grouped;
  }

  /// 시간대별 일정 그룹화
  Map<String, List<ScheduleModel>> get schedulesByTimeSlot {
    final Map<String, List<ScheduleModel>> grouped = {};
    
    for (final schedule in _schedules) {
      final hour = schedule.scheduledTime.hour;
      String timeSlot;
      
      if (hour >= 6 && hour < 12) {
        timeSlot = 'morning';
      } else if (hour >= 12 && hour < 18) {
        timeSlot = 'afternoon';
      } else if (hour >= 18 && hour < 22) {
        timeSlot = 'evening';
      } else {
        timeSlot = 'night';
      }
      
      if (!grouped.containsKey(timeSlot)) {
        grouped[timeSlot] = [];
      }
      grouped[timeSlot]!.add(schedule);
    }
    
    return grouped;
  }

  /// 완료되지 않은 일정만 필터링
  List<ScheduleModel> get pendingSchedules {
    return _schedules.where((schedule) => !schedule.isCompleted).toList();
  }

  /// 지연된 일정만 필터링
  List<ScheduleModel> get overdueSchedulesList {
    return _schedules.where((schedule) => schedule.isOverdue).toList();
  }

  /// 오늘 일정만 필터링
  List<ScheduleModel> get todaySchedules {
    return _schedules.where((schedule) => schedule.isToday).toList();
  }
}