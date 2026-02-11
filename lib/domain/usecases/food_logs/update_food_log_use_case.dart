// lib/domain/usecases/food_logs/update_food_log_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/repositories/food_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';

/// Use case to update an existing food log.
class UpdateFoodLogUseCase implements UseCase<UpdateFoodLogInput, FoodLog> {
  final FoodLogRepository _repository;
  final FoodItemRepository _foodItemRepository;
  final ProfileAuthorizationService _authService;

  UpdateFoodLogUseCase(
    this._repository,
    this._foodItemRepository,
    this._authService,
  );

  @override
  Future<Result<FoodLog, AppError>> call(UpdateFoodLogInput input) async {
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

    // Verify the log belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply updates
    final updated = existing.copyWith(
      mealType: input.mealType ?? existing.mealType,
      foodItemIds: input.foodItemIds ?? existing.foodItemIds,
      adHocItems: input.adHocItems ?? existing.adHocItems,
      notes: input.notes ?? existing.notes,
    );

    // 4. Validation
    final validationError = await _validate(updated, input.profileId);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  Future<ValidationError?> _validate(FoodLog log, String profileId) async {
    final errors = <String, List<String>>{};

    // Must have at least one food item
    if (log.foodItemIds.isEmpty && log.adHocItems.isEmpty) {
      errors['items'] = ['At least one food item is required'];
    }

    // Notes max length
    if (log.notes != null &&
        log.notes!.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    // Verify food item IDs exist and belong to profile
    for (final itemId in log.foodItemIds) {
      final result = await _foodItemRepository.getById(itemId);
      if (result.isFailure) {
        errors['foodItemIds'] = ['Food item not found: $itemId'];
        break;
      }
      final item = result.valueOrNull!;
      if (item.profileId != profileId) {
        errors['foodItemIds'] = ['Food item does not belong to this profile'];
        break;
      }
    }

    // Validate ad-hoc item names
    for (final name in log.adHocItems) {
      if (name.length < ValidationRules.nameMinLength ||
          name.length > ValidationRules.nameMaxLength) {
        errors['adHocItems'] = [
          'Ad-hoc item names must be ${ValidationRules.nameMinLength}-${ValidationRules.nameMaxLength} characters',
        ];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
