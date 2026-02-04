// lib/data/datasources/local/daos/supplement_dao.dart
// Data Access Object for supplements table per 22_API_CONTRACTS.md Section 4.2

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/supplements_table.dart';
import 'package:shadow_app/domain/entities/supplement.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'supplement_dao.g.dart';

/// Data Access Object for the supplements table.
///
/// Implements all database operations for Supplement entities.
/// Returns Result types for all operations per 22_API_CONTRACTS.md.
@DriftAccessor(tables: [Supplements])
class SupplementDao extends DatabaseAccessor<AppDatabase>
    with _$SupplementDaoMixin {
  SupplementDao(super.db);

  /// Get all supplements, optionally filtered by profile.
  Future<Result<List<domain.Supplement>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(supplements)
        ..where((s) => s.syncDeletedAt.isNull())
        ..orderBy([(s) => OrderingTerm.desc(s.syncCreatedAt)]);

      if (profileId != null) {
        query = query..where((s) => s.profileId.equals(profileId));
      }

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('supplements', e.toString(), stack),
      );
    }
  }

  /// Get a single supplement by ID.
  Future<Result<domain.Supplement, AppError>> getById(String id) async {
    try {
      final query = select(supplements)
        ..where((s) => s.id.equals(id) & s.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();

      if (row == null) {
        return Failure(DatabaseError.notFound('Supplement', id));
      }

      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('supplements', e.toString(), stack),
      );
    }
  }

  /// Create a new supplement.
  Future<Result<domain.Supplement, AppError>> create(
    domain.Supplement entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(supplements).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('supplements', e, stack));
    }
  }

  /// Update an existing supplement.
  Future<Result<domain.Supplement, AppError>> updateEntity(
    domain.Supplement entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) {
        return existsResult;
      }

      final companion = _entityToCompanion(entity);
      await (update(
        supplements,
      )..where((s) => s.id.equals(entity.id))).write(companion);

      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('supplements', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a supplement.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            supplements,
          )..where((s) => s.id.equals(id) & s.syncDeletedAt.isNull())).write(
            SupplementsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Supplement', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('supplements', id, e, stack));
    }
  }

  /// Hard delete a supplement (permanent removal).
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        supplements,
      )..where((s) => s.id.equals(id))).go();

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('Supplement', id));
      }

      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('supplements', id, e, stack));
    }
  }

  /// Get supplements modified since timestamp (for sync).
  Future<Result<List<domain.Supplement>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(supplements)
        ..where((s) => s.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(s) => OrderingTerm.asc(s.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('supplements', e.toString(), stack),
      );
    }
  }

  /// Get supplements pending sync.
  Future<Result<List<domain.Supplement>, AppError>> getPendingSync() async {
    try {
      final query = select(supplements)
        ..where((s) => s.syncIsDirty.equals(true))
        ..orderBy([(s) => OrderingTerm.asc(s.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('supplements', e.toString(), stack),
      );
    }
  }

  /// Get supplements by profile with optional active filter.
  Future<Result<List<domain.Supplement>, AppError>> getByProfile(
    String profileId, {
    bool? activeOnly,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(supplements)
        ..where((s) => s.profileId.equals(profileId) & s.syncDeletedAt.isNull())
        ..orderBy([(s) => OrderingTerm.asc(s.name)]);

      if (activeOnly ?? false) {
        query = query..where((s) => s.isArchived.equals(false));
      }

      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('supplements', e.toString(), stack),
      );
    }
  }

  /// Search supplements by name.
  Future<Result<List<domain.Supplement>, AppError>> search(
    String profileId,
    String query, {
    int limit = 20,
  }) async {
    try {
      final searchPattern = '%$query%';
      final dbQuery = select(supplements)
        ..where(
          (s) =>
              s.profileId.equals(profileId) &
              s.syncDeletedAt.isNull() &
              s.name.like(searchPattern),
        )
        ..orderBy([(s) => OrderingTerm.asc(s.name)])
        ..limit(limit);

      final rows = await dbQuery.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('supplements', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain Supplement entity.
  domain.Supplement _rowToEntity(SupplementRow row) {
    final ingredientsList = _parseIngredients(row.ingredients);
    final schedulesList = _parseSchedules(row.schedules);

    return domain.Supplement(
      id: row.id,
      clientId: row.clientId,
      profileId: row.profileId,
      name: row.name,
      form: SupplementForm.fromValue(row.form),
      customForm: row.customForm,
      dosageQuantity: row.dosageQuantity,
      dosageUnit: DosageUnit.fromValue(row.dosageUnit),
      brand: row.brand,
      notes: row.notes,
      ingredients: ingredientsList,
      schedules: schedulesList,
      startDate: row.startDate,
      endDate: row.endDate,
      isArchived: row.isArchived,
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
  }

  /// Convert domain Supplement entity to database companion.
  SupplementsCompanion _entityToCompanion(domain.Supplement entity) =>
      SupplementsCompanion(
        id: Value(entity.id),
        clientId: Value(entity.clientId),
        profileId: Value(entity.profileId),
        name: Value(entity.name),
        form: Value(entity.form.value),
        customForm: Value(entity.customForm),
        dosageQuantity: Value(entity.dosageQuantity),
        dosageUnit: Value(entity.dosageUnit.value),
        brand: Value(entity.brand),
        notes: Value(entity.notes),
        ingredients: Value(
          jsonEncode(entity.ingredients.map((i) => i.toJson()).toList()),
        ),
        schedules: Value(
          jsonEncode(entity.schedules.map((s) => s.toJson()).toList()),
        ),
        startDate: Value(entity.startDate),
        endDate: Value(entity.endDate),
        isArchived: Value(entity.isArchived),
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

  List<domain.SupplementIngredient> _parseIngredients(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map(
            (item) => domain.SupplementIngredient.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } on Exception {
      return [];
    }
  }

  List<domain.SupplementSchedule> _parseSchedules(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map(
            (item) => domain.SupplementSchedule.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } on Exception {
      return [];
    }
  }
}
