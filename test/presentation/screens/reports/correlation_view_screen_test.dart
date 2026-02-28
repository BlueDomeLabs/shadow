// test/presentation/screens/reports/correlation_view_screen_test.dart
// Widget tests for CorrelationViewScreen and Reports tab Correlation card — Phase 29.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/reports/report_data_service.dart';
import 'package:shadow_app/domain/reports/report_export_service.dart';
import 'package:shadow_app/domain/reports/report_query_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/screens/home/tabs/reports_tab.dart';
import 'package:shadow_app/presentation/screens/reports/correlation_view_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
// Test constants
// ════════════════════════════════════════════════════════════════════════════

const _profileId = 'test-profile-001';
const _areaId = 'area-001';

// Photo timestamp: arbitrary reference time.
final _photoTs = DateTime(2024, 6, 15, 14, 30).millisecondsSinceEpoch;

// ════════════════════════════════════════════════════════════════════════════
// Factory helpers
// ════════════════════════════════════════════════════════════════════════════

final _syncMeta = SyncMetadata.empty();

PhotoEntry _makePhoto({
  String id = 'photo-001',
  int? timestamp,
  String filePath = '/tmp/test_photo.jpg',
  String? notes,
}) => PhotoEntry(
  id: id,
  clientId: id,
  profileId: _profileId,
  photoAreaId: _areaId,
  timestamp: timestamp ?? _photoTs,
  filePath: filePath,
  notes: notes,
  syncMetadata: _syncMeta,
);

PhotoArea _makeArea({String id = _areaId, String name = 'Left Arm'}) =>
    PhotoArea(
      id: id,
      clientId: id,
      profileId: _profileId,
      name: name,
      syncMetadata: _syncMeta,
    );

FoodLog _makeFoodLog({required String id, required int timestamp}) => FoodLog(
  id: id,
  clientId: id,
  profileId: _profileId,
  timestamp: timestamp,
  syncMetadata: _syncMeta,
);

// ════════════════════════════════════════════════════════════════════════════
// Fake providers
// ════════════════════════════════════════════════════════════════════════════

class _FakePhotoAreaList extends PhotoAreaList {
  final List<PhotoArea> _areas;

  _FakePhotoAreaList({List<PhotoArea>? areas}) : _areas = areas ?? [];

  @override
  Future<List<PhotoArea>> build(String profileId) async => _areas;
}

