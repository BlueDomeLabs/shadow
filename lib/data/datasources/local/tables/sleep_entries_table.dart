// lib/data/datasources/local/tables/sleep_entries_table.dart
// Drift table definition for sleep_entries per 10_DATABASE_SCHEMA.md Section 7

import 'package:drift/drift.dart';

/// Drift table definition for sleep entries.
///
/// Maps to database table `sleep_entries` with all sync metadata columns.
/// See 10_DATABASE_SCHEMA.md Section 7 for schema definition.
@DataClassName('SleepEntryRow')
class SleepEntries extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get bedTime => integer().named('bed_time')(); // Epoch ms

  // Optional fields with defaults
  IntColumn get wakeTime =>
      integer().named('wake_time').nullable()(); // Epoch ms
  IntColumn get deepSleepMinutes =>
      integer().named('deep_sleep_minutes').withDefault(const Constant(0))();
  IntColumn get lightSleepMinutes =>
      integer().named('light_sleep_minutes').withDefault(const Constant(0))();
  IntColumn get restlessSleepMinutes => integer()
      .named('restless_sleep_minutes')
      .withDefault(const Constant(0))();
  IntColumn get dreamType => integer()
      .named('dream_type')
      .withDefault(const Constant(0))(); // DreamType enum
  IntColumn get wakingFeeling => integer()
      .named('waking_feeling')
      .withDefault(const Constant(1))(); // WakingFeeling enum
  TextColumn get notes => text().nullable()();

  // Import tracking (for wearable data)
  TextColumn get importSource => text().named('import_source').nullable()();
  TextColumn get importExternalId =>
      text().named('import_external_id').nullable()();

  // Sync metadata columns (required on all syncable entities)
  IntColumn get syncCreatedAt => integer().named('sync_created_at')();
  IntColumn get syncUpdatedAt =>
      integer().named('sync_updated_at').nullable()();
  IntColumn get syncDeletedAt =>
      integer().named('sync_deleted_at').nullable()();
  IntColumn get syncLastSyncedAt =>
      integer().named('sync_last_synced_at').nullable()();
  IntColumn get syncStatus =>
      integer().named('sync_status').withDefault(const Constant(0))();
  IntColumn get syncVersion =>
      integer().named('sync_version').withDefault(const Constant(1))();
  TextColumn get syncDeviceId => text().named('sync_device_id').nullable()();
  BoolColumn get syncIsDirty =>
      boolean().named('sync_is_dirty').withDefault(const Constant(true))();
  TextColumn get conflictData => text().named('conflict_data').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'sleep_entries';
}
