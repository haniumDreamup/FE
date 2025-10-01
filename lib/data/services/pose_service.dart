import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/pose_model.dart';

/// Pose 데이터 처리 서비스
/// MediaPipe Pose 데이터 전송 및 낙상 감지 연동
class PoseService {
  final ApiClient _apiClient;

  PoseService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Pose 데이터 전송 (POST /api/v1/pose/data)
  Future<PoseResponseModel> sendPoseData(PoseDataModel poseData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.poseData,
        data: poseData.toJson(),
      );

      if (response.data['success'] == true) {
        return PoseResponseModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Pose 데이터 전송 실패');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Pose 데이터 전송 중 오류가 발생했습니다: $e');
    }
  }

  /// Pose 데이터 배치 전송 (POST /api/v1/pose/data/batch)
  Future<List<PoseResponseModel>> sendPoseDataBatch(
      List<PoseDataModel> poseDataList) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.poseBatch,
        data: poseDataList.map((e) => e.toJson()).toList(),
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => PoseResponseModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Pose 배치 데이터 전송 실패');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Pose 배치 데이터 전송 중 오류가 발생했습니다: $e');
    }
  }

  /// 낙상 상태 조회 (GET /api/v1/pose/fall-status/{userId})
  Future<FallStatusModel> getFallStatus(int userId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.fallStatusPath(userId),
      );

      if (response.data['success'] == true) {
        return FallStatusModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '낙상 상태 조회 실패');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('낙상 상태 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 낙상 이벤트 피드백 전송 (POST /api/v1/pose/fall-event/{eventId}/feedback)
  Future<void> sendFallFeedback(
    int eventId,
    FallFeedbackRequest feedback,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.fallFeedbackPath(eventId),
        data: feedback.toJson(),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '피드백 전송 실패');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('피드백 전송 중 오류가 발생했습니다: $e');
    }
  }

  /// 실시간 Pose 스트리밍 (여러 프레임 연속 전송)
  Stream<PoseResponseModel> streamPoseData(
      Stream<PoseDataModel> poseDataStream) async* {
    await for (final poseData in poseDataStream) {
      try {
        final response = await sendPoseData(poseData);
        yield response;
      } catch (e) {
        // 스트림 중단하지 않고 에러만 로깅
        print('Pose 스트리밍 중 오류: $e');
      }
    }
  }

  /// DioException 처리
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('서버 연결 시간이 초과되었습니다');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('인증이 필요합니다. 다시 로그인해주세요');
        } else if (statusCode == 403) {
          return Exception('접근 권한이 없습니다');
        } else if (statusCode == 404) {
          return Exception('요청한 정보를 찾을 수 없습니다');
        }
        return Exception(
            e.response?.data['message'] ?? '서버 오류가 발생했습니다 (${statusCode})');
      case DioExceptionType.cancel:
        return Exception('요청이 취소되었습니다');
      case DioExceptionType.connectionError:
        return Exception('인터넷 연결을 확인해주세요');
      default:
        return Exception('알 수 없는 오류가 발생했습니다: ${e.message}');
    }
  }
}
