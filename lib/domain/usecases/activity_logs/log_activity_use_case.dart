// lib/domain/usecases/activity_logs/log_activity_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/activity_log_repository.dart';
import 'package:shadow_app/domain/repositories/activity_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:uuid/uuid.dart';

/// Use case to log an activity.
class LogActivityUseCase implements UseCase<LogActivityInput, ActivityLog> {
  final ActivityLogRepository _repository;
  final ActivityRepository _activityRepository;
  final ProfileAuthorizationService _authService;

  LogActivityUseCase(
    this._repository,
    this._activityRepository,
    this._authService,
  );

  @override
  Future<Result<ActivityLog, AppError>> call(LogActivityInput input) async {
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

    final log = ActivityLog(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      timestamp: input.timestamp,
      activityIds: input.activityIds,
      adHocActivities: input.adHocActivities,
      duration: input.duration,
      notes: input.notes,
      importSource: input.importSource,
      importExternalId: input.importExternalId,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(log);
  }

  Future<ValidationError?> _validate(LogActivityInput input) async {
    final errors = <String, List<String>>{};

    // Must have at least one activity (predefined or ad-hoc)
    if (input.activityIds.isEmpty && input.adHocActivities.isEmpty) {
      errors['activities'] = ['At least one activity is required'];
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + (60 * 60 * 1000);
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = [
        'Timestamp cannot be more than 1 hour in the future',
      ];
    }

    // Duration validation if provided
    if (input.duration != null) {
      if (input.duration! < ValidationRules.activityDurationMinMinutes ||
          input.duration! > ValidationRules.activityDurationMaxMinutes) {
        errors['duration'] = [
          'Duration must be between ${ValidationRules.activityDurationMinMinutes} and ${ValidationRules.activityDurationMaxMinutes} minutes',
        ];
      }
    }

    // Notes max length
    if (input.notes.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    // Verify activity IDs exist and belong to profile
    for (final activityId in input.activityIds) {
      final result = await _activityRepository.getById(activityId);
      if (result.isFailure) {
        errors['activityIds'] = ['Activity not found: $activityId'];
        break;
      }
      final activity = result.valueOrNull!;
      if (activity.profileId != input.profileId) {
        errors['activityIds'] = ['Activity does not belong to this profile'];
        break;
      }
    }

    // Validate ad-hoc activity names
    for (final name in input.adHocActivities) {
      if (name.length < ValidationRules.nameMinLength ||
          name.length > ValidationRules.nameMaxLength) {
        errors['adHocActivities'] = [
          'Ad-hoc activity names must be ${ValidationRules.nameMinLength}-${ValidationRules.nameMaxLength} characters',
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
