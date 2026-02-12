// lib/domain/usecases/intake_logs/mark_snoozed_use_case.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 4.2 - Snooze action

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/repositories/intake_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_log_inputs.dart';

/// Use case to mark an intake log as snoozed.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile write access FIRST
/// 2. Validation - Verify the intake exists and belongs to profile
/// 3. Validation - Verify snooze duration is valid
/// 4. Repository Call - Execute operation
class MarkSnoozedUseCase implements UseCase<MarkSnoozedInput, IntakeLog> {
  final IntakeLogRepository _repository;
  final ProfileAuthorizationService _authService;

  MarkSnoozedUseCase(this._repository, this._authService);

  /// Valid snooze durations in minutes per 38_UI_FIELD_SPECIFICATIONS.md.
  static const validDurations = ValidationRules.validSnoozeDurationMinutes;

  @override
  Future<Result<IntakeLog, AppError>> call(MarkSnoozedInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation - verify the intake exists and belongs to the profile
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Validate snooze duration
    if (!validDurations.contains(input.snoozeDurationMinutes)) {
      return Failure(
        ValidationError.fromFieldErrors({
          'snoozeDurationMinutes': [
            'Snooze duration must be one of: ${validDurations.join(", ")} minutes',
          ],
        }),
      );
    }

    // 4. Repository call
    return _repository.markSnoozed(input.id, input.snoozeDurationMinutes);
  }
}
