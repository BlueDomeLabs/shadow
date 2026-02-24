// test/unit/data/repositories/fasting_repository_impl_test.dart
// Phase 15b — Tests for FastingRepositoryImpl
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/fasting_session_dao.dart';
import 'package:shadow_app/data/repositories/fasting_repository_impl.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([FastingSessionDao, DeviceInfoService])
import 'fasting_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<FastingSession>, AppError>>(const Success([]));
  provideDummy<Result<FastingSession, AppError>>(
    const Success(
      FastingSession(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        protocol: DietPresetType.if168,
        startedAt: 0,
        targetHours: 16,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<FastingSession?, AppError>>(const Success(null));
  provideDummy<Result<void, AppError>>(const Success(null));

  group('FastingRepositoryImpl', () {
    late MockFastingSessionDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late FastingRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    FastingSession createTestSession({
      String id = 'fast-001',
      String profileId = testProfileId,
      int startedAt = 1704067200000,
      int? endedAt,
      SyncMetadata? syncMetadata,
    }) => FastingSession(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      protocol: DietPresetType.if168,
      startedAt: startedAt,
      endedAt: endedAt,
      targetHours: 16,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockFastingSessionDao();
      mockDeviceInfoService = MockDeviceInfoService();
      repository = FastingRepositoryImpl(
        mockDao,
        const Uuid(),
        mockDeviceInfoService,
      );
      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_withProfileId_delegatesToGetByProfile', () async {
        final sessions = [createTestSession()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(sessions));

        final result = await repository.getAll(profileId: testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, sessions);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getAll_withoutProfileId_returnsEmptyList', () async {
        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
        verifyNever(mockDao.getByProfile(any));
      });

      test('getAll_passesLimitToDao', () async {
        when(
          mockDao.getByProfile(testProfileId, limit: 5),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(profileId: testProfileId, limit: 5);

        verify(mockDao.getByProfile(testProfileId, limit: 5)).called(1);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final session = createTestSession();
        when(
          mockDao.getById('fast-001'),
        ).thenAnswer((_) async => Success(session));

        final result = await repository.getById('fast-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, session);
        verify(mockDao.getById('fast-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('missing')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('FastingSession', 'missing')),
        );

        final result = await repository.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final sessions = [createTestSession()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(sessions));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, sessions);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesLimitToDao', () async {
        when(
          mockDao.getByProfile(testProfileId, limit: 3),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(testProfileId, limit: 3);

        verify(mockDao.getByProfile(testProfileId, limit: 3)).called(1);
      });
    });

    group('getActiveFast', () {
      test('getActiveFast_delegatesToDao', () async {
        final session = createTestSession();
        when(
          mockDao.getActiveFast(testProfileId),
        ).thenAnswer((_) async => Success(session));

        final result = await repository.getActiveFast(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'fast-001');
        verify(mockDao.getActiveFast(testProfileId)).called(1);
      });

      test('getActiveFast_returnsNullWhenNoActiveFast', () async {
        when(
          mockDao.getActiveFast(testProfileId),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.getActiveFast(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final session = createTestSession(id: '');
        when(mockDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as FastingSession),
        );

        final result = await repository.create(session);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final session = createTestSession(id: 'my-session-id');
        when(mockDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as FastingSession),
        );

        final result = await repository.create(session);

        expect(result.valueOrNull!.id, 'my-session-id');
      });

      test('create_setsSyncMetadata', () async {
        final session = createTestSession(id: '');
        when(mockDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as FastingSession),
        );

        final result = await repository.create(session);

        expect(result.valueOrNull!.syncMetadata.syncDeviceId, testDeviceId);
        expect(result.valueOrNull!.syncMetadata.syncIsDirty, isTrue);
        expect(result.valueOrNull!.syncMetadata.syncVersion, 1);
      });
    });

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final session = createTestSession(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as FastingSession),
        );

        final result = await repository.update(session);

        expect(result.isSuccess, isTrue);
        expect(
          result.valueOrNull!.syncMetadata.syncStatus,
          SyncStatus.modified,
        );
        expect(result.valueOrNull!.syncMetadata.syncIsDirty, isTrue);
        expect(result.valueOrNull!.syncMetadata.syncDeviceId, testDeviceId);
      });
    });

    group('endFast', () {
      test('endFast_retrievesSessionAndSetsEndedAt', () async {
        final activeSession = createTestSession(id: 'fast-active');
        final endTime = DateTime.now().millisecondsSinceEpoch;
        when(
          mockDao.getById('fast-active'),
        ).thenAnswer((_) async => Success(activeSession));
        when(mockDao.updateEntity(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as FastingSession),
        );

        final result = await repository.endFast(
          'fast-active',
          endTime,
          isManualEnd: true,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.endedAt, endTime);
        expect(result.valueOrNull!.isManualEnd, isTrue);
        expect(result.valueOrNull!.isActive, isFalse);
      });

      test('endFast_returnsFailureWhenSessionNotFound', () async {
        when(mockDao.getById('missing')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('FastingSession', 'missing')),
        );

        final result = await repository.endFast(
          'missing',
          DateTime.now().millisecondsSinceEpoch,
        );

        expect(result.isFailure, isTrue);
      });
    });

    group('delete', () {
      test('delete_delegatesToSoftDelete', () async {
        when(
          mockDao.softDelete('fast-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('fast-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('fast-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDao', () async {
        when(
          mockDao.hardDelete('fast-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('fast-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('fast-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final sessions = [createTestSession()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(sessions));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, sessions);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final sessions = [createTestSession()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(sessions));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, sessions);
        verify(mockDao.getPendingSync()).called(1);
      });
    });
  });
}
