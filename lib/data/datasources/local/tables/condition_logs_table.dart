// lib/data/datasources/local/tables/condition_logs_table.dart
// Drift table definition for condition_logs per 10_DATABASE_SCHEMA.md

import 'package:drift/drift.dart';

/// Drift table definition for condition_logs.
///
/// Maps to database table `condition_logs` with all sync metadata columns.
/// See 10_DATABASE_SCHEMA.md for schema definition.
///
/// NOTE: @DataClassName('ConditionLogRow') avoids conflict with domain entity ConditionLog.
@DataClassName('ConditionLogRow')
class ConditionLogs extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get conditionId => text().named('condition_id')();
  IntColumn get timestamp => integer()(); // Epoch milliseconds
  IntColumn get severity => integer()(); // 1-10 scale
  BoolColumn get isFlare => boolean().named('is_flare')();
  TextColumn get flarePhotoIds =>
      text().named('flare_photo_ids').withDefault(const Constant(''))();

  // Optional fields
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().named('photo_path').nullable()();
  TextColumn get activityId => text().named('activity_id').nullable()();
  TextColumn get triggers => text().nullable()(); // Comma-separated

  // File sync metadata
  TextColumn get cloudStorageUrl =>
      text().named('cloud_storage_url').nullable()();
  TextColumn get fileHash => text().named('file_hash').nullable()();
  IntColumn get fileSizeBytes =>
      integer().named('file_size_bytes').nullable()();
  BoolColumn get isFileUploaded =>
      boolean().named('is_file_uploaded').withDefault(const Constant(false))();

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
  String get tableName => 'condition_logs';
}
