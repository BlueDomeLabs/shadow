// lib/data/datasources/local/daos/imported_vital_dao.dart
// Phase 16 — DAO for imported_vitals table
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/imported_vitals_table.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'imported_vital_dao.g.dart';

/// Data Access Object for the imported_vitals table.
@DriftAccessor(tables: [ImportedVitals])
class ImportedVitalDao extends DatabaseAccessor<AppDatabase>
    with _$ImportedVitalDaoMixin {
  ImportedVitalDao(super.db);

  /// Get all imported vitals for a profile, with optional date/type filters.
  Future<Result<List<domain.ImportedVital>, AppError>> getByProfile({
    required String profileId,
    int? startEpoch,
    int? endEpoch,
    HealthDataType? dataType,
  }) async {
    try {
      final query = select(importedVitals)
        ..where((v) => v.profileId.equals(profileId) & v.syncDeletedAt.isNull())
        ..orderBy([(v) => OrderingTerm.desc(v.recordedAt)]);

      if (startEpoch != null) {
        query.where((v) => v.recordedAt.isBiggerOrEqualValue(startEpoch));
      }
      if (endEpoch != null) {
        query.where((v) => v.recordedAt.isSmallerOrEqualValue(endEpoch));
      }
      if (dataType != null) {
        query.where((v) => v.dataType.equals(dataType.value));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('imported_vitals', e.toString(), stack),
      );
    }
  }

  /// Insert a single vital. Returns null on duplicate (deduplication).
  Future<Result<void, AppError>> insertIfNotDuplicate(
    domain.ImportedVital entity,
  ) async {
    try {
      await into(
        importedVitals,
      ).insertOnConflictUpdate(_entityToCompanion(entity));
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.insertFailed('imported_vitals', e, stack));
    }
  }

  /// Returns the most recent importedAt epoch ms for a (profileId, dataType) pair.
  Future<Result<int?, AppError>> getLastImportTime(
    String profileId,
    HealthDataType dataType,
  ) async {
    try {
      final row =
          await (select(importedVitals)
                ..where(
                  (v) =>
                      v.profileId.equals(profileId) &
                      v.dataType.equals(dataType.value) &
                      v.syncDeletedAt.isNull(),
                )
                ..orderBy([(v) => OrderingTerm.desc(v.importedAt)])
                ..limit(1))
              .getSingleOrNull();
      return Success(row?.importedAt);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('imported_vitals', e.toString(), stack),
      );
    }
  }

  /// Get records modified since a timestamp (for cloud sync).
  Future<Result<List<domain.ImportedVital>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final rows =
          await (select(importedVitals)
                ..where((v) => v.syncUpdatedAt.isBiggerThanValue(since))
                ..orderBy([(v) => OrderingTerm.asc(v.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('imported_vitals', e.toString(), stack),
      );
    }
  }

  domain.ImportedVital _rowToEntity(ImportedVitalRow row) =>
      domain.ImportedVital(
        id: row.id,
        clientId: row.clientId,
        profileId: row.profileId,
        dataType: HealthDataType.fromValue(row.dataType),
        value: row.value,
        unit: row.unit,
        recordedAt: row.recordedAt,
        sourcePlatform: HealthSourcePlatform.fromValue(row.sourcePlatform),
        sourceDevice: row.sourceDevice,
        importedAt: row.importedAt,
        syncMetadata: SyncMetadata(
          syncCreatedAt: row.syncCreatedAt,
          syncUpdatedAt: row.syncUpdatedAt ?? row.syncCreatedAt,
          syncDeletedAt: row.syncDeletedAt,
          syncLastSyncedAt: row.syncLastSyncedAt,
          syncStatus: SyncStatus.fromValue(row.syncStatus),
          syncVersion: row.syncVersion,
          syncDeviceId: row.syncDeviceId ?? '',
          syncIsDirty: row.syncIsDirty,
          conflictData: row.conflictData,
        ),
      );

  ImportedVitalsCompanion _entityToCompanion(domain.ImportedVital entity) =>
      ImportedVitalsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        dataType: Value(entity.dataType.value),
        value: Value(entity.value),
        unit: Value(entity.unit),
        recordedAt: Value(entity.recordedAt),
        sourcePlatform: Value(entity.sourcePlatform.value),
        sourceDevice: Value(entity.sourceDevice),
        importedAt: Value(entity.importedAt),
        syncCreatedAt: Value(entity.syncMetadata.syncCreatedAt),
        syncUpdatedAt: Value(entity.syncMetadata.syncUpdatedAt),
        syncDeletedAt: Value(entity.syncMetadata.syncDeletedAt),
        syncLastSyncedAt: Value(entity.syncMetadata.syncLastSyncedAt),
        syncStatus: Value(entity.syncMetadata.syncStatus.value),
        syncVersion: Value(entity.syncMetadata.syncVersion),
        syncDeviceId: Value(entity.syncMetadata.syncDeviceId),
        syncIsDirty: Value(entity.syncMetadata.syncIsDirty),
        conflictData: Value(entity.syncMetadata.conflictData),
      );
}
