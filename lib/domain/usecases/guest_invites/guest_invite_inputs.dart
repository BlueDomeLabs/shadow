// lib/domain/usecases/guest_invites/guest_invite_inputs.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.3

import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_invite_inputs.freezed.dart';

/// Input for CreateGuestInviteUseCase.
@freezed
class CreateGuestInviteInput with _$CreateGuestInviteInput {
  const factory CreateGuestInviteInput({
    required String profileId,
    @Default('') String label,
    int? expiresAt, // Epoch ms, null = no expiry
  }) = _CreateGuestInviteInput;
}

/// Input for RevokeGuestInviteUseCase.
@freezed
class RevokeGuestInviteInput with _$RevokeGuestInviteInput {
  const factory RevokeGuestInviteInput({required String inviteId}) =
      _RevokeGuestInviteInput;
}

/// Input for ValidateGuestTokenUseCase.
@freezed
class ValidateGuestTokenInput with _$ValidateGuestTokenInput {
  const factory ValidateGuestTokenInput({
    required String token,
    required String deviceId,
  }) = _ValidateGuestTokenInput;
}

/// Input for RemoveGuestDeviceUseCase.
@freezed
class RemoveGuestDeviceInput with _$RemoveGuestDeviceInput {
  const factory RemoveGuestDeviceInput({required String inviteId}) =
      _RemoveGuestDeviceInput;
}
