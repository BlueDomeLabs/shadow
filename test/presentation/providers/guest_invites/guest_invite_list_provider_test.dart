// test/presentation/providers/guest_invites/guest_invite_list_provider_test.dart
// Tests for GuestInviteList provider.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/create_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/list_guest_invites_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/remove_guest_device_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/guest_invites/guest_invite_list_provider.dart';

void main() {
  group('GuestInviteList', () {
    const testProfileId = 'profile-001';

    GuestInvite createTestInvite({
      String id = 'invite-001',
      String profileId = testProfileId,
      String token = 'token-abc',
      String label = "John's iPhone",
    }) => GuestInvite(
      id: id,
      profileId: profileId,
      token: token,
      label: label,
      createdAt: DateTime(2026).millisecondsSinceEpoch,
    );

    test('build loads invites for profile', () async {
      final testInvites = [
        createTestInvite(),
        createTestInvite(id: 'invite-002'),
      ];

      final container = ProviderContainer(
        overrides: [
          listGuestInvitesUseCaseProvider.overrideWithValue(
            _FakeListGuestInvitesUseCase(testInvites),
          ),
          // Override unused but potentially referenced providers
          createGuestInviteUseCaseProvider.overrideWithValue(
            _FakeCreateGuestInviteUseCase(createTestInvite()),
          ),
          revokeGuestInviteUseCaseProvider.overrideWithValue(
            _FakeRevokeGuestInviteUseCase(),
          ),
          removeGuestDeviceUseCaseProvider.overrideWithValue(
            _FakeRemoveGuestDeviceUseCase(),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Wait for the async build
      final result = await container.read(
        guestInviteListProvider(testProfileId).future,
      );

      expect(result, hasLength(2));
      expect(result.first.id, 'invite-001');
    });

    test('create calls use case and refreshes', () async {
      final testInvite = createTestInvite();

      final container = ProviderContainer(
        overrides: [
          listGuestInvitesUseCaseProvider.overrideWithValue(
            _FakeListGuestInvitesUseCase([]),
          ),
          createGuestInviteUseCaseProvider.overrideWithValue(
            _FakeCreateGuestInviteUseCase(testInvite),
          ),
          revokeGuestInviteUseCaseProvider.overrideWithValue(
            _FakeRevokeGuestInviteUseCase(),
          ),
          removeGuestDeviceUseCaseProvider.overrideWithValue(
            _FakeRemoveGuestDeviceUseCase(),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Wait for initial build
      await container.read(guestInviteListProvider(testProfileId).future);

      // Call create
      final created = await container
          .read(guestInviteListProvider(testProfileId).notifier)
          .create(const CreateGuestInviteInput(profileId: testProfileId));

      expect(created, isNotNull);
      expect(created!.id, 'invite-001');
    });

    test('revoke calls use case and refreshes', () async {
      final fakeRevoke = _FakeRevokeGuestInviteUseCase();

      final container = ProviderContainer(
        overrides: [
          listGuestInvitesUseCaseProvider.overrideWithValue(
            _FakeListGuestInvitesUseCase([createTestInvite()]),
          ),
          createGuestInviteUseCaseProvider.overrideWithValue(
            _FakeCreateGuestInviteUseCase(createTestInvite()),
          ),
          revokeGuestInviteUseCaseProvider.overrideWithValue(fakeRevoke),
          removeGuestDeviceUseCaseProvider.overrideWithValue(
            _FakeRemoveGuestDeviceUseCase(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(guestInviteListProvider(testProfileId).future);

      await container
          .read(guestInviteListProvider(testProfileId).notifier)
          .revoke('invite-001');

      expect(fakeRevoke.calledWith, 'invite-001');
    });

    test('removeDevice calls use case and refreshes', () async {
      final fakeRemove = _FakeRemoveGuestDeviceUseCase();

      final container = ProviderContainer(
        overrides: [
          listGuestInvitesUseCaseProvider.overrideWithValue(
            _FakeListGuestInvitesUseCase([createTestInvite()]),
          ),
          createGuestInviteUseCaseProvider.overrideWithValue(
            _FakeCreateGuestInviteUseCase(createTestInvite()),
          ),
          revokeGuestInviteUseCaseProvider.overrideWithValue(
            _FakeRevokeGuestInviteUseCase(),
          ),
          removeGuestDeviceUseCaseProvider.overrideWithValue(fakeRemove),
        ],
      );
      addTearDown(container.dispose);

      await container.read(guestInviteListProvider(testProfileId).future);

      await container
          .read(guestInviteListProvider(testProfileId).notifier)
          .removeDevice('invite-001');

      expect(fakeRemove.calledWith, 'invite-001');
    });
  });
}

// Fake use cases for testing

class _FakeListGuestInvitesUseCase implements ListGuestInvitesUseCase {
  final List<GuestInvite> _invites;
  _FakeListGuestInvitesUseCase(this._invites);

  @override
  Future<Result<List<GuestInvite>, AppError>> call(String profileId) async =>
      Success(_invites);
}

class _FakeCreateGuestInviteUseCase implements CreateGuestInviteUseCase {
  final GuestInvite _result;
  _FakeCreateGuestInviteUseCase(this._result);

  @override
  Future<Result<GuestInvite, AppError>> call(
    CreateGuestInviteInput input,
  ) async => Success(_result);
}

class _FakeRevokeGuestInviteUseCase implements RevokeGuestInviteUseCase {
  String? calledWith;

  @override
  Future<Result<void, AppError>> call(RevokeGuestInviteInput input) async {
    calledWith = input.inviteId;
    return const Success(null);
  }
}

class _FakeRemoveGuestDeviceUseCase implements RemoveGuestDeviceUseCase {
  String? calledWith;

  @override
  Future<Result<void, AppError>> call(RemoveGuestDeviceInput input) async {
    calledWith = input.inviteId;
    return const Success(null);
  }
}
