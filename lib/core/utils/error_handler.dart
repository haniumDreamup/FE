import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  // 에러 메시지를 사용자 친화적으로 변환
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is String) {
      return error;
    } else {
      return '알 수 없는 오류가 발생했어요. 다시 시도해주세요.';
    }
  }

  // DioException 처리
  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return '연결 시간이 초과되었어요. 인터넷 연결을 확인해주세요.';
      
      case DioExceptionType.connectionError:
        return '인터넷에 연결할 수 없어요. 네트워크를 확인해주세요.';
      
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      
      case DioExceptionType.cancel:
        return '요청이 취소되었어요.';
      
      default:
        return '서버와 통신 중 문제가 발생했어요. 잠시 후 다시 시도해주세요.';
    }
  }

  // HTTP 상태 코드별 메시지
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청이에요. 입력 내용을 확인해주세요.';
      case 401:
        return '로그인이 필요해요. 다시 로그인해주세요.';
      case 403:
        return '접근 권한이 없어요.';
      case 404:
        return '요청한 정보를 찾을 수 없어요.';
      case 409:
        return '이미 존재하는 정보예요.';
      case 500:
      case 502:
      case 503:
        return '서버에 문제가 생겼어요. 잠시 후 다시 시도해주세요.';
      default:
        return '오류가 발생했어요. (오류 코드: $statusCode)';
    }
  }

  // 스낵바로 에러 표시
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: '확인',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // 다이얼로그로 에러 표시
  static void showErrorDialog(
    BuildContext context, 
    dynamic error, {
    String? title,
    VoidCallback? onRetry,
  }) {
    final message = getErrorMessage(error);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              title ?? '오류 발생',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text(
                '다시 시도',
                style: TextStyle(fontSize: 16),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 성공 메시지 스낵바
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // 정보 메시지 스낵바
  static void showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}