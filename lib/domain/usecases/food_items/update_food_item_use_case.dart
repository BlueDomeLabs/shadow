// lib/domain/usecases/food_items/update_food_item_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';

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

    // 3. Apply updates
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      type: input.type ?? existing.type,
      simpleItemIds: input.simpleItemIds ?? existing.simpleItemIds,
      servingSize: input.servingSize ?? existing.servingSize,
      calories: input.calories ?? existing.calories,
      carbsGrams: input.carbsGrams ?? existing.carbsGrams,
      fatGrams: input.fatGrams ?? existing.fatGrams,
      proteinGrams: input.proteinGrams ?? existing.proteinGrams,
      fiberGrams: input.fiberGrams ?? existing.fiberGrams,
      sugarGrams: input.sugarGrams ?? existing.sugarGrams,
    );

    // 4. Validation
    final validationError = await _validate(updated, input.profileId);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  Future<ValidationError?> _validate(FoodItem item, String profileId) async {
    final errors = <String, List<String>>{};

    // Name validation: 2-200 characters per ValidationRules.foodNameMaxLength
    if (item.name.length < 2 || item.name.length > 200) {
      errors['name'] = ['Food item name must be 2-200 characters'];
    }

    // Complex items must have simple item IDs
    if (item.type == FoodItemType.complex && item.simpleItemIds.isEmpty) {
      errors['simpleItemIds'] = [
        'Complex items must include at least one simple item',
      ];
    }

    // Simple items should not have simple item IDs
    if (item.type == FoodItemType.simple && item.simpleItemIds.isNotEmpty) {
      errors['simpleItemIds'] = ['Simple items cannot have component items'];
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
      if (foundItem.isComplex) {
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
    if (item.servingSize != null && item.servingSize!.length > 50) {
      errors['servingSize'] = ['Serving size must be 50 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
