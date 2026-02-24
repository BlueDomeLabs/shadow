// lib/data/datasources/local/tables/diets_table.dart
// Phase 15b — Drift table for diets
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';

/// Drift table definition for diets.
///
/// Stores preset and custom diet configurations per profile.
/// See 59_DIET_TRACKING.md for full feature spec.
@DataClassName('DietRow')
class Diets extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get presetType =>
      integer().named('preset_type').nullable()(); // null = custom
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(false))();
  IntColumn get startDate => integer().named('start_date')();
  IntColumn get endDate => integer().named('end_date').nullable()();
  BoolColumn get isDraft =>
      boolean().named('is_draft').withDefault(const Constant(false))();

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
  String get tableName => 'diets';
}
