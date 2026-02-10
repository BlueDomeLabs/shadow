// lib/domain/entities/food_item.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.11

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

/// FoodItem entity for reusable food items.
///
/// Per 22_API_CONTRACTS.md Section 10.11.
/// Supports simple items and complex items (recipes composed of simple items).
@Freezed(toJson: true, fromJson: true)
class FoodItem with _$FoodItem implements Syncable {
  const FoodItem._();

  @JsonSerializable(explicitToJson: true)
  const factory FoodItem({
    required String id,
    required String clientId,
    required String profileId,
    required String name,
    @Default(FoodItemType.simple) FoodItemType type,
    @Default([]) List<String> simpleItemIds, // For complex items
    @Default(true) bool isUserCreated,
    @Default(false) bool isArchived,

    // Nutritional information (optional)
    String? servingSize, // e.g., "1 cup", "100g"
    double? calories, // kcal per serving
    double? carbsGrams, // Carbohydrates in grams
    double? fatGrams, // Fat in grams
    double? proteinGrams, // Protein in grams
    double? fiberGrams, // Fiber in grams
    double? sugarGrams, // Sugar in grams
    required SyncMetadata syncMetadata,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  /// Whether this is a complex item (recipe).
  bool get isComplex => type == FoodItemType.complex;

  /// Whether this is a simple item.
  bool get isSimple => type == FoodItemType.simple;

  /// Whether this item has any nutritional info.
  bool get hasNutritionalInfo => calories != null || carbsGrams != null;

  /// Whether this item is currently active (not archived).
  bool get isActive => !isArchived && syncMetadata.syncDeletedAt == null;
}
