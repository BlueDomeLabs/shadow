// lib/domain/usecases/profiles/delete_profile_use_case.dart
//
// Session A1: stub implementation — soft-deletes the profile record only.
// Session A2 will expand this to cascade-delete all health data for the
// profile and revoke all active guest invites before deletion.

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/profile_inputs.dart';

/// Use case to delete a Profile.
///
/// A1 stub: soft-deletes the profile entity only.
/// A2 expansion: will cascade to all 19 health data tables + revoke guest invites.
class DeleteProfileUseCase implements UseCaseNoOutput<DeleteProfileInput> {
  final ProfileRepository _repository;
  final ProfileAuthorizationService _authService;

  DeleteProfileUseCase(this._repository, this._authService);

  @override
  Future<Result<void, AppError>> call(DeleteProfileInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Soft-delete the profile.
    // TODO(A2): Before deleting, cascade-delete all health data rows and
    // revoke all active guest invites for this profileId.
    return _repository.delete(input.profileId);
  }
}
