// lib/domain/entities/diet_rule.dart
// Phase 15b — Individual rule within a diet
// Per 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'diet_rule.freezed.dart';

/// An individual compliance rule within a Diet.
///
/// Per 59_DIET_TRACKING.md — rules define what foods are allowed,
/// restricted, or forbidden. DietComplianceService evaluates rules
/// against food items during the food logging flow.
@freezed
class DietRule with _$DietRule {
  const factory DietRule({
    required String id,
    required String dietId,
    required DietRuleType ruleType,
    // What this rule applies to — only one of these is set per rule
    String? targetFoodItemId, // Specific food item ID
    String? targetCategory, // Food category (e.g. "dairy", "grains")
    String? targetIngredient, // Specific ingredient text (free-text)
    // Quantity constraints (for Limited and Required rule types)
    double? minValue,
    double? maxValue,
    String? unit, // "grams", "servings", "percent", "hours", "minutes"
    String? frequency, // "per_meal", "per_day", "per_week"
    // For time-based rules: minutes from midnight (e.g. 480 = 8:00 AM)
    int? timeValue,
    @Default(0) int sortOrder,
  }) = _DietRule;
}
