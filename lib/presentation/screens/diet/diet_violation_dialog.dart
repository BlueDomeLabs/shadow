// lib/presentation/screens/diet/diet_violation_dialog.dart
// Pre-save compliance violation alert — Phase 15b-3
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.5 + 59_DIET_TRACKING.md

import 'package:flutter/material.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

/// Result returned by DietViolationDialog when dismissed.
enum DietViolationChoice {
  /// User chose to log the food despite violations.
  logAnyway,

  /// User chose not to log the food.
  cancel,
}

/// Dialog shown when a food item violates the active diet's rules.
///
/// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.5:
/// - Title: "Diet Alert"
/// - Shows food name, violated rules, and compliance impact
/// - Buttons: "Cancel" (don't save) and "Log Anyway" (save with flag)
///
/// Returns [DietViolationChoice] via [Navigator.pop].
class DietViolationDialog extends StatelessWidget {
  final String foodName;
  final List<DietRule> violatedRules;
  final double complianceImpact;
  final double currentScore;

  const DietViolationDialog({
    super.key,
    required this.foodName,
    required this.violatedRules,
    required this.complianceImpact,
    required this.currentScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectedScore = (currentScore - complianceImpact).clamp(0.0, 100.0);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          const Text('Diet Alert'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This food violates your diet rules:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ...violatedRules.map(
              (rule) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.close, size: 16, color: theme.colorScheme.error),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _ruleDescription(rule),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Compliance impact', style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(
              'Score will drop from ${currentScore.toStringAsFixed(0)}% to ${projectedScore.toStringAsFixed(0)}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: projectedScore / 100,
                backgroundColor: theme.colorScheme.errorContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  projectedScore >= 80
                      ? Colors.green
                      : projectedScore >= 50
                      ? Colors.orange
                      : theme.colorScheme.error,
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(DietViolationChoice.cancel),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(DietViolationChoice.logAnyway),
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          child: const Text('Log Anyway'),
        ),
      ],
    );
  }

  /// Human-readable description of a violated diet rule.
  String _ruleDescription(DietRule rule) {
    switch (rule.ruleType) {
      case DietRuleType.excludeIngredient:
        final ingredient = rule.targetIngredient ?? 'ingredient';
        return 'Contains $ingredient (excluded by your diet)';
      case DietRuleType.excludeCategory:
        final category = rule.targetCategory ?? 'food category';
        return 'Contains $category (excluded by your diet)';
      case DietRuleType.eatingWindowStart:
        final time = _minutesToTimeString(rule.timeValue ?? 0);
        return 'Too early — eating window starts at $time';
      case DietRuleType.eatingWindowEnd:
        final time = _minutesToTimeString(rule.timeValue ?? 0);
        return 'Too late — eating window ends at $time';
      case DietRuleType.noEatingBefore:
        final time = _minutesToTimeString(rule.timeValue ?? 0);
        return 'No eating before $time';
      case DietRuleType.noEatingAfter:
        final time = _minutesToTimeString(rule.timeValue ?? 0);
        return 'No eating after $time';
      case DietRuleType.maxCalories:
        return 'Exceeds daily calorie limit (${rule.maxValue?.toStringAsFixed(0) ?? "?"} kcal)';
      case DietRuleType.maxCarbs:
        return 'Exceeds daily carb limit (${rule.maxValue?.toStringAsFixed(0) ?? "?"} g)';
      case DietRuleType.maxFat:
        return 'Exceeds daily fat limit (${rule.maxValue?.toStringAsFixed(0) ?? "?"} g)';
      case DietRuleType.maxProtein:
        return 'Exceeds daily protein limit (${rule.maxValue?.toStringAsFixed(0) ?? "?"} g)';
      case DietRuleType.fastingHours:
        return 'You are currently in a fasting period';
      case DietRuleType.maxMealsPerDay:
        return 'Maximum meals per day reached (${rule.maxValue?.toStringAsFixed(0) ?? "?"})';
      default:
        return 'Violates diet rule: ${rule.ruleType.name}';
    }
  }

  /// Converts minutes-from-midnight to "H:MM AM/PM" string.
  String _minutesToTimeString(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}

/// Shows the [DietViolationDialog] and returns the user's choice.
///
/// Returns null if dismissed without selecting an option.
Future<DietViolationChoice?> showDietViolationDialog({
  required BuildContext context,
  required String foodName,
  required List<DietRule> violatedRules,
  required double complianceImpact,
  double currentScore = 100.0,
}) => showDialog<DietViolationChoice>(
  context: context,
  barrierDismissible: false,
  builder: (_) => DietViolationDialog(
    foodName: foodName,
    violatedRules: violatedRules,
    complianceImpact: complianceImpact,
    currentScore: currentScore,
  ),
);
