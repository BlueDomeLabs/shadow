// lib/domain/usecases/food_items/food_item_inputs.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'food_item_inputs.freezed.dart';

/// A single ingredient component for a Composed food item.
///
/// Stores a reference to a Simple food item and the quantity multiplier
/// representing how many servings of that item are used in the dish.
class FoodItemComponentInput {
  final String simpleFoodItemId;
  final double quantity;

  const FoodItemComponentInput({
    required this.simpleFoodItemId,
    required this.quantity,
  });
}

@freezed
class CreateFoodItemInput with _$CreateFoodItemInput {
  const factory CreateFoodItemInput({
    required String profileId,
    required String clientId,
    required String name,
    @Default(FoodItemType.simple) FoodItemType type,
    @Default([]) List<String> simpleItemIds,
    @Default([]) List<FoodItemComponentInput> components,
    String? servingSize,
    double? calories,
    double? carbsGrams,
    double? fatGrams,
    double? proteinGrams,
    double? fiberGrams,
    double? sugarGrams,
    // Phase 15a fields
    double? sodiumMg,
    String? barcode,
    String? brand,
    String? ingredientsText,
    String? openFoodFactsId,
    String? importSource,
    String? imageUrl,
  }) = _CreateFoodItemInput;
}

@freezed
class GetFoodItemsInput with _$GetFoodItemsInput {
  const factory GetFoodItemsInput({
    required String profileId,
    FoodItemType? type,
    @Default(false) bool includeArchived,
    int? limit,
    int? offset,
  }) = _GetFoodItemsInput;
}

@freezed
class SearchFoodItemsInput with _$SearchFoodItemsInput {
  const factory SearchFoodItemsInput({
    required String profileId,
    required String query,
    @Default(20) int limit, // Value matches ValidationRules.defaultSearchLimit
  }) = _SearchFoodItemsInput;
}

@freezed
class UpdateFoodItemInput with _$UpdateFoodItemInput {
  const factory UpdateFoodItemInput({
    required String id,
    required String profileId,
    String? name,
    FoodItemType? type,
    List<String>? simpleItemIds,
    List<FoodItemComponentInput>? components,
    String? servingSize,
    double? calories,
    double? carbsGrams,
    double? fatGrams,
    double? proteinGrams,
    double? fiberGrams,
    double? sugarGrams,
    // Phase 15a fields
    double? sodiumMg,
    String? barcode,
    String? brand,
    String? ingredientsText,
    String? openFoodFactsId,
    String? importSource,
    String? imageUrl,
  }) = _UpdateFoodItemInput;
}

/// Input for LookupBarcodeUseCase.
@freezed
class LookupBarcodeInput with _$LookupBarcodeInput {
  const factory LookupBarcodeInput({required String barcode}) =
      _LookupBarcodeInput;
}

@freezed
class ArchiveFoodItemInput with _$ArchiveFoodItemInput {
  const factory ArchiveFoodItemInput({
    required String id,
    required String profileId,
    @Default(true) bool archive, // false to unarchive
  }) = _ArchiveFoodItemInput;
}
