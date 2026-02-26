// test/presentation/screens/conditions/flare_up_list_screen_test.dart
// Tests for FlareUpListScreen per Phase 18b spec.
// Follows condition_list_screen_test.dart reference pattern.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/providers/flare_ups/flare_up_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/flare_up_list_screen.dart';
import 'package:shadow_app/presentation/screens/conditions/report_flare_up_screen.dart';

void main() {
  group('FlareUpListScreen', () {
    const testProfileId = 'profile-001';
    const testConditionId = 'cond-001';
    const testConditionName = 'Eczema';

    // Jan 15 2025, noon UTC — avoids date shifting in western timezones
    const testStartDate = 1736942400000;

    FlareUp createTestFlareUp({
      String id = 'flare-001',
      String conditionId = testConditionId,
      int startDate = testStartDate,
      int? endDate,
      int severity = 5,
      String? notes,
      List<String> triggers = const [],
    }) => FlareUp(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      conditionId: conditionId,
      startDate: startDate,
      endDate: endDate,
      severity: severity,
      notes: notes,
      triggers: triggers,
      syncMetadata: SyncMetadata.empty(),
    );

    Condition createTestCondition({
      String id = testConditionId,
      String name = testConditionName,
    }) => Condition(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      category: 'Skin',
      bodyLocations: const [],
      startTimeframe: testStartDate,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen() => ProviderScope(
      overrides: [
        flareUpListProvider(
          testProfileId,
        ).overrideWith(() => _MockFlareUpList([])),
        conditionListProvider(
          testProfileId,
        ).overrideWith(() => _MockConditionList([])),
      ],
      child: const MaterialApp(
        home: FlareUpListScreen(profileId: testProfileId),
      ),
    );

    // ── App Bar ─────────────────────────────────────────────────────────────

    testWidgets('renders app bar with title Flare-Ups', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Flare-Ups'), findsOneWidget);
    });

    // ── FAB ─────────────────────────────────────────────────────────────────

    testWidgets('renders FAB for reporting flare-up', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('FAB has semantic label Report flare-up', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Report flare-up'), findsOneWidget);
    });

    // ── Empty State ──────────────────────────────────────────────────────────

    testWidgets('renders empty state message when no flare-ups', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('No flare-ups recorded'), findsOneWidget);
    });

    testWidgets('renders empty state subtext when no flare-ups', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Tap + to report a flare-up'), findsOneWidget);
    });

    testWidgets('renders warning icon in empty state', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    // ── List Items ───────────────────────────────────────────────────────────

    testWidgets('renders condition name on flare-up card', (tester) async {
      final flareUp = createTestFlareUp();
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(testConditionName), findsOneWidget);
    });

    testWidgets('renders formatted start date on card', (tester) async {
      final flareUp = createTestFlareUp();
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Jan 15, 2025
      expect(find.text('Jan 15, 2025'), findsOneWidget);
    });

    testWidgets('renders severity number on badge', (tester) async {
      final flareUp = createTestFlareUp(severity: 7);
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('renders ONGOING chip when endDate is null', (tester) async {
      final flareUp = createTestFlareUp();
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('ONGOING'), findsOneWidget);
    });

    testWidgets('does not render ONGOING chip when endDate is set', (
      tester,
    ) async {
      final flareUp = createTestFlareUp(
        endDate: testStartDate + 3600000, // 1 hour later
      );
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('ONGOING'), findsNothing);
    });

    testWidgets('falls back to Unknown Condition when conditionId not found', (
      tester,
    ) async {
      final flareUp = createTestFlareUp(conditionId: 'missing-id');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Unknown Condition'), findsOneWidget);
    });

    // ── Loading State ────────────────────────────────────────────────────────

    testWidgets('renders loading indicator while loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(_LoadingFlareUpList.new),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pump(); // one frame — still loading
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    // ── Error State ──────────────────────────────────────────────────────────

    testWidgets('renders error message and retry button on error', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(_ErrorFlareUpList.new),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Failed to load flare-ups'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    // ── Navigation ───────────────────────────────────────────────────────────

    testWidgets('tapping FAB opens ReportFlareUpScreen sheet', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Report Flare-Up'), findsOneWidget);
    });

    testWidgets('tapping flare-up card opens edit sheet', (tester) async {
      final flareUp = createTestFlareUp(severity: 3);
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(testConditionName));
      await tester.pumpAndSettle();

      expect(find.byType(ReportFlareUpScreen), findsOneWidget);
    });

    testWidgets('edit sheet opens with editingFlareUp set', (tester) async {
      final flareUp = createTestFlareUp(severity: 8, notes: 'very bad');
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flareUpListProvider(
              testProfileId,
            ).overrideWith(() => _MockFlareUpList([flareUp])),
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: FlareUpListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(testConditionName));
      await tester.pumpAndSettle();

      // Edit mode: title should say "Edit Flare-Up"
      expect(find.text('Edit Flare-Up'), findsOneWidget);
    });

    // ── Accessibility ─────────────────────────────────────────────────────────

    testWidgets('flare-up list body has semantic label', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Flare-up list',
      );
      expect(semanticsFinder, findsOneWidget);
    });
  });
}

// ── Mock Notifiers ────────────────────────────────────────────────────────────

class _MockFlareUpList extends FlareUpList {
  final List<FlareUp> _items;
  _MockFlareUpList(this._items);
  @override
  Future<List<FlareUp>> build(String profileId) async => _items;
}

class _LoadingFlareUpList extends FlareUpList {
  @override
  Future<List<FlareUp>> build(String profileId) async {
    // Never completes — keeps the provider in loading state.
    // Uses Completer to avoid creating a pending timer.
    await Completer<void>().future;
    return [];
  }
}

class _ErrorFlareUpList extends FlareUpList {
  @override
  Future<List<FlareUp>> build(String profileId) async {
    throw Exception('Load failed');
  }
}

class _MockConditionList extends ConditionList {
  final List<Condition> _conditions;
  _MockConditionList(this._conditions);
  @override
  Future<List<Condition>> build(String profileId) async => _conditions;
}
