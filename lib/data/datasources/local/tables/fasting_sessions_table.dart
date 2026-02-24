// lib/data/datasources/local/tables/fasting_sessions_table.dart
// Phase 15b — Drift table for fasting_sessions
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';

/// Drift table definition for fasting_sessions.
///
/// Records each intermittent fasting session with start/end times,
/// protocol, and target duration.
/// See 59_DIET_TRACKING.md for full feature spec.
@DataClassName('FastingSessionRow')
class FastingSessions extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get protocol => integer()(); // DietPresetType int value
  IntColumn get startedAt => integer().named('started_at')();
  IntColumn get endedAt => integer().named('ended_at').nullable()();
  RealColumn get targetHours => real().named('target_hours')();
  BoolColumn get isManualEnd =>
      boolean().named('is_manual_end').withDefault(const Constant(false))();

  // Sync metadata columns
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
  String get tableName => 'fasting_sessions';
}
