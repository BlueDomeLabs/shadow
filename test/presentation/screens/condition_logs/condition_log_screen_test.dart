// test/presentation/screens/condition_logs/condition_log_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/condition_logs/condition_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/condition_logs/condition_log_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('ConditionLogScreen', () {
    const testProfileId = 'profile-001';

    /// Scrolls the form ListView down to make bottom widgets visible.
    /// This form is long (7 sections), so we scroll in two steps.
    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pumpAndSettle();
    }

    Condition createTestCondition({
      String id = 'cond-001',
      String name = 'Eczema',
      List<String> triggers = const ['Stress', 'Dairy', 'Pollen'],
    }) => Condition(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      category: 'Skin',
      bodyLocations: const ['Arms', 'Hands'],
      triggers: triggers,
      startTimeframe: 1700000000000,
      syncMetadata: SyncMetadata.empty(),
    );

    ConditionLog createTestConditionLog({
      String id = 'log-001',
      String conditionId = 'cond-001',
      int timestamp = 1700000000000,
      int severity = 7,
      String? notes = 'Flare after eating dairy',
      bool isFlare = true,
      String? triggers = 'Stress,Dairy',
    }) => ConditionLog(
      id: id,
      clientId: 'client-log-001',
      profileId: testProfileId,
      conditionId: conditionId,
      timestamp: timestamp,
      severity: severity,
      notes: notes,
      isFlare: isFlare,
      triggers: triggers,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen({Condition? condition}) {
      final cond = condition ?? createTestCondition();
      return ProviderScope(
        overrides: [
          conditionLogListProvider(
            testProfileId,
            cond.id,
          ).overrideWith(() => _MockConditionLogList([])),
        ],
        child: MaterialApp(
          home: ConditionLogScreen(profileId: testProfileId, condition: cond),
        ),
      );
    }

    Widget buildEditScreen(ConditionLog log, {Condition? condition}) {
      final cond = condition ?? createTestCondition();
      return ProviderScope(
        overrides: [
          conditionLogListProvider(
            testProfileId,
            cond.id,
          ).overrideWith(() => _MockConditionLogList([log])),
        ],
        child: MaterialApp(
          home: ConditionLogScreen(
            profileId: testProfileId,
            condition: cond,
            conditionLog: log,
          ),
        ),
      );
    }

    group('add mode - rendering', () {
      testWidgets('renders Log Condition Entry title', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Log Condition Entry'), findsOneWidget);
      });

      testWidgets('renders all section headers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Date & Time'), findsOneWidget);
        expect(find.text('Severity'), findsOneWidget);
        expect(find.text('Flare Status'), findsOneWidget);
        expect(find.text('Triggers'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Photos'), findsOneWidget);
        expect(find.text('Notes'), findsWidgets);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders date and time picker buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
        expect(find.byIcon(Icons.access_time), findsOneWidget);
      });

      testWidgets('renders notes field with correct placeholder', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Notes about today'), findsOneWidget);
      });

      testWidgets('renders add photos button', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Add photos'), findsOneWidget);
        expect(find.text('Max 5 photos, 5MB each'), findsOneWidget);
      });

      testWidgets('renders trigger chips from condition', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Select triggers'), findsOneWidget);
        expect(find.text('Stress'), findsOneWidget);
        expect(find.text('Dairy'), findsOneWidget);
        expect(find.text('Pollen'), findsOneWidget);
      });

      testWidgets('renders add new trigger field', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Add New Trigger'), findsOneWidget);
        expect(find.text('Add new trigger'), findsOneWidget);
      });

      testWidgets('does not show Select triggers when no triggers defined', (
        tester,
      ) async {
        final condition = createTestCondition(triggers: []);
        await tester.pumpWidget(buildAddScreen(condition: condition));
        await tester.pumpAndSettle();

        expect(find.text('Select triggers'), findsNothing);
      });
    });

    group('add mode - defaults', () {
      testWidgets('severity slider defaults to 5', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Severity: 5'), findsOneWidget);
      });

      testWidgets('flare toggle defaults to off', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final switchTile = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile),
        );
        expect(switchTile.value, isFalse);
      });

      testWidgets('notes field starts empty', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        // Find the Notes ShadowTextField and verify its controller is empty
        final notesField = tester.widget<ShadowTextField>(
          find.byWidgetPredicate(
            (widget) => widget is ShadowTextField && widget.label == 'Notes',
          ),
        );
        expect(notesField.controller?.text, '');
      });

      testWidgets('no triggers selected by default', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // All FilterChips should be unselected
        final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
        for (final chip in chips) {
          expect(chip.selected, isFalse);
        }
      });
    });

    group('severity slider', () {
      testWidgets('severity labels show Minimal, Moderate, Severe', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('1 - Minimal'), findsOneWidget);
        expect(find.text('5 - Moderate'), findsOneWidget);
        expect(find.text('10 - Severe'), findsOneWidget);
      });

      testWidgets('slider renders with correct range', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.min, 1.0);
        expect(slider.max, 10.0);
        expect(slider.divisions, 9);
        expect(slider.value, 5.0);
      });

      testWidgets('displays current severity label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Default severity 5 shows "Moderate"
        expect(find.text('Moderate'), findsOneWidget);
      });
    });

    group('flare toggle', () {
      testWidgets('toggle switches value on tap', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Initially off
        var switchTile = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile),
        );
        expect(switchTile.value, isFalse);

        // Tap the switch
        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        // Should now be on
        switchTile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
        expect(switchTile.value, isTrue);
      });

      testWidgets('renders Is Flare-up label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Is Flare-up'), findsOneWidget);
      });
    });

    group('triggers', () {
      testWidgets('tapping a chip selects it', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap the Stress chip
        await tester.tap(find.text('Stress'));
        await tester.pumpAndSettle();

        // Verify the chip is now selected
        final stressChip = tester.widget<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Stress',
          ),
        );
        expect(stressChip.selected, isTrue);
      });

      testWidgets('tapping a selected chip deselects it', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap the Stress chip to select
        await tester.tap(find.text('Stress'));
        await tester.pumpAndSettle();

        // Tap again to deselect
        await tester.tap(find.text('Stress'));
        await tester.pumpAndSettle();

        final stressChip = tester.widget<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Stress',
          ),
        );
        expect(stressChip.selected, isFalse);
      });

      testWidgets('adding a new trigger creates a chip', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter text for new trigger
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is ShadowTextField &&
                  widget.label == 'Add New Trigger',
            ),
            matching: find.byType(TextField),
          ),
          'Heat',
        );
        await tester.pumpAndSettle();

        // Tap the add button
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // New trigger should appear as a chip and be selected
        expect(find.text('Heat'), findsOneWidget);
        final heatChip = tester.widget<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Heat',
          ),
        );
        expect(heatChip.selected, isTrue);
      });

      testWidgets('adding duplicate trigger selects existing chip', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter existing trigger name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is ShadowTextField &&
                  widget.label == 'Add New Trigger',
            ),
            matching: find.byType(TextField),
          ),
          'Stress',
        );
        await tester.pumpAndSettle();

        // Tap the add button
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Stress chip should be selected but not duplicated
        final stressChips = tester.widgetList<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Stress',
          ),
        );
        expect(stressChips.length, 1);
        expect(stressChips.first.selected, isTrue);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Condition Entry title', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        expect(find.text('Edit Condition Entry'), findsOneWidget);
      });

      testWidgets('populates severity from log', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        expect(find.text('Severity: 7'), findsOneWidget);
      });

      testWidgets('populates flare toggle from log', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        final switchTile = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile),
        );
        expect(switchTile.value, isTrue);
      });

      testWidgets('populates notes from log', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Flare after eating dairy'), findsOneWidget);
      });

      testWidgets('populates triggers from log', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        // Stress and Dairy chips should be selected
        final stressChip = tester.widget<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Stress',
          ),
        );
        expect(stressChip.selected, isTrue);

        final dairyChip = tester.widget<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Dairy',
          ),
        );
        expect(dairyChip.selected, isTrue);

        // Pollen should not be selected
        final pollenChip = tester.widget<FilterChip>(
          find.byWidgetPredicate(
            (widget) =>
                widget is FilterChip && (widget.label as Text).data == 'Pollen',
          ),
        );
        expect(pollenChip.selected, isFalse);
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets(
        'merges log triggers with condition triggers without duplicates',
        (tester) async {
          // Condition has [Stress, Dairy, Pollen]
          // Log has triggers 'Stress,CustomTrigger'
          final log = createTestConditionLog(triggers: 'Stress,CustomTrigger');
          await tester.pumpWidget(buildEditScreen(log));
          await tester.pumpAndSettle();

          // CustomTrigger should appear in available triggers
          expect(find.text('CustomTrigger'), findsOneWidget);
          // Original condition triggers still available
          expect(find.text('Pollen'), findsOneWidget);
          // No duplicates of Stress
          final stressChips = tester.widgetList<FilterChip>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is FilterChip &&
                  (widget.label as Text).data == 'Stress',
            ),
          );
          expect(stressChips.length, 1);
        },
      );
    });

    group('accessibility', () {
      testWidgets('body has semantic label for add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Log condition entry form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('body has semantic label for edit mode', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit condition log form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('severity slider has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Current severity, 1 minimal to 10 severe, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('log date has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Date of this log entry',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('flare toggle has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Currently in flare-up, toggle',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('notes field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Condition log notes, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        // Date & Time, Severity, Flare Status, Triggers visible at top
        expect(headerFinder, findsAtLeastNWidgets(4));
        await scrollToBottom(tester);
        // Photos, Notes headers visible at bottom
        expect(headerFinder, findsAtLeastNWidgets(2));
      });
    });

    group('validation', () {
      testWidgets('save succeeds with valid default values', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap Save with defaults (severity 5, no flare, now date)
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(find.text('Condition log created successfully'), findsOneWidget);
      });
    });

    group('save success', () {
      testWidgets('shows success snackbar on create', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(find.text('Condition log created successfully'), findsOneWidget);
      });

      testWidgets('shows success snackbar on update', (tester) async {
        final log = createTestConditionLog();
        await tester.pumpWidget(buildEditScreen(log));
        await tester.pumpAndSettle();

        // Tap Save Changes
        await scrollToBottom(tester);
        await tester.tap(find.text('Save Changes'));
        await tester.pump();

        expect(find.text('Condition log updated successfully'), findsOneWidget);
      });
    });

    group('save failure', () {
      testWidgets('shows error snackbar on save failure', (tester) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionLogListProvider(
                testProfileId,
                condition.id,
              ).overrideWith(_ErrorOnLogConditionLogList.new),
            ],
            child: MaterialApp(
              home: ConditionLogScreen(
                profileId: testProfileId,
                condition: condition,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.text('Unable to save data. Please try again.'),
          findsOneWidget,
        );
      });
    });

    group('dirty form and cancel', () {
      testWidgets('cancel pops without dialog when form is clean', (
        tester,
      ) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionLogListProvider(
                testProfileId,
                condition.id,
              ).overrideWith(() => _MockConditionLogList([])),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) => ConditionLogScreen(
                            profileId: testProfileId,
                            condition: condition,
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

        // Navigate to log screen
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        expect(find.text('Log Condition Entry'), findsOneWidget);

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should have popped back
        expect(find.text('Log Condition Entry'), findsNothing);
        expect(find.text('Go'), findsOneWidget);
      });

      testWidgets('cancel shows discard dialog when form is dirty', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Make form dirty by toggling flare
        await tester.tap(find.byType(SwitchListTile));
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
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Make form dirty
        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Tap Keep Editing
        await tester.tap(find.text('Keep Editing'));
        await tester.pumpAndSettle();

        // Should still be on log screen
        expect(find.text('Log Condition Entry'), findsOneWidget);
        expect(find.text('Discard Changes?'), findsNothing);
      });
    });

    group('widget types', () {
      testWidgets('uses ShadowTextField for text inputs', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(ShadowTextField), findsWidgets);
      });

      testWidgets('uses ShadowButton for action buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.byType(ShadowButton), findsWidgets);
      });

      testWidgets('uses Slider for severity', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('uses SwitchListTile for flare toggle', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(SwitchListTile), findsOneWidget);
      });

      testWidgets('uses FilterChip for triggers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byType(FilterChip),
          findsNWidgets(3),
        ); // Stress, Dairy, Pollen
      });

      testWidgets('uses Form widget', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });
    });
  });
}

/// Mock ConditionLogList notifier for testing.
class _MockConditionLogList extends ConditionLogList {
  final List<ConditionLog> _logs;

  _MockConditionLogList(this._logs);

  @override
  Future<List<ConditionLog>> build(
    String profileId,
    String conditionId,
  ) async => _logs;

  @override
  Future<void> log(LogConditionInput input) async {
    // Success - no-op for testing
  }

  @override
  Future<void> updateLog(UpdateConditionLogInput input) async {
    // Success - no-op for testing
  }
}

/// Mock notifier that simulates a failure on log.
class _ErrorOnLogConditionLogList extends ConditionLogList {
  @override
  Future<List<ConditionLog>> build(
    String profileId,
    String conditionId,
  ) async => [];

  @override
  Future<void> log(LogConditionInput input) async {
    throw DatabaseError.insertFailed('test');
  }
}
