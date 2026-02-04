// test/unit/data/repositories/supplement_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_dao.dart';
import 'package:shadow_app/data/repositories/supplement_repository_impl.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([SupplementDao, DeviceInfoService])
import 'supplement_repository_impl_test.mocks.dart';

void main() {
  // Provide dummy values for Result types that Mockito can't generate
  provideDummy<Result<List<Supplement>, AppError>>(const Success([]));
  provideDummy<Result<Supplement, AppError>>(
    const Success(
      Supplement(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        form: SupplementForm.capsule,
        dosageQuantity: 1,
        dosageUnit: DosageUnit.mg,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('SupplementRepositoryImpl', () {
    late MockSupplementDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late SupplementRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    Supplement createTestSupplement({
      String id = 'supp-001',
      String clientId = 'client-001',
      String profileId = testProfileId,
      String name = 'Test Supplement',
      SupplementForm form = SupplementForm.capsule,
      int dosageQuantity = 1,
      DosageUnit dosageUnit = DosageUnit.mg,
      bool isArchived = false,
      List<SupplementSchedule> schedules = const [],
      int? startDate,
      int? endDate,
      SyncMetadata? syncMetadata,
    }) => Supplement(
      id: id,
      clientId: clientId,
      profileId: profileId,
      name: name,
      form: form,
      dosageQuantity: dosageQuantity,
      dosageUnit: dosageUnit,
      isArchived: isArchived,
      schedules: schedules,
      startDate: startDate,
      endDate: endDate,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockSupplementDao();
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = SupplementRepositoryImpl(
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
        final supplements = [createTestSupplement()];
        when(mockDao.getAll()).thenAnswer((_) async => Success(supplements));

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, supplements);
        verify(mockDao.getAll()).called(1);
      });

      test('getAll_passesProfileIdToDao', () async {
        when(
          mockDao.getAll(profileId: testProfileId),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(profileId: testProfileId);

        verify(mockDao.getAll(profileId: testProfileId)).called(1);
      });

      test('getAll_passesLimitAndOffsetToDao', () async {
        when(
          mockDao.getAll(limit: 10, offset: 5),
        ).thenAnswer((_) async => const Success([]));

        await repository.getAll(limit: 10, offset: 5);

        verify(mockDao.getAll(limit: 10, offset: 5)).called(1);
      });

      test('getAll_returnsFailureFromDao', () async {
        when(mockDao.getAll()).thenAnswer(
          (_) async =>
              Failure(DatabaseError.queryFailed('supplements', 'error')),
        );

        final result = await repository.getAll();

        expect(result.isFailure, isTrue);
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final supplement = createTestSupplement();
        when(
          mockDao.getById('supp-001'),
        ).thenAnswer((_) async => Success(supplement));

        final result = await repository.getById('supp-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, supplement);
        verify(mockDao.getById('supp-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Supplement', 'non-existent')),
        );

        final result = await repository.getById('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final supplement = createTestSupplement(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Supplement;
          return Success(created);
        });

        final result = await repository.create(supplement);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, isNotEmpty);
        expect(created.id.length, 36); // UUID format
      });

      test('create_usesExistingIdWhenProvided', () async {
        final supplement = createTestSupplement(id: 'my-custom-id');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Supplement;
          return Success(created);
        });

        final result = await repository.create(supplement);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.id, 'my-custom-id');
      });

      test('create_setsSyncMetadataWithDeviceId', () async {
        final supplement = createTestSupplement(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Supplement;
          return Success(created);
        });

        final result = await repository.create(supplement);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncDeviceId, testDeviceId);
        verify(mockDeviceInfoService.getDeviceId()).called(1);
      });

      test('create_setsSyncStatusToPending', () async {
        final supplement = createTestSupplement(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Supplement;
          return Success(created);
        });

        final result = await repository.create(supplement);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncStatus, SyncStatus.pending);
      });

      test('create_setsSyncVersion1', () async {
        final supplement = createTestSupplement(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Supplement;
          return Success(created);
        });

        final result = await repository.create(supplement);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncVersion, 1);
      });

      test('create_setsSyncIsDirtyTrue', () async {
        final supplement = createTestSupplement(id: '');
        when(mockDao.create(any)).thenAnswer((invocation) async {
          final created = invocation.positionalArguments[0] as Supplement;
          return Success(created);
        });

        final result = await repository.create(supplement);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.syncMetadata.syncIsDirty, isTrue);
      });

      test('create_returnsFailureFromDao', () async {
        final supplement = createTestSupplement();
        when(mockDao.create(any)).thenAnswer(
          (_) async =>
              Failure(DatabaseError.constraintViolation('Duplicate ID')),
        );

        final result = await repository.create(supplement);

        expect(result.isFailure, isTrue);
      });
    });

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final supplement = createTestSupplement(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDao.updateEntity(any)).thenAnswer((invocation) async {
          final updated = invocation.positionalArguments[0] as Supplement;
          return Success(updated);
        });

        final result = await repository.update(supplement);

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
        final supplement = createTestSupplement(syncMetadata: originalMetadata);
        when(mockDao.updateEntity(any, markDirty: false)).thenAnswer((
          invocation,
        ) async {
          final updated = invocation.positionalArguments[0] as Supplement;
          return Success(updated);
        });

        final result = await repository.update(supplement, markDirty: false);

        expect(result.isSuccess, isTrue);
        final updated = result.valueOrNull!;
        // Entity should be unchanged when markDirty is false
        expect(updated.syncMetadata.syncVersion, 5);
        expect(updated.syncMetadata.syncStatus, SyncStatus.synced);
        verifyNever(mockDeviceInfoService.getDeviceId());
      });

      test('update_delegatesToDaoWithMarkDirtyFlag', () async {
        final supplement = createTestSupplement();
        when(
          mockDao.updateEntity(any, markDirty: false),
        ).thenAnswer((_) async => Success(supplement));

        await repository.update(supplement, markDirty: false);

        verify(mockDao.updateEntity(any, markDirty: false)).called(1);
      });

      test('update_returnsFailureFromDao', () async {
        final supplement = createTestSupplement();
        when(mockDao.updateEntity(any)).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Supplement', 'supp-001')),
        );

        final result = await repository.update(supplement);

        expect(result.isFailure, isTrue);
      });
    });

    group('delete', () {
      test('delete_delegatesToDaoSoftDelete', () async {
        when(
          mockDao.softDelete('supp-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('supp-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('supp-001')).called(1);
      });

      test('delete_returnsFailureWhenNotFound', () async {
        when(mockDao.softDelete('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Supplement', 'non-existent')),
        );

        final result = await repository.delete('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDaoHardDelete', () async {
        when(
          mockDao.hardDelete('supp-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('supp-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('supp-001')).called(1);
      });

      test('hardDelete_returnsFailureWhenNotFound', () async {
        when(mockDao.hardDelete('non-existent')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('Supplement', 'non-existent')),
        );

        final result = await repository.hardDelete('non-existent');

        expect(result.isFailure, isTrue);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final supplements = [createTestSupplement()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(supplements));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, supplements);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final supplements = [createTestSupplement()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(supplements));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, supplements);
        verify(mockDao.getPendingSync()).called(1);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final supplements = [createTestSupplement()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(supplements));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, supplements);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesAllParametersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            activeOnly: true,
            limit: 10,
            offset: 5,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          activeOnly: true,
          limit: 10,
          offset: 5,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            activeOnly: true,
            limit: 10,
            offset: 5,
          ),
        ).called(1);
      });
    });

    group('search', () {
      test('search_delegatesToDao', () async {
        final supplements = [createTestSupplement(name: 'Vitamin D')];
        when(
          mockDao.search(testProfileId, 'vitamin'),
        ).thenAnswer((_) async => Success(supplements));

        final result = await repository.search(testProfileId, 'vitamin');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, supplements);
        verify(mockDao.search(testProfileId, 'vitamin')).called(1);
      });

      test('search_passesCustomLimitToDao', () async {
        when(
          mockDao.search(testProfileId, 'vitamin', limit: 50),
        ).thenAnswer((_) async => const Success([]));

        await repository.search(testProfileId, 'vitamin', limit: 50);

        verify(mockDao.search(testProfileId, 'vitamin', limit: 50)).called(1);
      });
    });

    group('getDueAt', () {
      test('getDueAt_getsActiveSupplementsFromDao', () async {
        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => const Success([]));

        await repository.getDueAt(
          testProfileId,
          DateTime.now().millisecondsSinceEpoch,
        );

        verify(mockDao.getByProfile(testProfileId, activeOnly: true)).called(1);
      });

      test('getDueAt_filtersArchivedSupplements', () async {
        final activeSupp = createTestSupplement(
          id: 'active',
          schedules: const [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.breakfast,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
        );

        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => Success([activeSupp]));

        // 8:00 AM time (breakfast default is 8:00 AM)
        final breakfastTime = DateTime(2026, 2, 4, 8).millisecondsSinceEpoch;
        final result = await repository.getDueAt(testProfileId, breakfastTime);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.length, 1);
        expect(result.valueOrNull!.first.id, 'active');
      });

      test('getDueAt_returnsEmptyForNoMatchingSchedules', () async {
        final supplement = createTestSupplement(
          schedules: const [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.dinner,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
        );

        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => Success([supplement]));

        // 8:00 AM (far from dinner at 6:00 PM)
        final morningTime = DateTime(2026, 2, 4, 8).millisecondsSinceEpoch;
        final result = await repository.getDueAt(testProfileId, morningTime);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getDueAt_matchesDailyScheduleAnyDay', () async {
        final supplement = createTestSupplement(
          schedules: const [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.wake,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
        );

        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => Success([supplement]));

        // 7:00 AM (wake default)
        final wakeTime = DateTime(2026, 2, 4, 7).millisecondsSinceEpoch;
        final result = await repository.getDueAt(testProfileId, wakeTime);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.length, 1);
      });

      test('getDueAt_matchesSpecificWeekdaysOnly', () async {
        final supplement = createTestSupplement(
          schedules: const [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.breakfast,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.specificWeekdays,
              weekdays: [1, 3, 5], // Mon, Wed, Fri
            ),
          ],
        );

        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => Success([supplement]));

        // Tuesday Feb 4, 2026 at 8:00 AM - weekday 2 not in [1,3,5]
        final tuesdayTime = DateTime(2026, 2, 3, 8).millisecondsSinceEpoch;
        final result = await repository.getDueAt(testProfileId, tuesdayTime);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getDueAt_respectsTimingOffset', () async {
        final supplement = createTestSupplement(
          schedules: const [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.breakfast,
              timingType: SupplementTimingType.beforeEvent,
              frequencyType: SupplementFrequencyType.daily,
              offsetMinutes: 30, // 30 min before breakfast (7:30 AM)
            ),
          ],
        );

        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => Success([supplement]));

        // 7:30 AM (30 min before breakfast at 8:00 AM)
        final beforeBreakfast = DateTime(
          2026,
          2,
          4,
          7,
          30,
        ).millisecondsSinceEpoch;
        final result = await repository.getDueAt(
          testProfileId,
          beforeBreakfast,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.length, 1);
      });

      test('getDueAt_excludesSupplementsOutsideDateRange', () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final supplement = createTestSupplement(
          startDate: now + 86400000, // Tomorrow
          schedules: const [
            SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.breakfast,
              timingType: SupplementTimingType.withEvent,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
        );

        when(
          mockDao.getByProfile(testProfileId, activeOnly: true),
        ).thenAnswer((_) async => Success([supplement]));

        final result = await repository.getDueAt(testProfileId, now);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getDueAt_returnsFailureFromDao', () async {
        when(mockDao.getByProfile(testProfileId, activeOnly: true)).thenAnswer(
          (_) async =>
              Failure(DatabaseError.queryFailed('supplements', 'error')),
        );

        final result = await repository.getDueAt(
          testProfileId,
          DateTime.now().millisecondsSinceEpoch,
        );

        expect(result.isFailure, isTrue);
      });
    });
  });
}
