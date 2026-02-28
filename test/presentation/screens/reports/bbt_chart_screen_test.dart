// test/presentation/screens/reports/bbt_chart_screen_test.dart
// Widget tests for BBTChartScreen and Reports tab BBT card — Phase 26.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';
import 'package:shadow_app/domain/reports/report_data_service.dart';
import 'package:shadow_app/domain/reports/report_export_service.dart';
import 'package:shadow_app/domain/reports/report_query_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';
import 'package:shadow_app/presentation/screens/diet/diet_dashboard_screen.dart';
import 'package:shadow_app/presentation/screens/home/tabs/reports_tab.dart';
import 'package:shadow_app/presentation/screens/reports/bbt_chart_screen.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

final _syncMeta = SyncMetadata.empty();
const _profileId = 'test-profile-001';

FluidsEntry _makeEntry({
  required int entryDate,
  double? basalBodyTemperature,
  MenstruationFlow? menstruationFlow,
}) => FluidsEntry(
  id: 'fe-$entryDate',
  clientId: '',
  profileId: _profileId,
  entryDate: entryDate,
  basalBodyTemperature: basalBodyTemperature,
  menstruationFlow: menstruationFlow,
  syncMetadata: _syncMeta,
);

class _FakeUserSettingsNotifier extends UserSettingsNotifier {
  final UserSettings _settings;

  _FakeUserSettingsNotifier({UserSettings? settings})
    : _settings = settings ?? UserSettings.defaults;

  @override
  Future<UserSettings> build() async => _settings;
}

class _FakeFluidsEntryList extends FluidsEntryList {
  final List<FluidsEntry> _entries;

  _FakeFluidsEntryList({List<FluidsEntry>? entries}) : _entries = entries ?? [];

  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async => _entries;
}

class _LoadingFluidsEntryList extends FluidsEntryList {
  // Completer never completes so the provider stays in loading state forever
  // (no timers created, so the test framework won't complain).
  final _completer = Completer<List<FluidsEntry>>();

  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) => _completer.future;
}

