// test/unit/domain/services/diet_compliance_service_test.dart
// Tests for DietComplianceServiceImpl — Phase 15b-2

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/services/diet_compliance_service_impl.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  const service = DietComplianceServiceImpl();

  // 8:00 AM = 480 minutes from midnight
  // 12:00 PM = 720 minutes from midnight
  // 8:00 PM = 1200 minutes from midnight
  // Build an epoch time representing noon on some day
  final noonEpoch = DateTime(2026, 2, 24, 12).millisecondsSinceEpoch; // 720 min
  final earlyMorningEpoch = DateTime(
    2026,
    2,
    24,
    5,
  ).millisecondsSinceEpoch; // 300 min
  final eveningEpoch = DateTime(
    2026,
    2,
    24,
    21,
  ).millisecondsSinceEpoch; // 1260 min

  FoodItem makeFood({String name = 'Test Food', String? ingredientsText}) =>
      FoodItem(
        id: 'food-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        name: name,
        ingredientsText: ingredientsText,
        syncMetadata: const SyncMetadata(
          syncCreatedAt: 0,
          syncUpdatedAt: 0,
          syncDeviceId: 'device',
        ),
      );

  DietRule makeRule(
    DietRuleType ruleType, {
    String? targetIngredient,
    int? timeValue,
  }) => DietRule(
    id: 'rule-001',
    dietId: 'diet-001',
    ruleType: ruleType,
    targetIngredient: targetIngredient,
    timeValue: timeValue,
  );

  group('checkFoodAgainstRules', () {
    group('excludeIngredient rule', () {
      test('returnsViolation_whenIngredientFound', () {
        final food = makeFood(ingredientsText: 'wheat flour, sugar, salt');
        final rules = [
          makeRule(DietRuleType.excludeIngredient, targetIngredient: 'wheat'),
        ];

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, hasLength(1));
        expect(violations.first.ruleType, DietRuleType.excludeIngredient);
      });

      test('returnsNoViolation_whenIngredientNotFound', () {
        final food = makeFood(ingredientsText: 'rice, water, salt');
        final rules = [
          makeRule(DietRuleType.excludeIngredient, targetIngredient: 'wheat'),
        ];

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });

      test('isCaseInsensitive', () {
        final food = makeFood(ingredientsText: 'WHEAT flour, sugar');
        final rules = [
          makeRule(DietRuleType.excludeIngredient, targetIngredient: 'wheat'),
        ];

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, hasLength(1));
      });

      test('returnsNoViolation_whenNoIngredientsText', () {
        final food = makeFood();
        final rules = [
          makeRule(DietRuleType.excludeIngredient, targetIngredient: 'wheat'),
        ];

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });

      test('returnsNoViolation_whenTargetIngredientIsNull', () {
        final food = makeFood(ingredientsText: 'wheat, flour');
        final rules = [makeRule(DietRuleType.excludeIngredient)];

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });
    });

    group('eatingWindowStart rule', () {
      test('returnsViolation_whenEatingBeforeWindow', () {
        // Window starts at 8:00 AM (480). Eating at 5:00 AM (300) violates.
        final rules = [
          makeRule(DietRuleType.eatingWindowStart, timeValue: 480),
        ];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          earlyMorningEpoch,
        );

        expect(violations, hasLength(1));
      });

      test('returnsNoViolation_whenEatingAfterWindowStart', () {
        // Window starts at 8:00 AM. Eating at noon (720) is fine.
        final rules = [
          makeRule(DietRuleType.eatingWindowStart, timeValue: 480),
        ];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });

      test('allowsGracePeriodOf5Minutes', () {
        // Window starts at 8:00 AM (480). Eating at 7:56 AM (476) is within grace.
        final fiveMinBeforeEpoch = DateTime(
          2026,
          2,
          24,
          7,
          56,
        ).millisecondsSinceEpoch;
        final rules = [
          makeRule(DietRuleType.eatingWindowStart, timeValue: 480),
        ];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          fiveMinBeforeEpoch,
        );

        expect(violations, isEmpty);
      });
    });

    group('eatingWindowEnd rule', () {
      test('returnsViolation_whenEatingAfterWindow', () {
        // Window ends at 8:00 PM (1200). Eating at 9:00 PM (1260) violates.
        final rules = [makeRule(DietRuleType.eatingWindowEnd, timeValue: 1200)];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          eveningEpoch,
        );

        expect(violations, hasLength(1));
      });

      test('returnsNoViolation_whenEatingBeforeWindowEnd', () {
        final rules = [makeRule(DietRuleType.eatingWindowEnd, timeValue: 1200)];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });
    });

    group('noEatingBefore rule', () {
      test('returnsViolation_whenEatingBefore', () {
        // No eating before 10:00 AM (600). Eating at 5:00 AM (300) violates.
        final rules = [makeRule(DietRuleType.noEatingBefore, timeValue: 600)];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          earlyMorningEpoch,
        );

        expect(violations, hasLength(1));
      });

      test('returnsNoViolation_whenEatingAfterLimit', () {
        final rules = [makeRule(DietRuleType.noEatingBefore, timeValue: 600)];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });
    });

    group('noEatingAfter rule', () {
      test('returnsViolation_whenEatingAfter', () {
        // No eating after 8:00 PM (1200). Eating at 9:00 PM (1260) violates.
        final rules = [makeRule(DietRuleType.noEatingAfter, timeValue: 1200)];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          eveningEpoch,
        );

        expect(violations, hasLength(1));
      });

      test('returnsNoViolation_whenEatingBeforeLimit', () {
        final rules = [makeRule(DietRuleType.noEatingAfter, timeValue: 1200)];
        final food = makeFood();

        final violations = service.checkFoodAgainstRules(
          food,
          rules,
          noonEpoch,
        );

        expect(violations, isEmpty);
      });
    });

    group('skipped rule types', () {
      final skippedTypes = [
        DietRuleType.excludeCategory,
        DietRuleType.requireCategory,
        DietRuleType.limitCategory,
        DietRuleType.maxCarbs,
        DietRuleType.maxFat,
        DietRuleType.maxProtein,
        DietRuleType.maxCalories,
        DietRuleType.fastingHours,
        DietRuleType.fastingDays,
        DietRuleType.maxMealsPerDay,
        DietRuleType.mealSpacing,
      ];

      for (final ruleType in skippedTypes) {
        test('returnsNoViolation_for_${ruleType.name}', () {
          final food = makeFood();
          final rules = [makeRule(ruleType)];

          final violations = service.checkFoodAgainstRules(
            food,
            rules,
            noonEpoch,
          );

          expect(
            violations,
            isEmpty,
            reason: '${ruleType.name} requires async data — skipped',
          );
        });
      }
    });

    test('checksAllRules_returnsAllViolations', () {
      final food = makeFood(ingredientsText: 'wheat flour, sugar');
      // Two violations: ingredient + time
      final rules = [
        makeRule(DietRuleType.excludeIngredient, targetIngredient: 'wheat'),
        makeRule(DietRuleType.noEatingBefore, timeValue: 600), // 10:00 AM
      ];

      final violations = service.checkFoodAgainstRules(
        food,
        rules,
        earlyMorningEpoch,
      );

      expect(violations, hasLength(2));
    });

    test('returnsEmptyList_whenRulesIsEmpty', () {
      final food = makeFood();

      final violations = service.checkFoodAgainstRules(food, [], noonEpoch);

      expect(violations, isEmpty);
    });
  });

  group('calculateImpact', () {
    test('returnsZero_whenNoViolations', () {
      final impact = service.calculateImpact('profile-001', []);

      expect(impact, 0);
    });

    test('returns10_forOneViolation', () {
      final violations = [makeRule(DietRuleType.excludeIngredient)];

      final impact = service.calculateImpact('profile-001', violations);

      expect(impact, 10.0);
    });

    test('returns100_forTenOrMoreViolations', () {
      final violations = List.generate(
        15,
        (i) => makeRule(DietRuleType.excludeIngredient),
      );

      final impact = service.calculateImpact('profile-001', violations);

      expect(impact, 100.0);
    });

    test('clampsBetween0And100', () {
      final violations = List.generate(
        5,
        (i) => makeRule(DietRuleType.excludeIngredient),
      );

      final impact = service.calculateImpact('profile-001', violations);

      expect(impact, inInclusiveRange(0, 100));
    });
  });
}
