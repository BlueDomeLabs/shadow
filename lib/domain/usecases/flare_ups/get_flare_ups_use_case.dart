// lib/domain/usecases/flare_ups/get_flare_ups_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/repositories/flare_up_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';

/// Use case to get flare-ups for a profile.
class GetFlareUpsUseCase implements UseCase<GetFlareUpsInput, List<FlareUp>> {
  final FlareUpRepository _repository;
  final ProfileAuthorizationService _authService;

  GetFlareUpsUseCase(this._repository, this._authService);

  @override
  Future<Result<List<FlareUp>, AppError>> call(GetFlareUpsInput input) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch from repository
    if (input.conditionId != null) {
      return _repository.getByCondition(
        input.conditionId!,
        startDate: input.startDate,
        endDate: input.endDate,
        ongoingOnly: input.ongoingOnly,
        limit: input.limit,
        offset: input.offset,
      );
    }

    return _repository.getByProfile(
      input.profileId,
      startDate: input.startDate,
      endDate: input.endDate,
      ongoingOnly: input.ongoingOnly,
      limit: input.limit,
      offset: input.offset,
    );
  }
}
