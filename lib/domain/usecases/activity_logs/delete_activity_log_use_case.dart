// lib/domain/usecases/activity_logs/delete_activity_log_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/activity_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to delete (soft delete) an activity log.
class DeleteActivityLogUseCase
    implements UseCase<DeleteActivityLogInput, void> {
  final ActivityLogRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteActivityLogUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteActivityLogInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Verify entity exists and belongs to profile
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the log belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Soft delete
    return _repository.delete(input.id);
  }
}
