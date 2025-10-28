import '../models/guardian_dashboard_model.dart';
import '../../core/network/api_client.dart';

/// 보호자 대시보드 서비스
class GuardianDashboardService {
  final ApiClient _apiClient;

  GuardianDashboardService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 오늘의 상태 요약 조회
  /// GET /api/guardian/dashboard/daily-summary/{userId}?guardianId={guardianId}
  Future<DailyStatusSummary> getDailySummary({
    required int userId,
    required int guardianId,
  }) async {
    final response = await _apiClient.get(
      '/guardian/dashboard/daily-summary/$userId',
      queryParameters: {
        'guardianId': guardianId,
      },
    );

    // GuardianDashboardController는 response.ApiResponse를 반환하므로 OptimizedApiResponse로 래핑됨
    
    if (response.data['success'] == true) {
      return DailyStatusSummary.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? '일일 요약을 불러올 수 없습니다');
    }
  }

  /// 주간 요약 리포트 조회
  /// GET /api/guardian/dashboard/weekly-summary/{userId}?guardianId={guardianId}&weekOffset={weekOffset}
  Future<WeeklySummary> getWeeklySummary({
    required int userId,
    required int guardianId,
    int weekOffset = 0,
  }) async {
    final response = await _apiClient.get(
      '/guardian/dashboard/weekly-summary/$userId',
      queryParameters: {
        'guardianId': guardianId,
        'weekOffset': weekOffset,
      },
    );

    // GuardianDashboardController는 response.ApiResponse를 반환하므로 OptimizedApiResponse로 래핑됨
    
    if (response.data['success'] == true) {
      return WeeklySummary.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? '주간 요약을 불러올 수 없습니다');
    }
  }

  /// 통합 대시보드 조회 (오늘 + 주간 요약)
  /// GET /api/guardian/dashboard/integrated/{userId}?guardianId={guardianId}
  Future<IntegratedDashboard> getIntegratedDashboard({
    required int userId,
    required int guardianId,
  }) async {
    final response = await _apiClient.get(
      '/guardian/dashboard/integrated/$userId',
      queryParameters: {
        'guardianId': guardianId,
      },
    );

    // GuardianDashboardController는 response.ApiResponse를 반환하므로 OptimizedApiResponse로 래핑됨
    
    if (response.data['success'] == true) {
      return IntegratedDashboard.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? '통합 대시보드를 불러올 수 없습니다');
    }
  }
}
