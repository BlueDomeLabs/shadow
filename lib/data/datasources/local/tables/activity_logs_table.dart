// lib/data/datasources/local/tables/activity_logs_table.dart
// Drift table for activity_logs per 10_DATABASE_SCHEMA.md Section 6.2

import 'package:drift/drift.dart';

/// Drift table definition for activity_logs.
///
/// Maps to CREATE TABLE activity_logs in 10_DATABASE_SCHEMA.md Section 6.2.
/// Activity instances tracking when activities were performed.
@DataClassName('ActivityLogRow')
class ActivityLogs extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get timestamp => integer()();
  TextColumn get activityIds =>
      text().named('activity_ids')(); // Comma-separated IDs
  TextColumn get adHocActivities =>
      text().named('ad_hoc_activities')(); // Comma-separated names
  IntColumn get duration => integer().nullable()();
  TextColumn get notes => text().nullable()();

  // Import tracking (for wearable data)
  TextColumn get importSource => text().named('import_source').nullable()();
  TextColumn get importExternalId =>
      text().named('import_external_id').nullable()();

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
