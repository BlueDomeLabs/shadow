// test/integration/guest_profile_access_test.dart
// Phase 12d: End-to-end integration tests for the guest profile access system.
// Tests full flows across creation, activation, validation, revocation,
// device replacement, one-device limit, and disclaimer.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/deep_link_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/services/guest_sync_validator.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/domain/usecases/guest_invites/create_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/remove_guest_device_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart';
import 'package:shadow_app/presentation/providers/guest_mode/deep_link_handler.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =============================================================================
// In-memory repository that simulates database behavior
// =============================================================================

class _InMemoryGuestInviteRepository implements GuestInviteRepository {
  final Map<String, GuestInvite> _store = {};

  @override
  Future<Result<GuestInvite, AppError>> create(GuestInvite invite) async {
    _store[invite.id] = invite;
    return Success(invite);
  }

  @override
  Future<Result<GuestInvite, AppError>> getById(String id) async {
    final invite = _store[id];
    if (invite == null) {
      return Failure(DatabaseError.notFound('GuestInvite', id));
    }
    return Success(invite);
  }

  @override
  Future<Result<GuestInvite?, AppError>> getByToken(String token) async {
    final invite = _store.values.cast<GuestInvite?>().firstWhere(
      (inv) => inv?.token == token,
      orElse: () => null,
    );
    return Success(invite);
  }

  @override
  Future<Result<List<GuestInvite>, AppError>> getByProfile(
    String profileId,
  ) async {
    final invites = _store.values
        .where((inv) => inv.profileId == profileId)
        .toList();
    return Success(invites);
  }

  @override
  Future<Result<GuestInvite, AppError>> update(GuestInvite invite) async {
    _store[invite.id] = invite;
    return Success(invite);
  }

  @override
  Future<Result<void, AppError>> revoke(String id) async {
    final invite = _store[id];
    if (invite == null) {
      return Failure(DatabaseError.notFound('GuestInvite', id));
    }
    _store[id] = invite.copyWith(isRevoked: true, activeDeviceId: null);
    return const Success(null);
  }

  @override
  Future<Result<void, AppError>> hardDelete(String id) async {
    _store.remove(id);
    return const Success(null);
  }
}

// =============================================================================
// Fake deep link service for testing
// =============================================================================

class _FakeDeepLinkService extends DeepLinkService {
  final _controller = StreamController<GuestInviteLink>.broadcast();

  @override
  Stream<GuestInviteLink> get inviteLinks => _controller.stream;

  void emitLink(GuestInviteLink link) => _controller.add(link);

  @override
  Future<void> initialize() async {}

  @override
  void dispose() => _controller.close();
}

// =============================================================================
// Integration tests
// =============================================================================

