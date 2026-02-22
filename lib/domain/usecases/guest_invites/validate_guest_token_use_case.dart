// lib/domain/usecases/guest_invites/validate_guest_token_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.3

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';

/// Validates a guest token and checks one-device limit.
/// Returns the GuestInvite if valid, or an appropriate error.
class ValidateGuestTokenUseCase
    implements UseCase<ValidateGuestTokenInput, GuestInvite> {
  final GuestInviteRepository _repository;

  ValidateGuestTokenUseCase(this._repository);

  @override
  Future<Result<GuestInvite, AppError>> call(
    ValidateGuestTokenInput input,
  ) async {
    final result = await _repository.getByToken(input.token);
    if (result.isFailure) return Failure(result.errorOrNull!);

    final invite = result.valueOrNull;
    if (invite == null) {
      return Failure(AuthError.unauthorized('Invalid invite token'));
    }
    if (invite.isRevoked) {
      return Failure(AuthError.unauthorized('Invite has been revoked'));
    }
    if (invite.expiresAt != null &&
        invite.expiresAt! <= DateTime.now().millisecondsSinceEpoch) {
      return Failure(AuthError.unauthorized('Invite has expired'));
    }
    // One-device limit: if already activated by a different device, reject
    if (invite.activeDeviceId != null &&
        invite.activeDeviceId != input.deviceId) {
      return Failure(
        AuthError.unauthorized('Invite already active on another device'),
      );
    }
    return Success(invite);
  }
}
