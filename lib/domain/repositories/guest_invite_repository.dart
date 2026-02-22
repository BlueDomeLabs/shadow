// lib/domain/repositories/guest_invite_repository.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 18.2

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';

/// Repository contract for GuestInvite entities.
///
/// Unlike health data repositories, GuestInvite does not extend
/// EntityRepository because invites are not syncable health entities.
/// They are local management records used to control profile access.
abstract class GuestInviteRepository {
  /// Create a new guest invite for a profile.
  Future<Result<GuestInvite, AppError>> create(GuestInvite invite);

  /// Get a guest invite by ID.
  Future<Result<GuestInvite, AppError>> getById(String id);

  /// Get a guest invite by its token.
  Future<Result<GuestInvite?, AppError>> getByToken(String token);

  /// Get all invites for a profile.
  Future<Result<List<GuestInvite>, AppError>> getByProfile(String profileId);

  /// Update an existing invite (e.g., set activeDeviceId, lastSeenAt).
  Future<Result<GuestInvite, AppError>> update(GuestInvite invite);

  /// Revoke a guest invite (sets isRevoked = true, clears activeDeviceId).
  Future<Result<void, AppError>> revoke(String id);

  /// Permanently delete an invite.
  Future<Result<void, AppError>> hardDelete(String id);
}
