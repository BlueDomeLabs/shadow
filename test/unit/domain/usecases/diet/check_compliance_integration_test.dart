// test/unit/domain/usecases/diet/check_compliance_integration_test.dart
// Phase 15b-4 — End-to-end compliance: CheckComplianceUseCase + real DietComplianceServiceImpl
// Per 59_DIET_TRACKING.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/services/diet_compliance_service_impl.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/repositories/food_item_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/diet/check_compliance_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';

@GenerateMocks([
  DietRepository,
  FoodItemRepository,
  ProfileAuthorizationService,
])
import 'check_compliance_integration_test.mocks.dart';

void main() {
  provideDummy<Result<Diet, AppError>>(
    Success(
      Diet(
        id: 'd',
        clientId: 'd',
        profileId: 'd',
        name: 'D',
        startDate: 0,
        syncMetadata: SyncMetadata.empty(),
      ),
    ),
  );
  provideDummy<Result<List<DietRule>, AppError>>(const Success([]));
  provideDummy<Result<List<FoodItem>, AppError>>(const Success([]));

  group(
    'CheckComplianceUseCase — integration with real DietComplianceServiceImpl',
    () {
      late MockDietRepository mockDietRepo;
      late MockFoodItemRepository mockFoodItemRepo;
      late MockProfileAuthorizationService mockAuthService;
      late CheckComplianceUseCase useCase;

      const profileId = 'profile-001';
      const dietId = 'diet-001';

      final testDiet = Diet(
        id: dietId,
        clientId: 'client-001',
        profileId: profileId,
        name: 'Test Diet',
        startDate: 0,
        isActive: true,
        syncMetadata: SyncMetadata.empty(),
      );

      // Log time at noon (12:00 = 720 minutes from midnight) — within any eating window.
      final noonEpoch = DateTime(2024, 1, 15, 12).millisecondsSinceEpoch;

      setUp(() {
        mockDietRepo = MockDietRepository();
        mockFoodItemRepo = MockFoodItemRepository();
        mockAuthService = MockProfileAuthorizationService();
        useCase = CheckComplianceUseCase(
          mockDietRepo,
          mockFoodItemRepo,
          const DietComplianceServiceImpl(), // real implementation
          mockAuthService,
        );

        when(mockAuthService.canRead(profileId)).thenAnswer((_) async => true);
        when(
          mockDietRepo.getById(dietId),
        ).thenAnswer((_) async => Success(testDiet));
        when(
          mockFoodItemRepo.searchExcludingCategories(
            any,
            any,
            excludeCategories: anyNamed('excludeCategories'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => const Success([]));
      });

      // -----------------------------------------------------------------------
      // Ingredient exclusion — covers barcode scan and photo scan input paths
      // -----------------------------------------------------------------------

      group('ingredient exclusion', () {
        const glutenRule = DietRule(
          id: 'rule-gluten',
          dietId: dietId,
          ruleType: DietRuleType.excludeIngredient,
          targetIngredient: 'wheat',
        );

        const dairyRule = DietRule(
          id: 'rule-dairy',
          dietId: dietId,
          ruleType: DietRuleType.excludeIngredient,
          targetIngredient: 'milk',
        );

        test(
          'compliant food with no matching ingredient returns isCompliant=true',
          () async {
            when(
              mockDietRepo.getRules(dietId),
            ).thenAnswer((_) async => const Success([glutenRule]));

            final apple = FoodItem(
              id: 'food-apple',
              clientId: 'client-001',
              profileId: profileId,
              name: 'Apple',
              ingredientsText: 'apple, water, citric acid',
              syncMetadata: SyncMetadata.empty(),
            );

            final result = await useCase(
              CheckComplianceInput(
                profileId: profileId,
                dietId: dietId,
                foodItem: apple,
                logTimeEpoch: noonEpoch,
              ),
            );

            expect(result.isSuccess, isTrue);
            expect(result.valueOrNull!.isCompliant, isTrue);
            expect(result.valueOrNull!.violatedRules, isEmpty);
            expect(result.valueOrNull!.complianceImpact, 0.0);
          },
        );

        test('barcode-scanned food (Open Food Facts) with excluded ingredient '
            'returns isCompliant=false', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([glutenRule]));

          // Simulates a FoodItem produced by LookupBarcodeUseCase via Open Food Facts.
          final whiteBread = FoodItem(
            id: 'food-bread',
            clientId: 'client-001',
            profileId: profileId,
            name: 'White Bread',
            type: FoodItemType.packaged,
            barcode: '0123456789012',
            ingredientsText: 'enriched wheat flour, water, yeast, salt, sugar',
            importSource: 'open_food_facts',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: whiteBread,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull!.isCompliant, isFalse);
          expect(result.valueOrNull!.violatedRules, hasLength(1));
          expect(
            result.valueOrNull!.violatedRules.first.ruleType,
            DietRuleType.excludeIngredient,
          );
        });

        test('photo-scanned food (claude_scan) with excluded ingredient '
            'returns isCompliant=false', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([dairyRule]));

          // Simulates a FoodItem built from ScanIngredientPhotoUseCase output.
          final cheesePizza = FoodItem(
            id: 'food-pizza',
            clientId: 'client-001',
            profileId: profileId,
            name: 'Cheese Pizza',
            ingredientsText:
                'whole milk mozzarella, tomato sauce, wheat flour crust',
            importSource: 'claude_scan',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: cheesePizza,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull!.isCompliant, isFalse);
          expect(result.valueOrNull!.violatedRules, hasLength(1));
          expect(result.valueOrNull!.violatedRules.first.id, 'rule-dairy');
        });

        test('ingredient match is case-insensitive', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([glutenRule]));

          final food = FoodItem(
            id: 'food-case',
            clientId: 'client-001',
            profileId: profileId,
            name: 'Pasta',
            ingredientsText: 'WHOLE WHEAT FLOUR, water, eggs',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: food,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isFalse);
        });

        test('food with no ingredientsText is treated as compliant', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([glutenRule]));

          final mystery = FoodItem(
            id: 'food-mystery',
            clientId: 'client-001',
            profileId: profileId,
            name: 'Unknown Food',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: mystery,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isTrue);
        });

        test('multiple violated rules are all captured', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([glutenRule, dairyRule]));

          final food = FoodItem(
            id: 'food-multi',
            clientId: 'client-001',
            profileId: profileId,
            name: 'Mac and Cheese',
            // Contains both wheat AND milk
            ingredientsText: 'enriched wheat pasta, whole milk, cheddar cheese',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: food,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isFalse);
          expect(result.valueOrNull!.violatedRules, hasLength(2));
        });
      });

      // -----------------------------------------------------------------------
      // Eating window (fasting window) violations
      // -----------------------------------------------------------------------

      group('eating window violations', () {
        // Eating window: 8:00 AM (480) to 8:00 PM (1200), with 5-min grace.
        const windowStartRule = DietRule(
          id: 'rule-window-start',
          dietId: dietId,
          ruleType: DietRuleType.eatingWindowStart,
          timeValue: 480, // 8:00 AM
        );

        const windowEndRule = DietRule(
          id: 'rule-window-end',
          dietId: dietId,
          ruleType: DietRuleType.eatingWindowEnd,
          timeValue: 1200, // 8:00 PM
        );

        final anyFood = FoodItem(
          id: 'food-any',
          clientId: 'client-001',
          profileId: profileId,
          name: 'Food',
          syncMetadata: SyncMetadata.empty(),
        );

        test(
          'eating before window start (outside grace) returns violation',
          () async {
            when(
              mockDietRepo.getRules(dietId),
            ).thenAnswer((_) async => const Success([windowStartRule]));

            // 7:50 AM = 470 minutes — before 8:00 AM − 5 min grace (475)
            final tooEarly = DateTime(
              2024,
              1,
              15,
              7,
              50,
            ).millisecondsSinceEpoch;

            final result = await useCase(
              CheckComplianceInput(
                profileId: profileId,
                dietId: dietId,
                foodItem: anyFood,
                logTimeEpoch: tooEarly,
              ),
            );

            expect(result.valueOrNull!.isCompliant, isFalse);
            expect(
              result.valueOrNull!.violatedRules.first.ruleType,
              DietRuleType.eatingWindowStart,
            );
          },
        );

        test('eating within eating window returns compliant', () async {
          when(mockDietRepo.getRules(dietId)).thenAnswer(
            (_) async => const Success([windowStartRule, windowEndRule]),
          );

          // Noon — safely within the 8:00 AM – 8:00 PM window
          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isTrue);
        });

        test(
          'eating after window end (outside grace) returns violation',
          () async {
            when(
              mockDietRepo.getRules(dietId),
            ).thenAnswer((_) async => const Success([windowEndRule]));

            // 8:15 PM = 1215 minutes — after 8:00 PM + 5 min grace (1205)
            final tooLate = DateTime(
              2024,
              1,
              15,
              20,
              15,
            ).millisecondsSinceEpoch;

            final result = await useCase(
              CheckComplianceInput(
                profileId: profileId,
                dietId: dietId,
                foodItem: anyFood,
                logTimeEpoch: tooLate,
              ),
            );

            expect(result.valueOrNull!.isCompliant, isFalse);
            expect(
              result.valueOrNull!.violatedRules.first.ruleType,
              DietRuleType.eatingWindowEnd,
            );
          },
        );
      });

      // -----------------------------------------------------------------------
      // noEatingBefore / noEatingAfter (strict fasting rules)
      // -----------------------------------------------------------------------

      group('fasting window detection', () {
        const noEatingBeforeRule = DietRule(
          id: 'rule-no-before',
          dietId: dietId,
          ruleType: DietRuleType.noEatingBefore,
          timeValue: 540, // 9:00 AM
        );

        const noEatingAfterRule = DietRule(
          id: 'rule-no-after',
          dietId: dietId,
          ruleType: DietRuleType.noEatingAfter,
          timeValue: 1320, // 10:00 PM
        );

        final anyFood = FoodItem(
          id: 'food-any',
          clientId: 'client-001',
          profileId: profileId,
          name: 'Food',
          syncMetadata: SyncMetadata.empty(),
        );

        test('eating before noEatingBefore limit is a violation', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([noEatingBeforeRule]));

          // 8:00 AM = 480 minutes < 540 (9:00 AM limit)
          final tooEarly = DateTime(2024, 1, 15, 8).millisecondsSinceEpoch;

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: tooEarly,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isFalse);
          expect(
            result.valueOrNull!.violatedRules.first.ruleType,
            DietRuleType.noEatingBefore,
          );
        });

        test('eating at or after noEatingBefore limit is compliant', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([noEatingBeforeRule]));

          // 9:00 AM = 540 minutes — exactly at the limit, not violated
          final atLimit = DateTime(2024, 1, 15, 9).millisecondsSinceEpoch;

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: atLimit,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isTrue);
        });

        test('eating after noEatingAfter limit is a violation', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([noEatingAfterRule]));

          // 10:30 PM = 1350 minutes > 1320 (10:00 PM limit)
          final tooLate = DateTime(2024, 1, 15, 22, 30).millisecondsSinceEpoch;

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: tooLate,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isFalse);
          expect(
            result.valueOrNull!.violatedRules.first.ruleType,
            DietRuleType.noEatingAfter,
          );
        });

        test('eating at or before noEatingAfter limit is compliant', () async {
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([noEatingAfterRule]));

          // 10:00 PM = 1320 minutes — exactly at the limit, not violated
          final atLimit = DateTime(2024, 1, 15, 22).millisecondsSinceEpoch;

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: atLimit,
            ),
          );

          expect(result.valueOrNull!.isCompliant, isTrue);
        });
      });

      // -----------------------------------------------------------------------
      // Compliance impact calculation
      // -----------------------------------------------------------------------

      group('compliance impact', () {
        final anyFood = FoodItem(
          id: 'food-any',
          clientId: 'client-001',
          profileId: profileId,
          name: 'Food',
          ingredientsText: 'wheat, milk, sugar',
          syncMetadata: SyncMetadata.empty(),
        );

        test('single violation produces 10% impact', () async {
          const singleRule = DietRule(
            id: 'rule-single',
            dietId: dietId,
            ruleType: DietRuleType.excludeIngredient,
            targetIngredient: 'wheat',
          );
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([singleRule]));

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.complianceImpact, 10.0);
        });

        test('two violations produce 20% impact', () async {
          const rules = [
            DietRule(
              id: 'rule-a',
              dietId: dietId,
              ruleType: DietRuleType.excludeIngredient,
              targetIngredient: 'wheat',
            ),
            DietRule(
              id: 'rule-b',
              dietId: dietId,
              ruleType: DietRuleType.excludeIngredient,
              targetIngredient: 'milk',
            ),
          ];
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success(rules));

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: anyFood,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.complianceImpact, 20.0);
        });

        test('compliant food produces 0% impact', () async {
          const noConflictRule = DietRule(
            id: 'rule-no-conflict',
            dietId: dietId,
            ruleType: DietRuleType.excludeIngredient,
            targetIngredient: 'peanuts',
          );
          when(
            mockDietRepo.getRules(dietId),
          ).thenAnswer((_) async => const Success([noConflictRule]));

          final cleanFood = FoodItem(
            id: 'food-clean',
            clientId: 'client-001',
            profileId: profileId,
            name: 'Salad',
            ingredientsText: 'lettuce, tomato, cucumber',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: cleanFood,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.valueOrNull!.complianceImpact, 0.0);
        });
      });

      // -----------------------------------------------------------------------
      // Auth / ownership guards
      // -----------------------------------------------------------------------

      group('authorization', () {
        test('returns AuthError when profile access denied', () async {
          when(
            mockAuthService.canRead(profileId),
          ).thenAnswer((_) async => false);

          final food = FoodItem(
            id: 'food-x',
            clientId: 'client-001',
            profileId: profileId,
            name: 'Food',
            syncMetadata: SyncMetadata.empty(),
          );

          final result = await useCase(
            CheckComplianceInput(
              profileId: profileId,
              dietId: dietId,
              foodItem: food,
              logTimeEpoch: noonEpoch,
            ),
          );

          expect(result.isFailure, isTrue);
        });

        test(
          'returns AuthError when diet belongs to different profile',
          () async {
            when(
              mockDietRepo.getRules(dietId),
            ).thenAnswer((_) async => const Success([]));

            // Diet owned by a different profile
            final foreignDiet = Diet(
              id: dietId,
              clientId: 'client-001',
              profileId: 'profile-OTHER',
              name: 'Other Diet',
              startDate: 0,
              isActive: true,
              syncMetadata: SyncMetadata.empty(),
            );
            when(
              mockDietRepo.getById(dietId),
            ).thenAnswer((_) async => Success(foreignDiet));

            final food = FoodItem(
              id: 'food-x',
              clientId: 'client-001',
              profileId: profileId,
              name: 'Food',
              syncMetadata: SyncMetadata.empty(),
            );

            final result = await useCase(
              CheckComplianceInput(
                profileId: profileId,
                dietId: dietId,
                foodItem: food,
                logTimeEpoch: noonEpoch,
              ),
            );

            expect(result.isFailure, isTrue);
          },
        );
      });
    },
  );
}