// ---------------------------------------------------------------------------
// Fake services for ReportsTab (to avoid unimplemented provider throws)
// ---------------------------------------------------------------------------

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
  }) async => File('fake_activity.pdf');

  @override
  Future<File> exportActivityCsv({
    required String profileId,
    required List<ReportRow> rows,
  }) async => File('fake_activity.csv');

  @override
  Future<File> exportReferencePdf({
    required String profileId,
    required String profileName,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async => File('fake_reference.pdf');

  @override
  Future<File> exportReferenceCsv({
    required String profileId,
    required Map<ReferenceCategory, List<ReportRow>> data,
  }) async => File('fake_reference.csv');
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

// Compute the same default date range that BBTChartScreen.initState uses.
// Normalized to day boundaries to match the provider key.
DateTimeRange _defaultDateRange() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return DateTimeRange(
    start: today.subtract(const Duration(days: 30)),
    end: today.add(const Duration(days: 1)),
  );
}

Widget _buildBBTScreen({
  List<FluidsEntry>? entries,
  UserSettings? settings,
  bool loading = false,
}) {
  final range = _defaultDateRange();
  final startMs = range.start.millisecondsSinceEpoch;
  final endMs = range.end.millisecondsSinceEpoch;

  return ProviderScope(
    overrides: [
      userSettingsNotifierProvider.overrideWith(
        () => _FakeUserSettingsNotifier(settings: settings),
      ),
      fluidsEntryListProvider(_profileId, startMs, endMs).overrideWith(
        () => loading
            ? _LoadingFluidsEntryList()
            : _FakeFluidsEntryList(entries: entries),
      ),
    ],
    child: const MaterialApp(home: BBTChartScreen(profileId: _profileId)),
  );
}

Widget _buildReportsTab() => ProviderScope(
  overrides: [
    reportQueryServiceProvider.overrideWithValue(_FakeReportQueryService()),
    reportDataServiceProvider.overrideWithValue(_FakeReportDataService()),
    reportExportServiceProvider.overrideWithValue(_FakeReportExportService()),
    userSettingsNotifierProvider.overrideWith(_FakeUserSettingsNotifier.new),
  ],
  child: const MaterialApp(home: ReportsTab(profileId: _profileId)),
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // BBTChartScreen — loading state
  // -------------------------------------------------------------------------

  group('BBTChartScreen — loading state', () {
    testWidgets('shows CircularProgressIndicator while data loads', (
      tester,
    ) async {
      await tester.pumpWidget(_buildBBTScreen(loading: true));
      await tester.pump(); // one frame — data future hasn't resolved

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // BBTChartScreen — empty state
  // -------------------------------------------------------------------------

  group('BBTChartScreen — empty state', () {
    testWidgets('shows empty message when entries have no BBT data', (
      tester,
    ) async {
      final entries = [
        _makeEntry(entryDate: DateTime(2025).millisecondsSinceEpoch),
      ];
      await tester.pumpWidget(_buildBBTScreen(entries: entries));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No BBT data recorded yet. Add BBT readings in the Fluids tab.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows empty message when entries list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(_buildBBTScreen(entries: []));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No BBT data recorded yet. Add BBT readings in the Fluids tab.',
        ),
        findsOneWidget,
      );
    });
  });

  // -------------------------------------------------------------------------
  // BBTChartScreen — data present
  // -------------------------------------------------------------------------

  group('BBTChartScreen — data present', () {
    testWidgets('shows stats row with Avg / Min / Max / Readings labels', (
      tester,
    ) async {
      final entries = [
        _makeEntry(
          entryDate: DateTime(2025).millisecondsSinceEpoch,
          basalBodyTemperature: 98.2,
        ),
        _makeEntry(
          entryDate: DateTime(2025, 1, 2).millisecondsSinceEpoch,
          basalBodyTemperature: 98.6,
        ),
        _makeEntry(
          entryDate: DateTime(2025, 1, 3).millisecondsSinceEpoch,
          basalBodyTemperature: 97.8,
        ),
      ];
      await tester.pumpWidget(_buildBBTScreen(entries: entries));
      await tester.pumpAndSettle();

      expect(find.text('Avg'), findsOneWidget);
      expect(find.text('Min'), findsOneWidget);
      expect(find.text('Max'), findsOneWidget);
      expect(find.text('Readings'), findsOneWidget);
    });

    testWidgets('stats row shows reading count', (tester) async {
      final entries = [
        _makeEntry(
          entryDate: DateTime(2025, 2).millisecondsSinceEpoch,
          basalBodyTemperature: 98,
        ),
        _makeEntry(
          entryDate: DateTime(2025, 2, 2).millisecondsSinceEpoch,
          basalBodyTemperature: 98.4,
        ),
      ];
      await tester.pumpWidget(_buildBBTScreen(entries: entries));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('shows °C unit in stats when Celsius setting is active', (
      tester,
    ) async {
      final celsiusSettings = UserSettings.defaults.copyWith(
        temperatureUnit: TemperatureUnit.celsius,
      );
      final entries = [
        _makeEntry(
          entryDate: DateTime(2025, 3).millisecondsSinceEpoch,
          basalBodyTemperature: 98.6, // 37.0 °C
        ),
      ];
      await tester.pumpWidget(
        _buildBBTScreen(entries: entries, settings: celsiusSettings),
      );
      await tester.pumpAndSettle();

      // °C should appear in the stats row values (at least once).
      expect(find.textContaining('°C'), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // BBTChartScreen — AppBar and navigation
  // -------------------------------------------------------------------------

  group('BBTChartScreen — AppBar', () {
    testWidgets('renders BBT Chart title in AppBar', (tester) async {
      await tester.pumpWidget(_buildBBTScreen(entries: []));
      await tester.pump();

      expect(find.text('BBT Chart'), findsOneWidget);
    });

    testWidgets('prev/next month buttons are present in AppBar', (
      tester,
    ) async {
      await tester.pumpWidget(_buildBBTScreen(entries: []));
      await tester.pump();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('date preset chips are shown', (tester) async {
      await tester.pumpWidget(_buildBBTScreen(entries: []));
      await tester.pumpAndSettle();

      expect(find.text('Last 30 days'), findsOneWidget);
      expect(find.text('Last 90 days'), findsOneWidget);
      expect(find.text('All time'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Reports tab — BBT Chart card
  // -------------------------------------------------------------------------

  group('ReportsTab — BBT Chart card', () {
    testWidgets('renders BBT Chart card', (tester) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pump();

      expect(find.text('BBT Chart'), findsOneWidget);
    });

    testWidgets('"View Chart" button is present on BBT card', (tester) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pump();

      expect(find.text('View Chart'), findsOneWidget);
    });

    testWidgets(
      '"Configure" buttons are still present for Activity and Reference',
      (tester) async {
        await tester.pumpWidget(_buildReportsTab());
        await tester.pump();

        expect(find.text('Configure'), findsNWidgets(2));
      },
    );

    testWidgets('tapping View Chart navigates to BBTChartScreen', (
      tester,
    ) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pump();

      // The BBT Chart card is third in the list and may be off-screen on the
      // default 800x600 test surface. Drag the list down to reveal it.
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pump();

      await tester.tap(find.text('View Chart'));
      // Use pump (not pumpAndSettle) to avoid blocking on provider loading.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(BBTChartScreen), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Reports tab — Diet Adherence card
  // -------------------------------------------------------------------------

  group('ReportsTab — Diet Adherence card', () {
    testWidgets('renders Diet Adherence card', (tester) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pump();

      // Scroll down enough to reveal the fourth card.
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump();

      expect(find.text('Diet Adherence'), findsOneWidget);
    });

    testWidgets('"View Dashboard" button is present on Diet Adherence card', (
      tester,
    ) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump();

      expect(find.text('View Dashboard'), findsOneWidget);
    });

    testWidgets('tapping View Dashboard navigates to DietDashboardScreen', (
      tester,
    ) async {
      await tester.pumpWidget(_buildReportsTab());
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pump();

      await tester.tap(find.text('View Dashboard'));
      // Use pump (not pumpAndSettle) to avoid blocking on provider loading.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(DietDashboardScreen), findsOneWidget);
    });
  });
}
