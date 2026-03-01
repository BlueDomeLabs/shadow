// lib/domain/usecases/food_items/create_food_item_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_item_component.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new food item.
class CreateFoodItemUseCase implements UseCase<CreateFoodItemInput, FoodItem> {
  final FoodItemRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateFoodItemUseCase(this._repository, this._authService);

  @override
  Future<Result<FoodItem, AppError>> call(CreateFoodItemInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = await _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    // Derive simpleItemIds from components if components are provided
    final componentIds = input.components.isNotEmpty
        ? input.components.map((c) => c.simpleFoodItemId).toList()
        : input.simpleItemIds;

    final foodItem = FoodItem(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      type: input.type,
      simpleItemIds: componentIds,
      servingSize: input.servingSize,
      calories: input.calories,
      carbsGrams: input.carbsGrams,
      fatGrams: input.fatGrams,
      proteinGrams: input.proteinGrams,
      fiberGrams: input.fiberGrams,
      sugarGrams: input.sugarGrams,
      sodiumMg: input.sodiumMg,
      barcode: input.barcode,
      brand: input.brand,
      ingredientsText: input.ingredientsText,
      openFoodFactsId: input.openFoodFactsId,
      importSource: input.importSource,
      imageUrl: input.imageUrl,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    final createResult = await _repository.create(foodItem);
    if (createResult.isFailure) return createResult;

    // 5. Store components if provided (Phase 15a — composed items with quantity multipliers)
    if (input.type == FoodItemType.composed && input.components.isNotEmpty) {
      var sortOrder = 0;
      final components = input.components
          .map(
            (c) => FoodItemComponent(
              id: const Uuid().v4(),
              composedFoodItemId: id,
              simpleFoodItemId: c.simpleFoodItemId,
              quantity: c.quantity,
              sortOrder: sortOrder++,
            ),
          )
          .toList();
      await _repository.replaceComponents(id, components);
    }

    return createResult;
  }

  Future<ValidationError?> _validate(CreateFoodItemInput input) async {
    final errors = <String, List<String>>{};

    // Name validation
    final nameError = ValidationRules.foodName(input.name);
    if (nameError != null) errors['name'] = [nameError];

    // Composed items must have simple item IDs
    if (input.type == FoodItemType.composed && input.simpleItemIds.isEmpty) {
      errors['simpleItemIds'] = [
        'Composed items must include at least one simple item',
      ];
    }

    // Simple and packaged items should not have simple item IDs
    if (input.type == FoodItemType.simple && input.simpleItemIds.isNotEmpty) {
      errors['simpleItemIds'] = ['Simple items cannot have component items'];
    }
    if (input.type == FoodItemType.packaged && input.simpleItemIds.isNotEmpty) {
      errors['simpleItemIds'] = ['Packaged items cannot have component items'];
    }

    // Verify simple item IDs exist and belong to profile (only for composed items)
    if (input.type == FoodItemType.composed) {
      for (final itemId in input.simpleItemIds) {
        final result = await _repository.getById(itemId);
        if (result.isFailure) {
          errors['simpleItemIds'] = ['Food item not found: $itemId'];
          break;
        }
        final item = result.valueOrNull!;
        if (item.profileId != input.profileId) {
          errors['simpleItemIds'] = [
            'Food item does not belong to this profile',
          ];
          break;
        }
        // Prevent nesting complex items
        if (item.isComposed) {
          errors['simpleItemIds'] = ['Cannot nest complex items'];
          break;
        }
      }
    }

    // Nutritional values must be non-negative if provided
    if (input.calories != null && input.calories! < 0) {
      errors['calories'] = ['Calories cannot be negative'];
    }
    if (input.carbsGrams != null && input.carbsGrams! < 0) {
      errors['carbsGrams'] = ['Carbs cannot be negative'];
    }
    if (input.fatGrams != null && input.fatGrams! < 0) {
      errors['fatGrams'] = ['Fat cannot be negative'];
    }
    if (input.proteinGrams != null && input.proteinGrams! < 0) {
      errors['proteinGrams'] = ['Protein cannot be negative'];
    }
    if (input.fiberGrams != null && input.fiberGrams! < 0) {
      errors['fiberGrams'] = ['Fiber cannot be negative'];
    }
    if (input.sugarGrams != null && input.sugarGrams! < 0) {
      errors['sugarGrams'] = ['Sugar cannot be negative'];
    }

    // Serving size max length
    if (input.servingSize != null &&
        input.servingSize!.length > ValidationRules.servingSizeMaxLength) {
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
