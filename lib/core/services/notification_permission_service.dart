// lib/core/services/notification_permission_service.dart
// Per 57_NOTIFICATION_SYSTEM.md §11.3 — notification permission request service

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Requests OS-level notification permission from the user.
///
/// On Android 13+ (API 33+) this requests POST_NOTIFICATIONS at runtime.
/// On iOS and macOS this requests alert + badge + sound permissions.
/// On older Android, returns true immediately (permission is implicit).
class NotificationPermissionService {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationPermissionService(this._plugin);

  /// Requests notification permission and returns true if granted.
  ///
  /// Returns false if the user denies. Returns true on platforms where
  /// explicit permission is not required (pre-Android-13).
  Future<bool> requestPermission() async {
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final macos = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (macos != null) {
      final granted = await macos.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }
}