void main() {
  late _InMemoryGuestInviteRepository repository;
  late CreateGuestInviteUseCase createUseCase;
  late RevokeGuestInviteUseCase revokeUseCase;
  late RemoveGuestDeviceUseCase removeDeviceUseCase;
  late GuestTokenService tokenService;
  late GuestSyncValidator syncValidator;
  late _FakeDeepLinkService deepLinkService;
  late GuestModeNotifier guestModeNotifier;
  late DeepLinkHandler deepLinkHandler;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = _InMemoryGuestInviteRepository();
    createUseCase = CreateGuestInviteUseCase(repository);
    revokeUseCase = RevokeGuestInviteUseCase(repository);
    removeDeviceUseCase = RemoveGuestDeviceUseCase(repository);
    tokenService = GuestTokenService(repository);
    syncValidator = GuestSyncValidator(tokenService);
    deepLinkService = _FakeDeepLinkService();
    guestModeNotifier = GuestModeNotifier();

    deepLinkHandler = DeepLinkHandler(
      deepLinkService: deepLinkService,
      tokenService: tokenService,
      guestModeNotifier: guestModeNotifier,
      deviceId: 'guest-device-1',
    );
  });

  tearDown(() {
    deepLinkHandler.dispose();
    deepLinkService.dispose();
    guestModeNotifier.dispose();
  });

  // ===========================================================================
  // Flow 1: Full guest flow (create → QR → activate → validate)
  // ===========================================================================

  group('Full guest flow', () {
    test(
      'create invite → generate deep link → activate via deep link',
      () async {
        // Host creates an invite
        final createResult = await createUseCase(
          const CreateGuestInviteInput(
            profileId: 'profile-001',
            label: "Mom's iPad",
          ),
        );
        expect(createResult.isSuccess, isTrue);
        final invite = createResult.valueOrNull!;
        expect(invite.profileId, 'profile-001');
        expect(invite.token, isNotEmpty);
        expect(invite.isRevoked, isFalse);
        expect(invite.activeDeviceId, isNull);

        // Build deep link (same as QR screen does)
        final deepLink =
            'shadow://invite?token=${invite.token}&profile=${invite.profileId}';

        // Parse deep link (same as DeepLinkService does)
        final parsed = DeepLinkService.parseInviteLink(deepLink);
        expect(parsed, isNotNull);
        expect(parsed!.token, invite.token);
        expect(parsed.profileId, 'profile-001');

        // Guest device validates and activates
        final validateResult = await tokenService.validateAndActivate(
          token: invite.token,
          deviceId: 'guest-device-1',
        );
        expect(validateResult.isSuccess, isTrue);
        expect(validateResult.valueOrNull!.isValid, isTrue);

        // Device is now registered
        final afterResult = await repository.getByToken(invite.token);
        final afterInvite = afterResult.valueOrNull!;
        expect(afterInvite.activeDeviceId, 'guest-device-1');
        expect(afterInvite.lastSeenAt, isNotNull);
      },
    );

    test('create invite → deep link handler activates guest mode', () async {
      // Host creates invite
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      // Mark disclaimer as already seen so activation proceeds
      await guestModeNotifier.markDisclaimerSeen();
      deepLinkHandler.startListening();

      // Guest taps deep link
      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Guest mode is active
      expect(guestModeNotifier.state.isGuestMode, isTrue);
      expect(guestModeNotifier.state.guestProfileId, invite.profileId);
      expect(guestModeNotifier.state.guestToken, invite.token);
    });

    test('guest can sync after activation', () async {
      // Create and activate invite
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Guest validates before sync
      final syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(syncResult.isSuccess, isTrue);
      expect(syncResult.valueOrNull!.isValid, isTrue);
    });
  });

  // ===========================================================================
  // Flow 2: One-device limit enforcement
  // ===========================================================================

  group('One-device limit', () {
    test('second device is rejected when first is active', () async {
      // Create and activate on device 1
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Device 2 tries to activate
      final device2Result = await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-2',
      );

      expect(device2Result.isSuccess, isTrue);
      expect(device2Result.valueOrNull!.isValid, isFalse);
      expect(
        device2Result.valueOrNull!.rejectionReason,
        TokenRejectionReason.alreadyActiveOnAnotherDevice,
      );
    });

    test('second device rejection fires onAccessRevoked callback', () async {
      // Create invite on device 1
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Set up a second handler for device 2
      final device2Notifier = GuestModeNotifier();
      final device2Handler = DeepLinkHandler(
        deepLinkService: deepLinkService,
        tokenService: tokenService,
        guestModeNotifier: device2Notifier,
        deviceId: 'guest-device-2',
      );

      TokenRejectionReason? capturedReason;
      device2Handler
        ..onAccessRevoked = (reason) {
          capturedReason = reason;
        }
        ..startListening();

      // Device 2 taps the same deep link
      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(capturedReason, TokenRejectionReason.alreadyActiveOnAnotherDevice);
      expect(device2Notifier.state.isGuestMode, isFalse);

      device2Handler.dispose();
      device2Notifier.dispose();
    });

    test('same device can re-validate without rejection', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      // First activation
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Re-validate on same device (e.g., app restart)
      final revalidateResult = await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(revalidateResult.isSuccess, isTrue);
      expect(revalidateResult.valueOrNull!.isValid, isTrue);
    });

    test('second device sync validation also fails', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Device 2 tries to sync
      final syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-2',
      );
      expect(syncResult.isSuccess, isTrue);
      expect(syncResult.valueOrNull!.isValid, isFalse);
      expect(
        syncResult.valueOrNull!.rejectionReason,
        TokenRejectionReason.alreadyActiveOnAnotherDevice,
      );
    });
  });

  // ===========================================================================
  // Flow 3: Disclaimer
  // ===========================================================================

  group('Disclaimer flow', () {
    test('disclaimer shown on first guest activation', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      var disclaimerShown = false;
      deepLinkHandler
        ..onShowDisclaimer = () async {
          disclaimerShown = true;
          return true;
        }
        ..startListening();

      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(disclaimerShown, isTrue);
      expect(guestModeNotifier.state.isGuestMode, isTrue);
      expect(guestModeNotifier.state.hasSeenDisclaimer, isTrue);
    });

    test('disclaimer not shown on subsequent activations', () async {
      // Mark disclaimer as already seen
      await guestModeNotifier.markDisclaimerSeen();

      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      var disclaimerShown = false;
      deepLinkHandler
        ..onShowDisclaimer = () async {
          disclaimerShown = true;
          return true;
        }
        ..startListening();

      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Disclaimer was NOT shown because it was already seen
      expect(disclaimerShown, isFalse);
      expect(guestModeNotifier.state.isGuestMode, isTrue);
    });

    test('declining disclaimer prevents guest mode activation', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      Future<bool> declineDisclaimer() async => false;
      deepLinkHandler
        ..onShowDisclaimer = declineDisclaimer
        ..startListening();

      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(guestModeNotifier.state.isGuestMode, isFalse);
    });
  });

  // ===========================================================================
  // Flow 4: Revocation flow
  // ===========================================================================

  group('Revocation flow', () {
    test('host revokes → guest sync fails → access revoked', () async {
      // Create and activate
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Guest syncs successfully
      var syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(syncResult.valueOrNull!.isValid, isTrue);

      // Host revokes the invite
      final revokeResult = await revokeUseCase(
        RevokeGuestInviteInput(inviteId: invite.id),
      );
      expect(revokeResult.isSuccess, isTrue);

      // Guest tries to sync again — should be rejected
      syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(syncResult.isSuccess, isTrue);
      expect(syncResult.valueOrNull!.isValid, isFalse);
      expect(
        syncResult.valueOrNull!.rejectionReason,
        TokenRejectionReason.revoked,
      );
    });

    test('revocation clears activeDeviceId', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Verify device is registered
      var stored = (await repository.getByToken(invite.token)).valueOrNull!;
      expect(stored.activeDeviceId, 'guest-device-1');

      // Revoke
      await revokeUseCase(RevokeGuestInviteInput(inviteId: invite.id));

      // Verify activeDeviceId is cleared
      stored = (await repository.getByToken(invite.token)).valueOrNull!;
      expect(stored.activeDeviceId, isNull);
      expect(stored.isRevoked, isTrue);
    });

    test('deep link with revoked token triggers onAccessRevoked', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      // Revoke before any activation
      await revokeUseCase(RevokeGuestInviteInput(inviteId: invite.id));

      TokenRejectionReason? capturedReason;
      deepLinkHandler
        ..onAccessRevoked = (reason) {
          capturedReason = reason;
        }
        ..startListening();

      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(capturedReason, TokenRejectionReason.revoked);
      expect(guestModeNotifier.state.isGuestMode, isFalse);
    });

    test('guest mode deactivation clears state', () {
      guestModeNotifier.activateGuestMode(profileId: 'p1', token: 'tok-1');
      expect(guestModeNotifier.state.isGuestMode, isTrue);

      guestModeNotifier.deactivateGuestMode();

      expect(guestModeNotifier.state.isGuestMode, isFalse);
      expect(guestModeNotifier.state.guestProfileId, isNull);
      expect(guestModeNotifier.state.guestToken, isNull);
    });
  });

  // ===========================================================================
  // Flow 5: Device replacement flow
  // ===========================================================================

  group('Device replacement flow', () {
    test('host removes device → new device can activate same invite', () async {
      // Create and activate on device 1
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Verify device 2 can't activate
      var device2Result = await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-2',
      );
      expect(device2Result.valueOrNull!.isValid, isFalse);

      // Host removes device
      final removeResult = await removeDeviceUseCase(
        RemoveGuestDeviceInput(inviteId: invite.id),
      );
      expect(removeResult.isSuccess, isTrue);

      // Verify activeDeviceId is cleared
      final stored = (await repository.getByToken(invite.token)).valueOrNull!;
      expect(stored.activeDeviceId, isNull);
      expect(stored.isRevoked, isFalse); // Not revoked, just device cleared

      // Device 2 can now activate
      device2Result = await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-2',
      );
      expect(device2Result.isSuccess, isTrue);
      expect(device2Result.valueOrNull!.isValid, isTrue);

      // Device 2 is now registered
      final updated = (await repository.getByToken(invite.token)).valueOrNull!;
      expect(updated.activeDeviceId, 'guest-device-2');
    });

    test('host creates new invite after revoking old one', () async {
      // Create first invite
      final firstResult = await createUseCase(
        const CreateGuestInviteInput(
          profileId: 'profile-001',
          label: 'First device',
        ),
      );
      final firstInvite = firstResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: firstInvite.token,
        deviceId: 'guest-device-1',
      );

      // Revoke first invite
      await revokeUseCase(RevokeGuestInviteInput(inviteId: firstInvite.id));

      // Create new invite (new QR code)
      final secondResult = await createUseCase(
        const CreateGuestInviteInput(
          profileId: 'profile-001',
          label: 'Replacement device',
        ),
      );
      final secondInvite = secondResult.valueOrNull!;

      // Different token
      expect(secondInvite.token, isNot(firstInvite.token));

      // New device activates with new token
      final activateResult = await tokenService.validateAndActivate(
        token: secondInvite.token,
        deviceId: 'guest-device-2',
      );
      expect(activateResult.isSuccess, isTrue);
      expect(activateResult.valueOrNull!.isValid, isTrue);

      // Old token still rejected
      final oldResult = await tokenService.validateAndActivate(
        token: firstInvite.token,
        deviceId: 'guest-device-3',
      );
      expect(oldResult.valueOrNull!.isValid, isFalse);
      expect(
        oldResult.valueOrNull!.rejectionReason,
        TokenRejectionReason.revoked,
      );
    });

    test('device 1 can no longer sync after host removes device', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-1',
      );

      // Device 1 sync works before removal
      var syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(syncResult.valueOrNull!.isValid, isTrue);

      // Host removes device
      await removeDeviceUseCase(RemoveGuestDeviceInput(inviteId: invite.id));

      // Device 2 activates
      await tokenService.validateAndActivate(
        token: invite.token,
        deviceId: 'guest-device-2',
      );

      // Device 1 sync now fails (device mismatch)
      syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(syncResult.valueOrNull!.isValid, isFalse);
      expect(
        syncResult.valueOrNull!.rejectionReason,
        TokenRejectionReason.alreadyActiveOnAnotherDevice,
      );
    });
  });

  // ===========================================================================
  // Flow 6: Token expiry
  // ===========================================================================

  group('Token expiry', () {
    test('expired token rejected on deep link activation', () async {
      // Create invite with past expiry
      final createResult = await createUseCase(
        const CreateGuestInviteInput(
          profileId: 'profile-001',
          expiresAt: 1, // Epoch ms = 1 (long past)
        ),
      );
      final invite = createResult.valueOrNull!;

      TokenRejectionReason? capturedReason;
      deepLinkHandler
        ..onAccessRevoked = (reason) {
          capturedReason = reason;
        }
        ..startListening();

      deepLinkService.emitLink(
        GuestInviteLink(token: invite.token, profileId: invite.profileId),
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(capturedReason, TokenRejectionReason.expired);
    });

    test('expired token rejected on sync validation', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001', expiresAt: 1),
      );
      final invite = createResult.valueOrNull!;

      final syncResult = await syncValidator.validateBeforeSync(
        token: invite.token,
        deviceId: 'guest-device-1',
      );
      expect(syncResult.valueOrNull!.isValid, isFalse);
      expect(
        syncResult.valueOrNull!.rejectionReason,
        TokenRejectionReason.expired,
      );
    });
  });

  // ===========================================================================
  // Flow 7: Deep link URL parsing edge cases
  // ===========================================================================

  group('Deep link URL parsing', () {
    test('QR code deep link format is consistent', () async {
      final createResult = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite = createResult.valueOrNull!;

      // Build the same deep link the QR screen builds
      final deepLink =
          'shadow://invite?token=${invite.token}&profile=${invite.profileId}';

      // Parse it
      final parsed = DeepLinkService.parseInviteLink(deepLink);
      expect(parsed, isNotNull);
      expect(parsed!.token, invite.token);
      expect(parsed.profileId, invite.profileId);
    });

    test('token with special characters survives URL round-trip', () {
      // While our tokens are UUIDs, verify URL encoding works
      const encoded = 'shadow://invite?token=abc%20def%26ghi&profile=prof-1';
      final parsed = DeepLinkService.parseInviteLink(encoded);
      expect(parsed, isNotNull);
      expect(parsed!.token, 'abc def&ghi');
    });
  });

  // ===========================================================================
  // Flow 8: Multiple profiles
  // ===========================================================================

  group('Multiple profiles', () {
    test('invites for different profiles are independent', () async {
      // Create invite for profile 1
      final result1 = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite1 = result1.valueOrNull!;

      // Create invite for profile 2
      final result2 = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-002'),
      );
      final invite2 = result2.valueOrNull!;

      // Activate invite 1
      await tokenService.validateAndActivate(
        token: invite1.token,
        deviceId: 'guest-device-1',
      );

      // Invite 2 should still be activatable
      final validate2 = await tokenService.validateAndActivate(
        token: invite2.token,
        deviceId: 'guest-device-1',
      );
      expect(validate2.isSuccess, isTrue);
      expect(validate2.valueOrNull!.isValid, isTrue);
    });

    test('revoking one profile invite does not affect another', () async {
      final result1 = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      final invite1 = result1.valueOrNull!;

      final result2 = await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-002'),
      );
      final invite2 = result2.valueOrNull!;

      // Activate both
      await tokenService.validateAndActivate(
        token: invite1.token,
        deviceId: 'guest-device-1',
      );
      await tokenService.validateAndActivate(
        token: invite2.token,
        deviceId: 'guest-device-1',
      );

      // Revoke profile 1 invite
      await revokeUseCase(RevokeGuestInviteInput(inviteId: invite1.id));

      // Profile 1 sync fails
      final sync1 = await syncValidator.validateBeforeSync(
        token: invite1.token,
        deviceId: 'guest-device-1',
      );
      expect(sync1.valueOrNull!.isValid, isFalse);

      // Profile 2 sync still works
      final sync2 = await syncValidator.validateBeforeSync(
        token: invite2.token,
        deviceId: 'guest-device-1',
      );
      expect(sync2.valueOrNull!.isValid, isTrue);
    });

    test('listing invites returns only for requested profile', () async {
      await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );
      await createUseCase(
        const CreateGuestInviteInput(profileId: 'profile-002'),
      );

      final list1 = await repository.getByProfile('profile-001');
      expect(list1.valueOrNull!.length, 2);

      final list2 = await repository.getByProfile('profile-002');
      expect(list2.valueOrNull!.length, 1);
    });
  });
}
