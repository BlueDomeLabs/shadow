// test/presentation/providers/guest_mode/deep_link_handler_test.dart
// Tests for DeepLinkHandler invite link processing.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/deep_link_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/presentation/providers/guest_mode/deep_link_handler.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fake DeepLinkService that exposes a stream controller for testing.
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

/// Fake repository for testing.
class _FakeGuestInviteRepository implements GuestInviteRepository {
  GuestInvite? _invite;

  // ignore: use_setters_to_change_properties
  void seedInvite(GuestInvite invite) => _invite = invite;

  @override
  Future<Result<GuestInvite?, AppError>> getByToken(String token) async {
    if (_invite != null && _invite!.token == token) return Success(_invite);
    return const Success(null);
  }

  @override
  Future<Result<GuestInvite, AppError>> update(GuestInvite invite) async {
    _invite = invite;
    return Success(invite);
  }

  @override
  Future<Result<GuestInvite, AppError>> create(GuestInvite invite) async =>
      throw UnimplementedError();

  @override
  Future<Result<GuestInvite, AppError>> getById(String id) async =>
      throw UnimplementedError();

  @override
  Future<Result<List<GuestInvite>, AppError>> getByProfile(
    String profileId,
  ) async => throw UnimplementedError();

  @override
  Future<Result<void, AppError>> revoke(String id) async =>
      throw UnimplementedError();

  @override
  Future<Result<void, AppError>> hardDelete(String id) async =>
      throw UnimplementedError();
}

void _captureReason(
  DeepLinkHandler handler,
  void Function(TokenRejectionReason) onCapture,
) {
  handler.onAccessRevoked = onCapture;
}

void main() {
  late _FakeDeepLinkService deepLinkService;
  late _FakeGuestInviteRepository repository;
  late GuestTokenService tokenService;
  late GuestModeNotifier guestModeNotifier;
  late DeepLinkHandler handler;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    deepLinkService = _FakeDeepLinkService();
    repository = _FakeGuestInviteRepository();
    tokenService = GuestTokenService(repository);
    guestModeNotifier = GuestModeNotifier();

    handler = DeepLinkHandler(
      deepLinkService: deepLinkService,
      tokenService: tokenService,
      guestModeNotifier: guestModeNotifier,
      deviceId: 'device-1',
    );
  });

  tearDown(() {
    handler.dispose();
    deepLinkService.dispose();
    guestModeNotifier.dispose();
  });

  group('DeepLinkHandler', () {
    test(
      'activates guest mode for valid token when disclaimer already seen',
      () async {
        repository.seedInvite(
          const GuestInvite(
            id: 'inv-1',
            profileId: 'profile-1',
            token: 'tok-1',
            createdAt: 1000,
          ),
        );

        // Mark disclaimer as already seen
        await guestModeNotifier.markDisclaimerSeen();
        handler.startListening();

        deepLinkService.emitLink(
          const GuestInviteLink(token: 'tok-1', profileId: 'profile-1'),
        );

        // Allow async processing
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(guestModeNotifier.state.isGuestMode, isTrue);
        expect(guestModeNotifier.state.guestProfileId, 'profile-1');
        expect(guestModeNotifier.state.guestToken, 'tok-1');
      },
    );

    test('calls onAccessRevoked when token is revoked', () async {
      repository.seedInvite(
        const GuestInvite(
          id: 'inv-1',
          profileId: 'profile-1',
          token: 'tok-1',
          createdAt: 1000,
          isRevoked: true,
        ),
      );

      TokenRejectionReason? capturedReason;
      _captureReason(handler, (reason) => capturedReason = reason);
      handler.startListening();

      deepLinkService.emitLink(
        const GuestInviteLink(token: 'tok-1', profileId: 'profile-1'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(capturedReason, TokenRejectionReason.revoked);
      expect(guestModeNotifier.state.isGuestMode, isFalse);
    });

    test('calls onAccessRevoked when token not found', () async {
      // No invite seeded — token not found.
      TokenRejectionReason? capturedReason;
      _captureReason(handler, (reason) => capturedReason = reason);
      handler.startListening();

      deepLinkService.emitLink(
        const GuestInviteLink(token: 'missing', profileId: 'profile-1'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(capturedReason, TokenRejectionReason.notFound);
    });

    test('calls onAccessRevoked when token active on another device', () async {
      repository.seedInvite(
        const GuestInvite(
          id: 'inv-1',
          profileId: 'profile-1',
          token: 'tok-1',
          createdAt: 1000,
          activeDeviceId: 'other-device',
        ),
      );

      TokenRejectionReason? capturedReason;
      _captureReason(handler, (reason) => capturedReason = reason);
      handler.startListening();

      deepLinkService.emitLink(
        const GuestInviteLink(token: 'tok-1', profileId: 'profile-1'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(capturedReason, TokenRejectionReason.alreadyActiveOnAnotherDevice);
    });

    test('shows disclaimer before activating when not seen', () async {
      repository.seedInvite(
        const GuestInvite(
          id: 'inv-1',
          profileId: 'profile-1',
          token: 'tok-1',
          createdAt: 1000,
        ),
      );

      // Disclaimer not seen, user accepts
      var disclaimerShown = false;
      handler
        ..onShowDisclaimer = () async {
          disclaimerShown = true;
          return true;
        }
        ..startListening();

      deepLinkService.emitLink(
        const GuestInviteLink(token: 'tok-1', profileId: 'profile-1'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(disclaimerShown, isTrue);
      expect(guestModeNotifier.state.isGuestMode, isTrue);
    });

    test('does not activate when user declines disclaimer', () async {
      repository.seedInvite(
        const GuestInvite(
          id: 'inv-1',
          profileId: 'profile-1',
          token: 'tok-1',
          createdAt: 1000,
        ),
      );

      Future<bool> declineDisclaimer() async => false;
      handler
        ..onShowDisclaimer = declineDisclaimer
        ..startListening();

      deepLinkService.emitLink(
        const GuestInviteLink(token: 'tok-1', profileId: 'profile-1'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(guestModeNotifier.state.isGuestMode, isFalse);
    });

    test('dispose cancels subscription', () async {
      handler
        ..startListening()
        ..dispose();

      // After dispose, emitting should not crash
      deepLinkService.emitLink(
        const GuestInviteLink(token: 'tok-1', profileId: 'profile-1'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      // No crash, no activation
      expect(guestModeNotifier.state.isGuestMode, isFalse);
    });
  });
}
