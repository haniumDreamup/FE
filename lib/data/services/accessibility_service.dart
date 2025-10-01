import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 접근성 서비스 (백엔드 AccessibilityController와 동기화)
class AccessibilityService {
  final ApiClient _apiClient;

  AccessibilityService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 음성 안내 생성 (POST /api/v1/accessibility/voice-guidance)
  Future<String> generateVoiceGuidance(String text, {String? context}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.voiceGuidance,
        data: {
          'text': text,
          if (context != null) 'context': context,
        },
      );

      if (response.data['success'] == true) {
        return response.data['data']['guidance'] ?? text;
      } else {
        throw Exception(response.data['message'] ?? '음성 안내를 생성할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('음성 안내 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// ARIA 라벨 생성 (POST /api/v1/accessibility/aria-label)
  Future<String> generateAriaLabel(String elementType, Map<String, dynamic> properties) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.ariaLabel,
        data: {
          'elementType': elementType,
          'properties': properties,
        },
      );

      if (response.data['success'] == true) {
        return response.data['data']['ariaLabel'] ?? '';
      } else {
        throw Exception(response.data['message'] ?? 'ARIA 라벨을 생성할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('ARIA 라벨 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 스크린 리더 힌트 조회 (GET /api/v1/accessibility/screen-reader-hint)
  Future<String> getScreenReaderHint(String screenName, {String? action}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.screenReaderHint,
        queryParameters: {
          'screenName': screenName,
          if (action != null) 'action': action,
        },
      );

      if (response.data['success'] == true) {
        return response.data['data']['hint'] ?? '';
      } else {
        throw Exception(response.data['message'] ?? '스크린 리더 힌트를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('스크린 리더 힌트 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 접근성 설정 조회 (GET /api/v1/accessibility/settings)
  Future<AccessibilitySettingsModel> getAccessibilitySettings() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.accessibilitySettings);

      if (response.data['success'] == true) {
        return AccessibilitySettingsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '접근성 설정을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('접근성 설정 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 접근성 설정 업데이트 (PUT /api/v1/accessibility/settings)
  Future<AccessibilitySettingsModel> updateAccessibilitySettings(
    AccessibilitySettingsModel settings,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.accessibilitySettings,
        data: settings.toJson(),
      );

      if (response.data['success'] == true) {
        return AccessibilitySettingsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '접근성 설정을 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('접근성 설정 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// 접근성 프로필 적용 (POST /api/v1/accessibility/settings/apply-profile)
  Future<AccessibilitySettingsModel> applyAccessibilityProfile(String profileType) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.applyProfile,
        data: {'profileType': profileType},
      );

      if (response.data['success'] == true) {
        return AccessibilitySettingsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '접근성 프로필을 적용할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('접근성 프로필 적용 중 오류가 발생했습니다: $e');
    }
  }

  /// 색상 스킴 목록 조회 (GET /api/v1/accessibility/color-schemes)
  Future<List<ColorSchemeModel>> getColorSchemes() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.colorSchemes);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ColorSchemeModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '색상 스킴 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('색상 스킴 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 현재 색상 스킴 조회 (GET /api/v1/accessibility/color-schemes/current)
  Future<ColorSchemeModel> getCurrentColorScheme() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.currentColorScheme);

      if (response.data['success'] == true) {
        return ColorSchemeModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '현재 색상 스킴을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('현재 색상 스킴 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 간소화된 네비게이션 조회 (GET /api/v1/accessibility/simplified-navigation)
  Future<Map<String, dynamic>> getSimplifiedNavigation() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.simplifiedNavigation);

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '간소화된 네비게이션을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('간소화된 네비게이션 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 터치 타겟 정보 조회 (GET /api/v1/accessibility/touch-targets)
  Future<Map<String, dynamic>> getTouchTargets() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.touchTargets);

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '터치 타겟 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('터치 타겟 정보 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 텍스트 간소화 (POST /api/v1/accessibility/simplify-text)
  Future<String> simplifyText(String text, {String? targetLevel}) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.simplifyText,
        data: {
          'text': text,
          if (targetLevel != null) 'targetLevel': targetLevel,
        },
      );

      if (response.data['success'] == true) {
        return response.data['data']['simplifiedText'] ?? text;
      } else {
        throw Exception(response.data['message'] ?? '텍스트를 간소화할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('텍스트 간소화 중 오류가 발생했습니다: $e');
    }
  }

  /// 설정 동기화 (POST /api/v1/accessibility/settings/sync)
  Future<AccessibilitySettingsModel> syncSettings() async {
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.syncSettings);

