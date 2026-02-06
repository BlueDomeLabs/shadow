// lib/domain/usecases/activity_logs/get_activity_logs_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/repositories/activity_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Use case to get activity logs by date range.
class GetActivityLogsUseCase
    implements UseCase<GetActivityLogsInput, List<ActivityLog>> {
  final ActivityLogRepository _repository;
  final ProfileAuthorizationService _authService;

  GetActivityLogsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<ActivityLog>, AppError>> call(
    GetActivityLogsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDate != null &&
        input.endDate != null &&
        input.startDate! > input.endDate!) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before or equal to end date'],
        }),
      );
    }

    // 3. Repository call
    return _repository.getByProfile(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
