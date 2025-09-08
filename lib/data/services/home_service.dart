import 'package:dio/dio.dart';
import '../models/dashboard_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

class HomeService {
  final ApiClient _apiClient;

  HomeService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 홈 대시보드 정보 조회
  Future<DashboardModel> getDashboard() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.dashboard);
      
      if (response.data['success'] == true) {
        return DashboardModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '대시보드 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('대시보드 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 인사말 조회
  Future<String> getGreeting() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.greeting);
      
      if (response.data['success'] == true) {
        return response.data['data'] as String;
      } else {
        return '안녕하세요!';
      }
    } on DioException catch (e) {
      return _getDefaultGreeting();
    } catch (e) {
      return _getDefaultGreeting();
    }
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

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('네트워크 연결이 불안정합니다. 다시 시도해주세요.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다';
        if (statusCode == 401) {
          return Exception('로그인이 필요합니다');
        } else if (statusCode == 403) {
          return Exception('권한이 없습니다');
        } else if (statusCode == 404) {
          return Exception('요청한 정보를 찾을 수 없습니다');
        }
        return Exception(message);
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다');
      case DioExceptionType.unknown:
      default:
        if (e.error.toString().contains('SocketException')) {
          return Exception('인터넷 연결을 확인해주세요');
        }
        return Exception('알 수 없는 오류가 발생했습니다');
    }
  }
}