// lib/core/services/notification_tap_handler.dart
// Routes notification taps to the appropriate quick-entry sheet.

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

/// Parses notification tap responses and routes them to the app.
///
/// Inject this service into [FlutterLocalNotificationsPlugin.initialize]'s
/// [onDidReceiveNotificationResponse] callback. The app then sets [onTap]
/// to receive routed [NotificationCategory] events.
///
/// This decouples the platform layer (which calls [handleTap]) from the
/// presentation layer (which sets [onTap]), keeping both testable.
class NotificationTapHandler {
  /// The callback invoked when the user taps a notification.
  ///
  /// Set by [HomeScreen] on init to wire up quick-entry sheet routing.
  /// Set to null in [HomeScreen.dispose] to prevent leaks.
  void Function(NotificationCategory)? onTap;

  /// Parses [response.payload] and invokes [onTap] if set.
  ///
  /// Payload format: `{"category": N}` where N is [NotificationCategory.value].
  /// Silently ignores null, empty, or malformed payloads.
  void handleTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return;
      final value = decoded['category'] as int?;
      if (value == null) return;
      onTap?.call(NotificationCategory.fromValue(value));
    } on FormatException {
      // Malformed JSON payload — ignore silently
    }
  }
}
