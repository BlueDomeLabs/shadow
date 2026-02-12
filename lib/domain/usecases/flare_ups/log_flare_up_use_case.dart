// lib/domain/usecases/flare_ups/log_flare_up_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to log a new flare-up.
class LogFlareUpUseCase implements UseCase<LogFlareUpInput, FlareUp> {
  final FlareUpRepository _repository;
  final ConditionRepository _conditionRepository;
  final ProfileAuthorizationService _authService;

  LogFlareUpUseCase(
    this._repository,
    this._conditionRepository,
    this._authService,
  );

  @override
  Future<Result<FlareUp, AppError>> call(LogFlareUpInput input) async {
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

    final flareUp = FlareUp(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      conditionId: input.conditionId,
      startDate: input.startDate,
      endDate: input.endDate,
      severity: input.severity,
      notes: input.notes,
      triggers: input.triggers,
      activityId: input.activityId,
      photoPath: input.photoPath,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(flareUp);
  }

  Future<ValidationError?> _validate(LogFlareUpInput input) async {
    final errors = <String, List<String>>{};

    // Severity validation
    if (input.severity < ValidationRules.severityMin ||
        input.severity > ValidationRules.severityMax) {
      errors['severity'] = [
        'Severity must be between ${ValidationRules.severityMin} and ${ValidationRules.severityMax}',
      ];
    }

    // Verify condition exists and belongs to profile
    final conditionResult = await _conditionRepository.getById(
      input.conditionId,
    );
    if (conditionResult.isFailure) {
      errors['conditionId'] = ['Condition not found'];
    } else {
      final condition = conditionResult.valueOrNull!;
      if (condition.profileId != input.profileId) {
        errors['conditionId'] = ['Condition does not belong to this profile'];
      }
    }

    // Start date validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.startDate > oneHourFromNow) {
      errors['startDate'] = [
        'Start date cannot be more than 1 hour in the future',
      ];
    }

    // End date must be after start date if provided
    if (input.endDate != null && input.endDate! <= input.startDate) {
      errors['endDate'] = ['End date must be after start date'];
    }

    // Notes max length
    if (input.notes != null &&
        input.notes!.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    // Trigger descriptions
    for (final trigger in input.triggers) {
      if (trigger.isEmpty ||
          trigger.length > ValidationRules.triggerMaxLength) {
        errors['triggers'] = [
          'Each trigger must be 1-${ValidationRules.triggerMaxLength} characters',
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
