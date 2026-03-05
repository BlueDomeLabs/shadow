// lib/domain/usecases/profiles/delete_profile_use_case.dart

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/profile_inputs.dart';

/// Use case to delete a Profile.
///
/// Steps:
/// 1. Authorization check via ProfileAuthorizationService.
/// 2. Revoke all non-revoked guest invites for the profile.
/// 3. Cascade soft-delete all health data + the profile in a single transaction.
///    Guest invites are hard-deleted by deleteProfileCascade (no sync columns).
class DeleteProfileUseCase implements UseCaseNoOutput<DeleteProfileInput> {
  final ProfileRepository _repository;
  final ProfileAuthorizationService _authService;
  final GuestInviteRepository _guestInviteRepository;

  DeleteProfileUseCase(
    this._repository,
    this._authService,
    this._guestInviteRepository,
  );

  @override
  Future<Result<void, AppError>> call(DeleteProfileInput input) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Revoke all non-revoked guest invites
    final invitesResult = await _guestInviteRepository.getByProfile(
      input.profileId,
    );
    if (invitesResult.isFailure) return Failure(invitesResult.errorOrNull!);
    for (final invite in invitesResult.valueOrNull!) {
      if (!invite.isRevoked) {
        final revokeResult = await _guestInviteRepository.revoke(invite.id);
        if (revokeResult.isFailure) return Failure(revokeResult.errorOrNull!);
      }
    }

    // 3. Cascade delete all health data + profile
    return _repository.cascadeDeleteProfileData(input.profileId);
  }
}
