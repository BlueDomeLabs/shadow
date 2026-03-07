// lib/data/datasources/local/tables/bodily_output_logs_table.dart
// Drift table for bodily_output_logs per FLUIDS_RESTRUCTURING_SPEC.md Section 1.1

import 'package:drift/drift.dart';

/// Drift table for bodily output log events.
///
/// One row per individual output event (urine, bowel, gas, menstruation, BBT, custom).
/// Replaces the daily-aggregate fluids_entries model.
@DataClassName('BodilyOutputLogRow')
class BodilyOutputLogs extends Table {
  // Primary key
  TextColumn get id => text()();

  // Required fields
  TextColumn get clientId => text().named('client_id')();
  TextColumn get profileId => text().named('profile_id')();
  IntColumn get occurredAt => integer().named('occurred_at')(); // Epoch ms

  // Output type (required) — BodyOutputType enum
  IntColumn get outputType => integer().named('output_type')();

  // Custom type (output_type = 5 only)
  TextColumn get customTypeLabel =>
      text().named('custom_type_label').nullable()();

  // Urine fields (output_type = 0)
  IntColumn get urineCondition =>
      integer().named('urine_condition').nullable()(); // UrineCondition enum
  TextColumn get urineCustomCondition =>
      text().named('urine_custom_condition').nullable()();
  IntColumn get urineSize =>
      integer().named('urine_size').nullable()(); // OutputSize enum

  // Bowel fields (output_type = 1)
  IntColumn get bowelCondition =>
      integer().named('bowel_condition').nullable()(); // BowelCondition enum
  TextColumn get bowelCustomCondition =>
      text().named('bowel_custom_condition').nullable()();
  IntColumn get bowelSize =>
      integer().named('bowel_size').nullable()(); // OutputSize enum

  // Gas fields (output_type = 2)
  // Nullable at DB level — required enforced in use case layer
  IntColumn get gasSeverity =>
      integer().named('gas_severity').nullable()(); // GasSeverity enum

  // Menstruation fields (output_type = 3)
  IntColumn get menstruationFlow => integer()
      .named('menstruation_flow')
      .nullable()(); // MenstruationFlow enum

  // BBT fields (output_type = 4)
  RealColumn get temperatureValue =>
      real().named('temperature_value').nullable()();
  IntColumn get temperatureUnit =>
      integer().named('temperature_unit').nullable()(); // TemperatureUnit enum

  // Shared optional fields
  TextColumn get notes => text().nullable()();

  // Photo fields
  TextColumn get photoPath => text().named('photo_path').nullable()();
  TextColumn get cloudStorageUrl =>
      text().named('cloud_storage_url').nullable()();
  TextColumn get fileHash => text().named('file_hash').nullable()();
  IntColumn get fileSizeBytes =>
      integer().named('file_size_bytes').nullable()();
  BoolColumn get isFileUploaded =>
      boolean().named('is_file_uploaded').withDefault(const Constant(false))();

  // Import tracking
  TextColumn get importSource => text().named('import_source').nullable()();
  TextColumn get importExternalId =>
      text().named('import_external_id').nullable()();

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
  String get tableName => 'bodily_output_logs';
}
