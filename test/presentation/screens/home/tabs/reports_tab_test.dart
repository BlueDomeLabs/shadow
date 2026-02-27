// test/presentation/screens/home/tabs/reports_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/reports/report_query_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/home/tabs/reports_tab.dart';

// ---------------------------------------------------------------------------
// Fake ReportQueryService for testing
// ---------------------------------------------------------------------------

class _FakeReportQueryService implements ReportQueryService {
  Map<ActivityCategory, int> activityCounts;
  Map<ReferenceCategory, int> referenceCounts;

  _FakeReportQueryService({
    Map<ActivityCategory, int>? activityCounts,
    Map<ReferenceCategory, int>? referenceCounts,
  }) : activityCounts =
           activityCounts ?? {for (final c in ActivityCategory.values) c: 1},
       referenceCounts =
           referenceCounts ?? {for (final c in ReferenceCategory.values) c: 2};

  @override
  Future<Map<ActivityCategory, int>> countActivity({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async => {for (final c in categories) c: activityCounts[c] ?? 0};

  @override
  Future<Map<ReferenceCategory, int>> countReference({
    required String profileId,
    required Set<ReferenceCategory> categories,
  }) async => {for (final c in categories) c: referenceCounts[c] ?? 0};
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget buildTab({
  String profileId = 'test-profile-001',
  String? profileName,
  ReportQueryService? service,
}) => ProviderScope(
  overrides: [
    reportQueryServiceProvider.overrideWithValue(
      service ?? _FakeReportQueryService(),
    ),
  ],
  child: MaterialApp(
    home: ReportsTab(profileId: profileId, profileName: profileName),
  ),
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ReportsTab', () {
    // -----------------------------------------------------------------------
    // App bar
    // -----------------------------------------------------------------------

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Reports'), findsOneWidget);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Reports"), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Report type cards
    // -----------------------------------------------------------------------

    testWidgets('renders Activity Report card', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Activity Report'), findsOneWidget);
    });

    testWidgets('renders Reference Report card', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Reference Report'), findsOneWidget);
    });

    testWidgets('both Configure buttons are present', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Configure'), findsNWidgets(2));
    });

    // -----------------------------------------------------------------------
    // Activity Report bottom sheet
    // -----------------------------------------------------------------------

    testWidgets('tapping Activity Configure opens bottom sheet', (
      tester,
    ) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      // Tap the first Configure button (Activity Report card comes first)
      final configureButtons = find.text('Configure');
      await tester.tap(configureButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Activity Report'), findsWidgets);
      // Sheet has category checkboxes
      expect(find.text('Food Logs'), findsOneWidget);
    });

    testWidgets('activity sheet shows all 8 category checkboxes', (
      tester,
    ) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      expect(find.text('Food Logs'), findsOneWidget);
      expect(find.text('Supplement Intake'), findsOneWidget);
      expect(find.text('Fluids'), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Condition Check-ins'), findsOneWidget);
      expect(find.text('Flare-Ups'), findsOneWidget);
      expect(find.text('Journal Entries'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
    });

    testWidgets('activity sheet export button is disabled', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      final exportBtn = tester.widget<FilledButton>(
        find.byKey(const Key('activity-export-btn')),
      );
      expect(exportBtn.onPressed, isNull);
    });

    testWidgets('Select All selects all categories', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      // Uncheck one category first
      await tester.tap(find.text('Food Logs'));
      await tester.pump();

      // Then tap Select All
      await tester.tap(find.text('Select All'));
      await tester.pump();

      // All checkboxes should be checked — find all CheckboxListTile
      final checkboxes = tester
          .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
          .toList();
      expect(checkboxes.every((c) => c.value ?? false), isTrue);
    });

    testWidgets('Clear All unchecks all categories', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear All'));
      await tester.pump();

      final checkboxes = tester
          .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
          .toList();
      expect(checkboxes.every((c) => !(c.value ?? false)), isTrue);
    });

    testWidgets('Preview button calls service and shows counts', (
      tester,
    ) async {
      final service = _FakeReportQueryService(
        activityCounts: {ActivityCategory.foodLogs: 42},
      );
      await tester.pumpWidget(buildTab(service: service));
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('activity-preview-btn')));
      await tester.pumpAndSettle();

      // Count results should appear
      expect(find.textContaining('record'), findsWidgets);
    });

    // -----------------------------------------------------------------------
    // Reference Report bottom sheet
    // -----------------------------------------------------------------------

    testWidgets('tapping Reference Configure opens reference sheet', (
      tester,
    ) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      // Second Configure button = Reference Report
      final configureButtons = find.text('Configure');
      await tester.tap(configureButtons.last);
      await tester.pumpAndSettle();

      expect(find.text('Reference Report'), findsWidgets);
      expect(find.text('Food Library'), findsOneWidget);
      expect(find.text('Supplement Library'), findsOneWidget);
      expect(find.text('Conditions'), findsOneWidget);
    });

    testWidgets('reference sheet export button is disabled', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').last);
      await tester.pumpAndSettle();

      final exportBtn = tester.widget<FilledButton>(
        find.byKey(const Key('reference-export-btn')),
      );
      expect(exportBtn.onPressed, isNull);
    });

    testWidgets('reference Preview shows counts', (tester) async {
      final service = _FakeReportQueryService(
        referenceCounts: {ReferenceCategory.foodLibrary: 15},
      );
      await tester.pumpWidget(buildTab(service: service));
      await tester.pump();

      await tester.tap(find.text('Configure').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('reference-preview-btn')));
      await tester.pumpAndSettle();

      expect(find.textContaining('record'), findsWidgets);
    });
  });
}
