// lib/domain/usecases/diet/diet_types.dart
// Phase 15b-2 — Shared input/output types for diet use cases
// Per 22_API_CONTRACTS.md Section 4.5.4 + 59_DIET_TRACKING.md

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'diet_types.freezed.dart';

// =============================================================================
// CREATE DIET
// =============================================================================

@freezed
class CreateDietInput with _$CreateDietInput {
  const factory CreateDietInput({
    required String profileId,
    required String clientId,
    required String name,
    @Default('') String description,
    DietPresetType? presetType, // null = fully custom diet
    @Default([])
    List<DietRule> initialRules, // Custom rules to add after creation
    @Default(false)
    bool activateImmediately, // true = deactivate current + activate this
    @Default(false) bool isDraft,
    int? startDateEpoch, // Epoch ms; defaults to now
    int? endDateEpoch, // Epoch ms; optional
  }) = _CreateDietInput;
}

// =============================================================================
// GET DIETS
// =============================================================================

@freezed
class GetDietsInput with _$GetDietsInput {
  const factory GetDietsInput({
    required String profileId,
    @Default(false) bool activeOnly,
  }) = _GetDietsInput;
}

// =============================================================================
// GET ACTIVE DIET
// =============================================================================

@freezed
class GetActiveDietInput with _$GetActiveDietInput {
  const factory GetActiveDietInput({required String profileId}) =
      _GetActiveDietInput;
}

// =============================================================================
// ACTIVATE DIET
// =============================================================================

@freezed
class ActivateDietInput with _$ActivateDietInput {
  const factory ActivateDietInput({
    required String profileId,
    required String dietId,
  }) = _ActivateDietInput;
}

// =============================================================================
// CHECK COMPLIANCE
// =============================================================================

@freezed
class CheckComplianceInput with _$CheckComplianceInput {
  const factory CheckComplianceInput({
    required String profileId,
    required String dietId,
    required FoodItem foodItem,
    required int logTimeEpoch, // Epoch milliseconds
  }) = _CheckComplianceInput;
}

/// Result of a real-time compliance check before food is saved.
@freezed
class ComplianceCheckResult with _$ComplianceCheckResult {
  const factory ComplianceCheckResult({
    required bool isCompliant,
    required List<DietRule> violatedRules,
    required double
    complianceImpact, // Estimated % reduction in daily compliance
    required List<FoodItem> alternatives, // Suggested compliant alternatives
  }) = _ComplianceCheckResult;
}

// =============================================================================
// RECORD VIOLATION
// =============================================================================

@freezed
class RecordViolationInput with _$RecordViolationInput {
  const factory RecordViolationInput({
    required String profileId,
    required String clientId,
    required String dietId,
    required String ruleId,
    required String foodName,
    required String ruleDescription,
    @Default(false) bool wasOverridden, // true = "Add Anyway", false = "Cancel"
    required int timestamp, // Epoch ms
    String? foodLogId, // Set if wasOverridden=true and food was saved
  }) = _RecordViolationInput;
}

// =============================================================================
// GET VIOLATIONS
// =============================================================================

@freezed
class GetViolationsInput with _$GetViolationsInput {
  const factory GetViolationsInput({
    required String profileId,
    int? startDate, // Epoch ms
    int? endDate, // Epoch ms
    int? limit,
  }) = _GetViolationsInput;
}

// =============================================================================
// GET COMPLIANCE STATS (Dashboard)
// =============================================================================

@freezed
class GetComplianceStatsInput with _$GetComplianceStatsInput {
  const factory GetComplianceStatsInput({
    required String profileId,
    required String dietId,
    required int startDateEpoch, // Epoch ms
    required int endDateEpoch, // Epoch ms
  }) = _GetComplianceStatsInput;
}

/// Daily compliance record for one calendar day.
@freezed
class DailyCompliance with _$DailyCompliance {
  const DailyCompliance._();

  const factory DailyCompliance({
    required int dateEpoch, // Epoch ms (midnight of day)
    required double score, // 0-100
    required int violations, // Hard violations (user cancelled)
    required int warnings, // Soft violations (user added anyway)
  }) = _DailyCompliance;
}

/// Compliance statistics returned by GetComplianceStatsUseCase.
@freezed
class ComplianceStats with _$ComplianceStats {
  const factory ComplianceStats({
    required double overallScore, // 0-100 for requested date range
    required double dailyScore, // Today's score
    required double weeklyScore, // Last 7 days
    required double monthlyScore, // Last 30 days
    required int currentStreak, // Consecutive days ≥80% compliant
    required int longestStreak, // Best streak in range
    required int totalViolations, // Cancelled entries (wasOverridden=false)
    required int totalWarnings, // Added-anyway entries (wasOverridden=true)
    required Map<DietRuleType, double> complianceByRule,
    required List<DietViolation> recentViolations, // Last 10
    required List<DailyCompliance> dailyTrend,
  }) = _ComplianceStats;
}
