// lib/data/datasources/local/tables/diet_violations_table.dart
// Phase 15b — Drift table for diet_violations
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';

/// Drift table definition for diet_violations.
///
/// Records each diet compliance check failure, whether the user
/// added the food anyway (wasOverridden=true) or cancelled
/// (wasOverridden=false).
/// See 59_DIET_TRACKING.md for full feature spec.
@DataClassName('DietViolationRow')
class DietViolations extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get dietId => text().named('diet_id')();
  TextColumn get ruleId => text().named('rule_id')();
  TextColumn get foodLogId =>
      text().named('food_log_id').nullable()(); // null if cancelled
  TextColumn get foodName => text().named('food_name')();
  TextColumn get ruleDescription => text().named('rule_description')();
  BoolColumn get wasOverridden =>
      boolean().named('was_overridden').withDefault(const Constant(false))();
  IntColumn get timestamp => integer()();

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
  String get tableName => 'diet_violations';
}
