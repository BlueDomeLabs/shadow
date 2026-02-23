// test/domain/services/guest_token_service_test.dart
// Tests for GuestTokenService token validation and device activation.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';

/// Fake repository for testing GuestTokenService.
class _FakeGuestInviteRepository implements GuestInviteRepository {
  GuestInvite? _invite;
  GuestInvite? updatedInvite;
  AppError? getByTokenError;
  AppError? updateError;

  // ignore: use_setters_to_change_properties
  void seedInvite(GuestInvite invite) => _invite = invite;

  @override
  Future<Result<GuestInvite?, AppError>> getByToken(String token) async {
    if (getByTokenError != null) return Failure(getByTokenError!);
    if (_invite != null && _invite!.token == token) {
      return Success(_invite);
    }
    return const Success(null);
  }

  @override
  Future<Result<GuestInvite, AppError>> update(GuestInvite invite) async {
    if (updateError != null) return Failure(updateError!);
    updatedInvite = invite;
    _invite = invite;
    return Success(invite);
  }

  @override
  Future<Result<GuestInvite, AppError>> create(GuestInvite invite) async =>
      Success(invite);

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

GuestInvite _makeInvite({
  String token = 'test-token',
  bool isRevoked = false,
  int? expiresAt,
  String? activeDeviceId,
  int? lastSeenAt,
}) => GuestInvite(
  id: 'invite-1',
  profileId: 'profile-1',
  token: token,
  label: 'Test Device',
  createdAt: 1000000,
  expiresAt: expiresAt,
  isRevoked: isRevoked,
  activeDeviceId: activeDeviceId,
  lastSeenAt: lastSeenAt,
);

void main() {
  late _FakeGuestInviteRepository repository;
  late GuestTokenService service;

  setUp(() {
    repository = _FakeGuestInviteRepository();
    service = GuestTokenService(repository);
  });

  group('GuestTokenService.validateAndActivate', () {
    test('returns notFound when token does not exist', () async {
      // No invite seeded — token not found.
      final result = await service.validateAndActivate(
        token: 'missing',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      final validation = result.valueOrNull!;
      expect(validation.isValid, isFalse);
      expect(validation.rejectionReason, TokenRejectionReason.notFound);
    });

    test('returns revoked when token is revoked', () async {
      repository.seedInvite(_makeInvite(isRevoked: true));

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      final validation = result.valueOrNull!;
      expect(validation.isValid, isFalse);
      expect(validation.rejectionReason, TokenRejectionReason.revoked);
    });

    test('returns expired when token has passed expiry', () async {
      repository.seedInvite(_makeInvite(expiresAt: 1));

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      final validation = result.valueOrNull!;
      expect(validation.isValid, isFalse);
      expect(validation.rejectionReason, TokenRejectionReason.expired);
    });

    test(
      'returns alreadyActiveOnAnotherDevice when different device',
      () async {
        repository.seedInvite(_makeInvite(activeDeviceId: 'other-device'));

        final result = await service.validateAndActivate(
          token: 'test-token',
          deviceId: 'device-1',
        );

        expect(result.isSuccess, isTrue);
        final validation = result.valueOrNull!;
        expect(validation.isValid, isFalse);
        expect(
          validation.rejectionReason,
          TokenRejectionReason.alreadyActiveOnAnotherDevice,
        );
      },
    );

    test('registers device when not yet activated', () async {
      repository.seedInvite(_makeInvite());

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      final validation = result.valueOrNull!;
      expect(validation.isValid, isTrue);
      expect(validation.invite, isNotNull);
      expect(repository.updatedInvite!.activeDeviceId, 'device-1');
      expect(repository.updatedInvite!.lastSeenAt, isNotNull);
    });

    test('updates lastSeenAt when same device re-validates', () async {
      repository.seedInvite(
        _makeInvite(activeDeviceId: 'device-1', lastSeenAt: 100),
      );

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      final validation = result.valueOrNull!;
      expect(validation.isValid, isTrue);
      expect(repository.updatedInvite!.lastSeenAt, greaterThan(100));
    });

    test('returns failure when repository getByToken fails', () async {
      repository.getByTokenError = DatabaseError.queryFailed('test error');

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isFailure, isTrue);
    });

    test(
      'returns failure when repository update fails on registration',
      () async {
        repository
          ..seedInvite(_makeInvite())
          ..updateError = DatabaseError.updateFailed(
            'guest_invites',
            'invite-1',
          );

        final result = await service.validateAndActivate(
          token: 'test-token',
          deviceId: 'device-1',
        );

        expect(result.isFailure, isTrue);
      },
    );

    test('allows non-expired token with future expiresAt', () async {
      final futureExpiry =
          DateTime.now().millisecondsSinceEpoch + 86400000; // +1 day
      repository.seedInvite(_makeInvite(expiresAt: futureExpiry));

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isTrue);
    });

    test('allows token with no expiry', () async {
      repository.seedInvite(_makeInvite());

      final result = await service.validateAndActivate(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isTrue);
    });
  });

  group('GuestTokenService.validateOnly', () {
    test('returns valid for active token on same device', () async {
      repository.seedInvite(_makeInvite(activeDeviceId: 'device-1'));

      final result = await service.validateOnly(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isTrue);
      // validateOnly should NOT update the invite
      expect(repository.updatedInvite, isNull);
    });

    test('returns notFound when token does not exist', () async {
      final result = await service.validateOnly(
        token: 'missing',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(
        result.valueOrNull!.rejectionReason,
        TokenRejectionReason.notFound,
      );
    });

    test('returns revoked when token is revoked', () async {
      repository.seedInvite(_makeInvite(isRevoked: true));

      final result = await service.validateOnly(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.rejectionReason, TokenRejectionReason.revoked);
    });

    test('returns expired when token is past expiry', () async {
      repository.seedInvite(_makeInvite(expiresAt: 1));

      final result = await service.validateOnly(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.rejectionReason, TokenRejectionReason.expired);
    });

    test('returns alreadyActiveOnAnotherDevice for wrong device', () async {
      repository.seedInvite(_makeInvite(activeDeviceId: 'other-device'));

      final result = await service.validateOnly(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(
        result.valueOrNull!.rejectionReason,
        TokenRejectionReason.alreadyActiveOnAnotherDevice,
      );
    });

    test('returns valid for unactivated token', () async {
      repository.seedInvite(_makeInvite());

      final result = await service.validateOnly(
        token: 'test-token',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isTrue);
    });
  });
}
