// lib/data/datasources/local/daos/food_item_component_dao.dart
// Phase 15a — DAO for food_item_components join table
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/food_item_components_table.dart';
import 'package:shadow_app/domain/entities/food_item_component.dart';

part 'food_item_component_dao.g.dart';

/// Data Access Object for the food_item_components join table.
@DriftAccessor(tables: [FoodItemComponents])
class FoodItemComponentDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemComponentDaoMixin {
  FoodItemComponentDao(super.db);

  /// Get all components for a composed food item, ordered by sort_order.
  Future<Result<List<FoodItemComponent>, AppError>> getForComposedItem(
    String composedFoodItemId,
  ) async {
    try {
      final rows =
          await (select(foodItemComponents)
                ..where((c) => c.composedFoodItemId.equals(composedFoodItemId))
                ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_item_components', e.toString(), stack),
      );
    }
  }

  /// Replace all components for a composed food item.
  ///
  /// Deletes existing components and inserts the new list in a transaction.
  Future<Result<void, AppError>> replaceComponents(
    String composedFoodItemId,
    List<FoodItemComponent> components,
  ) async {
    try {
      await transaction(() async {
        await (delete(
          foodItemComponents,
        )..where((c) => c.composedFoodItemId.equals(composedFoodItemId))).go();
        for (final component in components) {
          await into(foodItemComponents).insert(_entityToCompanion(component));
        }
      });
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('food_item_components', e, stack),
      );
    }
  }

  /// Delete all components for a composed food item.
  Future<Result<void, AppError>> deleteForComposedItem(
    String composedFoodItemId,
  ) async {
    try {
      await (delete(
        foodItemComponents,
      )..where((c) => c.composedFoodItemId.equals(composedFoodItemId))).go();
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed(
          'food_item_components',
          composedFoodItemId,
          e,
          stack,
        ),
      );
    }
  }

  FoodItemComponent _rowToEntity(FoodItemComponentRow row) => FoodItemComponent(
    id: row.id,
    composedFoodItemId: row.composedFoodItemId,
    simpleFoodItemId: row.simpleFoodItemId,
    quantity: row.quantity,
    sortOrder: row.sortOrder,
  );

  FoodItemComponentsCompanion _entityToCompanion(FoodItemComponent e) =>
      FoodItemComponentsCompanion(
        id: Value(e.id),
        composedFoodItemId: Value(e.composedFoodItemId),
        simpleFoodItemId: Value(e.simpleFoodItemId),
        quantity: Value(e.quantity),
        sortOrder: Value(e.sortOrder),
      );
}
