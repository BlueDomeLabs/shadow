// lib/core/services/device_info_service.dart - EXACT IMPLEMENTATION FROM 05_IMPLEMENTATION_ROADMAP.md Section 2.3

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Service for retrieving device information.
/// Used by BaseRepository for sync metadata and multi-device tracking.
class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;
  String? _deviceId;
  String? _deviceName;

  DeviceInfoService(this._deviceInfoPlugin);

  /// Get unique device identifier.
  /// - iOS: identifierForVendor
  /// - Android: androidId
  /// - macOS: systemGUID
  /// Caches value after first retrieval.
  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceId =
          iosInfo.identifierForVendor ?? 'ios-${iosInfo.model}-${iosInfo.name}';
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceId = androidInfo.id;
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceId = macInfo.systemGUID ?? 'macos-${macInfo.computerName}';
    }

    return _deviceId!;
  }

  /// Get human-readable device name.
  /// Caches value after first retrieval.
  Future<String> getDeviceName() async {
    if (_deviceName != null) return _deviceName!;

    if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      _deviceName = '${iosInfo.name} (${iosInfo.model})';
    } else if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      _deviceName = '${androidInfo.brand} ${androidInfo.model}';
    } else if (Platform.isMacOS) {
      final macInfo = await _deviceInfoPlugin.macOsInfo;
      _deviceName = macInfo.computerName;
    }

    return _deviceName!;
  }

  /// Get current platform name.
  String getPlatform() {
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    return 'Unknown';
  }
}
