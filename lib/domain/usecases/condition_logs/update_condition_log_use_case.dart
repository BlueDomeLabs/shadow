// lib/domain/usecases/condition_logs/update_condition_log_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.9

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/repositories/condition_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_log_inputs.dart';

/// Use case to update an existing condition log entry.
class UpdateConditionLogUseCase
    implements UseCase<UpdateConditionLogInput, ConditionLog> {
  final ConditionLogRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateConditionLogUseCase(this._repository, this._authService);

  @override
  Future<Result<ConditionLog, AppError>> call(
    UpdateConditionLogInput input,
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
      timestamp: input.timestamp ?? existing.timestamp,
      severity: input.severity ?? existing.severity,
      notes: input.notes ?? existing.notes,
      isFlare: input.isFlare ?? existing.isFlare,
      triggers: input.triggers ?? existing.triggers,
    );

    // 4. Validation
    final validationError = _validate(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(ConditionLog log) {
    final errors = <String, List<String>>{};

    if (log.severity < ValidationRules.severityMin ||
        log.severity > ValidationRules.severityMax) {
      errors['severity'] = [
        'Severity must be between ${ValidationRules.severityMin} and ${ValidationRules.severityMax}',
      ];
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
