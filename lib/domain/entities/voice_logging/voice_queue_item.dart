// lib/domain/entities/voice_logging/voice_queue_item.dart
// Per VOICE_LOGGING_SPEC.md — in-memory model only, no database table.

import 'package:shadow_app/domain/enums/health_enums.dart';

enum VoiceQueueItemStatus { pending, answered, skipped }

/// A pending item the AI assistant should address during a voice session.
///
/// Built fresh at session open from the notification infrastructure.
/// Not persisted — in-memory only.
class VoiceQueueItem {
  final String id;
  final LoggableItemType itemType;
  final String? entityId;
  final String? entityName;
  final int triggeredAt;
  final bool isOverdue;
  VoiceQueueItemStatus status;

  VoiceQueueItem({
    required this.id,
    required this.itemType,
    this.entityId,
    this.entityName,
    required this.triggeredAt,
    required this.isOverdue,
    this.status = VoiceQueueItemStatus.pending,
  });
}