      if (response.data['success'] == true) {
        return AccessibilitySettingsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '설정을 동기화할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('설정 동기화 중 오류가 발생했습니다: $e');
    }
  }

  /// 접근성 통계 조회 (GET /api/v1/accessibility/statistics)
  Future<Map<String, dynamic>> getAccessibilityStatistics() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.accessibilityStatistics);

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '접근성 통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('접근성 통계 조회 중 오류가 발생했습니다: $e');
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

/// 접근성 설정 모델
class AccessibilitySettingsModel {
  final bool ttsEnabled;
  final double ttsSpeed;
  final String ttsLanguage;
  final bool highContrastEnabled;
  final bool largeTextEnabled;
  final double textScale;
  final bool reduceMotionEnabled;
  final bool screenReaderEnabled;
  final String colorScheme;
  final bool simplifiedUIEnabled;
  final bool voiceNavigationEnabled;
  final Map<String, dynamic> customSettings;

  const AccessibilitySettingsModel({
    required this.ttsEnabled,
    required this.ttsSpeed,
    required this.ttsLanguage,
    required this.highContrastEnabled,
    required this.largeTextEnabled,
    required this.textScale,
    required this.reduceMotionEnabled,
    required this.screenReaderEnabled,
    required this.colorScheme,
    required this.simplifiedUIEnabled,
    required this.voiceNavigationEnabled,
    this.customSettings = const {},
  });

  factory AccessibilitySettingsModel.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettingsModel(
      ttsEnabled: json['ttsEnabled'] ?? false,
      ttsSpeed: (json['ttsSpeed'] ?? 1.0).toDouble(),
      ttsLanguage: json['ttsLanguage'] ?? 'ko-KR',
      highContrastEnabled: json['highContrastEnabled'] ?? false,
      largeTextEnabled: json['largeTextEnabled'] ?? false,
      textScale: (json['textScale'] ?? 1.0).toDouble(),
      reduceMotionEnabled: json['reduceMotionEnabled'] ?? false,
      screenReaderEnabled: json['screenReaderEnabled'] ?? false,
      colorScheme: json['colorScheme'] ?? 'default',
      simplifiedUIEnabled: json['simplifiedUIEnabled'] ?? false,
      voiceNavigationEnabled: json['voiceNavigationEnabled'] ?? false,
      customSettings: Map<String, dynamic>.from(json['customSettings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ttsEnabled': ttsEnabled,
      'ttsSpeed': ttsSpeed,
      'ttsLanguage': ttsLanguage,
      'highContrastEnabled': highContrastEnabled,
      'largeTextEnabled': largeTextEnabled,
      'textScale': textScale,
      'reduceMotionEnabled': reduceMotionEnabled,
      'screenReaderEnabled': screenReaderEnabled,
      'colorScheme': colorScheme,
      'simplifiedUIEnabled': simplifiedUIEnabled,
      'voiceNavigationEnabled': voiceNavigationEnabled,
      'customSettings': customSettings,
    };
  }

  AccessibilitySettingsModel copyWith({
    bool? ttsEnabled,
    double? ttsSpeed,
    String? ttsLanguage,
    bool? highContrastEnabled,
    bool? largeTextEnabled,
    double? textScale,
    bool? reduceMotionEnabled,
    bool? screenReaderEnabled,
    String? colorScheme,
    bool? simplifiedUIEnabled,
    bool? voiceNavigationEnabled,
    Map<String, dynamic>? customSettings,
  }) {
    return AccessibilitySettingsModel(
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      ttsLanguage: ttsLanguage ?? this.ttsLanguage,
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      largeTextEnabled: largeTextEnabled ?? this.largeTextEnabled,
      textScale: textScale ?? this.textScale,
      reduceMotionEnabled: reduceMotionEnabled ?? this.reduceMotionEnabled,
      screenReaderEnabled: screenReaderEnabled ?? this.screenReaderEnabled,
      colorScheme: colorScheme ?? this.colorScheme,
      simplifiedUIEnabled: simplifiedUIEnabled ?? this.simplifiedUIEnabled,
      voiceNavigationEnabled: voiceNavigationEnabled ?? this.voiceNavigationEnabled,
      customSettings: customSettings ?? this.customSettings,
    );
  }
}

/// 색상 스킴 모델
class ColorSchemeModel {
  final String id;
  final String name;
  final String description;
  final Map<String, String> colors;
  final bool isHighContrast;
  final bool isDarkMode;

  const ColorSchemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.colors,
    required this.isHighContrast,
    required this.isDarkMode,
  });

  factory ColorSchemeModel.fromJson(Map<String, dynamic> json) {
    return ColorSchemeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      colors: Map<String, String>.from(json['colors'] ?? {}),
      isHighContrast: json['isHighContrast'] ?? false,
      isDarkMode: json['isDarkMode'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colors': colors,
      'isHighContrast': isHighContrast,
      'isDarkMode': isDarkMode,
    };
  }
}