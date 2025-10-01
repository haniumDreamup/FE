import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.dashboard);

      if (response.data != null) {
        return response.data;
      } else {
        throw Exception('대시보드 데이터를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['error'] != null) {
        throw Exception(e.response!.data['error']['message']);
      }
      throw Exception('네트워크 오류가 발생했어요');
    } catch (e) {
      throw Exception('대시보드 로딩 중 오류가 발생했어요');
    }
  }
}