import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 지오펜스 서비스 (백엔드 GeofenceController와 동기화)
class GeofenceService {
  final ApiClient _apiClient;

  GeofenceService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// 지오펜스 생성 (POST /api/geofences)
  Future<GeofenceModel> createGeofence(GeofenceCreateRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.geofences,
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        return GeofenceModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '지오펜스를 생성할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 지오펜스 수정 (PUT /api/geofences/{id})
  Future<GeofenceModel> updateGeofence(int geofenceId, GeofenceUpdateRequest request) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.geofenceDetailPath(geofenceId),
        data: request.toJson(),
      );

      if (response.data['success'] == true) {
        return GeofenceModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '지오펜스를 수정할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 수정 중 오류가 발생했습니다: $e');
    }
  }

  /// 지오펜스 삭제 (DELETE /api/geofences/{id})
  Future<void> deleteGeofence(int geofenceId) async {
    try {
      final response = await _apiClient.dio.delete(ApiEndpoints.geofenceDetailPath(geofenceId));

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? '지오펜스를 삭제할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// 지오펜스 상세 조회 (GET /api/geofences/{id})
  Future<GeofenceModel> getGeofenceDetail(int geofenceId) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.geofenceDetailPath(geofenceId));

      if (response.data['success'] == true) {
        return GeofenceModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 정보를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 정보 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 내 지오펜스 목록 조회 (GET /api/geofences)
  Future<List<GeofenceModel>> getMyGeofences() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.geofences);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => GeofenceModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 페이지별 지오펜스 목록 조회 (GET /api/geofences/paged)
  Future<List<GeofenceModel>> getGeofencesPaged({int page = 0, int size = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.geofencePaged,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map && data['content'] != null) {
          final List<dynamic> content = data['content'];
          return content.map((json) => GeofenceModel.fromJson(json)).toList();
        } else if (data is List) {
          return data.map((json) => GeofenceModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 타입별 지오펜스 조회 (GET /api/geofences/type/{type})
  Future<List<GeofenceModel>> getGeofencesByType(String type) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.geofenceByTypePath(type));

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => GeofenceModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '타입별 지오펜스 목록을 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('타입별 지오펜스 목록 조회 중 오류가 발생했습니다: $e');
    }
  }

  /// 지오펜스 활성화/비활성화 토글 (PATCH /api/geofences/{id}/toggle)
  Future<GeofenceModel> toggleGeofenceActive(int geofenceId) async {
    try {
      final response = await _apiClient.dio.patch(ApiEndpoints.toggleGeofencePath(geofenceId));

      if (response.data['success'] == true) {
        return GeofenceModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 상태를 변경할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 상태 변경 중 오류가 발생했습니다: $e');
    }
  }

  /// 지오펜스 우선순위 업데이트 (PUT /api/geofences/priorities)
  Future<List<GeofenceModel>> updateGeofencePriorities(
    List<Map<String, dynamic>> priorities,
  ) async {
    try {
      final response = await _apiClient.dio.put(
        ApiEndpoints.updateGeofencePriorities,
        data: {'priorities': priorities},
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => GeofenceModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 우선순위를 업데이트할 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 우선순위 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// 지오펜스 통계 조회 (GET /api/geofences/stats)
  Future<Map<String, dynamic>> getGeofenceStats() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.geofenceStats);

      if (response.data['success'] == true) {
        return response.data['data'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? '지오펜스 통계를 불러올 수 없습니다');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('지오펜스 통계 조회 중 오류가 발생했습니다: $e');
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

/// 지오펜스 모델
class GeofenceModel {
  final int id;
  final int userId;
  final String name;
  final String description;
  final String type; // HOME, WORK, MEDICAL, SAFE_ZONE, DANGER_ZONE
  final double centerLatitude;
  final double centerLongitude;
  final double radius;
  final bool isActive;
  final int priority;
  final String alertType; // ENTRY, EXIT, BOTH
  final bool notifyGuardians;
  final Map<String, dynamic>? settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GeofenceModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.type,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.radius,
    required this.isActive,
    required this.priority,
    required this.alertType,
    required this.notifyGuardians,
    this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    return GeofenceModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'SAFE_ZONE',
      centerLatitude: (json['centerLatitude'] ?? 0.0).toDouble(),
      centerLongitude: (json['centerLongitude'] ?? 0.0).toDouble(),
      radius: (json['radiusMeters'] ?? json['radius'] ?? 100.0).toDouble(),
      isActive: json['isActive'] ?? true,
      priority: json['priority'] ?? 1,
      alertType: json['alertType'] ?? 'BOTH',
      notifyGuardians: json['notifyGuardians'] ?? true,
      settings: json['settings'] != null ? Map<String, dynamic>.from(json['settings']) : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'type': type,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'radiusMeters': radius.round(),
      'isActive': isActive,
      'priority': priority,
      'alertType': alertType,
      'notifyGuardians': notifyGuardians,
      'settings': settings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get typeDisplay {
    switch (type.toUpperCase()) {
      case 'HOME':
        return '집';
      case 'WORK':
        return '직장';
      case 'MEDICAL':
        return '병원';
      case 'SAFE_ZONE':
        return '안전구역';
      case 'DANGER_ZONE':
        return '위험구역';
      default:
        return type;
    }
  }

  String get alertTypeDisplay {
    switch (alertType.toUpperCase()) {
      case 'ENTRY':
        return '진입시';
      case 'EXIT':
        return '나갈때';
      case 'BOTH':
        return '진입/나갈때';
      default:
        return alertType;
    }
  }
}

/// 지오펜스 생성 요청 모델
class GeofenceCreateRequest {
  final String name;
  final String description;
  final String type;
  final double centerLatitude;
  final double centerLongitude;
  final double radius;
  final String alertType;
  final bool notifyGuardians;
  final int? priority;
  final Map<String, dynamic>? settings;

  const GeofenceCreateRequest({
    required this.name,
    required this.description,
    required this.type,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.radius,
    required this.alertType,
    required this.notifyGuardians,
    this.priority,
    this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type,
      'centerLatitude': centerLatitude,
      'centerLongitude': centerLongitude,
      'radiusMeters': radius.round(),
      'alertType': alertType,
      'notifyGuardians': notifyGuardians,
      'priority': priority,
      'settings': settings,
    };
  }
}

/// 지오펜스 수정 요청 모델
class GeofenceUpdateRequest {
  final String? name;
  final String? description;
  final String? type;
  final double? centerLatitude;
  final double? centerLongitude;
  final double? radius;
  final String? alertType;
  final bool? notifyGuardians;
  final bool? isActive;
  final int? priority;
  final Map<String, dynamic>? settings;

  const GeofenceUpdateRequest({
    this.name,
    this.description,
    this.type,
    this.centerLatitude,
    this.centerLongitude,
    this.radius,
    this.alertType,
    this.notifyGuardians,
    this.isActive,
    this.priority,
    this.settings,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (type != null) data['type'] = type;
    if (centerLatitude != null) data['centerLatitude'] = centerLatitude;
    if (centerLongitude != null) data['centerLongitude'] = centerLongitude;
    if (radius != null) data['radiusMeters'] = radius!.round();
    if (alertType != null) data['alertType'] = alertType;
    if (notifyGuardians != null) data['notifyGuardians'] = notifyGuardians;
    if (isActive != null) data['isActive'] = isActive;
    if (priority != null) data['priority'] = priority;
    if (settings != null) data['settings'] = settings;
    return data;
  }
}