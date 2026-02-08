// lib/domain/usecases/food_logs/log_food_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/repositories/food_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to log food consumption.
class LogFoodUseCase implements UseCase<LogFoodInput, FoodLog> {
  final FoodLogRepository _repository;
  final FoodItemRepository _foodItemRepository;
  final ProfileAuthorizationService _authService;

  LogFoodUseCase(this._repository, this._foodItemRepository, this._authService);

  @override
  Future<Result<FoodLog, AppError>> call(LogFoodInput input) async {
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

    final log = FoodLog(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      timestamp: input.timestamp,
      mealType: input.mealType,
      foodItemIds: input.foodItemIds,
      adHocItems: input.adHocItems,
      notes: input.notes.isEmpty ? null : input.notes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(log);
  }

  Future<ValidationError?> _validate(LogFoodInput input) async {
    final errors = <String, List<String>>{};

    // Must have at least one food item (predefined or ad-hoc)
    if (input.foodItemIds.isEmpty && input.adHocItems.isEmpty) {
      errors['items'] = ['At least one food item is required'];
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + (60 * 60 * 1000);
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = [
        'Timestamp cannot be more than 1 hour in the future',
      ];
    }

    // Notes max length
    if (input.notes.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    // Verify food item IDs exist and belong to profile
    for (final itemId in input.foodItemIds) {
      final result = await _foodItemRepository.getById(itemId);
      if (result.isFailure) {
        errors['foodItemIds'] = ['Food item not found: $itemId'];
        break;
      }
      final item = result.valueOrNull!;
      if (item.profileId != input.profileId) {
        errors['foodItemIds'] = ['Food item does not belong to this profile'];
        break;
      }
    }

    // Validate ad-hoc item names (2-100 characters each)
    for (final name in input.adHocItems) {
      if (name.length < 2 || name.length > 100) {
        errors['adHocItems'] = ['Ad-hoc item names must be 2-100 characters'];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
