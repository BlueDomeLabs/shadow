// lib/data/datasources/local/tables/activities_table.dart
// Drift table for activities per 10_DATABASE_SCHEMA.md Section 6.1

import 'package:drift/drift.dart';

/// Drift table definition for activities.
///
/// Maps to CREATE TABLE activities in 10_DATABASE_SCHEMA.md Section 6.1.
/// Reusable activity definitions with archive support.
@DataClassName('ActivityRow')
class Activities extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get triggers => text().nullable()(); // Comma-separated
  IntColumn get durationMinutes => integer().named('duration_minutes')();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();

  // Sync metadata columns (9 columns per 10_DATABASE_SCHEMA.md)
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
}
