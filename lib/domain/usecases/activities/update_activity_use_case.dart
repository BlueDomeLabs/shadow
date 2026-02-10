// lib/domain/usecases/activities/update_activity_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to update an existing activity.
class UpdateActivityUseCase implements UseCase<UpdateActivityInput, Activity> {
  final ActivityRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateActivityUseCase(this._repository, this._authService);

  @override
  Future<Result<Activity, AppError>> call(UpdateActivityInput input) async {
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

    // 3. Apply updates
    final updated = existing.copyWith(
      name: input.name ?? existing.name,
      description: input.description ?? existing.description,
      location: input.location ?? existing.location,
      triggers: input.triggers ?? existing.triggers,
      durationMinutes: input.durationMinutes ?? existing.durationMinutes,
    );

    // 4. Validation
    final validationError = _validate(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(Activity activity) {
    final errors = <String, List<String>>{};

    // Name validation: 2-200 characters per ValidationRules.activityNameMaxLength
    if (activity.name.length < 2 || activity.name.length > 200) {
      errors['name'] = ['Activity name must be 2-200 characters'];
    }

    // Duration validation: 1-1440 minutes
    if (activity.durationMinutes < 1 || activity.durationMinutes > 1440) {
      errors['durationMinutes'] = [
        'Duration must be between 1 and 1440 minutes',
      ];
    }

    // Description max length
    if (activity.description != null && activity.description!.length > 500) {
      errors['description'] = ['Description must be 500 characters or less'];
    }

    // Location max length
    if (activity.location != null && activity.location!.length > 200) {
      errors['location'] = ['Location must be 200 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
