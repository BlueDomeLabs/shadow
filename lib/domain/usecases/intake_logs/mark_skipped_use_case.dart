// lib/domain/usecases/intake_logs/mark_skipped_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.10

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/intake_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_log_inputs.dart';

/// Use case to mark an intake log as skipped.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile write access FIRST
/// 2. Validation - Verify the intake exists and belongs to profile
/// 3. Repository Call - Execute operation
class MarkSkippedUseCase implements UseCase<MarkSkippedInput, void> {
  final IntakeLogRepository _repository;
  final ProfileAuthorizationService _authService;

  MarkSkippedUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(MarkSkippedInput input) async {
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

    // 3. Repository call
    return _repository.markSkipped(input.id, input.reason);
  }
}
