// lib/data/services/diet_compliance_service_impl.dart
// Phase 15b-2 — DietComplianceService implementation
// Per 59_DIET_TRACKING.md

import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/services/diet_compliance_service.dart';

/// Synchronous compliance checker — runs during the food-add flow.
///
/// Checks the food item against each applicable rule type.
/// Time-based rules compare the log timestamp against the rule's time value.
/// Ingredient-based rules scan the food's ingredientsText field.
/// Category and macro rules require additional data not available synchronously
/// and are skipped here (macro rules are evaluated in GetComplianceStatsUseCase).
class DietComplianceServiceImpl implements DietComplianceService {
  const DietComplianceServiceImpl();

  @override
  List<DietRule> checkFoodAgainstRules(
    FoodItem food,
    List<DietRule> rules,
    int logTimeEpoch,
  ) {
    final logTime = DateTime.fromMillisecondsSinceEpoch(logTimeEpoch);
    final minutesSinceMidnight = logTime.hour * 60 + logTime.minute;

    return rules
        .where((rule) => _isRuleViolated(food, rule, minutesSinceMidnight))
        .toList();
  }

  bool _isRuleViolated(FoodItem food, DietRule rule, int minutesSinceMidnight) {
    switch (rule.ruleType) {
      case DietRuleType.excludeIngredient:
        return _violatesIngredientExclusion(food, rule);
      case DietRuleType.eatingWindowStart:
        // Rule: no food before this time (start of eating window).
        // timeValue is minutes from midnight. Grace period: 5 minutes.
        final windowStart = rule.timeValue;
        return windowStart != null && minutesSinceMidnight < windowStart - 5;
      case DietRuleType.eatingWindowEnd:
        // Rule: no food after this time (end of eating window).
        final windowEnd = rule.timeValue;
        return windowEnd != null && minutesSinceMidnight > windowEnd + 5;
      case DietRuleType.noEatingBefore:
        final limit = rule.timeValue;
        return limit != null && minutesSinceMidnight < limit;
      case DietRuleType.noEatingAfter:
        final limit = rule.timeValue;
        return limit != null && minutesSinceMidnight > limit;
      // Category matching requires category metadata on FoodItem (not stored).
      // Macro, fasting, and other rules require async data or session tracking.
      // All other rule types are evaluated in GetComplianceStatsUseCase.
      case DietRuleType.excludeCategory:
      case DietRuleType.requireCategory:
      case DietRuleType.limitCategory:
      case DietRuleType.maxCarbs:
      case DietRuleType.maxFat:
      case DietRuleType.maxProtein:
      case DietRuleType.minCarbs:
      case DietRuleType.minFat:
      case DietRuleType.minProtein:
      case DietRuleType.carbPercentage:
      case DietRuleType.fatPercentage:
      case DietRuleType.proteinPercentage:
      case DietRuleType.maxCalories:
      case DietRuleType.maxMealsPerDay:
      case DietRuleType.mealSpacing:
      case DietRuleType.fastingHours:
      case DietRuleType.fastingDays:
        return false;
    }
  }

  bool _violatesIngredientExclusion(FoodItem food, DietRule rule) {
    final target = rule.targetIngredient;
    if (target == null || target.isEmpty) return false;

    final ingredientsText = food.ingredientsText ?? '';
    if (ingredientsText.isEmpty) {
      // If we have no ingredients info, give benefit of the doubt.
      return false;
    }

    return ingredientsText.toLowerCase().contains(target.toLowerCase());
  }

  @override
  double calculateImpact(String profileId, List<DietRule> violations) {
    if (violations.isEmpty) return 0;

    // Simplified impact estimate: each violation reduces compliance.
    // Full calculation (which requires async daily totals) is performed
    // in GetComplianceStatsUseCase.
    const impactPerViolation = 10.0;
    return (violations.length * impactPerViolation).clamp(0.0, 100.0);
  }
}
