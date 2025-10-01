import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

class OfflineService {
  static OfflineService? _instance;
  final Connectivity _connectivity = Connectivity();

  late Box _userBox;
  late Box _scheduleBox;

  StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  factory OfflineService() {
    _instance ??= OfflineService._internal();
    return _instance!;
  }

  OfflineService._internal();

  Future<void> initialize() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Open boxes
    _userBox = await Hive.openBox('user');
    _scheduleBox = await Hive.openBox('schedules');

    // Monitor connectivity
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });

    // Check initial connectivity
    final initialResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(initialResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;

    _connectionStatusController.add(_isOnline);

    // If we just came online, trigger sync
    if (!wasOnline && _isOnline) {
      _syncPendingData();
    }
  }

  // User data methods
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _userBox.put('userData', userData);
    await _userBox.put('lastSync', DateTime.now().toIso8601String());
  }

  Map<String, dynamic>? getUserData() {
    return _userBox.get('userData') as Map<String, dynamic>?;
  }

  // Schedule methods
  Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    await _scheduleBox.put('schedules', schedules);
    await _scheduleBox.put('lastSync', DateTime.now().toIso8601String());
  }

  List<Map<String, dynamic>> getSchedules() {
    final schedules = _scheduleBox.get('schedules');
    if (schedules != null && schedules is List) {
      return schedules.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // Sync methods
  Future<void> _syncPendingData() async {
    if (!_isOnline) return;
    // TODO: Implement pending data sync when needed
  }

  // Cache management
  Future<void> clearCache() async {
    await _scheduleBox.clear();
    // Don't clear user data
  }

  Future<void> clearAllData() async {
    await _scheduleBox.clear();
    await _userBox.clear();
  }

  DateTime? getLastSyncTime(String boxName) {
    Box box;
    switch (boxName) {
      case 'schedules':
        box = _scheduleBox;
        break;
      case 'user':
        box = _userBox;
        break;
      default:
        return null;
    }

    final lastSync = box.get('lastSync');
    if (lastSync != null && lastSync is String) {
      return DateTime.tryParse(lastSync);
    }
    return null;
  }

  bool needsSync(String boxName, {Duration maxAge = const Duration(hours: 1)}) {
    final lastSync = getLastSyncTime(boxName);
    if (lastSync == null) return true;

    return DateTime.now().difference(lastSync) > maxAge;
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
