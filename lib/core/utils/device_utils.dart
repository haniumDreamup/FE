import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// 디바이스 정보 유틸리티
class DeviceUtils {
  static const String _deviceIdKey = 'device_id';
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// 고유한 디바이스 ID 가져오기 (UUID 기반)
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);

    if (deviceId == null) {
      // 새로운 UUID 생성
      deviceId = const Uuid().v4();
      await prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  /// 플랫폼 이름 가져오기
  static String getPlatform() {
    if (kIsWeb) return 'WEB';
    if (Platform.isAndroid) return 'ANDROID';
    if (Platform.isIOS) return 'IOS';
    return 'UNKNOWN';
  }

  /// 디바이스 모델 가져오기
  static Future<String> getDeviceModel() async {
    if (kIsWeb) return 'Web Browser';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
    } catch (e) {
      return 'Unknown';
    }

    return 'Unknown';
  }

  /// OS 버전 가져오기
  static Future<String> getOsVersion() async {
    if (kIsWeb) return 'Web';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS ${iosInfo.systemVersion}';
      }
    } catch (e) {
      return 'Unknown';
    }

    return 'Unknown';
  }
}
