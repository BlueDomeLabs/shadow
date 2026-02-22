// lib/domain/usecases/guest_invites/create_guest_invite_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.3

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:uuid/uuid.dart';

/// Creates a new guest invite with a cryptographically secure token.
class CreateGuestInviteUseCase
    implements UseCase<CreateGuestInviteInput, GuestInvite> {
  final GuestInviteRepository _repository;

  CreateGuestInviteUseCase(this._repository);

  @override
  Future<Result<GuestInvite, AppError>> call(
    CreateGuestInviteInput input,
  ) async {
    final id = const Uuid().v4();
    final token = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final invite = GuestInvite(
      id: id,
      profileId: input.profileId,
      token: token,
      label: input.label,
      createdAt: now,
      expiresAt: input.expiresAt,
    );

    return _repository.create(invite);
  }
}
