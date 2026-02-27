// lib/data/datasources/local/daos/sleep_entry_dao.dart
// Data Access Object for sleep_entries table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/sleep_entries_table.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'sleep_entry_dao.g.dart';

/// Data Access Object for the sleep_entries table.
@DriftAccessor(tables: [SleepEntries])
class SleepEntryDao extends DatabaseAccessor<AppDatabase>
    with _$SleepEntryDaoMixin {
  SleepEntryDao(super.db);

  /// Get all sleep entries.
  Future<Result<List<domain.SleepEntry>, AppError>> getAll({
    String? profileId,
  }) async {
    try {
      var query = select(sleepEntries)
        ..where((s) => s.syncDeletedAt.isNull())
        ..orderBy([(s) => OrderingTerm.desc(s.bedTime)]);

      if (profileId != null) {
        query = query..where((s) => s.profileId.equals(profileId));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sleep_entries', e.toString(), stack),
      );
    }
  }

  /// Get a single entry by ID.
  Future<Result<domain.SleepEntry, AppError>> getById(String id) async {
    try {
      final query = select(sleepEntries)
        ..where((s) => s.id.equals(id) & s.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('SleepEntry', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sleep_entries', e.toString(), stack),
      );
    }
  }

  /// Create a new sleep entry.
  Future<Result<domain.SleepEntry, AppError>> create(
    domain.SleepEntry entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(sleepEntries).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('sleep_entries', e, stack));
    }
  }

  /// Update an existing entry.
  Future<Result<domain.SleepEntry, AppError>> updateEntity(
    domain.SleepEntry entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        sleepEntries,
      )..where((s) => s.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('sleep_entries', entity.id, e, stack),
      );
    }
  }

  /// Soft delete an entry.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            sleepEntries,
          )..where((s) => s.id.equals(id) & s.syncDeletedAt.isNull())).write(
            SleepEntriesCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('SleepEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('sleep_entries', id, e, stack));
    }
  }

  /// Hard delete an entry.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        sleepEntries,
      )..where((s) => s.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('SleepEntry', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('sleep_entries', id, e, stack));
    }
  }

  /// Get entries by profile with optional date filters.
  Future<Result<List<domain.SleepEntry>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(sleepEntries)
        ..where((s) => s.profileId.equals(profileId) & s.syncDeletedAt.isNull())
        ..orderBy([(s) => OrderingTerm.desc(s.bedTime)]);

      if (startDate != null) {
        query = query..where((s) => s.bedTime.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((s) => s.bedTime.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sleep_entries', e.toString(), stack),
      );
    }
  }

  /// Get sleep entry for a specific night.
  Future<Result<domain.SleepEntry?, AppError>> getForNight(
    String profileId,
    int date,
  ) async {
    try {
      // Get entries within the day (date to date + 24 hours)
      final endOfDay = date + Duration.millisecondsPerDay; // 24 hours in ms
      final query = select(sleepEntries)
        ..where(
          (s) =>
              s.profileId.equals(profileId) &
              s.syncDeletedAt.isNull() &
              s.bedTime.isBiggerOrEqualValue(date) &
              s.bedTime.isSmallerThanValue(endOfDay),
        )
        ..limit(1);

      final row = await query.getSingleOrNull();
      return Success(row != null ? _rowToEntity(row) : null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sleep_entries', e.toString(), stack),
      );
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.SleepEntry>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(sleepEntries)
        ..where((s) => s.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(s) => OrderingTerm.asc(s.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sleep_entries', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.SleepEntry>, AppError>> getPendingSync() async {
    try {
      final query = select(sleepEntries)
        ..where((s) => s.syncIsDirty.equals(true))
        ..orderBy([(s) => OrderingTerm.asc(s.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('sleep_entries', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.SleepEntry _rowToEntity(SleepEntryRow row) => domain.SleepEntry(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    bedTime: row.bedTime,
    wakeTime: row.wakeTime,
    deepSleepMinutes: row.deepSleepMinutes,
    lightSleepMinutes: row.lightSleepMinutes,
    restlessSleepMinutes: row.restlessSleepMinutes,
    dreamType: DreamType.fromValue(row.dreamType),
    wakingFeeling: WakingFeeling.fromValue(row.wakingFeeling),
    notes: row.notes,
    timeToFallAsleep: row.timeToFallAsleep,
    timesAwakened: row.timesAwakened,
    timeAwakeDuringNight: row.timeAwakeDuringNight,
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

  /// Convert domain entity to database companion.
  SleepEntriesCompanion _entityToCompanion(domain.SleepEntry entity) =>
      SleepEntriesCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        bedTime: Value(entity.bedTime),
        wakeTime: Value(entity.wakeTime),
        deepSleepMinutes: Value(entity.deepSleepMinutes),
        lightSleepMinutes: Value(entity.lightSleepMinutes),
        restlessSleepMinutes: Value(entity.restlessSleepMinutes),
        dreamType: Value(entity.dreamType.value),
        wakingFeeling: Value(entity.wakingFeeling.value),
        notes: Value(entity.notes),
        timeToFallAsleep: Value(entity.timeToFallAsleep),
        timesAwakened: Value(entity.timesAwakened),
        timeAwakeDuringNight: Value(entity.timeAwakeDuringNight),
        importSource: Value(entity.importSource),
        importExternalId: Value(entity.importExternalId),
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
