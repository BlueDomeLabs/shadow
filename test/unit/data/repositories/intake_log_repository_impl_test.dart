// test/unit/data/repositories/intake_log_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/intake_log_dao.dart';
import 'package:shadow_app/data/repositories/intake_log_repository_impl.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([IntakeLogDao, DeviceInfoService])
import 'intake_log_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<IntakeLog>, AppError>>(const Success([]));
  provideDummy<Result<IntakeLog, AppError>>(
    const Success(
      IntakeLog(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        supplementId: 'dummy',
        scheduledTime: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('IntakeLogRepositoryImpl', () {
    late MockIntakeLogDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late IntakeLogRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    IntakeLog createTestIntakeLog({
      String id = 'intake-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String supplementId = 'supp-001',
      int scheduledTime = 1704067200000,
      IntakeLogStatus status = IntakeLogStatus.pending,
      SyncMetadata? syncMetadata,
    }) => IntakeLog(
      id: id,
      clientId: clientId,
      profileId: profileId,
      supplementId: supplementId,
      scheduledTime: scheduledTime,
      status: status,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockIntakeLogDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = IntakeLogRepositoryImpl(
        mockDao,
        uuid,
        mockDeviceInfoService,
      );

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('getAll', () {
      test('getAll_delegatesToDao', () async {
        final logs = [createTestIntakeLog()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(logs));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getAll()).called(1);
      });

      test('getAll_passesParametersToDao', () async {
        when(
          mockDao.getAll(profileId: testProfileId, limit: 10, offset: 5),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(profileId: testProfileId, limit: 10, offset: 5);

        verify(
          mockDao.getAll(profileId: testProfileId, limit: 10, offset: 5),
        ).called(1);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final log = createTestIntakeLog();
        when(
          mockDao.getById('intake-001'),
        ).thenAnswer((_) async => Success(log));

        final result = await repository.getById('intake-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, log);
        verify(mockDao.getById('intake-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('IntakeLog', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final log = createTestIntakeLog(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as IntakeLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final log = createTestIntakeLog(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as IntakeLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final log = createTestIntakeLog(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as IntakeLog;
          return Success(created);
        });

        final result = await repository.create(log);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncDeviceId, testDeviceId);
        expect(created.syncMetadata.syncStatus, SyncStatus.pending);
        expect(created.syncMetadata.syncVersion, 1);
        expect(created.syncMetadata.syncIsDirty, isTrue);
      });
    });

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final log = createTestIntakeLog(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as IntakeLog;
          return Success(updated);
        });

        final result = await repository.update(log);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncStatus, SyncStatus.modified);
        expect(updated.syncMetadata.syncVersion, 2);
        expect(updated.syncMetadata.syncIsDirty, isTrue);
        expect(updated.syncMetadata.syncDeviceId, testDeviceId);
      });

      test('update_preservesEntityWhenMarkDirtyFalse', () async {
        const originalMetadata = SyncMetadata(
          syncCreatedAt: 1000,
          syncUpdatedAt: 1000,
          syncDeviceId: 'old-device',
          syncStatus: SyncStatus.synced,
          syncVersion: 5,
          syncIsDirty: false,
        );
        final log = createTestIntakeLog(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as IntakeLog;
          return Success(updated);
        });

        final result = await repository.update(log, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final log = createTestIntakeLog();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(log));

        await repository.update(log, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('intake-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('intake-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('intake-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('intake-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('intake-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('intake-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final logs = [createTestIntakeLog()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final logs = [createTestIntakeLog()];
        when(mockDao.getPendingSync()).thenAnswer((_) async => Success(logs));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final logs = [createTestIntakeLog()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            status: IntakeLogStatus.taken,
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          status: IntakeLogStatus.taken,
          startDate: 1000,
          endDate: 2000,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            status: IntakeLogStatus.taken,
            startDate: 1000,
            endDate: 2000,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('getBySupplement', () {
      test('getBySupplement_delegatesToDao', () async {
        final logs = [createTestIntakeLog()];
        when(
          mockDao.getBySupplement('supp-001'),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getBySupplement('supp-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(mockDao.getBySupplement('supp-001')).called(1);
      });

      test('getBySupplement_passesDateRangeToDao', () async {
        when(
          mockDao.getBySupplement('supp-001', startDate: 1000, endDate: 2000),
        ).thenAnswer((_) async => const Success([]));

        await repository.getBySupplement(
          'supp-001',
          startDate: 1000,
          endDate: 2000,
        );

        verify(
          mockDao.getBySupplement('supp-001', startDate: 1000, endDate: 2000),
        ).called(1);
      });
    });

    group('getPendingForDate', () {
      test('getPendingForDate_delegatesToDao', () async {
        final logs = [createTestIntakeLog()];
        when(
          mockDao.getPendingForDate(testProfileId, 1704067200000),
        ).thenAnswer((_) async => Success(logs));

        final result = await repository.getPendingForDate(
          testProfileId,
          1704067200000,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, logs);
        verify(
          mockDao.getPendingForDate(testProfileId, 1704067200000),
        ).called(1);
      });
    });

    group('markTaken', () {
      test('markTaken_delegatesToDao', () async {
        final log = createTestIntakeLog(status: IntakeLogStatus.taken);
        when(
          mockDao.markTaken('intake-001', 1704067200000),
        ).thenAnswer((_) async => Success(log));

        final result = await repository.markTaken('intake-001', 1704067200000);

        expect(result.isSuccess, isTrue);
        verify(mockDao.markTaken('intake-001', 1704067200000)).called(1);
      });
    });

    group('markSkipped', () {
      test('markSkipped_delegatesToDao', () async {
        final log = createTestIntakeLog(status: IntakeLogStatus.skipped);
        when(
          mockDao.markSkipped('intake-001', 'No appetite'),
        ).thenAnswer((_) async => Success(log));

        final result = await repository.markSkipped(
          'intake-001',
          'No appetite',
        );

        expect(result.isSuccess, isTrue);
        verify(mockDao.markSkipped('intake-001', 'No appetite')).called(1);
      });

      test('markSkipped_passesNullReasonToDao', () async {
        final log = createTestIntakeLog(status: IntakeLogStatus.skipped);
        when(
          mockDao.markSkipped('intake-001', null),
        ).thenAnswer((_) async => Success(log));

        final result = await repository.markSkipped('intake-001', null);

        expect(result.isSuccess, isTrue);
        verify(mockDao.markSkipped('intake-001', null)).called(1);
      });
    });

    group('markSnoozed', () {
      test('markSnoozed_delegatesToDao', () async {
        final log = createTestIntakeLog(status: IntakeLogStatus.snoozed);
        when(
          mockDao.markSnoozed('intake-001', 15),
        ).thenAnswer((_) async => Success(log));

        final result = await repository.markSnoozed('intake-001', 15);

        expect(result.isSuccess, isTrue);
        verify(mockDao.markSnoozed('intake-001', 15)).called(1);
      });
    });
  });
}
