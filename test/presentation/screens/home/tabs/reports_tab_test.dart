// test/presentation/screens/home/tabs/reports_tab_test.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/reports/report_data_service.dart';
import 'package:shadow_app/domain/reports/report_export_service.dart';
import 'package:shadow_app/domain/reports/report_query_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/home/tabs/reports_tab.dart';

// ---------------------------------------------------------------------------
// Fake services
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

class _FakeReportDataService implements ReportDataService {
  @override
  Future<List<ReportRow>> fetchActivityRows({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async => [];

  @override
  Future<Map<ReferenceCategory, List<ReportRow>>> fetchReferenceRows({
    required String profileId,
    required Set<ReferenceCategory> categories,
  }) async => {};
}

/// Slow data service — uses a completer to pause export for loading tests.
class _SlowReportDataService implements ReportDataService {
  final Completer<List<ReportRow>> _completer = Completer();

  @override
  Future<List<ReportRow>> fetchActivityRows({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) => _completer.future;

  @override
  Future<Map<ReferenceCategory, List<ReportRow>>> fetchReferenceRows({
    required String profileId,
    required Set<ReferenceCategory> categories,
  }) async => {};

  void complete([List<ReportRow>? rows]) => _completer.complete(rows ?? []);
}

class _FakeReportExportService implements ReportExportService {
  // Return File objects without real I/O so async chains complete in
  // microtasks and pumpAndSettle can settle in widget tests.
  @override
  Future<File> exportActivityPdf({
    required String profileId,
    required String profileName,
    required List<ReportRow> rows,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async => File('${Directory.systemTemp.path}/test_activity_report.pdf');

  @override
  Future<File> exportActivityCsv({
    required String profileId,
    required List<ReportRow> rows,
  }) async => File('${Directory.systemTemp.path}/test_activity_report.csv');

  @override
  Future<File> exportReferencePdf({
    required String profileId,
    required String profileName,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async => File('${Directory.systemTemp.path}/test_reference_report.pdf');

  @override
  Future<File> exportReferenceCsv({
    required String profileId,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async => File('${Directory.systemTemp.path}/test_reference_report.csv');
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget buildTab({
  String profileId = 'test-profile-001',
  String? profileName,
  ReportQueryService? queryService,
  ReportDataService? dataService,
  ReportExportService? exportService,
}) => ProviderScope(
  overrides: [
    reportQueryServiceProvider.overrideWithValue(
      queryService ?? _FakeReportQueryService(),
    ),
    reportDataServiceProvider.overrideWithValue(
      dataService ?? _FakeReportDataService(),
    ),
    reportExportServiceProvider.overrideWithValue(
      exportService ?? _FakeReportExportService(),
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

    testWidgets('activity export PDF button is enabled after Preview', (
      tester,
    ) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      // Tap Preview to confirm the sheet is functional
      await tester.tap(find.byKey(const Key('activity-preview-btn')));
      await tester.pumpAndSettle();

      // Export PDF button should be enabled (categories still selected)
      final exportPdfBtn = tester.widget<FilledButton>(
        find.byKey(const Key('activity-export-pdf-btn')),
      );
      expect(exportPdfBtn.onPressed, isNotNull);
    });

    testWidgets('activity export CSV button is enabled after Preview', (
      tester,
    ) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('activity-preview-btn')));
      await tester.pumpAndSettle();

      final exportCsvBtn = tester.widget<FilledButton>(
        find.byKey(const Key('activity-export-csv-btn')),
      );
      expect(exportCsvBtn.onPressed, isNotNull);
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
      await tester.pumpWidget(buildTab(queryService: service));
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('activity-preview-btn')));
      await tester.pumpAndSettle();

      // Count results should appear
      expect(find.textContaining('record'), findsWidgets);
    });

    testWidgets('loading indicator shown during export', (tester) async {
      final dataService = _SlowReportDataService();
      await tester.pumpWidget(buildTab(dataService: dataService));
      await tester.pump();

      await tester.tap(find.text('Configure').first);
      await tester.pumpAndSettle();

      // Tap Export PDF — the data service will not complete immediately
      await tester.tap(find.byKey(const Key('activity-export-pdf-btn')));
      await tester.pump(); // single frame to start loading

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // Let the export complete
      dataService.complete();
      await tester.pumpAndSettle();
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

    testWidgets('reference export PDF button is enabled', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').last);
      await tester.pumpAndSettle();

      final exportPdfBtn = tester.widget<FilledButton>(
        find.byKey(const Key('reference-export-pdf-btn')),
      );
      expect(exportPdfBtn.onPressed, isNotNull);
    });

    testWidgets('reference export CSV button is enabled', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Configure').last);
      await tester.pumpAndSettle();

      final exportCsvBtn = tester.widget<FilledButton>(
        find.byKey(const Key('reference-export-csv-btn')),
      );
      expect(exportCsvBtn.onPressed, isNotNull);
    });

    testWidgets('reference Preview shows counts', (tester) async {
      final service = _FakeReportQueryService(
        referenceCounts: {ReferenceCategory.foodLibrary: 15},
      );
      await tester.pumpWidget(buildTab(queryService: service));
      await tester.pump();

      await tester.tap(find.text('Configure').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('reference-preview-btn')));
      await tester.pumpAndSettle();

      expect(find.textContaining('record'), findsWidgets);
    });
  });
}
