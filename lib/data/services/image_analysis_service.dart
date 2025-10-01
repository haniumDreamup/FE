import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/image_analysis_model.dart';

/// 이미지 분석 서비스
/// 웨어러블 카메라 이미지 AI 분석 (Google Vision API)
class ImageAnalysisService {
  final ApiClient _apiClient;

  ImageAnalysisService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// 이미지 업로드 및 분석 (POST /api/images/analyze)
  Future<ImageAnalysisResponse> analyzeImage({
    required File imageFile,
    ImageUploadRequest? request,
  }) async {
    try {
      // MultipartFile 생성
      final fileName = imageFile.path.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', _getImageExtension(fileName)),
      );

      // FormData 생성
      final formData = FormData.fromMap({
        'image': multipartFile,
        if (request != null) 'request': jsonEncode(request.toJson()),
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.analyzeImage,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.data['success'] == true) {
        return ImageAnalysisResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '이미지 분석에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('이미지 분석 중 오류가 발생했습니다: $e');
    }
  }

  /// 분석 결과 조회 (GET /api/images/analysis/{id})
  Future<ImageAnalysisResponse> getAnalysisResult(int analysisId) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.analysisResultPath(analysisId),
      );

      if (response.data['success'] == true) {
        return ImageAnalysisResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '분석 결과 조회에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('분석 결과 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 빠른 분석 (POST /api/images/quick-analyze)
  /// 위험 여부만 신속하게 판단
  Future<QuickAnalysisResponse> quickAnalyze(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', _getImageExtension(fileName)),
      );

      final formData = FormData.fromMap({
        'image': multipartFile,
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.quickAnalyze,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.data['success'] == true) {
        return QuickAnalysisResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '빠른 분석에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('빠른 분석 중 오류가 발생했습니다: $e');
    }
  }

  /// Google Vision 분석 (POST /api/images/vision-analyze)
  /// Google Vision API의 모든 기능 사용
  Future<Map<String, dynamic>> visionAnalyze({
    required File imageFile,
    List<String>? features,
  }) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', _getImageExtension(fileName)),
      );

      final formData = FormData.fromMap({
        'image': multipartFile,
        if (features != null) 'features': features.join(','),
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.visionAnalyze,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Vision 분석에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Vision 분석 중 오류가 발생했습니다: $e');
    }
  }

  /// 위험 감지 (POST /api/images/detect-danger)
  /// 낙상, 화재, 가스 누출 등 위험 상황 감지
  Future<QuickAnalysisResponse> detectDanger(File imageFile) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType('image', _getImageExtension(fileName)),
      );

      final formData = FormData.fromMap({
        'image': multipartFile,
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.detectDanger,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.data['success'] == true) {
        return QuickAnalysisResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '위험 감지에 실패했습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('위험 감지 중 오류가 발생했습니다: $e');
    }
  }

  /// 이미지 파일 확장자 추출
  String _getImageExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }

  /// DioException 처리
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('서버 연결 시간이 초과되었습니다. 이미지 크기를 줄여보세요');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('인증이 필요합니다. 다시 로그인해주세요');
        } else if (statusCode == 403) {
          return Exception('접근 권한이 없습니다');
        } else if (statusCode == 413) {
          return Exception('이미지 파일이 너무 큽니다 (최대 10MB)');
        } else if (statusCode == 415) {
          return Exception('지원하지 않는 이미지 형식입니다');
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
