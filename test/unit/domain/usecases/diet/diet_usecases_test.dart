// test/unit/domain/usecases/diet/diet_usecases_test.dart
// Tests for diet use cases — Phase 15b-2

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/repositories/diet_violation_repository.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/diet_compliance_service.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/diet/activate_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/check_compliance_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/create_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';
import 'package:shadow_app/domain/usecases/diet/get_active_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/get_diets_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/get_violations_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/record_violation_use_case.dart';

@GenerateMocks([
  DietRepository,
  DietViolationRepository,
  FoodItemRepository,
  DietComplianceService,
  ProfileAuthorizationService,
])
import 'diet_usecases_test.mocks.dart';

void main() {
  provideDummy<Result<List<Diet>, AppError>>(const Success([]));
  provideDummy<Result<Diet?, AppError>>(const Success(null));
  provideDummy<Result<Diet, AppError>>(
    const Success(
      Diet(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        name: 'Dummy',
        startDate: 0,
        syncMetadata: SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'dummy',
        ),
      ),
    ),
  );
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<List<DietRule>, AppError>>(const Success([]));
  provideDummy<Result<DietRule, AppError>>(
    const Success(
      DietRule(
        id: 'dummy',
        dietId: 'dummy',
        ruleType: DietRuleType.excludeIngredient,
      ),
    ),
  );
  provideDummy<Result<List<DietViolation>, AppError>>(const Success([]));
  provideDummy<Result<DietViolation, AppError>>(
    const Success(
      DietViolation(
        id: 'dummy',
        clientId: 'dummy',
        profileId: 'dummy',
        dietId: 'dummy',
        ruleId: 'dummy',
        foodName: 'Dummy',
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
  provideDummy<Result<List<FoodItem>, AppError>>(const Success([]));
  provideDummy<Result<ComplianceCheckResult, AppError>>(
    const Success(
      ComplianceCheckResult(
        isCompliant: true,
        violatedRules: [],
        complianceImpact: 0,
        alternatives: [],
      ),
    ),
  );

  const testProfileId = 'profile-001';
  const testDietId = 'diet-001';
  const now = 1000000;

  Diet makeTestDiet({
    String id = testDietId,
    String profileId = testProfileId,
    String name = 'Test Diet',
    bool isActive = false,
  }) => Diet(
    id: id,
    clientId: 'client-001',
    profileId: profileId,
    name: name,
    isActive: isActive,
    startDate: now,
    syncMetadata: const SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: 'device',
    ),
  );

  FoodItem makeTestFood({String? ingredientsText}) => FoodItem(
    id: 'food-001',
    clientId: 'client-001',
    profileId: testProfileId,
    name: 'Test Food',
    ingredientsText: ingredientsText,
    syncMetadata: const SyncMetadata(
      syncCreatedAt: now,
      syncUpdatedAt: now,
      syncDeviceId: 'device',
    ),
  );

  // ============================================================
  // GetDietsUseCase
  // ============================================================

  group('GetDietsUseCase', () {
    late MockDietRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetDietsUseCase useCase;

    setUp(() {
      mockRepo = MockDietRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetDietsUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_returnsDiets', () async {
      final diets = [makeTestDiet()];
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Success(diets));

      final result = await useCase(
        const GetDietsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, diets);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetDietsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepo.getByProfile(any));
    });

    test('call_propagatesRepositoryFailure', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => Failure(DatabaseError.queryFailed('test')));

      final result = await useCase(
        const GetDietsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<DatabaseError>());
    });
  });

  // ============================================================
  // GetActiveDietUseCase
  // ============================================================

  group('GetActiveDietUseCase', () {
    late MockDietRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetActiveDietUseCase useCase;

    setUp(() {
      mockRepo = MockDietRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetActiveDietUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_returnsActiveDiet', () async {
      final diet = makeTestDiet(isActive: true);
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveDiet(testProfileId),
      ).thenAnswer((_) async => Success(diet));

      final result = await useCase(
        const GetActiveDietInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, diet);
    });

    test('call_returnsNull_whenNoDietActive', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveDiet(testProfileId),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(
        const GetActiveDietInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isNull);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetActiveDietInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  // ============================================================
  // CreateDietUseCase
  // ============================================================

  group('CreateDietUseCase', () {
    late MockDietRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late CreateDietUseCase useCase;

    setUp(() {
      mockRepo = MockDietRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = CreateDietUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_createsDiet', () async {
      final diet = makeTestDiet();
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.create(any)).thenAnswer((_) async => Success(diet));

      final result = await useCase(
        const CreateDietInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Test Diet',
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepo.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const CreateDietInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Test Diet',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepo.create(any));
    });

    test('call_whenNameIsEmpty_returnsValidationError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);

      final result = await useCase(
        const CreateDietInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: '',
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_whenNameTooLong_returnsValidationError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);

      final result = await useCase(
        CreateDietInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'A' * 101,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
    });

    test('call_whenActivateImmediately_deactivatesCurrentFirst', () async {
      final existing = makeTestDiet(isActive: true);
      final newDiet = makeTestDiet(
        id: 'diet-002',
        name: 'New Diet',
        isActive: true,
      );
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getActiveDiet(testProfileId),
      ).thenAnswer((_) async => Success(existing));
      when(
        mockRepo.deactivate(testProfileId),
      ).thenAnswer((_) async => const Success(null));
      when(mockRepo.create(any)).thenAnswer((_) async => Success(newDiet));

      await useCase(
        const CreateDietInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'New Diet',
          activateImmediately: true,
        ),
      );

      verify(mockRepo.deactivate(testProfileId)).called(1);
    });

    test('call_withInitialRules_addsRulesAfterCreation', () async {
      final diet = makeTestDiet();
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.create(any)).thenAnswer((_) async => Success(diet));
      when(mockRepo.addRule(any)).thenAnswer(
        (_) async => const Success(
          DietRule(
            id: 'rule-001',
            dietId: testDietId,
            ruleType: DietRuleType.excludeIngredient,
          ),
        ),
      );

      await useCase(
        const CreateDietInput(
          profileId: testProfileId,
          clientId: 'client-001',
          name: 'Test Diet',
          initialRules: [
            DietRule(
              id: '',
              dietId: '',
              ruleType: DietRuleType.excludeIngredient,
              targetIngredient: 'gluten',
            ),
          ],
        ),
      );

      verify(mockRepo.addRule(any)).called(1);
    });
  });

  // ============================================================
  // ActivateDietUseCase
  // ============================================================

  group('ActivateDietUseCase', () {
    late MockDietRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late ActivateDietUseCase useCase;

    setUp(() {
      mockRepo = MockDietRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = ActivateDietUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_activatesDiet', () async {
      final diet = makeTestDiet();
      final activeDiet = makeTestDiet(isActive: true);
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.getById(testDietId)).thenAnswer((_) async => Success(diet));
      when(
        mockRepo.setActive(testDietId, testProfileId),
      ).thenAnswer((_) async => Success(activeDiet));

      final result = await useCase(
        const ActivateDietInput(profileId: testProfileId, dietId: testDietId),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepo.setActive(testDietId, testProfileId)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const ActivateDietInput(profileId: testProfileId, dietId: testDietId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenDietNotFound_returnsFailure', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.getById(testDietId)).thenAnswer(
        (_) async => Failure(DatabaseError.notFound('Diet', testDietId)),
      );

      final result = await useCase(
        const ActivateDietInput(profileId: testProfileId, dietId: testDietId),
      );

      expect(result.isFailure, isTrue);
    });

    test('call_whenDietBelongsToDifferentProfile_returnsAuthError', () async {
      final wrongProfileDiet = makeTestDiet(profileId: 'other-profile');
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getById(testDietId),
      ).thenAnswer((_) async => Success(wrongProfileDiet));

      final result = await useCase(
        const ActivateDietInput(profileId: testProfileId, dietId: testDietId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test(
      'call_whenAlreadyActive_returnsSuccessWithoutCallingSetActive',
      () async {
        final activeDiet = makeTestDiet(isActive: true);
        when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
        when(
          mockRepo.getById(testDietId),
        ).thenAnswer((_) async => Success(activeDiet));

        final result = await useCase(
          const ActivateDietInput(profileId: testProfileId, dietId: testDietId),
        );

        expect(result.isSuccess, isTrue);
        verifyNever(mockRepo.setActive(any, any));
      },
    );
  });

  // ============================================================
  // CheckComplianceUseCase
  // ============================================================

  group('CheckComplianceUseCase', () {
    late MockDietRepository mockDietRepo;
    late MockFoodItemRepository mockFoodRepo;
    late MockDietComplianceService mockComplianceService;
    late MockProfileAuthorizationService mockAuth;
    late CheckComplianceUseCase useCase;

    setUp(() {
      mockDietRepo = MockDietRepository();
      mockFoodRepo = MockFoodItemRepository();
      mockComplianceService = MockDietComplianceService();
      mockAuth = MockProfileAuthorizationService();
      useCase = CheckComplianceUseCase(
        mockDietRepo,
        mockFoodRepo,
        mockComplianceService,
        mockAuth,
      );
    });

    test('call_whenCompliant_returnsIsCompliantTrue', () async {
      final diet = makeTestDiet();
      final food = makeTestFood();
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockDietRepo.getById(testDietId),
      ).thenAnswer((_) async => Success(diet));
      when(
        mockDietRepo.getRules(testDietId),
      ).thenAnswer((_) async => const Success([]));
      when(
        mockComplianceService.checkFoodAgainstRules(any, any, any),
      ).thenReturn([]);
      when(mockComplianceService.calculateImpact(any, any)).thenReturn(0);

      final result = await useCase(
        CheckComplianceInput(
          profileId: testProfileId,
          dietId: testDietId,
          foodItem: food,
          logTimeEpoch: now,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isCompliant, isTrue);
      expect(result.valueOrNull!.violatedRules, isEmpty);
    });

    test('call_whenViolationFound_returnsIsCompliantFalse', () async {
      final diet = makeTestDiet();
      final food = makeTestFood();
      const violatedRule = DietRule(
        id: 'rule-001',
        dietId: testDietId,
        ruleType: DietRuleType.excludeIngredient,
      );
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockDietRepo.getById(testDietId),
      ).thenAnswer((_) async => Success(diet));
      when(
        mockDietRepo.getRules(testDietId),
      ).thenAnswer((_) async => const Success([violatedRule]));
      when(
        mockComplianceService.checkFoodAgainstRules(any, any, any),
      ).thenReturn([violatedRule]);
      when(mockComplianceService.calculateImpact(any, any)).thenReturn(10);
      when(
        mockFoodRepo.searchExcludingCategories(
          any,
          any,
          excludeCategories: anyNamed('excludeCategories'),
        ),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase(
        CheckComplianceInput(
          profileId: testProfileId,
          dietId: testDietId,
          foodItem: food,
          logTimeEpoch: now,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.isCompliant, isFalse);
      expect(result.valueOrNull!.violatedRules, hasLength(1));
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        CheckComplianceInput(
          profileId: testProfileId,
          dietId: testDietId,
          foodItem: makeTestFood(),
          logTimeEpoch: now,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_whenDietBelongsToDifferentProfile_returnsAuthError', () async {
      final wrongDiet = makeTestDiet(profileId: 'other-profile');
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockDietRepo.getById(testDietId),
      ).thenAnswer((_) async => Success(wrongDiet));
      when(
        mockDietRepo.getRules(testDietId),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase(
        CheckComplianceInput(
          profileId: testProfileId,
          dietId: testDietId,
          foodItem: makeTestFood(),
          logTimeEpoch: now,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });
  });

  // ============================================================
  // RecordViolationUseCase
  // ============================================================

  group('RecordViolationUseCase', () {
    late MockDietViolationRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late RecordViolationUseCase useCase;

    setUp(() {
      mockRepo = MockDietViolationRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = RecordViolationUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_recordsViolation', () async {
      const violation = DietViolation(
        id: 'v-001',
        clientId: 'client-001',
        profileId: testProfileId,
        dietId: testDietId,
        ruleId: 'rule-001',
        foodName: 'Pizza',
        ruleDescription: 'No gluten',
        timestamp: now,
        syncMetadata: SyncMetadata(
          syncCreatedAt: now,
          syncUpdatedAt: now,
          syncDeviceId: 'device',
        ),
      );
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.create(any),
      ).thenAnswer((_) async => const Success(violation));

      final result = await useCase(
        const RecordViolationInput(
          profileId: testProfileId,
          clientId: 'client-001',
          dietId: testDietId,
          ruleId: 'rule-001',
          foodName: 'Pizza',
          ruleDescription: 'No gluten',
          timestamp: now,
        ),
      );

      expect(result.isSuccess, isTrue);
      verify(mockRepo.create(any)).called(1);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const RecordViolationInput(
          profileId: testProfileId,
          clientId: 'client-001',
          dietId: testDietId,
          ruleId: 'rule-001',
          foodName: 'Pizza',
          ruleDescription: 'No gluten',
          timestamp: now,
        ),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      verifyNever(mockRepo.create(any));
    });

    test('call_setsWasOverriddenFromInput', () async {
      DietViolation? capturedViolation;
      when(mockAuth.canWrite(testProfileId)).thenAnswer((_) async => true);
      when(mockRepo.create(any)).thenAnswer((invocation) async {
        capturedViolation =
            invocation.positionalArguments.first as DietViolation;
        return Success(capturedViolation!);
      });

      await useCase(
        const RecordViolationInput(
          profileId: testProfileId,
          clientId: 'client-001',
          dietId: testDietId,
          ruleId: 'rule-001',
          foodName: 'Pizza',
          ruleDescription: 'No gluten',
          wasOverridden: true,
          timestamp: now,
        ),
      );

      expect(capturedViolation?.wasOverridden, isTrue);
    });
  });

  // ============================================================
  // GetViolationsUseCase
  // ============================================================

  group('GetViolationsUseCase', () {
    late MockDietViolationRepository mockRepo;
    late MockProfileAuthorizationService mockAuth;
    late GetViolationsUseCase useCase;

    setUp(() {
      mockRepo = MockDietViolationRepository();
      mockAuth = MockProfileAuthorizationService();
      useCase = GetViolationsUseCase(mockRepo, mockAuth);
    });

    test('call_whenAuthorized_returnsViolations', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(testProfileId),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase(
        const GetViolationsInput(profileId: testProfileId),
      );

      expect(result.isSuccess, isTrue);
    });

    test('call_whenUnauthorized_returnsAuthError', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => false);

      final result = await useCase(
        const GetViolationsInput(profileId: testProfileId),
      );

      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
    });

    test('call_passesDateRangeAndLimitToRepository', () async {
      when(mockAuth.canRead(testProfileId)).thenAnswer((_) async => true);
      when(
        mockRepo.getByProfile(
          testProfileId,
          startDate: 100,
          endDate: 200,
          limit: 50,
        ),
      ).thenAnswer((_) async => const Success([]));

      await useCase(
        const GetViolationsInput(
          profileId: testProfileId,
          startDate: 100,
          endDate: 200,
          limit: 50,
        ),
      );

      verify(
        mockRepo.getByProfile(
          testProfileId,
          startDate: 100,
          endDate: 200,
          limit: 50,
        ),
      ).called(1);
    });
  });
}
