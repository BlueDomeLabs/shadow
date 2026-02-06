// lib/domain/usecases/activities/get_activities_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to get activities for a profile.
class GetActivitiesUseCase
    implements UseCase<GetActivitiesInput, List<Activity>> {
  final ActivityRepository _repository;
  final ProfileAuthorizationService _authService;

  GetActivitiesUseCase(this._repository, this._authService);

  @override
  Future<Result<List<Activity>, AppError>> call(
    GetActivitiesInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call
    return _repository.getByProfile(
      input.profileId,
      includeArchived: input.includeArchived,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
