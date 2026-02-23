/// Guest token validation service.
///
/// Validates a guest invite token against the local database,
/// registers the device, and enforces the one-device limit.
/// Used by deep link handler and pre-sync validation.
library;

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';

/// Reason a guest token was rejected.
enum TokenRejectionReason {
  /// Token does not exist in the database.
  notFound,

  /// Token has been revoked by the host.
  revoked,

  /// Token has passed its expiry date.
  expired,

  /// Token is already active on a different device.
  alreadyActiveOnAnotherDevice,
}

/// Result of token validation.
class TokenValidationResult {
  final bool isValid;
  final GuestInvite? invite;
  final TokenRejectionReason? rejectionReason;

  const TokenValidationResult.valid(this.invite)
    : isValid = true,
      rejectionReason = null;

  const TokenValidationResult.rejected(this.rejectionReason)
    : isValid = false,
      invite = null;
}

/// Service for validating and activating guest invite tokens.
class GuestTokenService {
  final GuestInviteRepository _repository;

  GuestTokenService(this._repository);

  /// Validate a token and optionally register the device.
  ///
  /// If [deviceId] is provided and the token is not yet activated,
  /// the device is registered against the token.
  ///
  /// Returns [TokenValidationResult] with validation outcome.
  Future<Result<TokenValidationResult, AppError>> validateAndActivate({
    required String token,
    required String deviceId,
  }) async {
    final result = await _repository.getByToken(token);
    if (result.isFailure) return Failure(result.errorOrNull!);

    final invite = result.valueOrNull;
    if (invite == null) {
      return const Success(
        TokenValidationResult.rejected(TokenRejectionReason.notFound),
      );
    }

    if (invite.isRevoked) {
      return const Success(
        TokenValidationResult.rejected(TokenRejectionReason.revoked),
      );
    }

    if (invite.expiresAt != null &&
        invite.expiresAt! <= DateTime.now().millisecondsSinceEpoch) {
      return const Success(
        TokenValidationResult.rejected(TokenRejectionReason.expired),
      );
    }

    // One-device limit enforcement
    if (invite.activeDeviceId != null && invite.activeDeviceId != deviceId) {
      return const Success(
        TokenValidationResult.rejected(
          TokenRejectionReason.alreadyActiveOnAnotherDevice,
        ),
      );
    }

    // Register device if not already registered
    if (invite.activeDeviceId == null) {
      final updateResult = await _repository.update(
        invite.copyWith(
          activeDeviceId: deviceId,
          lastSeenAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);
      return Success(TokenValidationResult.valid(updateResult.valueOrNull));
    }

    // Already registered to this device — update lastSeenAt
    final updateResult = await _repository.update(
      invite.copyWith(lastSeenAt: DateTime.now().millisecondsSinceEpoch),
    );
    if (updateResult.isFailure) return Failure(updateResult.errorOrNull!);
    return Success(TokenValidationResult.valid(updateResult.valueOrNull));
  }

  /// Validate a token without registering (for re-validation on sync).
  ///
  /// Checks that the token exists, is not revoked, not expired,
  /// and is still bound to the given device.
  Future<Result<TokenValidationResult, AppError>> validateOnly({
    required String token,
    required String deviceId,
  }) async {
    final result = await _repository.getByToken(token);
    if (result.isFailure) return Failure(result.errorOrNull!);

    final invite = result.valueOrNull;
    if (invite == null) {
      return const Success(
        TokenValidationResult.rejected(TokenRejectionReason.notFound),
      );
    }

    if (invite.isRevoked) {
      return const Success(
        TokenValidationResult.rejected(TokenRejectionReason.revoked),
      );
    }

    if (invite.expiresAt != null &&
        invite.expiresAt! <= DateTime.now().millisecondsSinceEpoch) {
      return const Success(
        TokenValidationResult.rejected(TokenRejectionReason.expired),
      );
    }

    if (invite.activeDeviceId != null && invite.activeDeviceId != deviceId) {
      return const Success(
        TokenValidationResult.rejected(
          TokenRejectionReason.alreadyActiveOnAnotherDevice,
        ),
      );
    }

    return Success(TokenValidationResult.valid(invite));
  }
}