// Minimal fake report services for ReportsTab (avoids UnimplementedError).
class _FakeReportQueryService implements ReportQueryService {
  @override
  Future<Map<ActivityCategory, int>> countActivity({
    required String profileId,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async => {for (final c in categories) c: 0};

  @override
  Future<Map<ReferenceCategory, int>> countReference({
    required String profileId,
    required Set<ReferenceCategory> categories,
  }) async => {for (final c in categories) c: 0};
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

class _FakeReportExportService implements ReportExportService {
  @override
  Future<File> exportActivityPdf({
    required String profileId,
    required String profileName,
    required List<ReportRow> rows,
    required Set<ActivityCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async => File('test_activity.pdf');

  @override
  Future<File> exportActivityCsv({
    required String profileId,
    required List<ReportRow> rows,
  }) async => File('test_activity.csv');

  @override
  Future<File> exportReferencePdf({
    required String profileId,
    required String profileName,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async => File('test_reference.pdf');

  @override
  Future<File> exportReferenceCsv({
    required String profileId,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async => File('test_reference.csv');
}

// ════════════════════════════════════════════════════════════════════════════
// Widget builders
// ════════════════════════════════════════════════════════════════════════════

Widget _buildScreen({CorrelationData? data, List<PhotoArea>? areas}) {
  final correlationData =
      data ??
      const CorrelationData(
        photos: [],
        foodLogs: [],
        intakeLogs: [],
        fluidsEntries: [],
        sleepEntries: [],
        conditionLogs: [],
        flareUps: [],
        journalEntries: [],
      );

  return ProviderScope(
    overrides: [
      correlationDataProvider.overrideWith((ref, _) async => correlationData),
      photoAreaListProvider(
        _profileId,
      ).overrideWith(() => _FakePhotoAreaList(areas: areas ?? [_makeArea()])),
    ],
    child: const MaterialApp(
      home: CorrelationViewScreen(profileId: _profileId),
    ),
  );
}

Widget _buildReportsTab() => ProviderScope(
  overrides: [
    reportQueryServiceProvider.overrideWithValue(_FakeReportQueryService()),
    reportDataServiceProvider.overrideWithValue(_FakeReportDataService()),
    reportExportServiceProvider.overrideWithValue(_FakeReportExportService()),
    correlationDataProvider.overrideWith(
      (ref, _) async => const CorrelationData(
        photos: [],
        foodLogs: [],
        intakeLogs: [],
        fluidsEntries: [],
        sleepEntries: [],
        conditionLogs: [],
        flareUps: [],
        journalEntries: [],
      ),
    ),
    photoAreaListProvider(_profileId).overrideWith(_FakePhotoAreaList.new),
  ],
  child: const MaterialApp(home: ReportsTab(profileId: _profileId)),
);

// ════════════════════════════════════════════════════════════════════════════
// Tests
// ════════════════════════════════════════════════════════════════════════════

void main() {
  group('CorrelationViewScreen', () {
    // -----------------------------------------------------------------------
    // Empty state
    // -----------------------------------------------------------------------

    testWidgets('empty state renders when no photos in range', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('No photos in this date range'), findsOneWidget);
      expect(
        find.text('Add photos in the Tracking tab to see correlations.'),
        findsOneWidget,
      );
    });

    // -----------------------------------------------------------------------
    // Photo card
    // -----------------------------------------------------------------------

    testWidgets('photo card renders with metadata and event window header', (
      tester,
    ) async {
      final photo = _makePhoto();
      final data = CorrelationData(
        photos: [photo],
        foodLogs: const [],
        intakeLogs: const [],
        fluidsEntries: const [],
        sleepEntries: const [],
        conditionLogs: const [],
        flareUps: const [],
        journalEntries: const [],
      );

      await tester.pumpWidget(_buildScreen(data: data));
      await tester.pumpAndSettle();

      // Event window header is always present for a photo card.
      expect(find.text('±48h window'), findsOneWidget);

      // No events → empty window message.
      expect(
        find.text('No selected events in ±48 hour window'),
        findsOneWidget,
      );
    });

    // -----------------------------------------------------------------------
    // Relative time formatting
    // -----------------------------------------------------------------------

    testWidgets("events show '3h before', 'at same time', '6h after'", (
      tester,
    ) async {
      final photo = _makePhoto(timestamp: _photoTs);

      // Three food logs: 3h before, at same time, 6h after.
      final foodBefore = _makeFoodLog(
        id: 'food-1',
        timestamp: _photoTs - 3 * 3600000,
      );
      final foodSame = _makeFoodLog(id: 'food-2', timestamp: _photoTs);
      final foodAfter = _makeFoodLog(
        id: 'food-3',
        timestamp: _photoTs + 6 * 3600000,
      );

      final data = CorrelationData(
        photos: [photo],
        foodLogs: [foodBefore, foodSame, foodAfter],
        intakeLogs: const [],
        fluidsEntries: const [],
        sleepEntries: const [],
        conditionLogs: const [],
        flareUps: const [],
        journalEntries: const [],
      );

      await tester.pumpWidget(_buildScreen(data: data));
      await tester.pumpAndSettle();

      expect(find.text('3h before'), findsOneWidget);
      expect(find.text('at same time'), findsOneWidget);
      expect(find.text('6h after'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Filter sheet
    // -----------------------------------------------------------------------

    testWidgets('filter sheet opens on tune icon tap', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('Event Categories'), findsOneWidget);
    });

    testWidgets('category chips are all selected by default', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      // Open filter sheet.
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // All category labels should be present as FilterChips.
      for (final cat in CorrelationCategory.values) {
        final chip = tester.widget<FilterChip>(
          find.ancestor(
            of: find.text(cat.label),
            matching: find.byType(FilterChip),
          ),
        );
        expect(
          chip.selected,
          isTrue,
          reason: '${cat.label} should be selected',
        );
      }
    });

    testWidgets('deselecting a category removes its events from all cards', (
      tester,
    ) async {
      final photo = _makePhoto();
      final foodLog = _makeFoodLog(id: 'food-1', timestamp: _photoTs);
      final data = CorrelationData(
        photos: [photo],
        foodLogs: [foodLog],
        intakeLogs: const [],
        fluidsEntries: const [],
        sleepEntries: const [],
        conditionLogs: const [],
        flareUps: const [],
        journalEntries: const [],
      );

      await tester.pumpWidget(_buildScreen(data: data));
      await tester.pumpAndSettle();

      // Food event is visible ('meal: 0 item(s)').
      expect(find.textContaining('meal:'), findsOneWidget);

      // Open filter sheet.
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();

      // Deselect Food category.
      final foodChip = find.ancestor(
        of: find.text('Food'),
        matching: find.byType(FilterChip),
      );
      await tester.tap(foodChip);
      await tester.pumpAndSettle();

      // Tap Apply.
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Food event is no longer visible.
      expect(find.textContaining('meal:'), findsNothing);
    });
  });

  // ════════════════════════════════════════════════════════════════════════════
  // Reports tab
  // ════════════════════════════════════════════════════════════════════════════

  group('ReportsTab — Correlation View card', () {
    testWidgets('Correlation View card present as fifth card', (tester) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pumpAndSettle();

      // Scroll until the 5th card is visible.
      await tester.scrollUntilVisible(find.text('Correlation View'), 200);

      expect(find.text('Correlation View'), findsOneWidget);
      expect(
        find.text(
          'See photos alongside surrounding health events '
          'to identify triggers and patterns.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      "'View Correlations' button navigates to CorrelationViewScreen",
      (tester) async {
        await tester.pumpWidget(_buildReportsTab());
        await tester.pumpAndSettle();

        // ListView is lazy: scroll until item is built into the tree, then
        // use ensureVisible to align it fully within the viewport.
        await tester.scrollUntilVisible(find.text('View Correlations'), 200);
        await tester.pump();
        await tester.ensureVisible(find.text('View Correlations'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('View Correlations'));
        await tester.pumpAndSettle();

        expect(find.byType(CorrelationViewScreen), findsOneWidget);
      },
    );
  });
}
