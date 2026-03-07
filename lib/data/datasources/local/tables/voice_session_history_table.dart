// lib/data/datasources/local/tables/voice_session_history_table.dart
// Drift table for voice_session_history per VOICE_LOGGING_SPEC.md Section 2.2

import 'package:drift/drift.dart';

/// Drift table for voice session turn history.
///
/// One row per conversation turn. Supports rolling 90-day retention window.
/// Local only — not synced.
///
/// Index on (profile_id, created_at DESC) is declared here for fresh installs
/// via createAll(). The migration also creates it via customStatement to ensure
/// DESC ordering on upgrade paths.
@TableIndex(
  name: 'idx_voice_session_history_profile_created',
  columns: {#profileId, #createdAt},
)
@DataClassName('VoiceSessionHistoryRow')
class VoiceSessionHistoryTable extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().named('profile_id').withLength(min: 1, max: 36)();
  TextColumn get sessionId =>
      text().named('session_id').withLength(min: 1, max: 36)();
  IntColumn get turnIndex => integer().named('turn_index')();

  // VoiceTurnRole enum: 0 = assistant, 1 = user
  IntColumn get role => integer()();

  TextColumn get content => text()();

  // LoggableItemType enum — null if this turn didn't log an item
  IntColumn get loggedItemType =>
      integer().named('logged_item_type').nullable()();

  IntColumn get createdAt => integer().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'voice_session_history';
}
