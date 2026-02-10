// lib/domain/usecases/condition_logs/get_condition_logs_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.9

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/repositories/condition_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_log_inputs.dart';

/// Use case to get condition logs for a profile.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile read access FIRST
/// 2. Repository Call - Delegate to repository
class GetConditionLogsUseCase
    implements UseCase<GetConditionLogsInput, List<ConditionLog>> {
  final ConditionLogRepository _repository;
  final ProfileAuthorizationService _authService;

  GetConditionLogsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<ConditionLog>, AppError>> call(
    GetConditionLogsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call — query by condition per spec
    return _repository.getByCondition(
      input.conditionId,
      startDate: input.startDate,
      endDate: input.endDate,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
