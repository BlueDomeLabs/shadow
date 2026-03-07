// lib/domain/repositories/voice_logging_repository.dart
// Per VOICE_LOGGING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_session_turn.dart';

/// Repository interface for voice logging persistence.
///
/// Both tables are local-only — no sync metadata, no SyncEntity requirements.
abstract class VoiceLoggingRepository {
  /// Fetch settings for a profile. Returns null if no row exists.
  Future<Result<VoiceLoggingSettings?, AppError>> getSettings(String profileId);

  /// Insert or update settings for a profile.
  Future<Result<void, AppError>> saveSettings(VoiceLoggingSettings settings);

  /// Fetch recent session turns for a profile within the last [daysBack] days.
  Future<Result<List<VoiceSessionTurn>, AppError>> getRecentTurns(
    String profileId, {
    int daysBack = 14,
  });

  /// Persist a single conversation turn.
  Future<Result<void, AppError>> saveTurn(VoiceSessionTurn turn);

  /// Delete turns older than 90 days for [profileId].
  ///
  /// Call at session open for retention enforcement.
  Future<Result<void, AppError>> pruneOldTurns(String profileId);
}
