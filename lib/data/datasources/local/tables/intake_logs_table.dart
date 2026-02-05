// lib/data/datasources/local/tables/intake_logs_table.dart
// Drift table definition for intake_logs per 10_DATABASE_SCHEMA.md

import 'package:drift/drift.dart';

/// Drift table definition for intake_logs.
///
/// Maps to database table `intake_logs` with all sync metadata columns.
/// See 10_DATABASE_SCHEMA.md for schema definition.
///
/// NOTE: @DataClassName('IntakeLogRow') avoids conflict with domain entity IntakeLog.
@DataClassName('IntakeLogRow')
class IntakeLogs extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get supplementId => text().named('supplement_id')();
  IntColumn get scheduledTime => integer().named('scheduled_time')();
  IntColumn get status => integer()(); // IntakeLogStatus enum

  // Optional fields
  IntColumn get actualTime => integer().named('actual_time').nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get note => text().nullable()();

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
  String get tableName => 'intake_logs';
}
