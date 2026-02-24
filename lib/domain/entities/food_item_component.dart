// lib/domain/entities/food_item_component.dart
// Phase 15a — Component of a Composed food item (join table entity)
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_item_component.freezed.dart';

/// A component ingredient of a Composed food item.
///
/// Represents one Simple item used in a Composed dish, with a quantity
/// multiplier indicating how many servings of that Simple item are used.
///
/// Per 59a_FOOD_DATABASE_EXTENSION.md — replaces the JSON simpleItemIds
/// array with a proper join table that supports quantity multipliers.
@freezed
class FoodItemComponent with _$FoodItemComponent {
  const factory FoodItemComponent({
    required String id,
    required String composedFoodItemId,
    required String simpleFoodItemId,
    @Default(1) double quantity, // Servings of Simple item used
    @Default(0) int sortOrder,
  }) = _FoodItemComponent;
}
