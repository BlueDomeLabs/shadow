// lib/data/datasources/local/tables/photo_entries_table.dart
// Drift table for photo_entries per 10_DATABASE_SCHEMA.md Section 11.2

import 'package:drift/drift.dart';

/// Drift table definition for photo_entries.
///
/// Maps to CREATE TABLE photo_entries in 10_DATABASE_SCHEMA.md Section 11.2.
/// Individual photo instances for tracking conditions over time.
@DataClassName('PhotoEntryRow')
class PhotoEntries extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  TextColumn get photoAreaId =>
      text().named('photo_area_id')(); // FK to photo_areas
  IntColumn get timestamp => integer()();
  TextColumn get filePath => text().named('file_path')();
  TextColumn get notes => text().nullable()();

  // File sync metadata
  TextColumn get cloudStorageUrl =>
      text().named('cloud_storage_url').nullable()();
  TextColumn get fileHash => text().named('file_hash').nullable()();
  IntColumn get fileSizeBytes =>
      integer().named('file_size_bytes').nullable()();
  BoolColumn get isFileUploaded =>
      boolean().named('is_file_uploaded').withDefault(const Constant(false))();

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
