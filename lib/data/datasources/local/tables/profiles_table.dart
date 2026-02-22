// lib/data/datasources/local/tables/profiles_table.dart
// Drift table definition for profiles per 10_DATABASE_SCHEMA.md Section 3.2

import 'package:drift/drift.dart';

/// Drift table definition for profiles.
///
/// Maps to database table `profiles` with all sync metadata columns.
/// See 10_DATABASE_SCHEMA.md Section 3.2 for schema definition.
///
/// NOTE: @DataClassName('ProfileRow') avoids conflict with domain entity Profile.
@DataClassName('ProfileRow')
class Profiles extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get name => text()();

  // Optional fields
  IntColumn get birthDate => integer().named('birth_date').nullable()();
  IntColumn get biologicalSex =>
      integer().named('biological_sex').nullable()(); // BiologicalSex enum
  TextColumn get ethnicity => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get ownerId => text().named('owner_id').nullable()();
  IntColumn get dietType => integer()
      .named('diet_type')
      .withDefault(const Constant(0))(); // ProfileDietType enum
  TextColumn get dietDescription =>
      text().named('diet_description').nullable()();

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
  String get tableName => 'profiles';
}
