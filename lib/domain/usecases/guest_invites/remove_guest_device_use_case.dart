// lib/domain/usecases/guest_invites/remove_guest_device_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.3

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';

/// Removes the active device from an invite (clears activeDeviceId).
/// Host uses this before generating a replacement QR code.
class RemoveGuestDeviceUseCase
    implements UseCaseNoOutput<RemoveGuestDeviceInput> {
  final GuestInviteRepository _repository;

  RemoveGuestDeviceUseCase(this._repository);

  @override
  Future<Result<void, AppError>> call(RemoveGuestDeviceInput input) async {
    final result = await _repository.getById(input.inviteId);
    if (result.isFailure) return Failure(result.errorOrNull!);

    final invite = result.valueOrNull!;
    final updated = invite.copyWith(activeDeviceId: null);
    final updateResult = await _repository.update(updated);
    if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);
    return const Success(null);
  }
}
