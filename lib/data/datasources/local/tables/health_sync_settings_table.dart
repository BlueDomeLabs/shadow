// lib/data/datasources/local/tables/health_sync_settings_table.dart
// Phase 16 — Drift table for health platform sync preferences
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:drift/drift.dart';

/// Drift table for per-profile health sync preferences.
///
/// One row per profile. id = profileId.
/// enabled_data_types stored as JSON array of HealthDataType integer values.
/// Local only — not synced to Google Drive.
@DataClassName('HealthSyncSettingsRow')
class HealthSyncSettingsTable extends Table {
  // Primary key — equals profileId (one row per profile)
  TextColumn get id => text()();
  TextColumn get profileId => text().named('profile_id')();

  // Settings fields
  TextColumn get enabledDataTypes => text()
      .named('enabled_data_types')
      .withDefault(
        const Constant('[0,1,2,3,4,5,6,7,8]'),
      )(); // JSON array of HealthDataType int values
  IntColumn get dateRangeDays =>
      integer().named('date_range_days').withDefault(const Constant(30))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'health_sync_settings';
}
