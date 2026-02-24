// test/unit/data/repositories/diet_violation_repository_impl_test.dart
// Phase 15b — Tests for DietViolationRepositoryImpl
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_violation_dao.dart';
import 'package:shadow_app/data/repositories/diet_violation_repository_impl.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([DietViolationDao, DeviceInfoService])
import 'diet_violation_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<DietViolation>, AppError>>(const Success([]));
  provideDummy<Result<DietViolation, AppError>>(
    const Success(
      DietViolation(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        dietId: 'dummy',
        ruleId: 'dummy',
        foodName: 'dummy',
        ruleDescription: 'dummy',
        timestamp: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('DietViolationRepositoryImpl', () {
    late MockDietViolationDao mockDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late DietViolationRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    DietViolation createTestViolation({
      String id = 'viol-001',
      String profileId = testProfileId,
      SyncMetadata? syncMetadata,
    }) => DietViolation(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      dietId: 'diet-001',
      ruleId: 'rule-001',
      foodName: 'Cheese',
      ruleDescription: 'No dairy',
      timestamp: 1000,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    setUp(() {
      mockDao = MockDietViolationDao();
      mockDeviceInfoService = MockDeviceInfoService();
      repository = DietViolationRepositoryImpl(
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
        final violations = [createTestViolation()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(violations));

        final result = await repository.getAll(profileId: testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, violations);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getAll_withoutProfileId_returnsEmptyList', () async {
        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
        verifyNever(mockDao.getByProfile(any));
      });
    });

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final violation = createTestViolation();
        when(
          mockDao.getById('viol-001'),
        ).thenAnswer((_) async => Success(violation));

        final result = await repository.getById('viol-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, violation);
        verify(mockDao.getById('viol-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDao.getById('missing')).thenAnswer(
          (_) async =>
              Failure(DatabaseError.notFound('DietViolation', 'missing')),
        );

        final result = await repository.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final violations = [createTestViolation()];
        when(
          mockDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(violations));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        verify(mockDao.getByProfile(testProfileId)).called(1);
      });

      test('getByProfile_passesDateFiltersToDao', () async {
        when(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            limit: 10,
          ),
        ).thenAnswer((_) async => const Success([]));

        await repository.getByProfile(
          testProfileId,
          startDate: 1000,
          endDate: 2000,
          limit: 10,
        );

        verify(
          mockDao.getByProfile(
            testProfileId,
            startDate: 1000,
            endDate: 2000,
            limit: 10,
          ),
        ).called(1);
      });
    });

    group('getByDiet', () {
      test('getByDiet_delegatesToDao', () async {
        final violations = [createTestViolation()];
        when(
          mockDao.getByDiet('diet-001'),
        ).thenAnswer((_) async => Success(violations));

        final result = await repository.getByDiet('diet-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, violations);
        verify(mockDao.getByDiet('diet-001')).called(1);
      });
    });

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final violation = createTestViolation(id: '');
        when(mockDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietViolation),
        );

        final result = await repository.create(violation);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final violation = createTestViolation(id: 'my-violation-id');
        when(mockDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietViolation),
        );

        final result = await repository.create(violation);

        expect(result.valueOrNull!.id, 'my-violation-id');
      });

      test('create_setsSyncMetadata', () async {
        final violation = createTestViolation(id: '');
        when(mockDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietViolation),
        );

        final result = await repository.create(violation);

        expect(result.valueOrNull!.syncMetadata.syncDeviceId, testDeviceId);
        expect(result.valueOrNull!.syncMetadata.syncIsDirty, isTrue);
      });
    });

    group('update', () {
      test('update_isNoOp_returnsGetById', () async {
        final violation = createTestViolation();
        when(
          mockDao.getById('viol-001'),
        ).thenAnswer((_) async => Success(violation));

        final result = await repository.update(violation);

        expect(result.isSuccess, isTrue);
        verify(mockDao.getById('viol-001')).called(1);
        // No updateEntity call — violations are append-only
        verifyNever(mockDao.create(any));
      });
    });

    group('delete', () {
      test('delete_delegatesToSoftDelete', () async {
        when(
          mockDao.softDelete('viol-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('viol-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.softDelete('viol-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDao', () async {
        when(
          mockDao.hardDelete('viol-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('viol-001');

        expect(result.isSuccess, isTrue);
        verify(mockDao.hardDelete('viol-001')).called(1);
      });
    });

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final violations = [createTestViolation()];
        when(
          mockDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(violations));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, violations);
        verify(mockDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final violations = [createTestViolation()];
        when(
          mockDao.getPendingSync(),
        ).thenAnswer((_) async => Success(violations));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, violations);
        verify(mockDao.getPendingSync()).called(1);
      });
    });
  });
}
