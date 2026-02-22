// lib/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.3

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';

/// Revokes a guest invite. The guest device loses access on next sync.
class RevokeGuestInviteUseCase
    implements UseCaseNoOutput<RevokeGuestInviteInput> {
  final GuestInviteRepository _repository;

  RevokeGuestInviteUseCase(this._repository);

  @override
  Future<Result<void, AppError>> call(RevokeGuestInviteInput input) async =>
      _repository.revoke(input.inviteId);
}
