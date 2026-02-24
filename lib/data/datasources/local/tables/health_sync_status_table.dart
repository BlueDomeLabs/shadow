// lib/data/datasources/local/tables/health_sync_status_table.dart
// Phase 16 — Drift table for per-data-type sync status tracking
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:drift/drift.dart';

/// Drift table for per-data-type health sync status.
///
/// One row per (profileId, dataType) pair.
/// id = "${profileId}_${dataType.value}" (composite key).
/// Local only — not synced to Google Drive (tracks device-level import state).
///
/// Exempt from sync metadata per 02_CODING_STANDARDS.md Section 8.2.1
/// (similar to imported_data_log — import deduplication/tracking only).
@DataClassName('HealthSyncStatusRow')
class HealthSyncStatusTable extends Table {
  // Primary key — composite "profileId_dataTypeValue"
  TextColumn get id => text()();
  TextColumn get profileId => text().named('profile_id')();

  IntColumn get dataType =>
      integer().named('data_type')(); // HealthDataType.value

  // Status fields
  IntColumn get lastSyncedAt =>
      integer().named('last_synced_at').nullable()(); // epoch ms; null = never
  IntColumn get recordCount =>
      integer().named('record_count').withDefault(const Constant(0))();
  TextColumn get lastError => text().named('last_error').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'health_sync_status';
}
