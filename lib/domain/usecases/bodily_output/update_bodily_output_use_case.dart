// lib/domain/usecases/bodily_output/update_bodily_output_use_case.dart
// Per FLUIDS_RESTRUCTURING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to update an existing bodily output log.
///
/// Applies the same validation rules as LogBodilyOutputUseCase.
class UpdateBodilyOutputUseCase implements UseCase<BodilyOutputLog, void> {
  final BodilyOutputRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateBodilyOutputUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(BodilyOutputLog input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation (same rules as log)
    final validationError = _validate(input);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 3. Persist update
    return _repository.update(input);
  }

  ValidationError? _validate(BodilyOutputLog input) {
    final errors = <String, List<String>>{};

    if (input.profileId.isEmpty) {
      errors['profileId'] = ['Profile ID must not be empty'];
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    const tolerance = ValidationRules.maxFutureTimestampToleranceMs;
    if (input.occurredAt > now + tolerance) {
      errors['occurredAt'] = ['Event time cannot be in the future'];
    }

    switch (input.outputType) {
      case BodyOutputType.gas:
        if (input.gasSeverity == null) {
          errors['gasSeverity'] = ['Gas severity is required for gas events'];
        }
      case BodyOutputType.custom:
        if (input.customTypeLabel == null || input.customTypeLabel!.isEmpty) {
          errors['customTypeLabel'] = [
            'Custom type label is required for custom events',
          ];
        }
      case BodyOutputType.bbt:
        if (input.temperatureValue == null) {
          errors['temperatureValue'] = [
            'Temperature value is required for BBT events',
          ];
        }
      case BodyOutputType.urine:
        if (input.urineCondition == UrineCondition.custom &&
            (input.urineCustomCondition == null ||
                input.urineCustomCondition!.isEmpty)) {
          errors['urineCustomCondition'] = [
            'Custom urine condition description is required',
          ];
        }
      case BodyOutputType.bowel:
        if (input.bowelCondition == BowelCondition.custom &&
            (input.bowelCustomCondition == null ||
                input.bowelCustomCondition!.isEmpty)) {
          errors['bowelCustomCondition'] = [
            'Custom bowel condition description is required',
          ];
        }
      case BodyOutputType.menstruation:
        break;
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
