// lib/domain/usecases/activities/create_activity_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new activity.
class CreateActivityUseCase implements UseCase<CreateActivityInput, Activity> {
  final ActivityRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateActivityUseCase(this._repository, this._authService);

  @override
  Future<Result<Activity, AppError>> call(CreateActivityInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final activity = Activity(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      name: input.name,
      description: input.description,
      location: input.location,
      triggers: input.triggers,
      durationMinutes: input.durationMinutes,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(activity);
  }

  ValidationError? _validate(CreateActivityInput input) {
    final errors = <String, List<String>>{};

    // Name validation: 2-200 characters per ValidationRules.activityNameMaxLength
    if (input.name.length < 2 || input.name.length > 200) {
      errors['name'] = ['Activity name must be 2-200 characters'];
    }

    // Duration validation: 1-1440 minutes (max 24 hours)
    if (input.durationMinutes < 1 || input.durationMinutes > 1440) {
      errors['durationMinutes'] = [
        'Duration must be between 1 and 1440 minutes',
      ];
    }

    // Description max length
    if (input.description != null && input.description!.length > 500) {
      errors['description'] = ['Description must be 500 characters or less'];
    }

    // Location max length
    if (input.location != null && input.location!.length > 200) {
      errors['location'] = ['Location must be 200 characters or less'];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
