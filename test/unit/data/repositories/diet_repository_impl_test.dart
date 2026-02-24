// test/unit/data/repositories/diet_repository_impl_test.dart
// Phase 15b — Tests for DietRepositoryImpl
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_exception_dao.dart';
import 'package:shadow_app/data/datasources/local/daos/diet_rule_dao.dart';
import 'package:shadow_app/data/repositories/diet_repository_impl.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_exception.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:uuid/uuid.dart';

@GenerateMocks([DietDao, DietRuleDao, DietExceptionDao, DeviceInfoService])
import 'diet_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<Diet>, AppError>>(const Success([]));
  provideDummy<Result<Diet, AppError>>(
    const Success(
      Diet(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'dummy',
        startDate: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<Diet?, AppError>>(const Success(null));
  provideDummy<Result<List<DietRule>, AppError>>(const Success([]));
  provideDummy<Result<DietRule, AppError>>(
    const Success(
      DietRule(
        id: 'dummy',
        dietId: 'dummy',
        ruleType: DietRuleType.excludeCategory,
      ),
    ),
  );
  provideDummy<Result<List<DietException>, AppError>>(const Success([]));
  provideDummy<Result<DietException, AppError>>(
    const Success(
      DietException(id: 'dummy', ruleId: 'dummy', description: 'dummy'),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));

  group('DietRepositoryImpl', () {
    late MockDietDao mockDietDao;
    late MockDietRuleDao mockRuleDao;
    late MockDietExceptionDao mockExceptionDao;
    late MockDeviceInfoService mockDeviceInfoService;
    late DietRepositoryImpl repository;

    const testDeviceId = 'test-device-123';
    const testProfileId = 'profile-001';

    Diet createTestDiet({
      String id = 'diet-001',
      String profileId = testProfileId,
      bool isActive = false,
      SyncMetadata? syncMetadata,
    }) => Diet(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      name: 'Test Diet',
      startDate: 1704067200000,
      isActive: isActive,
      syncMetadata: syncMetadata ?? SyncMetadata.create(deviceId: 'old-device'),
    );

    DietRule createTestRule({
      String id = 'rule-001',
      String dietId = 'diet-001',
    }) => DietRule(
      id: id,
      dietId: dietId,
      ruleType: DietRuleType.excludeCategory,
      targetCategory: 'dairy',
    );

    DietException createTestException({
      String id = 'exc-001',
      String ruleId = 'rule-001',
    }) => DietException(id: id, ruleId: ruleId, description: 'Hard cheese');

    setUp(() {
      mockDietDao = MockDietDao();
      mockRuleDao = MockDietRuleDao();
      mockExceptionDao = MockDietExceptionDao();
      mockDeviceInfoService = MockDeviceInfoService();
      repository = DietRepositoryImpl(
        mockDietDao,
        mockRuleDao,
        mockExceptionDao,
        const Uuid(),
        mockDeviceInfoService,
      );
      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    // ---- getAll ----

    group('getAll', () {
      test('getAll_withProfileId_delegatesToGetByProfile', () async {
        final diets = [createTestDiet()];
        when(
          mockDietDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(diets));

        final result = await repository.getAll(profileId: testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, diets);
        verify(mockDietDao.getByProfile(testProfileId)).called(1);
      });

      test('getAll_withoutProfileId_returnsEmptyList', () async {
        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
        verifyNever(mockDietDao.getByProfile(any));
      });
    });

    // ---- getById ----

    group('getById', () {
      test('getById_delegatesToDao', () async {
        final diet = createTestDiet();
        when(
          mockDietDao.getById('diet-001'),
        ).thenAnswer((_) async => Success(diet));

        final result = await repository.getById('diet-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, diet);
        verify(mockDietDao.getById('diet-001')).called(1);
      });

      test('getById_returnsFailureWhenNotFound', () async {
        when(mockDietDao.getById('missing')).thenAnswer(
          (_) async => Failure(DatabaseError.notFound('Diet', 'missing')),
        );

        final result = await repository.getById('missing');

        expect(result.isFailure, isTrue);
      });
    });

    // ---- getByProfile ----

    group('getByProfile', () {
      test('getByProfile_delegatesToDao', () async {
        final diets = [createTestDiet()];
        when(
          mockDietDao.getByProfile(testProfileId),
        ).thenAnswer((_) async => Success(diets));

        final result = await repository.getByProfile(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, diets);
        verify(mockDietDao.getByProfile(testProfileId)).called(1);
      });
    });

    // ---- getActiveDiet ----

    group('getActiveDiet', () {
      test('getActiveDiet_delegatesToDao', () async {
        final diet = createTestDiet(isActive: true);
        when(
          mockDietDao.getActiveDiet(testProfileId),
        ).thenAnswer((_) async => Success(diet));

        final result = await repository.getActiveDiet(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'diet-001');
        verify(mockDietDao.getActiveDiet(testProfileId)).called(1);
      });

      test('getActiveDiet_returnsNullWhenNoActiveDiet', () async {
        when(
          mockDietDao.getActiveDiet(testProfileId),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.getActiveDiet(testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    // ---- create ----

    group('create', () {
      test('create_generatesIdWhenEmpty', () async {
        final diet = createTestDiet(id: '');
        when(mockDietDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as Diet),
        );

        final result = await repository.create(diet);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id.length, 36);
      });

      test('create_usesExistingIdWhenProvided', () async {
        final diet = createTestDiet(id: 'my-diet-id');
        when(mockDietDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as Diet),
        );

        final result = await repository.create(diet);

        expect(result.valueOrNull!.id, 'my-diet-id');
      });

      test('create_setsSyncMetadata', () async {
        final diet = createTestDiet(id: '');
        when(mockDietDao.create(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as Diet),
        );

        final result = await repository.create(diet);

        expect(result.valueOrNull!.syncMetadata.syncDeviceId, testDeviceId);
        expect(result.valueOrNull!.syncMetadata.syncIsDirty, isTrue);
        expect(result.valueOrNull!.syncMetadata.syncVersion, 1);
      });
    });

    // ---- update ----

    group('update', () {
      test('update_marksDirtyByDefault', () async {
        final diet = createTestDiet(
          syncMetadata: const SyncMetadata(
            syncCreatedAt: 1000,
            syncUpdatedAt: 1000,
            syncDeviceId: 'old-device',
            syncStatus: SyncStatus.synced,
          ),
        );
        when(mockDietDao.updateEntity(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as Diet),
        );

        final result = await repository.update(diet);

        expect(result.isSuccess, isTrue);
        expect(
          result.valueOrNull!.syncMetadata.syncStatus,
          SyncStatus.modified,
        );
        expect(result.valueOrNull!.syncMetadata.syncIsDirty, isTrue);
        expect(result.valueOrNull!.syncMetadata.syncDeviceId, testDeviceId);
      });
    });

    // ---- setActive ----

    group('setActive', () {
      test('setActive_deactivatesAllThenActivatesDiet', () async {
        final diet = createTestDiet(id: 'diet-target');
        when(mockDietDao.deactivateAll(testProfileId)).thenAnswer((_) async {});
        when(
          mockDietDao.getById('diet-target'),
        ).thenAnswer((_) async => Success(diet));
        when(mockDietDao.updateEntity(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as Diet),
        );

        final result = await repository.setActive('diet-target', testProfileId);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.isActive, isTrue);
        expect(result.valueOrNull!.isDraft, isFalse);
        verify(mockDietDao.deactivateAll(testProfileId)).called(1);
        verify(mockDietDao.getById('diet-target')).called(1);
        verify(mockDietDao.updateEntity(any)).called(1);
      });

      test('setActive_returnsFailureWhenDietNotFound', () async {
        when(mockDietDao.deactivateAll(testProfileId)).thenAnswer((_) async {});
        when(mockDietDao.getById('missing')).thenAnswer(
          (_) async => Failure(DatabaseError.notFound('Diet', 'missing')),
        );

        final result = await repository.setActive('missing', testProfileId);

        expect(result.isFailure, isTrue);
        verifyNever(mockDietDao.updateEntity(any));
      });
    });

    // ---- deactivate ----

    group('deactivate', () {
      test('deactivate_callsDeactivateAll', () async {
        when(mockDietDao.deactivateAll(testProfileId)).thenAnswer((_) async {});

        final result = await repository.deactivate(testProfileId);

        expect(result.isSuccess, isTrue);
        verify(mockDietDao.deactivateAll(testProfileId)).called(1);
      });
    });

    // ---- delete / hardDelete ----

    group('delete', () {
      test('delete_delegatesToSoftDelete', () async {
        when(
          mockDietDao.softDelete('diet-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.delete('diet-001');

        expect(result.isSuccess, isTrue);
        verify(mockDietDao.softDelete('diet-001')).called(1);
      });
    });

    group('hardDelete', () {
      test('hardDelete_delegatesToDao', () async {
        when(
          mockDietDao.hardDelete('diet-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.hardDelete('diet-001');

        expect(result.isSuccess, isTrue);
        verify(mockDietDao.hardDelete('diet-001')).called(1);
      });
    });

    // ---- sync helpers ----

    group('getModifiedSince', () {
      test('getModifiedSince_delegatesToDao', () async {
        final diets = [createTestDiet()];
        when(
          mockDietDao.getModifiedSince(1000),
        ).thenAnswer((_) async => Success(diets));

        final result = await repository.getModifiedSince(1000);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, diets);
        verify(mockDietDao.getModifiedSince(1000)).called(1);
      });
    });

    group('getPendingSync', () {
      test('getPendingSync_delegatesToDao', () async {
        final diets = [createTestDiet()];
        when(
          mockDietDao.getPendingSync(),
        ).thenAnswer((_) async => Success(diets));

        final result = await repository.getPendingSync();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, diets);
        verify(mockDietDao.getPendingSync()).called(1);
      });
    });

    // ---- Rules ----

    group('getRules', () {
      test('getRules_delegatesToRuleDao', () async {
        final rules = [createTestRule()];
        when(
          mockRuleDao.getForDiet('diet-001'),
        ).thenAnswer((_) async => Success(rules));

        final result = await repository.getRules('diet-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, rules);
        verify(mockRuleDao.getForDiet('diet-001')).called(1);
      });
    });

    group('addRule', () {
      test('addRule_generatesIdWhenEmpty', () async {
        final rule = createTestRule(id: '');
        when(mockRuleDao.insert(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietRule),
        );

        final result = await repository.addRule(rule);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id.length, 36);
      });

      test('addRule_usesExistingId', () async {
        final rule = createTestRule(id: 'my-rule-id');
        when(mockRuleDao.insert(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietRule),
        );

        final result = await repository.addRule(rule);

        expect(result.valueOrNull!.id, 'my-rule-id');
      });
    });

    group('updateRule', () {
      test('updateRule_delegatesToRuleDao', () async {
        final rule = createTestRule();
        when(
          mockRuleDao.updateEntity(rule),
        ).thenAnswer((_) async => Success(rule));

        final result = await repository.updateRule(rule);

        expect(result.isSuccess, isTrue);
        verify(mockRuleDao.updateEntity(rule)).called(1);
      });
    });

    group('deleteRule', () {
      test('deleteRule_deletesExceptionsFirstThenRule', () async {
        when(
          mockExceptionDao.deleteForRule('rule-001'),
        ).thenAnswer((_) async => const Success<void, AppError>(null));
        when(
          mockRuleDao.deleteById('rule-001'),
        ).thenAnswer((_) async => const Success<void, AppError>(null));

        final result = await repository.deleteRule('rule-001');

        expect(result.isSuccess, isTrue);
        // Exceptions deleted before rule
        verifyInOrder([
          mockExceptionDao.deleteForRule('rule-001'),
          mockRuleDao.deleteById('rule-001'),
        ]);
      });
    });

    // ---- Exceptions ----

    group('getExceptions', () {
      test('getExceptions_delegatesToExceptionDao', () async {
        final exceptions = [createTestException()];
        when(
          mockExceptionDao.getForRule('rule-001'),
        ).thenAnswer((_) async => Success(exceptions));

        final result = await repository.getExceptions('rule-001');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, exceptions);
        verify(mockExceptionDao.getForRule('rule-001')).called(1);
      });
    });

    group('addException', () {
      test('addException_generatesIdWhenEmpty', () async {
        final exception = createTestException(id: '');
        when(mockExceptionDao.insert(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietException),
        );

        final result = await repository.addException(exception);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull!.id, isNotEmpty);
        expect(result.valueOrNull!.id.length, 36);
      });

      test('addException_usesExistingId', () async {
        final exception = createTestException(id: 'my-exc-id');
        when(mockExceptionDao.insert(any)).thenAnswer(
          (inv) async => Success(inv.positionalArguments[0] as DietException),
        );

        final result = await repository.addException(exception);

        expect(result.valueOrNull!.id, 'my-exc-id');
      });
    });

    group('deleteException', () {
      test('deleteException_delegatesToExceptionDao', () async {
        when(
          mockExceptionDao.deleteById('exc-001'),
        ).thenAnswer((_) async => const Success(null));

        final result = await repository.deleteException('exc-001');

        expect(result.isSuccess, isTrue);
        verify(mockExceptionDao.deleteById('exc-001')).called(1);
      });
    });
  });
}
