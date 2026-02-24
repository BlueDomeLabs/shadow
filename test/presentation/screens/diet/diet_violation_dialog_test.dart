// test/presentation/screens/diet/diet_violation_dialog_test.dart
// Tests for DietViolationDialog.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/screens/diet/diet_violation_dialog.dart';

void main() {
  group('DietViolationDialog', () {
    const testRule = DietRule(
      id: 'rule-001',
      dietId: 'diet-001',
      ruleType: DietRuleType.excludeIngredient,
      targetIngredient: 'gluten',
    );

    Widget buildDialog({
      String foodName = 'White Bread',
      List<DietRule>? violatedRules,
      double complianceImpact = 10.0,
      double currentScore = 100.0,
    }) => MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showDietViolationDialog(
              context: context,
              foodName: foodName,
              violatedRules: violatedRules ?? [testRule],
              complianceImpact: complianceImpact,
              currentScore: currentScore,
            ),
            child: const Text('Show Dialog'),
          ),
        ),
      ),
    );

    testWidgets('shows "Diet Alert" title', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Diet Alert'), findsOneWidget);
    });

    testWidgets('shows food name', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('White Bread'), findsOneWidget);
    });

    testWidgets('shows violated rule description', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.textContaining('gluten'), findsOneWidget);
    });

    testWidgets('shows compliance impact text', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.textContaining('100%'), findsOneWidget);
      expect(find.textContaining('90%'), findsOneWidget);
    });

    testWidgets('shows Cancel button', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('shows "Log Anyway" button', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Log Anyway'), findsOneWidget);
    });

    testWidgets('Cancel dismisses dialog', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Diet Alert'), findsNothing);
    });

    testWidgets('"Log Anyway" dismisses dialog', (tester) async {
      await tester.pumpWidget(buildDialog());
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log Anyway'));
      await tester.pumpAndSettle();

      expect(find.text('Diet Alert'), findsNothing);
    });

    testWidgets('shows multiple violated rules', (tester) async {
      final rules = [
        const DietRule(
          id: 'rule-001',
          dietId: 'diet-001',
          ruleType: DietRuleType.excludeIngredient,
          targetIngredient: 'gluten',
        ),
        const DietRule(
          id: 'rule-002',
          dietId: 'diet-001',
          ruleType: DietRuleType.excludeCategory,
          targetCategory: 'grains',
        ),
      ];
      await tester.pumpWidget(buildDialog(violatedRules: rules));
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.textContaining('gluten'), findsOneWidget);
      expect(find.textContaining('grains'), findsOneWidget);
    });
  });
}
