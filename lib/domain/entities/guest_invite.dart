// lib/domain/entities/guest_invite.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.1

import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_invite.freezed.dart';
part 'guest_invite.g.dart';

/// A guest invite allowing a device to access a single profile.
///
/// Created by the host, scanned by the guest via QR code.
/// See 56_GUEST_PROFILE_ACCESS.md for full feature spec.
@Freezed(toJson: true, fromJson: true)
class GuestInvite with _$GuestInvite {
  const GuestInvite._();

  @JsonSerializable(explicitToJson: true)
  const factory GuestInvite({
    required String id,
    required String profileId,
    required String token, // Cryptographically secure token (UUID v4)
    @Default('') String label, // e.g. "John's iPhone"
    required int createdAt, // Epoch ms
    int? expiresAt, // Epoch ms, null = no expiry
    @Default(false) bool isRevoked,
    int? lastSeenAt, // Epoch ms, last guest sync
    String?
    activeDeviceId, // Device ID of activated guest, null = not yet activated
  }) = _GuestInvite;

  factory GuestInvite.fromJson(Map<String, dynamic> json) =>
      _$GuestInviteFromJson(json);

  /// Whether this invite is currently usable (not revoked, not expired).
  bool get isActive =>
      !isRevoked &&
      (expiresAt == null || expiresAt! > DateTime.now().millisecondsSinceEpoch);

  /// Whether a guest device has activated this invite.
  bool get isActivated => activeDeviceId != null;
}
