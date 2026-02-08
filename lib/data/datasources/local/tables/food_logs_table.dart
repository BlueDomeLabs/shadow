// lib/data/datasources/local/tables/food_logs_table.dart
// Drift table for food_logs per 10_DATABASE_SCHEMA.md Section 5.2

import 'package:drift/drift.dart';

/// Drift table definition for food_logs.
///
/// Maps to CREATE TABLE food_logs in 10_DATABASE_SCHEMA.md Section 5.2.
/// Food consumption log entries.
@DataClassName('FoodLogRow')
class FoodLogs extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get timestamp => integer()();
  IntColumn get mealType => integer().named('meal_type').nullable()();
  TextColumn get foodItemIds =>
      text().named('food_item_ids')(); // Comma-separated IDs
  TextColumn get adHocItems =>
      text().named('ad_hoc_items')(); // Comma-separated names
  TextColumn get notes => text().nullable()();

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
