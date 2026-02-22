// lib/data/datasources/local/tables/sync_conflicts_table.dart
// Drift table definition for sync_conflicts per 10_DATABASE_SCHEMA.md Section 17

import 'package:drift/drift.dart';

/// Drift table definition for the sync_conflicts table.
///
/// Stores one row per detected sync conflict. This is the authoritative
/// source for conflict state — always queried to count, list, and resolve.
///
/// NOTE: This table has NO sync metadata columns. Conflict records are
/// local-only and are never uploaded to Google Drive.
///
/// See 10_DATABASE_SCHEMA.md Section 17 for full schema documentation.
/// See 22_API_CONTRACTS.md Section 17.7 for resolution behavior.
@DataClassName('SyncConflictRow')
class SyncConflicts extends Table {
  // Primary key
  TextColumn get id => text()();

  // Entity identification
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get profileId => text().named('profile_id')();

  // Version numbers at time of conflict detection
  IntColumn get localVersion => integer().named('local_version')();
  IntColumn get remoteVersion => integer().named('remote_version')();

  // Full JSON snapshots of both versions at detection time
  TextColumn get localData => text().named('local_data')();
  TextColumn get remoteData => text().named('remote_data')();

  // Timestamps
  IntColumn get detectedAt => integer().named('detected_at')();

  // Resolution state
  BoolColumn get isResolved =>
      boolean().named('is_resolved').withDefault(const Constant(false))();
  IntColumn get resolution => integer()
      .nullable()(); // ConflictResolutionType.value; null if unresolved
  IntColumn get resolvedAt => integer()
      .named('resolved_at')
      .nullable()(); // Epoch ms; null if unresolved

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'sync_conflicts';
}
