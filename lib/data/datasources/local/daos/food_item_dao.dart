// lib/data/datasources/local/daos/food_item_dao.dart
// Data Access Object for food_items table per 22_API_CONTRACTS.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/food_items_table.dart';
import 'package:shadow_app/domain/entities/food_item.dart' as domain;
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'food_item_dao.g.dart';

/// Data Access Object for the food_items table.
@DriftAccessor(tables: [FoodItems])
class FoodItemDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemDaoMixin {
  FoodItemDao(super.db);

  /// Get all food items.
  Future<Result<List<domain.FoodItem>, AppError>> getAll({
    String? profileId,
    int? limit,
    int? offset,
  }) async {
    try {
      var query = select(foodItems)
        ..where((f) => f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.asc(f.name)]);

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
        DatabaseError.queryFailed('food_items', e.toString(), stack),
      );
    }
  }

  /// Get a single food item by ID.
  Future<Result<domain.FoodItem, AppError>> getById(String id) async {
    try {
      final query = select(foodItems)
        ..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull());

      final row = await query.getSingleOrNull();
      if (row == null) {
        return Failure(DatabaseError.notFound('FoodItem', id));
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_items', e.toString(), stack),
      );
    }
  }

  /// Create a new food item.
  Future<Result<domain.FoodItem, AppError>> create(
    domain.FoodItem entity,
  ) async {
    try {
      final companion = _entityToCompanion(entity);
      await into(foodItems).insert(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      if (e.toString().contains('UNIQUE constraint failed')) {
        return Failure(
          DatabaseError.constraintViolation('Duplicate ID: ${entity.id}'),
        );
      }
      return Failure(DatabaseError.insertFailed('food_items', e, stack));
    }
  }

  /// Update an existing food item.
  Future<Result<domain.FoodItem, AppError>> updateEntity(
    domain.FoodItem entity, {
    bool markDirty = true,
  }) async {
    try {
      final existsResult = await getById(entity.id);
      if (existsResult.isFailure) return existsResult;

      final companion = _entityToCompanion(entity);
      await (update(
        foodItems,
      )..where((f) => f.id.equals(entity.id))).write(companion);
      return getById(entity.id);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.updateFailed('food_items', entity.id, e, stack),
      );
    }
  }

  /// Soft delete a food item.
  Future<Result<void, AppError>> softDelete(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            foodItems,
          )..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull())).write(
            FoodItemsCompanion(
              syncDeletedAt: Value(now),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
              syncStatus: Value(SyncStatus.deleted.value),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FoodItem', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('food_items', id, e, stack));
    }
  }

  /// Hard delete a food item.
  Future<Result<void, AppError>> hardDelete(String id) async {
    try {
      final rowsAffected = await (delete(
        foodItems,
      )..where((f) => f.id.equals(id))).go();
      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FoodItem', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.deleteFailed('food_items', id, e, stack));
    }
  }

  /// Get food items by profile with optional type and archive filters.
  Future<Result<List<domain.FoodItem>, AppError>> getByProfile(
    String profileId, {
    FoodItemType? type,
    bool includeArchived = false,
  }) async {
    try {
      var query = select(foodItems)
        ..where((f) => f.profileId.equals(profileId) & f.syncDeletedAt.isNull())
        ..orderBy([(f) => OrderingTerm.asc(f.name)]);

      if (type != null) {
        query = query..where((f) => f.type.equals(type.value));
      }
      if (!includeArchived) {
        query = query..where((f) => f.isArchived.equals(false));
      }

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_items', e.toString(), stack),
      );
    }
  }

  /// Search food items by name.
  Future<Result<List<domain.FoodItem>, AppError>> search(
    String profileId,
    String query, {
    int limit = 20,
  }) async {
    try {
      final searchQuery = select(foodItems)
        ..where(
          (f) =>
              f.profileId.equals(profileId) &
              f.syncDeletedAt.isNull() &
              f.isArchived.equals(false) &
              f.name.like('%$query%'),
        )
        ..orderBy([(f) => OrderingTerm.asc(f.name)])
        ..limit(limit);

      final rows = await searchQuery.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_items', e.toString(), stack),
      );
    }
  }

  /// Archive a food item.
  Future<Result<void, AppError>> archive(String id) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final rowsAffected =
          await (update(
            foodItems,
          )..where((f) => f.id.equals(id) & f.syncDeletedAt.isNull())).write(
            FoodItemsCompanion(
              isArchived: const Value(true),
              syncUpdatedAt: Value(now),
              syncIsDirty: const Value(true),
            ),
          );

      if (rowsAffected == 0) {
        return Failure(DatabaseError.notFound('FoodItem', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(DatabaseError.updateFailed('food_items', id, e, stack));
    }
  }

  /// Get modified since timestamp.
  Future<Result<List<domain.FoodItem>, AppError>> getModifiedSince(
    int since,
  ) async {
    try {
      final query = select(foodItems)
        ..where((f) => f.syncUpdatedAt.isBiggerThanValue(since))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_items', e.toString(), stack),
      );
    }
  }

  /// Get entries pending sync.
  Future<Result<List<domain.FoodItem>, AppError>> getPendingSync() async {
    try {
      final query = select(foodItems)
        ..where((f) => f.syncIsDirty.equals(true))
        ..orderBy([(f) => OrderingTerm.asc(f.syncUpdatedAt)]);

      final rows = await query.get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_items', e.toString(), stack),
      );
    }
  }

  /// Convert database row to domain entity.
  domain.FoodItem _rowToEntity(FoodItemRow row) => domain.FoodItem(
    id: row.id,
    clientId: row.clientId,
    profileId: row.profileId,
    name: row.name,
    type: FoodItemType.fromValue(row.type),
    simpleItemIds: _parseList(row.simpleItemIds),
    isUserCreated: row.isUserCreated,
    isArchived: row.isArchived,
    servingSize: _buildServingSize(row.servingSize, row.servingUnit),
    calories: row.calories,
    carbsGrams: row.carbsGrams,
    fatGrams: row.fatGrams,
    proteinGrams: row.proteinGrams,
    fiberGrams: row.fiberGrams,
    sugarGrams: row.sugarGrams,
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
  FoodItemsCompanion _entityToCompanion(domain.FoodItem entity) {
    final (servingSize, servingUnit) = _parseServingSize(entity.servingSize);
    return FoodItemsCompanion(
      id: Value(entity.id),
      clientId: Value(entity.clientId),
      profileId: Value(entity.profileId),
      name: Value(entity.name),
      type: Value(entity.type.value),
      simpleItemIds: Value(entity.simpleItemIds.join(',')),
      isUserCreated: Value(entity.isUserCreated),
      isArchived: Value(entity.isArchived),
      servingSize: Value(servingSize),
      servingUnit: Value(servingUnit),
      calories: Value(entity.calories),
      carbsGrams: Value(entity.carbsGrams),
      fatGrams: Value(entity.fatGrams),
      proteinGrams: Value(entity.proteinGrams),
      fiberGrams: Value(entity.fiberGrams),
      sugarGrams: Value(entity.sugarGrams),
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

  /// Parse comma-separated string to list.
  List<String> _parseList(String? value) {
    if (value == null || value.isEmpty) return [];
    return value.split(',').where((s) => s.isNotEmpty).toList();
  }

  /// Build serving size string from numeric value and unit.
  String? _buildServingSize(double? size, String? unit) {
    if (size == null) return null;
    if (unit == null || unit.isEmpty) return size.toString();
    // Format as "1 cup" or "100 g"
    final sizeStr = size == size.truncate()
        ? size.truncate().toString()
        : size.toString();
    return '$sizeStr $unit';
  }

  /// Parse serving size string to numeric value and unit.
  (double?, String?) _parseServingSize(String? servingSize) {
    if (servingSize == null || servingSize.isEmpty) return (null, null);
    // Try to parse "1 cup" or "100g" format
    final parts = servingSize.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return (null, null);
    final size = double.tryParse(parts[0]);
    final unit = parts.length > 1 ? parts.sublist(1).join(' ') : null;
    return (size, unit);
  }
}
