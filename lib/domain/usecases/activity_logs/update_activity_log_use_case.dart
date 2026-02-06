// lib/domain/usecases/activity_logs/update_activity_log_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/repositories/activity_log_repository.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to update an existing activity log.
class UpdateActivityLogUseCase
    implements UseCase<UpdateActivityLogInput, ActivityLog> {
  final ActivityLogRepository _repository;
  final ActivityRepository _activityRepository;
  final ProfileAuthorizationService _authService;

  UpdateActivityLogUseCase(
    this._repository,
    this._activityRepository,
    this._authService,
  );

  @override
  Future<Result<ActivityLog, AppError>> call(
    UpdateActivityLogInput input,
  ) async {
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
      activityIds: input.activityIds ?? existing.activityIds,
      adHocActivities: input.adHocActivities ?? existing.adHocActivities,
      duration: input.duration ?? existing.duration,
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

  Future<ValidationError?> _validate(ActivityLog log, String profileId) async {
    final errors = <String, List<String>>{};

    // Must have at least one activity
    if (log.activityIds.isEmpty && log.adHocActivities.isEmpty) {
      errors['activities'] = ['At least one activity is required'];
    }

    // Duration validation if provided
    if (log.duration != null) {
      if (log.duration! < 1 || log.duration! > 1440) {
        errors['duration'] = ['Duration must be between 1 and 1440 minutes'];
      }
    }

    // Notes max length
    if (log.notes != null && log.notes!.length > 2000) {
      errors['notes'] = ['Notes must be 2000 characters or less'];
    }

    // Verify activity IDs exist and belong to profile
    for (final activityId in log.activityIds) {
      final result = await _activityRepository.getById(activityId);
      if (result.isFailure) {
        errors['activityIds'] = ['Activity not found: $activityId'];
        break;
      }
      final activity = result.valueOrNull!;
      if (activity.profileId != profileId) {
        errors['activityIds'] = ['Activity does not belong to this profile'];
        break;
      }
    }

    // Validate ad-hoc activity names
    for (final name in log.adHocActivities) {
      if (name.length < 2 || name.length > 100) {
        errors['adHocActivities'] = [
          'Ad-hoc activity names must be 2-100 characters',
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
