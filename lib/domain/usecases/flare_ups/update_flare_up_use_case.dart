// lib/domain/usecases/flare_ups/update_flare_up_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';

/// Use case to update an existing flare-up.
class UpdateFlareUpUseCase implements UseCase<UpdateFlareUpInput, FlareUp> {
  final FlareUpRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateFlareUpUseCase(this._repository, this._authService);

  @override
  Future<Result<FlareUp, AppError>> call(UpdateFlareUpInput input) async {
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

    // Verify the flare-up belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Validation
    final validationError = _validate(input, existing);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 4. Apply updates
    final updated = existing.copyWith(
      severity: input.severity ?? existing.severity,
      notes: input.notes ?? existing.notes,
      triggers: input.triggers ?? existing.triggers,
      photoPath: input.photoPath ?? existing.photoPath,
    );

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(UpdateFlareUpInput input, FlareUp existing) {
    final errors = <String, List<String>>{};

    // Severity validation
    if (input.severity != null &&
        (input.severity! < ValidationRules.severityMin ||
            input.severity! > ValidationRules.severityMax)) {
      errors['severity'] = [
        'Severity must be between ${ValidationRules.severityMin} and ${ValidationRules.severityMax}',
      ];
    }

    // Notes max length
    if (input.notes != null &&
        input.notes!.length > ValidationRules.notesMaxLength) {
      errors['notes'] = [
        'Notes must be ${ValidationRules.notesMaxLength} characters or less',
      ];
    }

    // Trigger descriptions
    if (input.triggers != null) {
      for (final trigger in input.triggers!) {
        if (trigger.isEmpty ||
            trigger.length > ValidationRules.triggerMaxLength) {
          errors['triggers'] = [
            'Each trigger must be 1-${ValidationRules.triggerMaxLength} characters',
          ];
          break;
        }
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
