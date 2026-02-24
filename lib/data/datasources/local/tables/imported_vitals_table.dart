// lib/data/datasources/local/tables/imported_vitals_table.dart
// Phase 16 — Drift table for imported health platform vitals
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:drift/drift.dart';

/// Drift table for health platform imported vitals.
///
/// Stores measurements imported from Apple HealthKit and Google Health Connect.
/// Records are read-only after creation — Shadow never modifies them.
/// Deduplication: skip records with same (data_type, recorded_at, source_platform, profile_id).
///
/// Timestamps (recorded_at, imported_at) are stored as INTEGER (epoch ms UTC)
/// per 02_CODING_STANDARDS.md Section 8.3.
@DataClassName('ImportedVitalRow')
class ImportedVitals extends Table {
  // Primary key
  TextColumn get id => text()();

  // Core fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();

  // Health measurement fields
  IntColumn get dataType =>
      integer().named('data_type')(); // HealthDataType.value
  RealColumn get value => real()();
  TextColumn get unit => text()();
  IntColumn get recordedAt =>
      integer().named('recorded_at')(); // epoch ms from source device
  IntColumn get sourcePlatform =>
      integer().named('source_platform')(); // HealthSourcePlatform.value
  TextColumn get sourceDevice =>
      text().named('source_device').nullable()(); // device name if available
  IntColumn get importedAt =>
      integer().named('imported_at')(); // epoch ms when Shadow imported

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
  String get tableName => 'imported_vitals';
}
