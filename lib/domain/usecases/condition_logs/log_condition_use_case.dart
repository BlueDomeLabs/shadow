// lib/domain/usecases/condition_logs/log_condition_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.9

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/condition_log_repository.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_log_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to log a condition entry.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Validation - Validate input using ValidationRules
/// 3. Create entity
/// 4. Repository Call - Execute operation
class LogConditionUseCase implements UseCase<LogConditionInput, ConditionLog> {
  final ConditionLogRepository _repository;
  final ConditionRepository _conditionRepository;
  final ProfileAuthorizationService _authService;

  LogConditionUseCase(
    this._repository,
    this._conditionRepository,
    this._authService,
  );

  @override
  Future<Result<ConditionLog, AppError>> call(LogConditionInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Verify condition exists and belongs to profile
    final conditionResult = await _conditionRepository.getById(
      input.conditionId,
    );
    if (conditionResult.isFailure) {
      return Failure(conditionResult.errorOrNull!);
    }
    final condition = conditionResult.valueOrNull!;
    if (condition.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Validation
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 4. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final conditionLog = ConditionLog(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      conditionId: input.conditionId,
      timestamp: input.timestamp,
      severity: input.severity,
      notes: input.notes,
      isFlare: input.isFlare,
      flarePhotoIds: input.flarePhotoIds,
      photoPath: input.photoPath,
      activityId: input.activityId,
      triggers: input.triggers,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 5. Persist
    return _repository.create(conditionLog);
  }

  ValidationError? _validate(LogConditionInput input) {
    final errors = <String, List<String>>{};

    // Condition ID validation
    if (input.conditionId.trim().isEmpty) {
      errors['conditionId'] = ['Condition ID is required'];
    }

    // Timestamp validation
    if (input.timestamp <= 0) {
      errors['timestamp'] = ['Timestamp must be a valid epoch timestamp'];
    }

    // Future timestamp check (consistent with all other log use cases)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + (60 * 60 * 1000);
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = [
        'Timestamp cannot be more than 1 hour in the future',
      ];
    }

    // Severity validation (1-10 scale)
    if (input.severity < ValidationRules.severityMin ||
        input.severity > ValidationRules.severityMax) {
      errors['severity'] = [
        'Severity must be between ${ValidationRules.severityMin} and ${ValidationRules.severityMax}',
      ];
    }

    // Notes validation (optional but max length)
    if (input.notes != null &&
        input.notes!.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    // Flare photo IDs count validation
    if (input.flarePhotoIds.length > ValidationRules.maxPhotosPerConditionLog) {
      errors['flarePhotoIds'] = [
        'Maximum ${ValidationRules.maxPhotosPerConditionLog} flare photos allowed',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
