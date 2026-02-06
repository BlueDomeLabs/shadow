// lib/domain/usecases/food_items/get_food_items_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';

/// Use case to get food items for a profile.
class GetFoodItemsUseCase
    implements UseCase<GetFoodItemsInput, List<FoodItem>> {
  final FoodItemRepository _repository;
  final ProfileAuthorizationService _authService;

  GetFoodItemsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FoodItem>, AppError>> call(GetFoodItemsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch from repository
    return _repository.getByProfile(
      input.profileId,
      type: input.type,
      includeArchived: input.includeArchived,
    );
  }
}
