// lib/domain/usecases/food_items/update_food_item_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_item_component.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to update an existing food item.
class UpdateFoodItemUseCase implements UseCase<UpdateFoodItemInput, FoodItem> {
  final FoodItemRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateFoodItemUseCase(this._repository, this._authService);

  @override
  Future<Result<FoodItem, AppError>> call(UpdateFoodItemInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the item belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // Derive simpleItemIds from components if components are provided
    final componentIds =
        (input.components != null && input.components!.isNotEmpty)
        ? input.components!.map((c) => c.simpleFoodItemId).toList()
        : input.simpleItemIds;

    // 3. Apply updates
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      type: input.type ?? existing.type,
      simpleItemIds: componentIds ?? existing.simpleItemIds,
      servingSize: input.servingSize ?? existing.servingSize,
      calories: input.calories ?? existing.calories,
      carbsGrams: input.carbsGrams ?? existing.carbsGrams,
      fatGrams: input.fatGrams ?? existing.fatGrams,
      proteinGrams: input.proteinGrams ?? existing.proteinGrams,
      fiberGrams: input.fiberGrams ?? existing.fiberGrams,
      sugarGrams: input.sugarGrams ?? existing.sugarGrams,
      sodiumMg: input.sodiumMg ?? existing.sodiumMg,
      barcode: input.barcode ?? existing.barcode,
      brand: input.brand ?? existing.brand,
      ingredientsText: input.ingredientsText ?? existing.ingredientsText,
      openFoodFactsId: input.openFoodFactsId ?? existing.openFoodFactsId,
      importSource: input.importSource ?? existing.importSource,
      imageUrl: input.imageUrl ?? existing.imageUrl,
    );

    // 4. Validation
    final validationError = await _validate(updated, input.profileId);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    final updateResult = await _repository.update(updated);
    if (updateResult.isFailure) return updateResult;

    // 6. Replace components if provided (Phase 15a — composed items with quantity multipliers)
    if (input.components != null &&
        (input.type ?? existing.type) == FoodItemType.composed) {
      var sortOrder = 0;
      final components = input.components!
          .map(
            (c) => FoodItemComponent(
              id: const Uuid().v4(),
              composedFoodItemId: existing.id,
              simpleFoodItemId: c.simpleFoodItemId,
              quantity: c.quantity,
              sortOrder: sortOrder++,
            ),
          )
          .toList();
      await _repository.replaceComponents(existing.id, components);
    }

    return updateResult;
  }

  Future<ValidationError?> _validate(FoodItem item, String profileId) async {
    final errors = <String, List<String>>{};

    // Name validation
    if (item.name.length < ValidationRules.nameMinLength ||
        item.name.length > ValidationRules.foodNameMaxLength) {
      errors['name'] = [
        'Food item name must be ${ValidationRules.nameMinLength}-${ValidationRules.foodNameMaxLength} characters',
      ];
    }

    // Composed items must have simple item IDs
    if (item.type == FoodItemType.composed && item.simpleItemIds.isEmpty) {
      errors['simpleItemIds'] = [
        'Composed items must include at least one simple item',
      ];
    }

    // Simple and packaged items should not have simple item IDs
    if (item.type == FoodItemType.simple && item.simpleItemIds.isNotEmpty) {
      errors['simpleItemIds'] = ['Simple items cannot have component items'];
    }
    if (item.type == FoodItemType.packaged && item.simpleItemIds.isNotEmpty) {
      errors['simpleItemIds'] = ['Packaged items cannot have component items'];
    }

    // Verify simple item IDs exist and belong to profile
    for (final itemId in item.simpleItemIds) {
      final result = await _repository.getById(itemId);
      if (result.isFailure) {
        errors['simpleItemIds'] = ['Food item not found: $itemId'];
        break;
      }
      final foundItem = result.valueOrNull!;
      if (foundItem.profileId != profileId) {
        errors['simpleItemIds'] = ['Food item does not belong to this profile'];
        break;
      }
      // Prevent nesting complex items
      if (foundItem.isComposed) {
        errors['simpleItemIds'] = ['Cannot nest complex items'];
        break;
      }
      // Prevent self-reference
      if (foundItem.id == item.id) {
        errors['simpleItemIds'] = ['Item cannot reference itself'];
        break;
      }
    }

    // Nutritional values must be non-negative if provided
    if (item.calories != null && item.calories! < 0) {
      errors['calories'] = ['Calories cannot be negative'];
    }
    if (item.carbsGrams != null && item.carbsGrams! < 0) {
      errors['carbsGrams'] = ['Carbs cannot be negative'];
    }
    if (item.fatGrams != null && item.fatGrams! < 0) {
      errors['fatGrams'] = ['Fat cannot be negative'];
    }
    if (item.proteinGrams != null && item.proteinGrams! < 0) {
      errors['proteinGrams'] = ['Protein cannot be negative'];
    }
    if (item.fiberGrams != null && item.fiberGrams! < 0) {
      errors['fiberGrams'] = ['Fiber cannot be negative'];
    }
    if (item.sugarGrams != null && item.sugarGrams! < 0) {
      errors['sugarGrams'] = ['Sugar cannot be negative'];
    }

    // Serving size max length
    if (item.servingSize != null &&
        item.servingSize!.length > ValidationRules.servingSizeMaxLength) {
      errors['servingSize'] = [
        'Serving size must be ${ValidationRules.servingSizeMaxLength} characters or less',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
