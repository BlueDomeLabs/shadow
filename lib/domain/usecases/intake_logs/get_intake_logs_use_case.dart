// lib/domain/usecases/intake_logs/get_intake_logs_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.10

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/repositories/intake_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_log_inputs.dart';

/// Use case to get intake logs for a profile.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile read access FIRST
/// 2. Repository Call - Delegate to repository
class GetIntakeLogsUseCase
    implements UseCase<GetIntakeLogsInput, List<IntakeLog>> {
  final IntakeLogRepository _repository;
  final ProfileAuthorizationService _authService;

  GetIntakeLogsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<IntakeLog>, AppError>> call(
    GetIntakeLogsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call
    return _repository.getByProfile(
      input.profileId,
      status: input.status,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
