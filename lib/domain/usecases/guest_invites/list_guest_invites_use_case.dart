// lib/domain/usecases/guest_invites/list_guest_invites_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.3

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

/// Lists all guest invites for a profile.
class ListGuestInvitesUseCase implements UseCase<String, List<GuestInvite>> {
  final GuestInviteRepository _repository;

  ListGuestInvitesUseCase(this._repository);

  @override
  Future<Result<List<GuestInvite>, AppError>> call(String profileId) async =>
      _repository.getByProfile(profileId);
}
