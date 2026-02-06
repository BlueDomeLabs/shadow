// lib/domain/usecases/food_logs/get_food_logs_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/repositories/food_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';

/// Use case to get food logs for a profile.
class GetFoodLogsUseCase implements UseCase<GetFoodLogsInput, List<FoodLog>> {
  final FoodLogRepository _repository;
  final ProfileAuthorizationService _authService;

  GetFoodLogsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FoodLog>, AppError>> call(GetFoodLogsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation - start date must be before end date
    if (input.startDate != null &&
        input.endDate != null &&
        input.startDate! > input.endDate!) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before end date'],
        }),
      );
    }

    // 3. Fetch from repository
    return _repository.getByProfile(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
