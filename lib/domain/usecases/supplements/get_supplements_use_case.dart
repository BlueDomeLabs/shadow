// lib/domain/usecases/supplements/get_supplements_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 4.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/repositories/supplement_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';

/// Use case to get supplements for a profile.
///
/// Follows the standard pattern:
/// 1. Authorization - Check profile access FIRST
/// 2. Repository Call - Execute operation
class GetSupplementsUseCase
    implements UseCase<GetSupplementsInput, List<Supplement>> {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSupplementsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<Supplement>, AppError>> call(
    GetSupplementsInput input,
  ) async {
    // 1. Check authorization FIRST
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Execute repository call
    return _repository.getByProfile(
      input.profileId,
      activeOnly: input.activeOnly,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
