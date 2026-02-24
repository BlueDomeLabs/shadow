// lib/domain/entities/food_item.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.11
// Updated in Phase 15a: new Packaged type, barcode/brand/ingredients fields, sodium

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

/// FoodItem entity for reusable food items.
///
/// Per 22_API_CONTRACTS.md Section 10.11 + 59a_FOOD_DATABASE_EXTENSION.md.
/// Supports Simple, Composed (recipe), and Packaged (barcode product) types.
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
    @Default([]) List<String> simpleItemIds, // For composed items
    @Default(true) bool isUserCreated,
    @Default(false) bool isArchived,

    // Nutritional information (optional for all types)
    String? servingSize, // e.g., "1 cup", "100g"
    double? calories, // kcal per serving
    double? carbsGrams, // Carbohydrates in grams
    double? fatGrams, // Fat in grams
    double? proteinGrams, // Protein in grams
    double? fiberGrams, // Fiber in grams
    double? sugarGrams, // Sugar in grams
    double? sodiumMg, // Sodium in milligrams — Phase 15a
    // Packaged item fields (nullable, Packaged type only) — Phase 15a
    String? barcode, // UPC or EAN barcode number
    String? brand, // Manufacturer or brand name
    String? ingredientsText, // Raw ingredients list as printed on label
    String? openFoodFactsId, // Open Food Facts product identifier
    String? importSource, // "open_food_facts", "claude_scan", or "manual"
    String? imageUrl, // Product image URL from Open Food Facts

    required SyncMetadata syncMetadata,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  /// Whether this is a composed item (recipe).
  bool get isComposed => type == FoodItemType.composed;

  /// Whether this is a simple item.
  bool get isSimple => type == FoodItemType.simple;

  /// Whether this is a packaged item (manufactured product with barcode).
  bool get isPackaged => type == FoodItemType.packaged;

  /// Whether this item has any nutritional info.
  bool get hasNutritionalInfo => calories != null || carbsGrams != null;

  /// Whether this item is currently active (not archived).
  bool get isActive => !isArchived && syncMetadata.syncDeletedAt == null;
}
