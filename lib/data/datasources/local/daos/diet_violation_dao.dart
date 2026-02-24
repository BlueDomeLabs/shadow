// lib/data/datasources/local/daos/diet_violation_dao.dart
// Phase 15b — DAO for diet_violations table
// Per 59_DIET_TRACKING.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/diet_violations_table.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'diet_violation_dao.g.dart';

/// Data Access Object for the diet_violations table.
@DriftAccessor(tables: [DietViolations])
class DietViolationDao extends DatabaseAccessor<AppDatabase>
    with _$DietViolationDaoMixin {
  DietViolationDao(super.db);

  /// Get all violations for a profile, most recent first.
  Future<Result<List<domain.DietViolation>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
  }) async {
    try {
      var query = select(dietViolations)
        ..where((v) => v.profileId.equals(profileId) & v.syncDeletedAt.isNull())
        ..orderBy([(v) => OrderingTerm.desc(v.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((v) => v.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((v) => v.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_violations', e.toString(), stack),
      );
    }
  }

  /// Get all violations for a specific diet.
  Future<Result<List<domain.DietViolation>, AppError>> getByDiet(
    String dietId,
  ) async {
    try {
      final rows =
          await (select(dietViolations)
                ..where(
                  (v) => v.dietId.equals(dietId) & v.syncDeletedAt.isNull(),
                )
                ..orderBy([(v) => OrderingTerm.desc(v.timestamp)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_violations', e.toString(), stack),
      );
    }
  }

  /// Get a single violation by ID.
  Future<Result<domain.DietViolation, AppError>> getById(String id) async {
    try {
      final row =
          await (select(dietViolations)
                ..where((v) => v.id.equals(id) & v.syncDeletedAt.isNull()))
              .getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('DietViolation', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_violations', e.toString(), stack),
      );
    }
  }

  /// Create a new violation record.
  Future<Result<domain.DietViolation, AppError>> create(
    domain.DietViolation entity,
  ) async {
    try {
      await into(dietViolations).insert(_entityToCompanion(entity));
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('diet_violations', e, stack));
    }
  }

  /// Soft delete a violation.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            dietViolations,
          )..where((v) => v.id.equals(id) & v.syncDeletedAt.isNull())).write(
            DietViolationsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('DietViolation', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('diet_violations', id, e, stack),
      );
    }
  }

  /// Hard delete a violation.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        dietViolations,
      )..where((v) => v.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('DietViolation', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('diet_violations', id, e, stack),
      );
    }
  }

  /// Get modified since timestamp (for sync).
  Future<Result<List<domain.DietViolation>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final rows =
          await (select(dietViolations)
                ..where((v) => v.syncUpdatedAt.isBiggerThanValue(since))
                ..orderBy([(v) => OrderingTerm.asc(v.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_violations', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.DietViolation>, AppError>> getPendingSync() async {
    try {
      final rows =
          await (select(dietViolations)
                ..where((v) => v.syncIsDirty.equals(true))
                ..orderBy([(v) => OrderingTerm.asc(v.syncUpdatedAt)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('diet_violations', e.toString(), stack),
      );
    }
  }

  domain.DietViolation _rowToEntity(DietViolationRow row) =>
      domain.DietViolation(
        id: row.id,
        clientId: row.clientId,
        profileId: row.profileId,
        dietId: row.dietId,
        ruleId: row.ruleId,
        foodLogId: row.foodLogId,
        foodName: row.foodName,
        ruleDescription: row.ruleDescription,
        wasOverridden: row.wasOverridden,
        timestamp: row.timestamp,
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

  DietViolationsCompanion _entityToCompanion(domain.DietViolation entity) =>
      DietViolationsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        dietId: Value(entity.dietId),
        ruleId: Value(entity.ruleId),
        foodLogId: Value(entity.foodLogId),
        foodName: Value(entity.foodName),
        ruleDescription: Value(entity.ruleDescription),
        wasOverridden: Value(entity.wasOverridden),
        timestamp: Value(entity.timestamp),
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
