// lib/domain/services/diet_compliance_service.dart
// Phase 15b-2 — Abstract DietComplianceService interface
// Per 59_DIET_TRACKING.md + 22_API_CONTRACTS.md Section 4.5.4

import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/food_item.dart';

/// Domain service that performs real-time diet compliance checks.
///
/// Called synchronously from CheckComplianceUseCase during the food-add flow
/// (before saving). Must complete in under 500ms per spec.
abstract class DietComplianceService {
  /// Check a food item against a list of diet rules.
  ///
  /// Returns the rules that are violated. Empty list = compliant.
  /// [logTimeEpoch] is used for time-based rules (eating window, fasting).
  List<DietRule> checkFoodAgainstRules(
    FoodItem food,
    List<DietRule> rules,
    int logTimeEpoch,
  );

  /// Estimate how much logging this food will reduce compliance percentage.
  ///
  /// Returns a value in the range [0.0, 100.0]. A value of 0 means no
  /// compliance impact (food is compliant). A positive value indicates
  /// the approximate percentage-point reduction in daily compliance.
  double calculateImpact(String profileId, List<DietRule> violations);
}
