// lib/data/datasources/local/tables/journal_entries_table.dart
// Drift table for journal_entries per 10_DATABASE_SCHEMA.md Section 8.1

import 'package:drift/drift.dart';

/// Drift table definition for journal_entries.
///
/// Maps to CREATE TABLE journal_entries in 10_DATABASE_SCHEMA.md Section 8.1.
/// User journal notes with optional mood tracking and audio attachments.
@DataClassName('JournalEntryRow')
class JournalEntries extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get timestamp => integer()();
  TextColumn get content => text()();
  TextColumn get title => text().nullable()();
  IntColumn get mood => integer().nullable()(); // 1-10 rating
  TextColumn get tags => text().nullable()(); // Comma-separated tags
  TextColumn get audioUrl => text().named('audio_url').nullable()();

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
