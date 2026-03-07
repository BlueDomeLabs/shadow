// lib/data/repositories/bodily_output_repository_impl.dart
// Per FLUIDS_RESTRUCTURING_SPEC.md Section 5

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/bodily_output_dao.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:uuid/uuid.dart';

/// Repository implementation for bodily output logs.
class BodilyOutputRepositoryImpl implements BodilyOutputRepository {
  final BodilyOutputDao _dao;
  final Uuid _uuid;

  BodilyOutputRepositoryImpl(this._dao, this._uuid);

  @override
  Future<Result<void, AppError>> log(BodilyOutputLog entry) async {
    try {
      final id = entry.id.isEmpty ? _uuid.v4() : entry.id;
      final now = DateTime.now().millisecondsSinceEpoch;
      final companion = _toCompanion(
        entry.copyWith(
          id: id,
          syncMetadata: entry.syncMetadata.copyWith(
            syncCreatedAt: entry.syncMetadata.syncCreatedAt == 0
                ? now
                : entry.syncMetadata.syncCreatedAt,
            syncUpdatedAt: now,
          ),
        ),
      );
      await _dao.insert(companion);
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('bodily_output_logs', e, stack),
      );
    }
  }

  @override
  Future<Result<List<BodilyOutputLog>, AppError>> getAll(
    String profileId, {
    int? from,
    int? to,
    BodyOutputType? type,
  }) async {
    try {
      final rows = await _dao.getAll(
        profileId,
        from: from,
        to: to,
        outputType: type?.value,
      );
      return Success(rows.map<BodilyOutputLog>(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('bodily_output_logs', e.toString(), stack),
      );
    }
  }

  @override
  Future<Result<BodilyOutputLog, AppError>> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Failure(DatabaseError.notFound('BodilyOutputLog', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('bodily_output_logs', e.toString(), stack),
      );
    }
  }

  @override
  Future<Result<void, AppError>> update(BodilyOutputLog entry) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final companion = _toCompanion(
        entry.copyWith(
          syncMetadata: entry.syncMetadata.copyWith(
            syncUpdatedAt: now,
            syncIsDirty: true,
            syncStatus: SyncStatus.modified,
            syncVersion: entry.syncMetadata.syncVersion + 1,
          ),
        ),
      );
      await _dao.updateEntry(companion);
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('bodily_output_logs', entry.id, e, stack),
      );
    }
  }

  @override
  Future<Result<void, AppError>> delete(String profileId, String id) async {
    try {
      final row = await _dao.getById(id);
      if (row == null) {
        return Failure(DatabaseError.notFound('BodilyOutputLog', id));
      }
      if (row.profileId != profileId) {
        return Failure(AuthError.profileAccessDenied(profileId));
      }
      final now = DateTime.now().millisecondsSinceEpoch;
      await _dao.softDelete(id, now);
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('bodily_output_logs', id, e, stack),
      );
    }
  }

  /// Convert a database row to a domain entity.
  BodilyOutputLog _rowToEntity(BodilyOutputLogRow row) => BodilyOutputLog(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    occurredAt: row.occurredAt,
    outputType: BodyOutputType.fromValue(row.outputType),
    customTypeLabel: row.customTypeLabel,
    urineCondition: row.urineCondition != null
        ? UrineCondition.fromValue(row.urineCondition!)
        : null,
    urineCustomCondition: row.urineCustomCondition,
    urineSize: row.urineSize != null
        ? OutputSize.fromValue(row.urineSize!)
        : null,
    bowelCondition: row.bowelCondition != null
        ? BowelCondition.fromValue(row.bowelCondition!)
        : null,
    bowelCustomCondition: row.bowelCustomCondition,
    bowelSize: row.bowelSize != null
        ? OutputSize.fromValue(row.bowelSize!)
        : null,
    gasSeverity: row.gasSeverity != null
        ? GasSeverity.fromValue(row.gasSeverity!)
        : null,
    menstruationFlow: row.menstruationFlow != null
        ? MenstruationFlow.fromValue(row.menstruationFlow!)
        : null,
    temperatureValue: row.temperatureValue,
    temperatureUnit: row.temperatureUnit != null
        ? TemperatureUnit.fromValue(row.temperatureUnit!)
        : null,
    notes: row.notes,
    photoPath: row.photoPath,
    cloudStorageUrl: row.cloudStorageUrl,
    fileHash: row.fileHash,
    fileSizeBytes: row.fileSizeBytes,
    isFileUploaded: row.isFileUploaded,
    importSource: row.importSource,
    importExternalId: row.importExternalId,
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

  /// Convert a domain entity to a database companion.
  BodilyOutputLogsCompanion _toCompanion(BodilyOutputLog entry) =>
      BodilyOutputLogsCompanion(
        id: Value(entry.id),
        clientId: Value(entry.clientId),
        profileId: Value(entry.profileId),
        occurredAt: Value(entry.occurredAt),
        outputType: Value(entry.outputType.value),
        customTypeLabel: Value(entry.customTypeLabel),
        urineCondition: Value(entry.urineCondition?.value),
        urineCustomCondition: Value(entry.urineCustomCondition),
        urineSize: Value(entry.urineSize?.value),
        bowelCondition: Value(entry.bowelCondition?.value),
        bowelCustomCondition: Value(entry.bowelCustomCondition),
        bowelSize: Value(entry.bowelSize?.value),
        gasSeverity: Value(entry.gasSeverity?.value),
        menstruationFlow: Value(entry.menstruationFlow?.value),
        temperatureValue: Value(entry.temperatureValue),
        temperatureUnit: Value(entry.temperatureUnit?.value),
        notes: Value(entry.notes),
        photoPath: Value(entry.photoPath),
        cloudStorageUrl: Value(entry.cloudStorageUrl),
        fileHash: Value(entry.fileHash),
        fileSizeBytes: Value(entry.fileSizeBytes),
        isFileUploaded: Value(entry.isFileUploaded),
        importSource: Value(entry.importSource),
        importExternalId: Value(entry.importExternalId),
        syncCreatedAt: Value(entry.syncMetadata.syncCreatedAt),
        syncUpdatedAt: Value(entry.syncMetadata.syncUpdatedAt),
        syncDeletedAt: Value(entry.syncMetadata.syncDeletedAt),
        syncLastSyncedAt: Value(entry.syncMetadata.syncLastSyncedAt),
        syncStatus: Value(entry.syncMetadata.syncStatus.value),
        syncVersion: Value(entry.syncMetadata.syncVersion),
        syncDeviceId: Value(entry.syncMetadata.syncDeviceId),
        syncIsDirty: Value(entry.syncMetadata.syncIsDirty),
        conflictData: Value(entry.syncMetadata.conflictData),
      );
}
