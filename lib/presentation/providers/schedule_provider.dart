import 'package:flutter/material.dart';
import '../../data/models/schedule_model.dart';
import '../../data/services/schedule_service.dart';
import '../../core/utils/error_handler.dart';

/// 일정 관리 Provider
/// 일정 조회, 추가, 수정, 삭제 및 상태 관리
class ScheduleProvider extends ChangeNotifier {
  final ScheduleService _scheduleService;

  // 일정 데이터
  List<ScheduleResponse> _schedules = [];
  List<ScheduleResponse> _todaySchedules = [];
  List<ScheduleResponse> _upcomingSchedules = [];
  ScheduleResponse? _selectedSchedule;

  // 페이징 정보
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  bool _hasMore = true;

  // 상태 관리
  bool _isLoading = false;
  String? _errorMessage;

  ScheduleProvider({ScheduleService? scheduleService})
      : _scheduleService = scheduleService ?? ScheduleService();

  // Getters
  List<ScheduleResponse> get schedules => _schedules;
  List<ScheduleResponse> get todaySchedules => _todaySchedules;
  List<ScheduleResponse> get upcomingSchedules => _upcomingSchedules;
  ScheduleResponse? get selectedSchedule => _selectedSchedule;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  bool get hasMore => _hasMore;

  /// 오늘의 일정 조회
  Future<void> loadTodaySchedules() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _todaySchedules = await _scheduleService.getTodaySchedules();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getErrorMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 다가오는 일정 조회
  Future<void> loadUpcomingSchedules({int days = 7}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _upcomingSchedules = await _scheduleService.getUpcomingSchedules(days: days);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 전체 일정 목록 조회 (페이징)
  Future<void> loadSchedules({int page = 0, int size = 20, bool append = false}) async {
    if (!append) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final response = await _scheduleService.getSchedules(page: page, size: size);

      if (append) {
        _schedules.addAll(response.content);
      } else {
        _schedules = response.content;
      }

      _currentPage = response.pageable.pageNumber;
      _totalPages = response.totalPages;
      _totalElements = response.totalElements;
      _hasMore = !response.last;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 다음 페이지 로드
  Future<void> loadMoreSchedules() async {
    if (!_hasMore || _isLoading) return;
    await loadSchedules(page: _currentPage + 1, append: true);
  }

  /// 특정 날짜 일정 조회
  Future<void> loadSchedulesByDate(DateTime date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedules = await _scheduleService.getSchedulesByDate(date);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 기간별 일정 조회
  Future<void> loadSchedulesByRange(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _schedules = await _scheduleService.getSchedulesByRange(startDate, endDate);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 일정 상세 조회
  Future<void> loadSchedule(int scheduleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedSchedule = await _scheduleService.getSchedule(scheduleId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 일정 생성
  Future<bool> createSchedule(ScheduleRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newSchedule = await _scheduleService.createSchedule(request);

      // 로컬 목록에 추가
      _schedules.insert(0, newSchedule);

      // 오늘 일정이면 오늘 목록에도 추가
      if (_isTodaySchedule(newSchedule)) {
        _todaySchedules.insert(0, newSchedule);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 일정 수정
  Future<bool> updateSchedule(int scheduleId, ScheduleRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSchedule = await _scheduleService.updateSchedule(scheduleId, request);

      // 로컬 목록 업데이트
      final index = _schedules.indexWhere((s) => s.id == scheduleId);
      if (index != -1) {
        _schedules[index] = updatedSchedule;
      }

      final todayIndex = _todaySchedules.indexWhere((s) => s.id == scheduleId);
      if (todayIndex != -1) {
        if (_isTodaySchedule(updatedSchedule)) {
          _todaySchedules[todayIndex] = updatedSchedule;
        } else {
          _todaySchedules.removeAt(todayIndex);
        }
      }

      if (_selectedSchedule?.id == scheduleId) {
        _selectedSchedule = updatedSchedule;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 일정 삭제
  Future<bool> deleteSchedule(int scheduleId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _scheduleService.deleteSchedule(scheduleId);

      // 로컬 목록에서 제거
      _schedules.removeWhere((s) => s.id == scheduleId);
      _todaySchedules.removeWhere((s) => s.id == scheduleId);
      _upcomingSchedules.removeWhere((s) => s.id == scheduleId);

      if (_selectedSchedule?.id == scheduleId) {
        _selectedSchedule = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 일정 완료 처리
  Future<bool> completeSchedule(int scheduleId) async {
    try {
      final updatedSchedule = await _scheduleService.completeSchedule(scheduleId);
      _updateLocalSchedule(updatedSchedule);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 일정 완료 취소
  Future<bool> uncompleteSchedule(int scheduleId) async {
    try {
      final updatedSchedule = await _scheduleService.uncompleteSchedule(scheduleId);
      _updateLocalSchedule(updatedSchedule);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 일정 활성화
  Future<bool> activateSchedule(int scheduleId) async {
    try {
      final updatedSchedule = await _scheduleService.activateSchedule(scheduleId);
      _updateLocalSchedule(updatedSchedule);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 일정 비활성화
  Future<bool> deactivateSchedule(int scheduleId) async {
    try {
      final updatedSchedule = await _scheduleService.deactivateSchedule(scheduleId);
      _updateLocalSchedule(updatedSchedule);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 다음 실행 건너뛰기
  Future<bool> skipNextSchedule(int scheduleId) async {
    try {
      final updatedSchedule = await _scheduleService.skipNextSchedule(scheduleId);
      _updateLocalSchedule(updatedSchedule);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 반복 일정 목록 조회
  Future<List<String>> getScheduleOccurrences(int scheduleId, {int count = 10}) async {
    try {
      return await _scheduleService.getScheduleOccurrences(scheduleId, count: count);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return [];
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// 선택된 일정 초기화
  void clearSelectedSchedule() {
    _selectedSchedule = null;
    notifyListeners();
  }

  /// Helper: 로컬 일정 업데이트
  void _updateLocalSchedule(ScheduleResponse updatedSchedule) {
    final id = updatedSchedule.id;

    final index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
    }

    final todayIndex = _todaySchedules.indexWhere((s) => s.id == id);
    if (todayIndex != -1) {
      _todaySchedules[todayIndex] = updatedSchedule;
    }

    final upcomingIndex = _upcomingSchedules.indexWhere((s) => s.id == id);
    if (upcomingIndex != -1) {
      _upcomingSchedules[upcomingIndex] = updatedSchedule;
    }

    if (_selectedSchedule?.id == id) {
      _selectedSchedule = updatedSchedule;
    }
  }

  /// Helper: 오늘 일정인지 확인
  bool _isTodaySchedule(ScheduleResponse schedule) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (schedule.nextExecutionDateTime != null) {
      final nextExecution = schedule.nextExecutionDateTime!;
      final nextDate = DateTime(nextExecution.year, nextExecution.month, nextExecution.day);
      return nextDate.isAtSameMomentAs(today);
    }

    return false;
  }
}
