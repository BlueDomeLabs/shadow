// lib/domain/entities/voice_logging/voice_session_turn.dart
// Per VOICE_LOGGING_SPEC.md Section 2.2

import 'package:shadow_app/domain/enums/health_enums.dart';

/// One conversational turn in a voice logging session.
///
/// Persisted in voice_session_history. Pruned after 90 days.
class VoiceSessionTurn {
  final String id;
  final String profileId;
  final String sessionId;
  final int turnIndex;
  final VoiceTurnRole role;
  final String content;
  final LoggableItemType? loggedItemType;
  final int createdAt;

  const VoiceSessionTurn({
    required this.id,
    required this.profileId,
    required this.sessionId,
    required this.turnIndex,
    required this.role,
    required this.content,
    this.loggedItemType,
    required this.createdAt,
  });
}
