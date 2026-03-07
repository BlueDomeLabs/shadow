// lib/data/datasources/local/daos/voice_session_history_dao.dart
// Per VOICE_LOGGING_SPEC.md Section 2.2

import 'package:drift/drift.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/voice_session_history_table.dart';

part 'voice_session_history_dao.g.dart';

/// Data Access Object for the voice_session_history table.
///
/// Returns raw table rows. Conversion to domain entities is handled in
/// VoiceLoggingRepositoryImpl.
@DriftAccessor(tables: [VoiceSessionHistoryTable])
class VoiceSessionHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$VoiceSessionHistoryDaoMixin {
  VoiceSessionHistoryDao(super.db);

  /// Fetch all turns for a profile created on or after [sinceEpochMs].
  ///
  /// Ordered by created_at ascending (chronological).
  Future<List<VoiceSessionHistoryRow>> getRecentTurns(
    String profileId,
    int sinceEpochMs,
  ) =>
      (select(voiceSessionHistoryTable)
            ..where(
              (t) =>
                  t.profileId.equals(profileId) &
                  t.createdAt.isBiggerOrEqualValue(sinceEpochMs),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  /// Insert a new conversation turn.
  Future<void> insertTurn(VoiceSessionHistoryTableCompanion data) =>
      into(voiceSessionHistoryTable).insert(data);

  /// Delete all turns for a profile created before [cutoffEpochMs].
  ///
  /// Called at session open for 90-day retention enforcement.
  Future<void> deleteOlderThan(String profileId, int cutoffEpochMs) =>
      (delete(voiceSessionHistoryTable)..where(
            (t) =>
                t.profileId.equals(profileId) &
                t.createdAt.isSmallerThanValue(cutoffEpochMs),
          ))
          .go();
}
