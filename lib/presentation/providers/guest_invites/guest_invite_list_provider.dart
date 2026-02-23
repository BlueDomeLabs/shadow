/// Guest invite list provider.
///
/// Manages the list of guest invites for a profile.
/// Follows the UseCase delegation pattern per 02_CODING_STANDARDS.md Section 6.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shadow_app/core/services/logger_service.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

part 'guest_invite_list_provider.g.dart';

/// Provider for managing guest invite list with profile scope.
@riverpod
class GuestInviteList extends _$GuestInviteList {
  static final _log = logger.scope('GuestInviteList');

  @override
  Future<List<GuestInvite>> build(String profileId) async {
    _log.debug('Loading guest invites for profile: $profileId');

    final useCase = ref.read(listGuestInvitesUseCaseProvider);
    final result = await useCase(profileId);

    return result.when(
      success: (invites) {
        _log.debug('Loaded ${invites.length} guest invites');
        return invites;
      },
      failure: (error) {
        _log.error('Load failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Creates a new guest invite.
  Future<GuestInvite?> create(CreateGuestInviteInput input) async {
    _log.debug('Creating guest invite for profile: ${input.profileId}');

    final useCase = ref.read(createGuestInviteUseCaseProvider);
    final result = await useCase(input);

    return result.when(
      success: (invite) {
        _log.info('Guest invite created successfully');
        ref.invalidateSelf();
        return invite;
      },
      failure: (error) {
        _log.error('Create failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Revokes a guest invite.
  Future<void> revoke(String inviteId) async {
    _log.debug('Revoking guest invite: $inviteId');

    final useCase = ref.read(revokeGuestInviteUseCaseProvider);
    final result = await useCase(RevokeGuestInviteInput(inviteId: inviteId));

    result.when(
      success: (_) {
        _log.info('Guest invite revoked successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Revoke failed: ${error.message}');
        throw error;
      },
    );
  }

  /// Removes the active device from an invite.
  Future<void> removeDevice(String inviteId) async {
    _log.debug('Removing device from invite: $inviteId');

    final useCase = ref.read(removeGuestDeviceUseCaseProvider);
    final result = await useCase(RemoveGuestDeviceInput(inviteId: inviteId));

    result.when(
      success: (_) {
        _log.info('Device removed from invite successfully');
        ref.invalidateSelf();
      },
      failure: (error) {
        _log.error('Remove device failed: ${error.message}');
        throw error;
      },
    );
  }
}
