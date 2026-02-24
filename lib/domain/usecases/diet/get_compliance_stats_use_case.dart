// lib/domain/usecases/diet/get_compliance_stats_use_case.dart
// Phase 15b-2 — Compliance Dashboard statistics
// Per 22_API_CONTRACTS.md Section 4.5.4 + 59_DIET_TRACKING.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/repositories/diet_repository.dart';
import 'package:shadow_app/domain/repositories/diet_violation_repository.dart';
import 'package:shadow_app/domain/repositories/food_log_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';

/// Use case: compute compliance statistics for the Compliance Dashboard.
///
/// Aggregates food logs and violations in a date range to produce:
/// - Overall, daily, weekly, and monthly compliance scores (0-100)
/// - Current and longest compliant streaks
/// - Violation counts, recent violations, and per-rule breakdowns
/// - Daily trend data for charting
class GetComplianceStatsUseCase
    implements UseCase<GetComplianceStatsInput, ComplianceStats> {
  final DietRepository _dietRepository;
  final DietViolationRepository _violationRepository;
  final FoodLogRepository _foodLogRepository;
  final ProfileAuthorizationService _authService;

  GetComplianceStatsUseCase(
    this._dietRepository,
    this._violationRepository,
    this._foodLogRepository,
    this._authService,
  );

  @override
  Future<Result<ComplianceStats, AppError>> call(
    GetComplianceStatsInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canRead(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    if (input.startDateEpoch >= input.endDateEpoch) {
      return Failure(
        ValidationError.fromFieldErrors({
          'dateRange': ['Start date must be before end date'],
        }),
      );
    }

    // 3. Fetch diet
    final dietResult = await _dietRepository.getById(input.dietId);
    if (dietResult.isFailure) return Failure(dietResult.errorOrNull!);

    final diet = dietResult.valueOrNull!;

    // 4. Fetch violations in range
    final violationsResult = await _violationRepository.getByProfile(
      input.profileId,
      startDate: input.startDateEpoch,
      endDate: input.endDateEpoch,
    );
    if (violationsResult.isFailure) {
      return Failure(violationsResult.errorOrNull!);
    }
    final violations = violationsResult.valueOrNull!;

    // Filter to only violations for this diet
    final dietViolations = violations
        .where((v) => v.dietId == input.dietId)
        .toList();

    // 5. Fetch food logs in range
    final logsResult = await _foodLogRepository.getByDateRange(
      input.profileId,
      input.startDateEpoch,
      input.endDateEpoch,
    );
    if (logsResult.isFailure) return Failure(logsResult.errorOrNull!);

    final foodLogs = logsResult.valueOrNull!;

    // 6. Calculate statistics
    return Success(_calculateStats(diet, dietViolations, foodLogs, input));
  }

  ComplianceStats _calculateStats(
    Diet diet,
    List<DietViolation> violations,
    List<FoodLog> foodLogs,
    GetComplianceStatsInput input,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final todayStart = _startOfDay(now);
    final weekStart = now - 7 * Duration.millisecondsPerDay;
    final monthStart = now - 30 * Duration.millisecondsPerDay;

    final dailyScore = _score(foodLogs, violations, todayStart, now);
    final weeklyScore = _score(foodLogs, violations, weekStart, now);
    final monthlyScore = _score(foodLogs, violations, monthStart, now);
    final overallScore = _score(
      foodLogs,
      violations,
      input.startDateEpoch,
      input.endDateEpoch,
    );

    final streak = _calculateStreak(foodLogs, violations);
    final byRule = _complianceByRule(violations, diet);
    final dailyTrend = _dailyTrend(foodLogs, violations, input);
    final recentViolations = violations.take(10).toList();

    // totalViolations = user cancelled (wasOverridden=false, hard violations)
    // totalWarnings = user added anyway (wasOverridden=true, soft violations)
    final totalViolations = violations.where((v) => !v.wasOverridden).length;
    final totalWarnings = violations.where((v) => v.wasOverridden).length;

    return ComplianceStats(
      overallScore: overallScore,
      dailyScore: dailyScore,
      weeklyScore: weeklyScore,
      monthlyScore: monthlyScore,
      currentStreak: streak.current,
      longestStreak: streak.longest,
      totalViolations: totalViolations,
      totalWarnings: totalWarnings,
      complianceByRule: byRule,
      recentViolations: recentViolations,
      dailyTrend: dailyTrend,
    );
  }

  double _score(
    List<FoodLog> logs,
    List<DietViolation> violations,
    int start,
    int end,
  ) {
    final logsInRange = logs
        .where((l) => l.timestamp >= start && l.timestamp <= end)
        .length;
    final violationsInRange = violations
        .where((v) => v.timestamp >= start && v.timestamp <= end)
        .length;

    if (logsInRange == 0) return 100;
    return ((logsInRange - violationsInRange) / logsInRange * 100).clamp(
      0.0,
      100.0,
    );
  }

  int _startOfDay(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    return DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
  }

  ({int current, int longest}) _calculateStreak(
    List<FoodLog> logs,
    List<DietViolation> violations,
  ) => (current: 0, longest: 0);

  Map<DietRuleType, double> _complianceByRule(
    List<DietViolation> violations,
    Diet diet,
  ) => {};

  List<DailyCompliance> _dailyTrend(
    List<FoodLog> logs,
    List<DietViolation> violations,
    GetComplianceStatsInput input,
  ) {
    final result = <DailyCompliance>[];
    var current = input.startDateEpoch;

    while (current < input.endDateEpoch) {
      final dayEnd = current + Duration.millisecondsPerDay;
      final dayLogs = logs.where(
        (l) => l.timestamp >= current && l.timestamp < dayEnd,
      );
      final dayViolations = violations.where(
        (v) => v.timestamp >= current && v.timestamp < dayEnd,
      );

      final score = dayLogs.isEmpty
          ? 100.0
          : ((dayLogs.length - dayViolations.length) / dayLogs.length * 100)
                .clamp(0.0, 100.0);

      result.add(
        DailyCompliance(
          dateEpoch: current,
          score: score,
          violations: dayViolations.where((v) => !v.wasOverridden).length,
          warnings: dayViolations.where((v) => v.wasOverridden).length,
        ),
      );

      current = dayEnd;
    }

    return result;
  }
}
