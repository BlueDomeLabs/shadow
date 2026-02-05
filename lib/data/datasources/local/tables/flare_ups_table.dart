// lib/data/datasources/local/tables/flare_ups_table.dart
// Drift table for flare_ups per 10_DATABASE_SCHEMA.md Section 9.3

import 'package:drift/drift.dart';

/// Drift table definition for flare_ups.
///
/// Maps to CREATE TABLE flare_ups in 10_DATABASE_SCHEMA.md Section 9.3.
/// Acute condition episodes with start/end dates.
@DataClassName('FlareUpRow')
class FlareUps extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get conditionId => text().named('condition_id')();
  IntColumn get startDate => integer().named('start_date')(); // Epoch ms
  IntColumn get endDate =>
      integer().named('end_date').nullable()(); // Epoch ms, null = ongoing
  IntColumn get severity => integer()(); // 1-10 scale
  TextColumn get notes => text().nullable()();
  TextColumn get triggers => text()(); // JSON array of trigger descriptions
  TextColumn get activityId => text().named('activity_id').nullable()();
  TextColumn get photoPath => text().named('photo_path').nullable()();

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
