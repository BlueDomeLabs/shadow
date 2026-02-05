// lib/domain/usecases/conditions/get_conditions_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.8

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/repositories/condition_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';

/// Use case to get conditions for a profile.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile read access FIRST
/// 2. Repository Call - Delegate to repository
class GetConditionsUseCase
    implements UseCase<GetConditionsInput, List<Condition>> {
  final ConditionRepository _repository;
  final ProfileAuthorizationService _authService;

  GetConditionsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<Condition>, AppError>> call(
    GetConditionsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Repository call
    return _repository.getByProfile(
      input.profileId,
      status: input.status,
      includeArchived: input.includeArchived,
    );
  }
}
