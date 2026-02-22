// test/unit/domain/usecases/guest_invites/guest_invite_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/usecases/guest_invites/create_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/list_guest_invites_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/remove_guest_device_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/validate_guest_token_use_case.dart';

@GenerateMocks([GuestInviteRepository])
import 'guest_invite_usecases_test.mocks.dart';

void main() {
  // Provide dummy values for Result types that Mockito can't generate
  provideDummy<Result<List<GuestInvite>, AppError>>(const Success([]));
  provideDummy<Result<GuestInvite, AppError>>(
    const Success(
      GuestInvite(
        id: 'dummy',
        profileId: 'dummy',
        token: 'dummy',
        createdAt: 0,
      ),
    ),
  );
  provideDummy<Result<GuestInvite?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));

  GuestInvite createTestInvite({
    String id = 'invite-001',
    String profileId = 'profile-001',
    String token = 'token-001',
    String label = 'Test Device',
    int createdAt = 1000,
    int? expiresAt,
    bool isRevoked = false,
    String? activeDeviceId,
  }) => GuestInvite(
    id: id,
    profileId: profileId,
    token: token,
    label: label,
    createdAt: createdAt,
    expiresAt: expiresAt,
    isRevoked: isRevoked,
    activeDeviceId: activeDeviceId,
  );

  group('CreateGuestInviteUseCase', () {
    late MockGuestInviteRepository mockRepository;
    late CreateGuestInviteUseCase useCase;

    setUp(() {
      mockRepository = MockGuestInviteRepository();
      useCase = CreateGuestInviteUseCase(mockRepository);
    });

    test('call_createsInviteWithGeneratedIdAndToken', () async {
      when(mockRepository.create(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as GuestInvite),
      );

      final result = await useCase(
        const CreateGuestInviteInput(
          profileId: 'profile-001',
          label: 'Phone A',
        ),
      );

      expect(result.isSuccess, isTrue);
      final invite = result.valueOrNull!;
      expect(invite.id, isNotEmpty);
      expect(invite.token, isNotEmpty);
      expect(invite.id, isNot(invite.token)); // ID and token are different
      expect(invite.profileId, 'profile-001');
      expect(invite.label, 'Phone A');
      expect(invite.createdAt, greaterThan(0));
      expect(invite.isRevoked, isFalse);
      verify(mockRepository.create(any)).called(1);
    });

    test('call_passesExpiresAtToInvite', () async {
      when(mockRepository.create(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as GuestInvite),
      );

      final result = await useCase(
        const CreateGuestInviteInput(profileId: 'profile-001', expiresAt: 9999),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.expiresAt, 9999);
    });

    test('call_defaultLabelIsEmpty', () async {
      when(mockRepository.create(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as GuestInvite),
      );

      final result = await useCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.label, '');
    });

    test('call_repositoryFailure_returnsFailure', () async {
      when(mockRepository.create(any)).thenAnswer(
        (_) async =>
            Failure(DatabaseError.insertFailed('guest_invites', 'test error')),
      );

      final result = await useCase(
        const CreateGuestInviteInput(profileId: 'profile-001'),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });
  });

  group('RevokeGuestInviteUseCase', () {
    late MockGuestInviteRepository mockRepository;
    late RevokeGuestInviteUseCase useCase;

    setUp(() {
      mockRepository = MockGuestInviteRepository();
      useCase = RevokeGuestInviteUseCase(mockRepository);
    });

    test('call_delegatesToRepository', () async {
      when(
        mockRepository.revoke('invite-001'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const RevokeGuestInviteInput(inviteId: 'invite-001'),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepository.revoke('invite-001')).called(1);
    });

    test('call_repositoryFailure_returnsFailure', () async {
      when(mockRepository.revoke('nonexistent')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('guest_invites', 'nonexistent')),
      );

      final result = await useCase(
        const RevokeGuestInviteInput(inviteId: 'nonexistent'),
      );

      expect(result.isFailure, isTrue);
    });
  });

  group('ListGuestInvitesUseCase', () {
    late MockGuestInviteRepository mockRepository;
    late ListGuestInvitesUseCase useCase;

    setUp(() {
      mockRepository = MockGuestInviteRepository();
      useCase = ListGuestInvitesUseCase(mockRepository);
    });

    test('call_delegatesToRepository', () async {
      final invites = [createTestInvite(), createTestInvite(id: 'invite-002')];
      when(
        mockRepository.getByProfile('profile-001'),
      ).thenAnswer((_) async => Success(invites));

      final result = await useCase('profile-001');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 2);
      verify(mockRepository.getByProfile('profile-001')).called(1);
    });

    test('call_noInvites_returnsEmptyList', () async {
      when(
        mockRepository.getByProfile('profile-empty'),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase('profile-empty');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isEmpty);
    });
  });

  group('ValidateGuestTokenUseCase', () {
    late MockGuestInviteRepository mockRepository;
    late ValidateGuestTokenUseCase useCase;

    setUp(() {
      mockRepository = MockGuestInviteRepository();
      useCase = ValidateGuestTokenUseCase(mockRepository);
    });

    test('call_validToken_returnsInvite', () async {
      final invite = createTestInvite();
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.token, 'token-001');
    });

    test('call_tokenNotFound_returnsAuthError', () async {
      when(
        mockRepository.getByToken('bad-token'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'bad-token', deviceId: 'device-A'),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      expect(result.errorOrNull?.message, contains('Invalid invite token'));
    });

    test('call_revokedInvite_returnsAuthError', () async {
      final invite = createTestInvite(isRevoked: true);
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      expect(result.errorOrNull?.message, contains('revoked'));
    });

    test('call_expiredInvite_returnsAuthError', () async {
      final invite = createTestInvite(expiresAt: 1); // expired (epoch 1ms)
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      expect(result.errorOrNull?.message, contains('expired'));
    });

    test('call_notExpired_returnsSuccess', () async {
      final farFuture = DateTime.now().millisecondsSinceEpoch + 999999999;
      final invite = createTestInvite(expiresAt: farFuture);
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isSuccess, isTrue);
    });

    test('call_noExpiry_returnsSuccess', () async {
      final invite = createTestInvite();
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isSuccess, isTrue);
    });

    test('call_sameDevice_returnsSuccess', () async {
      final invite = createTestInvite(activeDeviceId: 'device-A');
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isSuccess, isTrue);
    });

    test('call_differentDevice_returnsAuthError', () async {
      final invite = createTestInvite(activeDeviceId: 'device-A');
      when(
        mockRepository.getByToken('token-001'),
      ).thenAnswer((_) async => Success(invite));

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-B'),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      expect(result.errorOrNull?.message, contains('another device'));
    });

    test('call_repositoryFailure_returnsFailure', () async {
      when(mockRepository.getByToken('token-001')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.queryFailed('guest_invites', 'db error')),
      );

      final result = await useCase(
        const ValidateGuestTokenInput(token: 'token-001', deviceId: 'device-A'),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });
  });

  group('RemoveGuestDeviceUseCase', () {
    late MockGuestInviteRepository mockRepository;
    late RemoveGuestDeviceUseCase useCase;

    setUp(() {
      mockRepository = MockGuestInviteRepository();
      useCase = RemoveGuestDeviceUseCase(mockRepository);
    });

    test('call_clearsActiveDeviceId', () async {
      final invite = createTestInvite(activeDeviceId: 'device-A');
      when(
        mockRepository.getById('invite-001'),
      ).thenAnswer((_) async => Success(invite));
      when(mockRepository.update(any)).thenAnswer(
        (invocation) async =>
            Success(invocation.positionalArguments[0] as GuestInvite),
      );

      final result = await useCase(
        const RemoveGuestDeviceInput(inviteId: 'invite-001'),
      );

      expect(result.isSuccess, isTrue);
      final captured =
          verify(mockRepository.update(captureAny)).captured.single
              as GuestInvite;
      expect(captured.activeDeviceId, isNull);
      expect(captured.id, 'invite-001');
    });

    test('call_inviteNotFound_returnsFailure', () async {
      when(mockRepository.getById('nonexistent')).thenAnswer(
        (_) async =>
            Failure(DatabaseError.notFound('guest_invites', 'nonexistent')),
      );

      final result = await useCase(
        const RemoveGuestDeviceInput(inviteId: 'nonexistent'),
      );

      expect(result.isFailure, isTrue);
      verifyNever(mockRepository.update(any));
    });

    test('call_updateFailure_returnsFailure', () async {
      final invite = createTestInvite(activeDeviceId: 'device-A');
      when(
        mockRepository.getById('invite-001'),
      ).thenAnswer((_) async => Success(invite));
      when(mockRepository.update(any)).thenAnswer(
        (_) async => Failure(
          DatabaseError.updateFailed('guest_invites', 'update error'),
        ),
      );

      final result = await useCase(
        const RemoveGuestDeviceInput(inviteId: 'invite-001'),
      );

      expect(result.isFailure, isTrue);
    });
  });
}
