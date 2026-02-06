// lib/domain/usecases/activities/archive_activity_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to archive or unarchive an activity.
class ArchiveActivityUseCase
    implements UseCase<ArchiveActivityInput, Activity> {
  final ActivityRepository _repository;
  final ProfileAuthorizationService _authService;

  ArchiveActivityUseCase(this._repository, this._authService);

  @override
  Future<Result<Activity, AppError>> call(ArchiveActivityInput input) async {
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

    // Verify the activity belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply archive state
    final updated = existing.copyWith(isArchived: input.archive);

    // 4. Persist
    return _repository.update(updated);
  }
}
