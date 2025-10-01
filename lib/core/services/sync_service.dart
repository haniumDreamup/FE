import 'dart:async';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/api_client.dart';
import '../constants/api_endpoints.dart';
import 'offline_service.dart';

/// 오프라인/온라인 데이터 동기화 서비스
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final OfflineService _offlineService = OfflineService();
  final ApiClient _apiClient = ApiClient();
  final Connectivity _connectivity = Connectivity();
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  
  // 동기화 상태 스트림
  final StreamController<SyncStatus> _syncStatusController = 
      StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;
  
  // 동기화 설정
  static const Duration _syncInterval = Duration(minutes: 5);
  static const int _maxRetryAttempts = 3;
  
  /// 동기화 서비스 초기화
  Future<void> initialize() async {
    // 연결 상태 모니터링
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // 온라인 상태가 되면 즉시 동기화
        performSync();
      }
    });
    
    // 주기적 동기화 시작
    _startPeriodicSync();
    
    // 초기 동기화
    performSync();
  }
  
  /// 주기적 동기화 시작
  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_syncInterval, (_) {
      performSync();
    });
  }
  
  /// 수동 동기화 실행
  Future<void> performSync() async {
    if (_isSyncing) return;
    
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _syncStatusController.add(SyncStatus.offline);
      return;
    }
    
    _isSyncing = true;
    _syncStatusController.add(SyncStatus.syncing);
    
    try {
      // 1. 서버에서 최신 데이터 가져오기
      await _downloadLatestData();
      
      // 2. 로컬 변경사항 업로드
      await _uploadPendingChanges();
      
      // 3. 충돌 해결
      await _resolveConflicts();
      
      _syncStatusController.add(SyncStatus.completed);
    } catch (e) {
      print('Sync failed: $e');
      _syncStatusController.add(SyncStatus.failed);
    } finally {
      _isSyncing = false;
    }
  }
  
  /// 서버에서 최신 데이터 다운로드
  Future<void> _downloadLatestData() async {
    try {
      // 사용자 정보 다운로드
      if (_offlineService.needsSync('user', maxAge: Duration(days: 1))) {
        await _downloadUserData();
      }

      // TODO: Schedule API 확인 후 추가
      // TODO: Medication API는 백엔드 미구현
    } catch (e) {
      throw Exception('Failed to download data: $e');
    }
  }
  

  /// 사용자 정보 다운로드
  Future<void> _downloadUserData() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userMe);

      if (response.statusCode == 200) {
        await _offlineService.saveUserData(response.data['data']);
      }
    } catch (e) {
      print('Failed to download user data: $e');
    }
  }
  
  /// 로컬 변경사항 업로드
  Future<void> _uploadPendingChanges() async {
    // TODO: Medication API 백엔드 미구현
    // TODO: Schedule API 확인 필요
  }
  
  /// 충돌 해결
  Future<void> _resolveConflicts() async {
    // 서버 타임스탬프와 로컬 타임스탬프 비교
    // 충돌이 있을 경우:
    // 1. 최신 변경사항 우선 (Last Write Wins)
    // 2. 또는 사용자에게 선택 요청
    
    // 현재는 간단한 구현 - 서버 데이터 우선
    // TODO: 더 정교한 충돌 해결 로직 구현
  }
  
  /// 강제 동기화 (모든 데이터 새로고침)
  Future<void> forceSync() async {
    // 캐시 시간 무시하고 모든 데이터 다운로드
    await _offlineService.clearCache();
    await performSync();
  }
  
  /// 동기화 서비스 종료
  void dispose() {
    _syncTimer?.cancel();
    _syncStatusController.close();
  }
}

/// 동기화 상태
enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
  offline,
}

/// 동기화 충돌 해결 전략
enum ConflictResolution {
  serverWins,  // 서버 데이터 우선
  clientWins,  // 클라이언트 데이터 우선
  merge,       // 병합
  askUser,     // 사용자에게 선택 요청
}