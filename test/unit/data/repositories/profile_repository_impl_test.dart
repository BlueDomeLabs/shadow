// test/unit/data/repositories/profile_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/profile_dao.dart';
import 'package:shadow_app/data/repositories/profile_repository_impl.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([ProfileDao, DeviceInfoService])
import 'profile_repository_impl_test.mocks.dart';

void main() {
  // Provide dummy values for Result types that Mockito can't generate
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
  provideDummy<Result<Profile?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));

  group('ProfileRepositoryImpl', () {
    late MockProfileDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late ProfileRepositoryImpl repository;

    const testDeviceId = 'test-device-123';

    Profile createTestProfile({
      String id = 'profile-001',
      String clientId = 'client-001',
      String name = 'Test Profile',
      String? ownerId = 'owner-001',
      SyncMetadata? syncMetadata,
    }) => Profile(
      id: id,
      clientId: clientId,
      name: name,
      ownerId: ownerId,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockProfileDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = ProfileRepositoryImpl(mockDao, uuid, mockDeviceInfoService);

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('delegates to dao', () async {
        when(mockDao.getAll()).thenAnswer((_) async => const Success([]));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        verify(mockDao.getAll()).called(1);
      });
    });

    group('getById', () {
      test('delegates to dao', () async {
        final profile = createTestProfile();
        when(
          mockDao.getById('profile-001'),
        ).thenAnswer((_) async => Success(profile));

        final result = await repository.getById('profile-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.getById('profile-001')).called(1);
      });
    });

    group('create', () {
      test('prepares entity with sync metadata and delegates to dao', () async {
        final profile = createTestProfile();

        when(mockDao.create(any)).thenAnswer((_) async => Success(profile));

        final result = await repository.create(profile);

        expect(result.isSuccess, isTrue);
        final captured =
            verify(mockDao.create(captureAny)).captured.single as Profile;
        expect(captured.syncMetadata.syncDeviceId, testDeviceId);
      });

      test('generates new ID when entity ID is empty', () async {
        final profile = createTestProfile(id: '');

        when(mockDao.create(any)).thenAnswer((_) async => Success(profile));

        await repository.create(profile);

        final captured =
            verify(mockDao.create(captureAny)).captured.single as Profile;
        expect(captured.id, isNotEmpty);
        expect(captured.id, isNot(''));
      });

      test('preserves existing ID when not empty', () async {
        final profile = createTestProfile(id: 'keep-this-id');

        when(mockDao.create(any)).thenAnswer((_) async => Success(profile));

        await repository.create(profile);

        final captured =
            verify(mockDao.create(captureAny)).captured.single as Profile;
        expect(captured.id, 'keep-this-id');
      });
    });

    group('update', () {
      test('prepares sync metadata and delegates to dao', () async {
        final profile = createTestProfile();

        when(
          mockDao.updateEntity(any),
        ).thenAnswer((_) async => Success(profile));

        final result = await repository.update(profile);

        expect(result.isSuccess, isTrue);
        final captured =
            verify(mockDao.updateEntity(captureAny)).captured.single as Profile;
        expect(captured.syncMetadata.syncDeviceId, testDeviceId);
        expect(captured.syncMetadata.syncIsDirty, isTrue);
      });

      test('skips sync metadata update when markDirty is false', () async {
        final profile = createTestProfile();

        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(profile));

        await repository.update(profile, markDirty: false);

        final captured =
            verify(
                  mockDao.updateEntity(captureAny, markDirty: false),
                ).captured.single
                as Profile;
        // When markDirty=false, original entity is passed through unchanged
        expect(captured.syncMetadata.syncDeviceId, 'old-device');
      });
    });

    group('delete', () {
      test('delegates to dao softDelete', () async {
        when(
          mockDao.softDelete('profile-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('profile-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('profile-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('delegates to dao hardDelete', () async {
        when(
          mockDao.hardDelete('profile-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('profile-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('profile-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('delegates to dao', () async {
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('delegates to dao', () async {
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByOwner', () {
      test('delegates to dao', () async {
        when(
          mockDao.getByOwner('owner-001'),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getByOwner('owner-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.getByOwner('owner-001')).called(1);
      });
    });

    group('getDefault', () {
      test('delegates to dao', () async {
        when(
          mockDao.getDefault('owner-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.getDefault('owner-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.getDefault('owner-001')).called(1);
      });
    });

    group('getByUser', () {
      test('delegates to dao getByOwner', () async {
        when(
          mockDao.getByOwner('user-001'),
        ).thenAnswer((_) async => const Success([]));

        final result = await repository.getByUser('user-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.getByOwner('user-001')).called(1);
      });
    });
  });
}
