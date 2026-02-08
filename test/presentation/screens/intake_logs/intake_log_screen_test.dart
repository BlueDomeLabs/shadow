// test/presentation/screens/intake_logs/intake_log_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/intake_logs/intake_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/intake_logs/intake_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/intake_logs/intake_log_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('IntakeLogScreen', () {
    const testProfileId = 'profile-001';

    /// Scrolls the form ListView down to make bottom widgets visible.
    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    IntakeLog createTestIntakeLog({
      String id = 'intake-001',
      String clientId = 'client-001',
      String supplementId = 'supp-001',
      int scheduledTime = 1700000000000,
      int? actualTime,
      IntakeLogStatus status = IntakeLogStatus.pending,
      String? reason,
      String? note,
      int? snoozeDurationMinutes,
    }) => IntakeLog(
      id: id,
      clientId: clientId,
      profileId: testProfileId,
      supplementId: supplementId,
      scheduledTime: scheduledTime,
      actualTime: actualTime,
      status: status,
      reason: reason,
      note: note,
      snoozeDurationMinutes: snoozeDurationMinutes,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen({
      IntakeLog? intakeLog,
      _MockIntakeLogList Function()? mockFactory,
    }) {
      final log = intakeLog ?? createTestIntakeLog();
      return ProviderScope(
        overrides: [
          intakeLogListProvider(
            testProfileId,
          ).overrideWith(mockFactory ?? () => _MockIntakeLogList([log])),
        ],
        child: MaterialApp(
          home: IntakeLogScreen(profileId: testProfileId, intakeLog: log),
        ),
      );
    }

    group('rendering', () {
      testWidgets('renders Log Supplement Intake title', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Log Supplement Intake'), findsOneWidget);
      });

      testWidgets('renders Status section header', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Status'), findsOneWidget);
      });

      testWidgets('renders Notes section header', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Notes'), findsWidgets);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders status segment with 3 options', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Taken'), findsOneWidget);
        expect(find.text('Skipped'), findsOneWidget);
        expect(find.text('Snoozed'), findsOneWidget);
      });

      testWidgets('default status is Taken', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // When Taken is selected (default), Actual Time should be visible
        // since it only shows when status == Taken
        expect(find.text('Actual Time'), findsOneWidget);
        // Snooze Duration and Skip Reason should NOT be visible
        expect(find.text('Snooze Duration'), findsNothing);
        expect(find.text('Skip Reason'), findsNothing);
      });

      testWidgets('renders Actual Time when Taken is selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Actual Time'), findsOneWidget);
      });

      testWidgets('renders Notes field with placeholder', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.text('Any additional notes'), findsOneWidget);
      });

      testWidgets('uses ShadowTextField for text inputs', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.byType(ShadowTextField), findsWidgets);
      });

      testWidgets('uses ShadowButton for action buttons', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.byType(ShadowButton), findsWidgets);
      });

      testWidgets('uses Form widget', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('populates notes from existing intake log', (tester) async {
        final log = createTestIntakeLog(note: 'Took with breakfast');
        await tester.pumpWidget(buildScreen(intakeLog: log));
        await tester.pumpAndSettle();

        expect(find.text('Took with breakfast'), findsOneWidget);
      });
    });

    group('conditional fields', () {
      testWidgets('Actual Time visible when Taken selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Default is Taken
        expect(find.text('Actual Time'), findsOneWidget);
      });

      testWidgets('Actual Time hidden when Skipped selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Skipped segment
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        expect(find.text('Actual Time'), findsNothing);
      });

      testWidgets('Actual Time hidden when Snoozed selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Snoozed segment
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        expect(find.text('Actual Time'), findsNothing);
      });

      testWidgets('Snooze Duration visible when Snoozed selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Snoozed segment
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        expect(find.text('Snooze Duration'), findsOneWidget);
      });

      testWidgets('Snooze Duration hidden when Taken selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Default is Taken
        expect(find.text('Snooze Duration'), findsNothing);
      });

      testWidgets('Snooze Duration defaults to 15 min', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Snoozed segment
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        expect(find.text('15 min'), findsOneWidget);
      });

      testWidgets('Snooze Duration dropdown shows all options', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Snoozed segment
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        // Open dropdown
        await tester.tap(find.text('15 min'));
        await tester.pumpAndSettle();

        expect(find.text('5 min'), findsOneWidget);
        expect(find.text('10 min'), findsOneWidget);
        expect(find.text('15 min'), findsWidgets); // selected + dropdown item
        expect(find.text('30 min'), findsOneWidget);
        expect(find.text('60 min'), findsOneWidget);
      });

      testWidgets('Skip Reason visible when Skipped selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Skipped segment
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        expect(find.text('Skip Reason'), findsOneWidget);
      });

      testWidgets('Skip Reason hidden when Taken selected', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Default is Taken
        expect(find.text('Skip Reason'), findsNothing);
      });

      testWidgets('Skip Reason has correct placeholder', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Skipped segment
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        expect(find.text('Select reason'), findsOneWidget);
      });

      testWidgets('Skip Reason dropdown shows all options', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Skipped segment
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        // Open dropdown
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();

        expect(find.text('Forgot'), findsOneWidget);
        expect(find.text('Side Effects'), findsOneWidget);
        expect(find.text('Out of Stock'), findsOneWidget);
        expect(find.text('Other'), findsOneWidget);
      });

      testWidgets('Custom Reason visible when Skip Reason is Other', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Skipped segment
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        // Initially no Custom Reason
        expect(find.text('Custom Reason'), findsNothing);

        // Open dropdown and select Other
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        // Custom Reason should now be visible
        expect(find.text('Custom Reason'), findsOneWidget);
      });

      testWidgets('Custom Reason hidden when Skip Reason is not Other', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Tap Skipped segment
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        // Select Other
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        expect(find.text('Custom Reason'), findsOneWidget);

        // Switch to Forgot
        await tester.tap(find.text('Other'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Forgot').last);
        await tester.pumpAndSettle();

        expect(find.text('Custom Reason'), findsNothing);
      });

      testWidgets('Custom Reason has correct placeholder', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Navigate to Custom Reason field
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        expect(find.text('Describe reason'), findsOneWidget);
      });

      testWidgets('switching status clears other sections', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Go to Skipped, verify Skip Reason visible
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();
        expect(find.text('Skip Reason'), findsOneWidget);

        // Switch to Snoozed, verify Snooze Duration visible and Skip Reason gone
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();
        expect(find.text('Snooze Duration'), findsOneWidget);
        expect(find.text('Skip Reason'), findsNothing);

        // Switch to Taken, verify Actual Time visible and Snooze Duration gone
        await tester.tap(find.text('Taken'));
        await tester.pumpAndSettle();
        expect(find.text('Actual Time'), findsOneWidget);
        expect(find.text('Snooze Duration'), findsNothing);
      });
    });

    group('validation', () {
      testWidgets(
        'shows error when Custom Reason is empty and Other is selected',
        (tester) async {
          await tester.pumpWidget(buildScreen());
          await tester.pumpAndSettle();

          // Select Skipped -> Other
          await tester.tap(find.text('Skipped'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Skip Reason'));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Other').last);
          await tester.pumpAndSettle();

          // Tap Save without entering custom reason
          await scrollToBottom(tester);
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();

          expect(
            find.text('Custom reason is required when Other is selected'),
            findsOneWidget,
          );
        },
      );

      testWidgets('no validation error when Taken status and save', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Default is Taken, just save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Should succeed (show success snackbar)
        expect(find.text('Intake logged successfully'), findsOneWidget);
      });

      testWidgets('clears validation error when valid input entered', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Select Skipped -> Other
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        // Trigger validation error
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.text('Custom reason is required when Other is selected'),
          findsOneWidget,
        );

        // Enter valid custom reason
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Custom skip reason, required if other selected',
            ),
            matching: find.byType(TextField),
          ),
          'Stomach upset',
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Custom reason is required when Other is selected'),
          findsNothing,
        );
      });
    });

    group('accessibility', () {
      testWidgets('body has semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Log supplement intake form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('status segment has correct semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Intake status, required, taken skipped or snoozed',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('actual time has correct semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Time taken, required if taken',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('snooze duration has correct semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Switch to Snoozed to make it visible
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Snooze duration, required if snoozed',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('skip reason has correct semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Switch to Skipped to make it visible
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Skip reason, optional, select reason',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('custom reason has correct semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Switch to Skipped -> Other to make it visible
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Custom skip reason, required if other selected',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('notes field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Supplement notes, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        // Status and Notes headers
        expect(headerFinder, findsAtLeastNWidgets(2));
      });
    });

    group('dirty form and cancel', () {
      testWidgets('cancel pops without dialog when form is clean', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              intakeLogListProvider(
                testProfileId,
              ).overrideWith(() => _MockIntakeLogList([createTestIntakeLog()])),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) => IntakeLogScreen(
                            profileId: testProfileId,
                            intakeLog: createTestIntakeLog(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Go'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to intake log screen
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        expect(find.text('Log Supplement Intake'), findsOneWidget);

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should have popped back
        expect(find.text('Log Supplement Intake'), findsNothing);
        expect(find.text('Go'), findsOneWidget);
      });

      testWidgets('cancel shows discard dialog when form is dirty', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Make the form dirty by entering text in notes
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement notes, optional',
            ),
            matching: find.byType(TextField),
          ),
          'Some notes',
        );
        await tester.pumpAndSettle();

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should show discard confirmation dialog
        expect(find.text('Discard Changes?'), findsOneWidget);
        expect(
          find.text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
          findsOneWidget,
        );
      });

      testWidgets('Keep Editing dismisses discard dialog', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Make form dirty
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement notes, optional',
            ),
            matching: find.byType(TextField),
          ),
          'Some notes',
        );
        await tester.pumpAndSettle();

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Tap Keep Editing
        await tester.tap(find.text('Keep Editing'));
        await tester.pumpAndSettle();

        // Should still be on screen
        expect(find.text('Log Supplement Intake'), findsOneWidget);
        expect(find.text('Discard Changes?'), findsNothing);
      });
    });

    group('save success', () {
      testWidgets('shows success snackbar on save with Taken status', (
        tester,
      ) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();

        // Default is Taken, tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(find.text('Intake logged successfully'), findsOneWidget);
      });

      testWidgets('calls markTaken when Taken status selected', (tester) async {
        final mockList = _MockIntakeLogList([createTestIntakeLog()]);
        await tester.pumpWidget(buildScreen(mockFactory: () => mockList));
        await tester.pumpAndSettle();

        // Default is Taken, tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mockList.markTakenCalled, isTrue);
        expect(mockList.markSkippedCalled, isFalse);
        expect(mockList.markSnoozedCalled, isFalse);
      });

      testWidgets('calls markSkipped when Skipped status selected', (
        tester,
      ) async {
        final mockList = _MockIntakeLogList([createTestIntakeLog()]);
        await tester.pumpWidget(buildScreen(mockFactory: () => mockList));
        await tester.pumpAndSettle();

        // Switch to Skipped
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mockList.markSkippedCalled, isTrue);
        expect(mockList.markTakenCalled, isFalse);
        expect(mockList.markSnoozedCalled, isFalse);
      });

      testWidgets('calls markSnoozed when Snoozed status selected', (
        tester,
      ) async {
        final mockList = _MockIntakeLogList([createTestIntakeLog()]);
        await tester.pumpWidget(buildScreen(mockFactory: () => mockList));
        await tester.pumpAndSettle();

        // Switch to Snoozed
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mockList.markSnoozedCalled, isTrue);
        expect(mockList.markTakenCalled, isFalse);
        expect(mockList.markSkippedCalled, isFalse);
      });

      testWidgets('passes skip reason to markSkipped', (tester) async {
        final mockList = _MockIntakeLogList([createTestIntakeLog()]);
        await tester.pumpWidget(buildScreen(mockFactory: () => mockList));
        await tester.pumpAndSettle();

        // Switch to Skipped
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();

        // Select Forgot reason
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Forgot').last);
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mockList.lastSkippedInput?.reason, 'Forgot');
      });

      testWidgets('passes custom reason when Other selected', (tester) async {
        final mockList = _MockIntakeLogList([createTestIntakeLog()]);
        await tester.pumpWidget(buildScreen(mockFactory: () => mockList));
        await tester.pumpAndSettle();

        // Switch to Skipped -> Other
        await tester.tap(find.text('Skipped'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Skip Reason'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        // Enter custom reason
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Custom skip reason, required if other selected',
            ),
            matching: find.byType(TextField),
          ),
          'Stomach upset',
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mockList.lastSkippedInput?.reason, 'Stomach upset');
      });

      testWidgets('passes snooze duration to markSnoozed', (tester) async {
        final mockList = _MockIntakeLogList([createTestIntakeLog()]);
        await tester.pumpWidget(buildScreen(mockFactory: () => mockList));
        await tester.pumpAndSettle();

        // Switch to Snoozed
        await tester.tap(find.text('Snoozed'));
        await tester.pumpAndSettle();

        // Default is 15 min, just save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mockList.lastSnoozedInput?.snoozeDurationMinutes, 15);
      });
    });

    group('save failure', () {
      testWidgets('shows error snackbar on save failure', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              intakeLogListProvider(
                testProfileId,
              ).overrideWith(_ErrorOnSaveIntakeLogList.new),
            ],
            child: MaterialApp(
              home: IntakeLogScreen(
                profileId: testProfileId,
                intakeLog: createTestIntakeLog(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Default is Taken, tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Failed to save intake log'),
          findsOneWidget,
        );
      });
    });
  });
}

