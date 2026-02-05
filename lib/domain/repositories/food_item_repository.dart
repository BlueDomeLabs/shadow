// lib/domain/repositories/food_item_repository.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.11

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/entity_repository.dart';

/// Repository contract for FoodItem entities.
///
/// Extends EntityRepository with food-item-specific query methods.
abstract class FoodItemRepository
    implements EntityRepository<FoodItem, String> {
  // Inherited from EntityRepository:
  // - getAll, getById, create, update, delete, hardDelete
  // - getModifiedSince, getPendingSync

  /// Get food items for a profile with optional type and archive filters.
  Future<Result<List<FoodItem>, AppError>> getByProfile(
    String profileId, {
    FoodItemType? type,
    bool includeArchived = false,
  });

  /// Search food items by name.
  Future<Result<List<FoodItem>, AppError>> search(
    String profileId,
    String query, {
    int limit = 20,
  });

  /// Archive a food item.
  Future<Result<void, AppError>> archive(String id);

  /// Search food items excluding specific categories.
  Future<Result<List<FoodItem>, AppError>> searchExcludingCategories(
    String profileId,
    String query, {
    required List<String> excludeCategories,
    int limit = 20,
  });
}
