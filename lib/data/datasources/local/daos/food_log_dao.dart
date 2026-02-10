// lib/data/datasources/local/daos/food_log_dao.dart
// Data Access Object for food_logs table per 22_API_CONTRACTS.md

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/food_logs_table.dart';
import 'package:shadow_app/domain/entities/food_log.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'food_log_dao.g.dart';

/// Data Access Object for the food_logs table.
@DriftAccessor(tables: [FoodLogs])
class FoodLogDao extends DatabaseAccessor<AppDatabase> with _$FoodLogDaoMixin {
  FoodLogDao(super.db);

  /// Get all food logs.
  Future<Result<List<domain.FoodLog>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(foodLogs)
        ..where((f) => f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.desc(f.timestamp)]);

      if (profileId != null) {
        query = query..where((f) => f.profileId.equals(profileId));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Get a single food log by ID.
  Future<Result<domain.FoodLog, AppError>> getById(String id) async {
    try {
      final query = select(foodLogs)
        ..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('FoodLog', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Create a new food log.
  Future<Result<domain.FoodLog, AppError>> create(domain.FoodLog entity) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(foodLogs).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('food_logs', e, stack));
    }
  }

  /// Update an existing food log.
  Future<Result<domain.FoodLog, AppError>> updateEntity(
    domain.FoodLog entity,
  ) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        foodLogs,
      )..where((f) => f.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('food_logs', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a food log.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            foodLogs,
          )..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull())).write(
            FoodLogsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FoodLog', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('food_logs', id, e, stack));
    }
  }

  /// Hard delete a food log.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        foodLogs,
      )..where((f) => f.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FoodLog', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('food_logs', id, e, stack));
    }
  }

  /// Get food logs by profile with optional date filters.
  Future<Result<List<domain.FoodLog>, AppError>> getByProfile(
    String profileId, {
    int? startDate,
    int? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(foodLogs)
        ..where((f) => f.profileId.equals(profileId) & f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.desc(f.timestamp)]);

      if (startDate != null) {
        query = query
          ..where((f) => f.timestamp.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query = query..where((f) => f.timestamp.isSmallerOrEqualValue(endDate));
      }
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Get food logs for a specific date.
  Future<Result<List<domain.FoodLog>, AppError>> getForDate(
    String profileId,
    int date,
  ) async {
    try {
      // Get entries within the day (date to date + 24 hours)
      final endOfDay = date + 86400000; // 24 hours in ms
      final query = select(foodLogs)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.syncDeletedAt.isNull() &
              f.timestamp.isBiggerOrEqualValue(date) &
              f.timestamp.isSmallerThanValue(endOfDay),
        )
        ..orderBy([(f) => OrderingTerm.desc(f.timestamp)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Get food logs within a date range.
  Future<Result<List<domain.FoodLog>, AppError>> getByDateRange(
    String profileId,
    int startDate,
    int endDate,
  ) async {
    try {
      final query = select(foodLogs)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.syncDeletedAt.isNull() &
              f.timestamp.isBiggerOrEqualValue(startDate) &
              f.timestamp.isSmallerOrEqualValue(endDate),
        )
        ..orderBy([(f) => OrderingTerm.desc(f.timestamp)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.FoodLog>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(foodLogs)
        ..where((f) => f.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.FoodLog>, AppError>> getPendingSync() async {
    try {
      final query = select(foodLogs)
        ..where((f) => f.syncIsDirty.equals(true))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_logs', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.FoodLog _rowToEntity(FoodLogRow row) => domain.FoodLog(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    timestamp: row.timestamp,
    mealType: row.mealType != null ? MealType.fromValue(row.mealType!) : null,
    foodItemIds: _parseJsonList(row.foodItemIds),
    adHocItems: _parseJsonList(row.adHocItems),
    notes: row.notes,
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
  FoodLogsCompanion _entityToCompanion(domain.FoodLog entity) =>
      FoodLogsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        timestamp: Value(entity.timestamp),
        mealType: Value(entity.mealType?.value),
        foodItemIds: Value(jsonEncode(entity.foodItemIds)),
        adHocItems: Value(jsonEncode(entity.adHocItems)),
        notes: Value(entity.notes),
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

  /// Parse JSON array string to list.
  List<String> _parseJsonList(String value) {
    if (value.isEmpty) return [];
    try {
      final list = jsonDecode(value) as List<dynamic>;
      return list.map((item) => item.toString()).toList();
    } on Exception {
      return [];
    }
  }
}
