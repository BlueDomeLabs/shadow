// lib/domain/usecases/bodily_output/get_bodily_outputs_use_case.dart
// Per FLUIDS_RESTRUCTURING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Use case to retrieve bodily output events for a profile.
///
/// Supports optional date range and output type filters.
class GetBodilyOutputsUseCase {
  final BodilyOutputRepository _repository;
  final ProfileAuthorizationService _authService;

  GetBodilyOutputsUseCase(this._repository, this._authService);

  Future<Result<List<BodilyOutputLog>, AppError>> execute(
    String profileId, {
    int? from,
    int? to,
    BodyOutputType? type,
  }) async {
    if (!await _authService.canRead(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    return _repository.getAll(profileId, from: from, to: to, type: type);
  }
}
