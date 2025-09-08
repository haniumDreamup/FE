import 'package:flutter/material.dart';
import '../../data/models/medication_model.dart';
import '../../data/services/medication_service.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _medicationService;

  MedicationProvider({MedicationService? medicationService})
      : _medicationService = medicationService ?? MedicationService();

  List<MedicationModel> _medications = [];
  bool _isLoading = false;
  String? _error;

  List<MedicationModel> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalMedications => _medications.length;
  int get completedMedications => _medications.where((med) => med.isTaken).length;
  double get completionRate => totalMedications > 0 ? (completedMedications / totalMedications * 100) : 0;

  /// 오늘의 약물 목록 로드
  Future<void> loadTodayMedications() async {
    _setLoading(true);
    _error = null;

    try {
      _medications = await _medicationService.getTodayMedications();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 특정 날짜의 약물 목록 로드
  Future<void> loadMedicationsByDate(DateTime date) async {
    _setLoading(true);
    _error = null;

    try {
      _medications = await _medicationService.getMedicationsByDate(date);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// 약물 복용 상태 토글
  Future<void> toggleMedication(int medicationId, bool taken) async {
    // 낙관적 업데이트
    final index = _medications.indexWhere((med) => med.id == medicationId);
    if (index == -1) return;

    final oldMedication = _medications[index];
    _medications[index] = oldMedication.copyWith(
      isTaken: taken,
      takenAt: taken ? DateTime.now() : null,
    );
    notifyListeners();

    try {
      final updatedMedication = await _medicationService.takeMedication(
        medicationId,
        taken,
      );
      
      _medications[index] = updatedMedication;
      notifyListeners();
    } catch (e) {
      // 실패 시 롤백
      _medications[index] = oldMedication;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// 약물 상세 정보 로드
  Future<MedicationModel?> getMedicationDetail(int medicationId) async {
    try {
      return await _medicationService.getMedicationDetail(medicationId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// 약물 통계 로드
  Future<Map<String, dynamic>?> loadMedicationStats() async {
    try {
      return await _medicationService.getMedicationStats();
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

  /// 특정 약물 찾기
  MedicationModel? findMedication(int id) {
    try {
      return _medications.firstWhere((med) => med.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 복용 시간별 약물 그룹화
  Map<String, List<MedicationModel>> get medicationsByTime {
    final Map<String, List<MedicationModel>> grouped = {};
    
    for (final medication in _medications) {
      for (final time in medication.times) {
        if (!grouped.containsKey(time)) {
          grouped[time] = [];
        }
        grouped[time]!.add(medication);
      }
    }
    
    return grouped;
  }

  /// 중요한 약물만 필터링
  List<MedicationModel> get importantMedications {
    return _medications.where((med) => med.isImportant).toList();
  }

  /// 복용하지 않은 약물만 필터링
  List<MedicationModel> get pendingMedications {
    return _medications.where((med) => !med.isTaken).toList();
  }
}