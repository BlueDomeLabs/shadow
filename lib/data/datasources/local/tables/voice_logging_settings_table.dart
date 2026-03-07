// lib/data/datasources/local/tables/voice_logging_settings_table.dart
// Drift table for voice_logging_settings per VOICE_LOGGING_SPEC.md Section 2.1

import 'package:drift/drift.dart';

/// Drift table for per-profile voice logging preferences.
///
/// One row per profile. id = profileId (same value).
/// Local only — not synced.
@DataClassName('VoiceLoggingSettingsRow')
class VoiceLoggingSettingsTable extends Table {
  // Primary key — equals profileId (one row per profile)
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().named('profile_id').withLength(min: 1, max: 36)();

  // ClosingStyle enum integer value. Default 1 = random.
  IntColumn get closingStyle =>
      integer().named('closing_style').withDefault(const Constant(1))();

  // Fixed farewell text (used when closing_style = 2/fixed)
  TextColumn get fixedFarewell => text().named('fixed_farewell').nullable()();

  // JSON array of NotificationCategory integer values defining priority order.
  // Null = use default priority order.
  TextColumn get categoryPriorityOrder =>
      text().named('category_priority_order').nullable()();

  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'voice_logging_settings';
}
