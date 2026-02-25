// test/presentation/screens/food_logs/food_log_screen_compliance_test.dart
// Phase 15b-4 — FoodLogScreen: real-time violation alerts + compliance flow
// Per 59_DIET_TRACKING.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/diet_rule.dart';
import 'package:shadow_app/domain/entities/diet_violation.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/diet/check_compliance_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';
import 'package:shadow_app/domain/usecases/diet/get_active_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/diet/record_violation_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/food_logs/food_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_logs/food_log_screen.dart';

void main() {
  group('FoodLogScreen — diet compliance integration', () {
    const testProfileId = 'profile-001';

    // The active diet used in all compliance tests.
    final activeDiet = Diet(
      id: 'diet-active',
      clientId: 'client-001',
      profileId: testProfileId,
      name: 'Test Diet',
      startDate: 0,
      isActive: true,
      syncMetadata: SyncMetadata.empty(),
    );

    // A single violated rule — ingredient exclusion.
    const violatedRule = DietRule(
      id: 'rule-gluten',
      dietId: 'diet-active',
      ruleType: DietRuleType.excludeIngredient,
      targetIngredient: 'wheat',
    );

    // A compliance result with violations (isCompliant=false).
    const violationResult = ComplianceCheckResult(
      isCompliant: false,
      violatedRules: [violatedRule],
      complianceImpact: 10,
      alternatives: [],
    );

    // A compliance result with no violations (isCompliant=true).
    const compliantResult = ComplianceCheckResult(
      isCompliant: true,
      violatedRules: [],
      complianceImpact: 0,
      alternatives: [],
    );

    // An eating-window violation for fasting window tests.
    const fastingRule = DietRule(
      id: 'rule-fasting',
      dietId: 'diet-active',
      ruleType: DietRuleType.eatingWindowStart,
      timeValue: 480,
    );

    const fastingViolationResult = ComplianceCheckResult(
      isCompliant: false,
      violatedRules: [fastingRule],
      complianceImpact: 10,
      alternatives: [],
    );

    /// Scrolls the form ListView down to make bottom widgets visible.
    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    /// Adds an ad-hoc item via the UI (types in field, taps +).
    Future<void> addAdHocItem(WidgetTester tester, String name) async {
      await scrollToBottom(tester);
      final adHocField = find.descendant(
        of: find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Food name, required',
        ),
        matching: find.byType(TextField),
      );
      await tester.enterText(adHocField, name);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
    }

    Widget buildScreen({
      required Diet? activeDietResult,
      required ComplianceCheckResult checkResult,
      required _TrackingFoodLogList foodLogList,
      required _TrackingRecordViolationUseCase recordViolation,
    }) => ProviderScope(
      overrides: [
        foodLogListProvider(testProfileId).overrideWith(() => foodLogList),
        getActiveDietUseCaseProvider.overrideWithValue(
          _FakeGetActiveDietUseCase(activeDietResult),
        ),
        checkComplianceUseCaseProvider.overrideWithValue(
          _FakeCheckComplianceUseCase(checkResult),
        ),
        recordViolationUseCaseProvider.overrideWithValue(recordViolation),
      ],
      child: const MaterialApp(home: FoodLogScreen(profileId: testProfileId)),
    );

    /// Pumps enough frames for the async compliance chain to complete
    /// and the DietViolationDialog to be rendered.
    ///
    /// Cannot use pumpAndSettle() here because _isSaving=true shows a
    /// CircularProgressIndicator whose looping animation never settles.
    Future<void> pumpThroughComplianceCheck(WidgetTester tester) async {
      // 4 microtask cycles: tap → getActiveDiet → checkCompliance → showDialog
      await tester.pump();
      await tester.pump();
      await tester.pump();
      await tester.pump();
    }

    // -------------------------------------------------------------------------
    // No active diet — compliance check is skipped entirely
    // -------------------------------------------------------------------------

    group('no active diet', () {
      testWidgets('saves directly without showing dialog', (tester) async {
        final foodLogList = _TrackingFoodLogList();
        final recordViolation = _TrackingRecordViolationUseCase();

        await tester.pumpWidget(
          buildScreen(
            activeDietResult: null, // No active diet
            checkResult: compliantResult,
            foodLogList: foodLogList,
            recordViolation: recordViolation,
          ),
        );
        await tester.pumpAndSettle();

        await addAdHocItem(tester, 'Bread');
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(find.text('Diet Alert'), findsNothing);
        expect(find.text('Food log created successfully'), findsOneWidget);
        expect(foodLogList.logCalled, isTrue);
        expect(recordViolation.calls, isEmpty);
      });
    });

    // -------------------------------------------------------------------------
    // Active diet + compliant food
    // -------------------------------------------------------------------------

    group('compliant food with active diet', () {
      testWidgets('saves directly without showing Diet Alert dialog', (
        tester,
      ) async {
        final foodLogList = _TrackingFoodLogList();
        final recordViolation = _TrackingRecordViolationUseCase();

        await tester.pumpWidget(
          buildScreen(
            activeDietResult: activeDiet,
            checkResult: compliantResult, // No violations
            foodLogList: foodLogList,
            recordViolation: recordViolation,
          ),
        );
        await tester.pumpAndSettle();

        await addAdHocItem(tester, 'Apple');
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        // Use pump() not pumpAndSettle() — CircularProgressIndicator never settles.
        // With compliantResult, the chain completes and snackbar shows immediately.
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump();

        expect(find.text('Diet Alert'), findsNothing);
        expect(find.text('Food log created successfully'), findsOneWidget);
        expect(foodLogList.logCalled, isTrue);
        expect(recordViolation.calls, isEmpty);
      });
    });

    // -------------------------------------------------------------------------
    // Active diet + violation detected → Diet Alert dialog shown
    // -------------------------------------------------------------------------

    group('violation detected', () {
      testWidgets('shows Diet Alert dialog with violated rule description', (
        tester,
      ) async {
        final foodLogList = _TrackingFoodLogList();
        final recordViolation = _TrackingRecordViolationUseCase();

        await tester.pumpWidget(
          buildScreen(
            activeDietResult: activeDiet,
            checkResult: violationResult,
            foodLogList: foodLogList,
            recordViolation: recordViolation,
          ),
        );
        await tester.pumpAndSettle();

        await addAdHocItem(tester, 'Bread');
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await pumpThroughComplianceCheck(tester);

        expect(find.text('Diet Alert'), findsOneWidget);
      });

      testWidgets(
        '"Log Anyway" saves food log and records violation with wasOverridden=true',
        (tester) async {
          final foodLogList = _TrackingFoodLogList();
          final recordViolation = _TrackingRecordViolationUseCase();

          await tester.pumpWidget(
            buildScreen(
              activeDietResult: activeDiet,
              checkResult: violationResult,
              foodLogList: foodLogList,
              recordViolation: recordViolation,
            ),
          );
          await tester.pumpAndSettle();

          await addAdHocItem(tester, 'Bread');
          await scrollToBottom(tester);
          await tester.tap(find.text('Save'));
          await pumpThroughComplianceCheck(tester);

          // Confirm dialog is shown
          expect(find.text('Log Anyway'), findsOneWidget);

          await tester.tap(find.text('Log Anyway'));
          // Pump through: dialog pop → _saveFoodLog → _recordViolations → snackbar
          await tester.pump();
          await tester.pump();
          await tester.pump();
          await tester.pump();

          // Food was saved
          expect(foodLogList.logCalled, isTrue);
          // Violation was recorded with wasOverridden=true
          expect(recordViolation.calls, hasLength(1));
          expect(recordViolation.calls.first.wasOverridden, isTrue);
          expect(recordViolation.calls.first.ruleId, 'rule-gluten');
        },
      );

      testWidgets(
        '"Cancel" does not save food log, records violation with wasOverridden=false, '
        'shows "Food not logged" snackbar',
        (tester) async {
          final foodLogList = _TrackingFoodLogList();
          final recordViolation = _TrackingRecordViolationUseCase();

          await tester.pumpWidget(
            buildScreen(
              activeDietResult: activeDiet,
              checkResult: violationResult,
              foodLogList: foodLogList,
              recordViolation: recordViolation,
            ),
          );
          await tester.pumpAndSettle();

          await addAdHocItem(tester, 'Bread');
          await scrollToBottom(tester);
          await tester.tap(find.text('Save'));
          await pumpThroughComplianceCheck(tester);

          // Confirm dialog is shown (there are two "Cancel" texts — one in the
          // form and one in the dialog, so target the one inside AlertDialog).
          expect(find.byType(AlertDialog), findsOneWidget);

          await tester.tap(
            find.descendant(
              of: find.byType(AlertDialog),
              matching: find.text('Cancel'),
            ),
          );
          // Pump through: dialog pop → _recordViolations → snackbar shown
          await tester.pump();
          await tester.pump();
          await tester.pump();

          // Food was NOT saved
          expect(foodLogList.logCalled, isFalse);
          // Violation was recorded with wasOverridden=false
          expect(recordViolation.calls, hasLength(1));
          expect(recordViolation.calls.first.wasOverridden, isFalse);
          // "Food not logged" snackbar is shown
          expect(find.text('Food not logged'), findsOneWidget);
        },
      );
    });

    // -------------------------------------------------------------------------
    // No ad-hoc items — compliance check is skipped even with active diet
    // -------------------------------------------------------------------------

    group('no ad-hoc items', () {
      testWidgets(
        'saves directly without showing dialog when no ad-hoc items entered',
        (tester) async {
          final foodLogList = _TrackingFoodLogList();
          final recordViolation = _TrackingRecordViolationUseCase();

          await tester.pumpWidget(
            buildScreen(
              activeDietResult: activeDiet,
              checkResult: violationResult, // Would violate if checked
              foodLogList: foodLogList,
              recordViolation: recordViolation,
            ),
          );
          await tester.pumpAndSettle();

          // Do NOT add any ad-hoc items — just tap Save
          await scrollToBottom(tester);
          await tester.tap(find.text('Save'));
          await tester.pump();

          // No dialog shown — skip check when no items
          expect(find.text('Diet Alert'), findsNothing);
          expect(find.text('Food log created successfully'), findsOneWidget);
          expect(foodLogList.logCalled, isTrue);
          expect(recordViolation.calls, isEmpty);
        },
      );
    });

    // -------------------------------------------------------------------------
    // Fasting window violation — eating window / noEatingBefore
    // -------------------------------------------------------------------------

    group('fasting window violation', () {
      testWidgets('shows Diet Alert for eating window start violation', (
        tester,
      ) async {
        final foodLogList = _TrackingFoodLogList();
        final recordViolation = _TrackingRecordViolationUseCase();

        await tester.pumpWidget(
          buildScreen(
            activeDietResult: activeDiet,
            checkResult: fastingViolationResult,
            foodLogList: foodLogList,
            recordViolation: recordViolation,
          ),
        );
        await tester.pumpAndSettle();

        await addAdHocItem(tester, 'Oatmeal');
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await pumpThroughComplianceCheck(tester);

        // Dialog shows for eating window violation
        expect(find.text('Diet Alert'), findsOneWidget);

        // Dismiss with "Log Anyway"
        await tester.tap(find.text('Log Anyway'));
        await tester.pump();
        await tester.pump();
        await tester.pump();
        await tester.pump();

        expect(foodLogList.logCalled, isTrue);
        expect(recordViolation.calls.first.ruleId, 'rule-fasting');
      });
    });
  });
}

