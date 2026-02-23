// lib/domain/entities/scheduled_notification.dart
// Per 57_NOTIFICATION_SYSTEM.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

part 'scheduled_notification.freezed.dart';

/// A computed notification ready to be handed to the platform scheduler.
///
/// Not persisted to the database — computed fresh from [AnchorEventTime]s
/// and [NotificationCategorySettings] each time scheduling occurs.
/// This is a pure value object passed across the domain/data boundary.
@freezed
class ScheduledNotification with _$ScheduledNotification {
  const ScheduledNotification._();

  const factory ScheduledNotification({
    /// Deterministic stable ID: `shadow_notif_{category.value}_{HHmm}`.
    ///
    /// Stability means rescheduling replaces existing notifications
    /// rather than adding duplicates.
    required String id,

    /// The category this notification belongs to.
    required NotificationCategory category,

    /// Time of day in 24-hour HH:mm format (e.g. "07:00", "22:00").
    required String timeOfDay,

    /// Short title shown in the notification header (category display name).
    required String title,

    /// Full notification body text from the spec.
    required String body,

    /// JSON payload passed to the app when the notification is tapped.
    ///
    /// Contains at minimum `{"category": N}`. Anchor-event notifications
    /// also include `{"anchorEvent": N}` for context.
    required String payload,

    /// How many minutes after firing before the notification expires.
    required int expiresAfterMinutes,
  }) = _ScheduledNotification;
}
