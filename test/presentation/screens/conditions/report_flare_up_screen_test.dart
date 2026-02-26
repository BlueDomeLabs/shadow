// test/presentation/screens/conditions/report_flare_up_screen_test.dart
// Tests for ReportFlareUpScreen per Phase 18b spec.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/usecases/flare_ups/flare_up_inputs.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/providers/flare_ups/flare_up_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/report_flare_up_screen.dart';

void main() {
  group('ReportFlareUpScreen', () {
    const testProfileId = 'profile-001';
    const testConditionId = 'cond-001';
    const testConditionName = 'Eczema';
    const testStartDate = 1736899200000; // Jan 15 2026

    Condition createTestCondition({
      String id = testConditionId,
      String name = testConditionName,
      bool isArchived = false,
    }) => Condition(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      category: 'Skin',
      bodyLocations: const [],
      startTimeframe: testStartDate,
      isArchived: isArchived,
      syncMetadata: SyncMetadata.empty(),
    );

    FlareUp createTestFlareUp({
      String id = 'flare-001',
      int severity = 6,
      String? notes,
      List<String> triggers = const ['stress', 'dairy'],
      int? endDate,
    }) => FlareUp(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      conditionId: testConditionId,
      startDate: testStartDate,
      endDate: endDate,
      severity: severity,
      notes: notes,
      triggers: triggers,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildSheet({
      String? preselectedConditionId,
      FlareUp? editingFlareUp,
      List<Condition>? conditions,
      FlareUpList Function()? flareUpListFactory,
    }) => ProviderScope(
      overrides: [
        conditionListProvider(testProfileId).overrideWith(
          () => _MockConditionList(conditions ?? [createTestCondition()]),
        ),
        flareUpListProvider(
          testProfileId,
        ).overrideWith(flareUpListFactory ?? _NoOpFlareUpList.new),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: ReportFlareUpScreen(
            profileId: testProfileId,
            preselectedConditionId: preselectedConditionId,
            editingFlareUp: editingFlareUp,
          ),
        ),
      ),
    );

    // ── New Mode — Field Presence ─────────────────────────────────────────────

    testWidgets('renders title Report Flare-Up in new mode', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.text('Report Flare-Up'), findsOneWidget);
    });

    testWidgets('renders condition dropdown in new mode', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('condition_dropdown')), findsOneWidget);
    });

    testWidgets('renders severity slider', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('severity_slider')), findsOneWidget);
    });

    testWidgets('renders triggers field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('triggers_field')), findsOneWidget);
    });

    testWidgets('renders notes field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('notes_field')), findsOneWidget);
    });

    testWidgets('renders start date field in new mode', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('start_date_field')), findsOneWidget);
    });

    testWidgets('renders end date field in new mode', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('end_date_field')), findsOneWidget);
    });

    testWidgets('renders save button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('save_button')), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('renders cancel button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders close icon button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('condition dropdown shows active condition', (tester) async {
      await tester.pumpWidget(
        buildSheet(preselectedConditionId: testConditionId),
      );
      await tester.pumpAndSettle();
      expect(find.text(testConditionName), findsWidgets);
    });

    testWidgets('archived conditions excluded from dropdown', (tester) async {
      final archived = createTestCondition(
        id: 'cond-archived',
        name: 'Archived Condition',
        isArchived: true,
      );
      final active = createTestCondition();
      await tester.pumpWidget(buildSheet(conditions: [active, archived]));
      await tester.pumpAndSettle();
      expect(find.text('Archived Condition'), findsNothing);
    });

    // ── New Mode — Validation ─────────────────────────────────────────────────

    testWidgets('shows validation error when no condition selected', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet(conditions: [createTestCondition()]));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('save_button')));
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      expect(find.text('Please select a condition'), findsOneWidget);
    });

    // ── Edit Mode ─────────────────────────────────────────────────────────────

    testWidgets('renders title Edit Flare-Up in edit mode', (tester) async {
      await tester.pumpWidget(buildSheet(editingFlareUp: createTestFlareUp()));
      await tester.pumpAndSettle();
      expect(find.text('Edit Flare-Up'), findsOneWidget);
    });

    testWidgets('edit mode pre-fills severity label', (tester) async {
      final flareUp = createTestFlareUp(severity: 8);
      await tester.pumpWidget(buildSheet(editingFlareUp: flareUp));
      await tester.pumpAndSettle();
      expect(find.text('Severity: 8'), findsOneWidget);
    });

    testWidgets('edit mode pre-fills triggers field', (tester) async {
      final flareUp = createTestFlareUp(triggers: ['stress', 'dairy']);
      await tester.pumpWidget(buildSheet(editingFlareUp: flareUp));
      await tester.pumpAndSettle();
      final field = tester.widget<TextFormField>(
        find.byKey(const Key('triggers_field')),
      );
      expect(field.controller?.text, 'stress, dairy');
    });

    testWidgets('edit mode pre-fills notes field', (tester) async {
      final flareUp = createTestFlareUp(notes: 'Very painful episode');
      await tester.pumpWidget(buildSheet(editingFlareUp: flareUp));
      await tester.pumpAndSettle();
      final field = tester.widget<TextFormField>(
        find.byKey(const Key('notes_field')),
      );
      expect(field.controller?.text, 'Very painful episode');
    });

    testWidgets('edit mode shows condition name as read-only (no dropdown)', (
      tester,
    ) async {
      final flareUp = createTestFlareUp();
      await tester.pumpWidget(buildSheet(editingFlareUp: flareUp));
      await tester.pumpAndSettle();
      // In edit mode condition is shown as read-only — no DropdownButtonFormField
      expect(find.byKey(const Key('condition_dropdown')), findsNothing);
      // The condition label heading is present as a text widget
      expect(find.text('Condition'), findsWidgets);
    });

    testWidgets('edit mode shows start date as read-only (no picker widget)', (
      tester,
    ) async {
      final flareUp = createTestFlareUp();
      await tester.pumpWidget(buildSheet(editingFlareUp: flareUp));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('start_date_field')), findsNothing);
      expect(find.text('Start Date/Time'), findsOneWidget);
    });

    testWidgets('ongoing flare-up shows Ongoing for end date in edit mode', (
      tester,
    ) async {
      final flareUp =
          createTestFlareUp(); // ongoing — endDate is null by default
      await tester.pumpWidget(buildSheet(editingFlareUp: flareUp));
      await tester.pumpAndSettle();
      expect(find.text('Ongoing'), findsOneWidget);
    });

    testWidgets('edit mode save calls updateFlareUp notifier method, not log', (
      tester,
    ) async {
      final flareUp = createTestFlareUp(severity: 4);
      final tracker = _TrackingFlareUpList();
      await tester.pumpWidget(
        buildSheet(
          editingFlareUp: flareUp,
          conditions: [createTestCondition()],
          flareUpListFactory: () => tracker,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('save_button')));
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      expect(tracker.updateCalled, isTrue);
      expect(tracker.logCalled, isFalse);
    });

    testWidgets('new mode save calls log notifier method', (tester) async {
      final tracker = _TrackingFlareUpList();
      await tester.pumpWidget(
        buildSheet(
          conditions: [createTestCondition()],
          preselectedConditionId: testConditionId,
          flareUpListFactory: () => tracker,
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('save_button')));
      await tester.tap(find.byKey(const Key('save_button')));
      await tester.pumpAndSettle();

      expect(tracker.logCalled, isTrue);
      expect(tracker.updateCalled, isFalse);
    });
  });
}

// ── Mock Notifiers ────────────────────────────────────────────────────────────

class _MockConditionList extends ConditionList {
  final List<Condition> _conditions;
  _MockConditionList(this._conditions);
  @override
  Future<List<Condition>> build(String profileId) async => _conditions;
}

class _NoOpFlareUpList extends FlareUpList {
  @override
  Future<List<FlareUp>> build(String profileId) async => [];
}

class _TrackingFlareUpList extends FlareUpList {
  bool logCalled = false;
  bool updateCalled = false;

  @override
  Future<List<FlareUp>> build(String profileId) async => [];

  @override
  Future<void> log(LogFlareUpInput input) async {
    logCalled = true;
  }

  @override
  Future<void> updateFlareUp(UpdateFlareUpInput input) async {
    updateCalled = true;
  }
}