// =============================================================================
// Fake / tracking helpers
// =============================================================================

/// FoodLogList that tracks whether log() was called.
class _TrackingFoodLogList extends FoodLogList {
  bool logCalled = false;

  @override
  Future<List<FoodLog>> build(String profileId) async => [];

  @override
  Future<void> log(LogFoodInput input) async {
    logCalled = true;
  }

  @override
  Future<void> updateLog(UpdateFoodLogInput input) async {}

  @override
  Future<void> delete(DeleteFoodLogInput input) async {}
}

/// Fake GetActiveDietUseCase — returns the supplied [diet] (or null).
class _FakeGetActiveDietUseCase implements GetActiveDietUseCase {
  final Diet? _diet;
  _FakeGetActiveDietUseCase(this._diet);

  @override
  Future<Result<Diet?, AppError>> call(GetActiveDietInput input) async =>
      Success(_diet);
}

/// Fake CheckComplianceUseCase — always returns the supplied [result].
class _FakeCheckComplianceUseCase implements CheckComplianceUseCase {
  final ComplianceCheckResult _result;
  _FakeCheckComplianceUseCase(this._result);

  @override
  Future<Result<ComplianceCheckResult, AppError>> call(
    CheckComplianceInput input,
  ) async => Success(_result);
}

/// RecordViolationUseCase that captures all calls for assertion.
class _TrackingRecordViolationUseCase implements RecordViolationUseCase {
  final List<RecordViolationInput> calls = [];

  @override
  Future<Result<DietViolation, AppError>> call(
    RecordViolationInput input,
  ) async {
    calls.add(input);
    return Success(
      DietViolation(
        id: 'viol-test',
        clientId: input.clientId,
        profileId: input.profileId,
        dietId: input.dietId,
        ruleId: input.ruleId,
        foodName: input.foodName,
        ruleDescription: input.ruleDescription,
        wasOverridden: input.wasOverridden,
        timestamp: input.timestamp,
        syncMetadata: SyncMetadata.empty(),
      ),
    );
  }
}