/// Mock IntakeLogList notifier for testing.
class _MockIntakeLogList extends IntakeLogList {
  final List<IntakeLog> _logs;

  bool markTakenCalled = false;
  bool markSkippedCalled = false;
  bool markSnoozedCalled = false;

  MarkTakenInput? lastTakenInput;
  MarkSkippedInput? lastSkippedInput;
  MarkSnoozedInput? lastSnoozedInput;

  _MockIntakeLogList(this._logs);

  @override
  Future<List<IntakeLog>> build(String profileId) async => _logs;

  @override
  Future<void> markTaken(MarkTakenInput input) async {
    markTakenCalled = true;
    lastTakenInput = input;
  }

  @override
  Future<void> markSkipped(MarkSkippedInput input) async {
    markSkippedCalled = true;
    lastSkippedInput = input;
  }

  @override
  Future<void> markSnoozed(MarkSnoozedInput input) async {
    markSnoozedCalled = true;
    lastSnoozedInput = input;
  }
}

/// Mock notifier that simulates a failure on all save operations.
class _ErrorOnSaveIntakeLogList extends IntakeLogList {
  @override
  Future<List<IntakeLog>> build(String profileId) async => [];

  @override
  Future<void> markTaken(MarkTakenInput input) async {
    throw Exception('Save failed');
  }

  @override
  Future<void> markSkipped(MarkSkippedInput input) async {
    throw Exception('Save failed');
  }

  @override
  Future<void> markSnoozed(MarkSnoozedInput input) async {
    throw Exception('Save failed');
  }
}
