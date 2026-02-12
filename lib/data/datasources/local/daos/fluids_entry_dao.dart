// lib/data/datasources/local/daos/fluids_entry_dao.dart
// Data Access Object for fluids_entries table per 22_API_CONTRACTS.md

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/fluids_entries_table.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'fluids_entry_dao.g.dart';

/// Data Access Object for the fluids_entries table.
@DriftAccessor(tables: [FluidsEntries])
class FluidsEntryDao extends DatabaseAccessor<AppDatabase>
    with _$FluidsEntryDaoMixin {
  FluidsEntryDao(super.db);

  /// Get all fluids entries.
  Future<Result<List<domain.FluidsEntry>, AppError>> getAll({
    String? profileId,
  }) async {
    try {
      var query = select(fluidsEntries)
        ..where((f) => f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.desc(f.entryDate)]);

      if (profileId != null) {
        query = query..where((f) => f.profileId.equals(profileId));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Get a single entry by ID.
  Future<Result<domain.FluidsEntry, AppError>> getById(String id) async {
    try {
      final query = select(fluidsEntries)
        ..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('FluidsEntry', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Create a new fluids entry.
  Future<Result<domain.FluidsEntry, AppError>> create(
    domain.FluidsEntry entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(fluidsEntries).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('fluids_entries', e, stack));
    }
  }

  /// Update an existing entry.
  Future<Result<domain.FluidsEntry, AppError>> updateEntity(
    domain.FluidsEntry entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        fluidsEntries,
      )..where((f) => f.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('fluids_entries', entity.id, e, stack),
      );
    }
  }

  /// Soft delete an entry.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            fluidsEntries,
          )..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull())).write(
            FluidsEntriesCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FluidsEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('fluids_entries', id, e, stack),
      );
    }
  }

  /// Hard delete an entry.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        fluidsEntries,
      )..where((f) => f.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FluidsEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('fluids_entries', id, e, stack),
      );
    }
  }

  /// Get entries by date range.
  Future<Result<List<domain.FluidsEntry>, AppError>> getByDateRange(
    String profileId,
    int start,
    int end,
  ) async {
    try {
      final query = select(fluidsEntries)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.syncDeletedAt.isNull() &
              f.entryDate.isBiggerOrEqualValue(start) &
              f.entryDate.isSmallerOrEqualValue(end),
        )
        ..orderBy([(f) => OrderingTerm.desc(f.entryDate)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Get BBT entries for chart.
  Future<Result<List<domain.FluidsEntry>, AppError>> getBBTEntries(
    String profileId,
    int start,
    int end,
  ) async {
    try {
      final query = select(fluidsEntries)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.syncDeletedAt.isNull() &
              f.basalBodyTemperature.isNotNull() &
              f.entryDate.isBiggerOrEqualValue(start) &
              f.entryDate.isSmallerOrEqualValue(end),
        )
        ..orderBy([(f) => OrderingTerm.asc(f.entryDate)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Get menstruation entries.
  Future<Result<List<domain.FluidsEntry>, AppError>> getMenstruationEntries(
    String profileId,
    int start,
    int end,
  ) async {
    try {
      final query = select(fluidsEntries)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.syncDeletedAt.isNull() &
              f.menstruationFlow.isNotNull() &
              f.entryDate.isBiggerOrEqualValue(start) &
              f.entryDate.isSmallerOrEqualValue(end),
        )
        ..orderBy([(f) => OrderingTerm.desc(f.entryDate)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.FluidsEntry>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(fluidsEntries)
        ..where((f) => f.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.FluidsEntry>, AppError>> getPendingSync() async {
    try {
      final query = select(fluidsEntries)
        ..where((f) => f.syncIsDirty.equals(true))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('fluids_entries', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.FluidsEntry _rowToEntity(FluidsEntryRow row) => domain.FluidsEntry(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    entryDate: row.entryDate,
    waterIntakeMl: row.waterIntakeMl,
    waterIntakeNotes: row.waterIntakeNotes,
    bowelCondition: row.bowelCondition != null
        ? BowelCondition.fromValue(row.bowelCondition!)
        : null,
    bowelSize: row.bowelSize != null
        ? MovementSize.fromValue(row.bowelSize!)
        : null,
    bowelPhotoPath: row.bowelPhotoPath,
    urineCondition: row.urineCondition != null
        ? UrineCondition.fromValue(row.urineCondition!)
        : null,
    urineSize: row.urineSize != null
        ? MovementSize.fromValue(row.urineSize!)
        : null,
    urinePhotoPath: row.urinePhotoPath,
    menstruationFlow: row.menstruationFlow != null
        ? MenstruationFlow.fromValue(row.menstruationFlow!)
        : null,
    basalBodyTemperature: row.basalBodyTemperature,
    bbtRecordedTime: row.bbtRecordedTime,
    otherFluidName: row.otherFluidName,
    otherFluidAmount: row.otherFluidAmount,
    otherFluidNotes: row.otherFluidNotes,
    importSource: row.importSource,
    importExternalId: row.importExternalId,
    cloudStorageUrl: row.cloudStorageUrl,
    fileHash: row.fileHash,
    fileSizeBytes: row.fileSizeBytes,
    isFileUploaded: row.isFileUploaded,
    notes: row.notes,
    photoIds: _parsePhotoIds(row.photoIds),
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

  /// Convert domain entity to database companion.
  FluidsEntriesCompanion _entityToCompanion(domain.FluidsEntry entity) =>
      FluidsEntriesCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        entryDate: Value(entity.entryDate),
        waterIntakeMl: Value(entity.waterIntakeMl),
        waterIntakeNotes: Value(entity.waterIntakeNotes),
        hasBowelMovement: Value(entity.hasBowelData),
        bowelCondition: Value(entity.bowelCondition?.value),
        bowelSize: Value(entity.bowelSize?.value),
        bowelPhotoPath: Value(entity.bowelPhotoPath),
        hasUrineMovement: Value(entity.hasUrineData),
        urineCondition: Value(entity.urineCondition?.value),
        urineSize: Value(entity.urineSize?.value),
        urinePhotoPath: Value(entity.urinePhotoPath),
        menstruationFlow: Value(entity.menstruationFlow?.value),
        basalBodyTemperature: Value(entity.basalBodyTemperature),
        bbtRecordedTime: Value(entity.bbtRecordedTime),
        otherFluidName: Value(entity.otherFluidName),
        otherFluidAmount: Value(entity.otherFluidAmount),
        otherFluidNotes: Value(entity.otherFluidNotes),
        importSource: Value(entity.importSource),
        importExternalId: Value(entity.importExternalId),
        cloudStorageUrl: Value(entity.cloudStorageUrl),
        fileHash: Value(entity.fileHash),
        fileSizeBytes: Value(entity.fileSizeBytes),
        isFileUploaded: Value(entity.isFileUploaded),
        notes: Value(entity.notes),
        photoIds: Value(jsonEncode(entity.photoIds)),
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

  List<String> _parsePhotoIds(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.cast<String>();
    } on Exception catch (e) {
      debugPrint(
        'WARNING: Failed to parse JSON in FluidsEntryDao._parsePhotoIds: $e',
      );
      return [];
    }
  }
}
