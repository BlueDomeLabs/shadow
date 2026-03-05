// test/unit/domain/usecases/profiles/profile_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/guest_invite_repository.dart';
import 'package:shadow_app/domain/repositories/profile_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/profiles/create_profile_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/delete_profile_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/get_profiles_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/profile_inputs.dart';
import 'package:shadow_app/domain/usecases/profiles/update_profile_use_case.dart';

@GenerateMocks([
  ProfileRepository,
  ProfileAuthorizationService,
  DeviceInfoService,
  GuestInviteRepository,
])
import 'profile_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<Profile>, AppError>>(const Success([]));
  provideDummy<Result<Profile, AppError>>(
    const Success(
      Profile(
        id: 'dummy',
        clientId: 'dummy',
        name: 'Dummy',
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<GuestInvite>, AppError>>(const Success([]));

  const testDeviceId = 'device-001';
  const testProfileId = 'profile-001';

  Profile makeProfile({
    String id = testProfileId,
    String clientId = 'client-001',
    String name = 'Alice',
    String? ownerId = testDeviceId,
  }) => Profile(
    id: id,
    clientId: clientId,
    name: name,
    ownerId: ownerId,
    syncMetadata: const SyncMetadata(
      syncCreatedAt: 0,
      syncUpdatedAt: 0,
      syncDeviceId: testDeviceId,
    ),
  );

  // ============================================================
  // GetProfilesUseCase
  // ============================================================

  group('GetProfilesUseCase', () {
    late MockProfileRepository mockRepo;
    late MockDeviceInfoService mockDevice;
    late GetProfilesUseCase useCase;

    setUp(() {
      mockRepo = MockProfileRepository();
      mockDevice = MockDeviceInfoService();
      useCase = GetProfilesUseCase(mockRepo, mockDevice);
      when(mockDevice.getDeviceId()).thenAnswer((_) async => testDeviceId);
    });

    test('returns profiles filtered by device owner', () async {
      final profiles = [makeProfile()];
      when(
        mockRepo.getByOwner(testDeviceId),
      ).thenAnswer((_) async => Success(profiles));

      final result = await useCase();

      expect(result, isA<Success<List<Profile>, AppError>>());
      final value = (result as Success<List<Profile>, AppError>).value;
      expect(value, profiles);
      verify(mockRepo.getByOwner(testDeviceId)).called(1);
    });

    test('propagates repository failure', () async {
      when(
        mockRepo.getByOwner(testDeviceId),
      ).thenAnswer((_) async => Failure(DatabaseError.queryFailed('test')));

      final result = await useCase();

      expect(result, isA<Failure<List<Profile>, AppError>>());
    });

    test('uses device ID from DeviceInfoService', () async {
      when(
        mockRepo.getByOwner(testDeviceId),
      ).thenAnswer((_) async => const Success([]));

      await useCase();

      verify(mockDevice.getDeviceId()).called(1);
      verify(mockRepo.getByOwner(testDeviceId)).called(1);
    });
  });

  // ============================================================
  // CreateProfileUseCase
  // ============================================================

  group('CreateProfileUseCase', () {
    late MockProfileRepository mockRepo;
    late MockDeviceInfoService mockDevice;
    late CreateProfileUseCase useCase;

    setUp(() {
      mockRepo = MockProfileRepository();
      mockDevice = MockDeviceInfoService();
      useCase = CreateProfileUseCase(mockRepo, mockDevice);
      when(mockDevice.getDeviceId()).thenAnswer((_) async => testDeviceId);
    });

    test('creates profile with ownerId from device', () async {
      when(mockRepo.create(any)).thenAnswer(
        (inv) async => Success(inv.positionalArguments[0] as Profile),
      );

      const input = CreateProfileInput(
        clientId: 'client-001',
        ownerId: '', // Ignored — use case overrides with device ID
        name: 'Alice',
      );

      final result = await useCase(input);

      expect(result, isA<Success<Profile, AppError>>());
      final created = (result as Success<Profile, AppError>).value;
      expect(created.ownerId, testDeviceId);
      expect(created.name, 'Alice');
    });

    test('populates ownerId even if caller passes different value', () async {
      when(mockRepo.create(any)).thenAnswer(
        (inv) async => Success(inv.positionalArguments[0] as Profile),
      );

      const input = CreateProfileInput(
        clientId: 'client-001',
        ownerId: 'caller-supplied-value', // Should be overridden
        name: 'Bob',
      );

      final result = await useCase(input);

      expect(result, isA<Success<Profile, AppError>>());
      final created = (result as Success<Profile, AppError>).value;
      expect(created.ownerId, testDeviceId); // Device ID, not caller value
    });

    test('returns ValidationError when name is empty', () async {
      const input = CreateProfileInput(
        clientId: 'client-001',
        ownerId: '',
        name: '',
      );

      final result = await useCase(input);

      expect(result, isA<Failure<Profile, AppError>>());
      final error = (result as Failure<Profile, AppError>).error;
      expect(error, isA<ValidationError>());
    });

    test('propagates repository failure', () async {
      when(
        mockRepo.create(any),
      ).thenAnswer((_) async => Failure(DatabaseError.queryFailed('test')));

      const input = CreateProfileInput(
        clientId: 'client-001',
        ownerId: '',
        name: 'Alice',
      );

      final result = await useCase(input);

      expect(result, isA<Failure<Profile, AppError>>());
    });
  });

  // ============================================================
  // UpdateProfileUseCase
  // ============================================================

  group('UpdateProfileUseCase', () {
    late MockProfileRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late UpdateProfileUseCase useCase;

    setUp(() {
      mockRepo = MockProfileRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = UpdateProfileUseCase(mockRepo, mockAuth);
    });

    test('updates profile fields', () async {
      final existing = makeProfile();
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getById(testProfileId),
      ).thenAnswer((_) async => Success(existing));
      when(mockRepo.update(any)).thenAnswer(
        (inv) async => Success(inv.positionalArguments[0] as Profile),
      );

      const input = UpdateProfileInput(
        profileId: testProfileId,
        name: 'Alice Updated',
      );

      final result = await useCase(input);

      expect(result, isA<Success<Profile, AppError>>());
      final updated = (result as Success<Profile, AppError>).value;
      expect(updated.name, 'Alice Updated');
    });

    test('returns AuthError when access denied', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      const input = UpdateProfileInput(
        profileId: testProfileId,
        name: 'Alice Updated',
      );

      final result = await useCase(input);

      expect(result, isA<Failure<Profile, AppError>>());
      final error = (result as Failure<Profile, AppError>).error;
      expect(error, isA<AuthError>());
    });

    test('returns ValidationError when name is empty', () async {
      final existing = makeProfile();
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getById(testProfileId),
      ).thenAnswer((_) async => Success(existing));

      const input = UpdateProfileInput(profileId: testProfileId, name: '');

      final result = await useCase(input);

      expect(result, isA<Failure<Profile, AppError>>());
      expect(
        (result as Failure<Profile, AppError>).error,
        isA<ValidationError>(),
      );
    });
  });

  // ============================================================
  // DeleteProfileUseCase
  // ============================================================

  group('DeleteProfileUseCase', () {
    late MockProfileRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late MockGuestInviteRepository mockInvites;
    late DeleteProfileUseCase useCase;

    GuestInvite makeInvite({
      String id = 'invite-001',
      bool isRevoked = false,
    }) => GuestInvite(
      id: id,
      profileId: testProfileId,
      token: 'token-$id',
      createdAt: 0,
      isRevoked: isRevoked,
    );

    setUp(() {
      mockRepo = MockProfileRepository();
      mockAuth = MockProfileAuthorizationService();
      mockInvites = MockGuestInviteRepository();
      useCase = DeleteProfileUseCase(mockRepo, mockAuth, mockInvites);
    });

    test('cascade-deletes profile when authorized and no invites', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockInvites.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success([]));
      when(
        mockRepo.cascadeDeleteProfileData(testProfileId),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const DeleteProfileInput(profileId: testProfileId),
      );

      expect(result, isA<Success<void, AppError>>());
      verify(mockRepo.cascadeDeleteProfileData(testProfileId)).called(1);
      verifyNever(mockInvites.revoke(any));
    });

    test('revokes non-revoked invites before cascade delete', () async {
      final invite1 = makeInvite();
      final invite2 = makeInvite(id: 'invite-002', isRevoked: true);

      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockInvites.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success([invite1, invite2]));
      when(
        mockInvites.revoke('invite-001'),
      ).thenAnswer((_) async => const Success(null));
      when(
        mockRepo.cascadeDeleteProfileData(testProfileId),
      ).thenAnswer((_) async => const Success(null));

      await useCase(const DeleteProfileInput(profileId: testProfileId));

      verify(mockInvites.revoke('invite-001')).called(1);
      verifyNever(mockInvites.revoke('invite-002')); // already revoked
      verify(mockRepo.cascadeDeleteProfileData(testProfileId)).called(1);
    });

    test('returns AuthError when access denied', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const DeleteProfileInput(profileId: testProfileId),
      );

      expect(result, isA<Failure<void, AppError>>());
      final error = (result as Failure<void, AppError>).error;
      expect(error, isA<AuthError>());
      verifyNever(mockInvites.getByProfile(any));
      verifyNever(mockRepo.cascadeDeleteProfileData(any));
    });

    test(
      'propagates repository failure from cascadeDeleteProfileData',
      () async {
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(
          mockInvites.getByProfile(testProfileId),
        ).thenAnswer((_) async => const Success([]));
        when(mockRepo.cascadeDeleteProfileData(testProfileId)).thenAnswer(
          (_) async =>
              Failure(DatabaseError.transactionFailed('deleteProfileCascade')),
        );

        final result = await useCase(
          const DeleteProfileInput(profileId: testProfileId),
        );

        expect(result, isA<Failure<void, AppError>>());
      },
    );
  });
}
