// test/domain/services/guest_sync_validator_test.dart
// Tests for GuestSyncValidator pre-sync token checks.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/services/guest_sync_validator.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';

/// Fake repository for testing.
class _FakeGuestInviteRepository implements GuestInviteRepository {
  GuestInvite? _invite;
  AppError? getByTokenError;

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
  Future<Result<GuestInvite, AppError>> update(GuestInvite invite) async =>
      Success(invite);

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

void main() {
  late _FakeGuestInviteRepository repository;
  late GuestTokenService tokenService;
  late GuestSyncValidator validator;

  setUp(() {
    repository = _FakeGuestInviteRepository();
    tokenService = GuestTokenService(repository);
    validator = GuestSyncValidator(tokenService);
  });

  group('GuestSyncValidator.validateBeforeSync', () {
    test('returns valid when token is active on this device', () async {
      repository.seedInvite(
        const GuestInvite(
          id: 'inv-1',
          profileId: 'p1',
          token: 'tok-1',
          createdAt: 1000,
          activeDeviceId: 'device-1',
        ),
      );

      final result = await validator.validateBeforeSync(
        token: 'tok-1',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isTrue);
    });

    test('returns rejected when token is revoked', () async {
      repository.seedInvite(
        const GuestInvite(
          id: 'inv-1',
          profileId: 'p1',
          token: 'tok-1',
          createdAt: 1000,
          isRevoked: true,
        ),
      );

      final result = await validator.validateBeforeSync(
        token: 'tok-1',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isFalse);
      expect(result.valueOrNull!.rejectionReason, TokenRejectionReason.revoked);
    });

    test('returns rejected when token not found', () async {
      final result = await validator.validateBeforeSync(
        token: 'missing',
        deviceId: 'device-1',
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isValid, isFalse);
      expect(
        result.valueOrNull!.rejectionReason,
        TokenRejectionReason.notFound,
      );
    });

    test('returns failure on repository error', () async {
      repository.getByTokenError = DatabaseError.queryFailed('db down');

      final result = await validator.validateBeforeSync(
        token: 'tok-1',
        deviceId: 'device-1',
      );

      expect(result.isFailure, isTrue);
    });
  });
}
