// lib/domain/usecases/bodily_output/delete_bodily_output_use_case.dart
// Per FLUIDS_RESTRUCTURING_SPEC.md Section 4

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/bodily_output_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';

/// Use case to soft-delete a bodily output log.
class DeleteBodilyOutputUseCase {
  final BodilyOutputRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteBodilyOutputUseCase(this._repository, this._authService);

  Future<Result<void, AppError>> execute(String profileId, String id) async {
    if (!await _authService.canWrite(profileId)) {
      return Failure(AuthError.profileAccessDenied(profileId));
    }

    return _repository.delete(profileId, id);
  }
}
