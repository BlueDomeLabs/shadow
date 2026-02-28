// lib/presentation/screens/reports/bbt_chart_screen.dart
// BBT Chart screen — unit-aware basal body temperature trend with menstruation overlay.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';
import 'package:shadow_app/presentation/widgets/shadow_chart.dart';

// ---------------------------------------------------------------------------
// Pure helper functions (extracted for unit testability)
// ---------------------------------------------------------------------------

/// Converts a BBT value from °F to the display unit.
///
/// BBT is always stored in Fahrenheit. When [useCelsius] is true, applies
/// the standard °F → °C formula: (°F - 32) × 5/9.
double bbtToDisplay(double fahrenheit, {required bool useCelsius}) {
  if (!useCelsius) return fahrenheit;
  return (fahrenheit - 32) * 5 / 9;
}

/// Groups fluids entries that have menstruation data into consecutive
/// [DateTimeRange] objects.
///
/// Entries with [MenstruationFlow.none] or null flow are excluded. Consecutive
/// calendar days are merged into a single range. Non-consecutive days produce
/// separate ranges. Entries are assumed to be unordered and are sorted
/// internally.
List<DateTimeRange> groupMenstruationRanges(List<FluidsEntry> entries) {
  final days =
      entries
          .where(
            (e) =>
                e.menstruationFlow != null &&
                e.menstruationFlow != MenstruationFlow.none,
          )
          .map((e) {
            final d = DateTime.fromMillisecondsSinceEpoch(e.entryDate);
            return DateTime(d.year, d.month, d.day);
          })
          .toSet()
          .toList()
        ..sort();

  if (days.isEmpty) return [];

  final ranges = <DateTimeRange>[];
  var rangeStart = days.first;
  var rangeEnd = days.first;

  for (var i = 1; i < days.length; i++) {
    final expected = rangeEnd.add(const Duration(days: 1));
    if (days[i] == expected) {
      rangeEnd = days[i];
    } else {
      ranges.add(
        DateTimeRange(
          start: rangeStart,
          end: rangeEnd.add(const Duration(days: 1)),
        ),
      );
      rangeStart = days[i];
      rangeEnd = days[i];
    }
  }
  ranges.add(
    DateTimeRange(
      start: rangeStart,
      end: rangeEnd.add(const Duration(days: 1)),
    ),
  );
  return ranges;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

enum _DatePreset { last30, last90, allTime, custom }

/// BBT Chart screen — shows basal body temperature trend with menstruation
/// overlay. Supports °F / °C based on user settings. Date range is
/// user-configurable via preset chips and prev/next month navigation.
class BBTChartScreen extends ConsumerStatefulWidget {
  final String profileId;

  const BBTChartScreen({super.key, required this.profileId});

  @override
  ConsumerState<BBTChartScreen> createState() => _BBTChartScreenState();
}

class _BBTChartScreenState extends ConsumerState<BBTChartScreen> {
  late DateTimeRange _dateRange;
  _DatePreset _preset = _DatePreset.last30;
  bool _showDataTable = false;

  @override
  void initState() {
    super.initState();
    _dateRange = _presetRange(_DatePreset.last30);
  }

  // ---------------------------------------------------------------------------
  // Date range helpers
  // ---------------------------------------------------------------------------

  static DateTimeRange _presetRange(_DatePreset preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case _DatePreset.last30:
        return DateTimeRange(
          start: today.subtract(const Duration(days: 30)),
          end: today.add(const Duration(days: 1)),
        );
      case _DatePreset.last90:
        return DateTimeRange(
          start: today.subtract(const Duration(days: 90)),
          end: today.add(const Duration(days: 1)),
        );
      case _DatePreset.allTime:
        return DateTimeRange(
          start: DateTime(2000),
          end: today.add(const Duration(days: 1)),
        );
      case _DatePreset.custom:
        // Returned only from prev/next month navigation.
        return DateTimeRange(
          start: today.subtract(const Duration(days: 30)),
          end: today.add(const Duration(days: 1)),
        );
    }
  }

  void _setPreset(_DatePreset preset) {
    setState(() {
      _preset = preset;
      _dateRange = _presetRange(preset);
    });
  }

  void _prevMonth() {
    setState(() {
      _preset = _DatePreset.custom;
      _dateRange = DateTimeRange(
        start: DateTime(
          _dateRange.start.year,
          _dateRange.start.month - 1,
          _dateRange.start.day,
        ),
        end: DateTime(
          _dateRange.end.year,
          _dateRange.end.month - 1,
          _dateRange.end.day,
        ),
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _preset = _DatePreset.custom;
      _dateRange = DateTimeRange(
        start: DateTime(
          _dateRange.start.year,
          _dateRange.start.month + 1,
          _dateRange.start.day,
        ),
        end: DateTime(
          _dateRange.end.year,
          _dateRange.end.month + 1,
          _dateRange.end.day,
        ),
      );
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(userSettingsNotifierProvider);
    final useCelsius =
        settingsAsync.valueOrNull?.temperatureUnit == TemperatureUnit.celsius;

    final startMs = _dateRange.start.millisecondsSinceEpoch;
    final endMs = _dateRange.end.millisecondsSinceEpoch;

    final entriesAsync = ref.watch(
      fluidsEntryListProvider(widget.profileId, startMs, endMs),
    );

    final hasData = entriesAsync.valueOrNull?.any((e) => e.hasBBTData) ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BBT Chart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous month',
            onPressed: _prevMonth,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Next month',
            onPressed: _nextMonth,
          ),
          if (hasData)
            IconButton(
              icon: Icon(_showDataTable ? Icons.bar_chart : Icons.table_chart),
              tooltip: _showDataTable ? 'Show chart' : 'Show data table',
              onPressed: () => setState(() => _showDataTable = !_showDataTable),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildPresetChips(),
          Expanded(child: _buildBody(context, useCelsius, entriesAsync)),
        ],
      ),
    );
  }

  Widget _buildPresetChips() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        _chip('Last 30 days', _DatePreset.last30),
        const SizedBox(width: 8),
        _chip('Last 90 days', _DatePreset.last90),
        const SizedBox(width: 8),
        _chip('All time', _DatePreset.allTime),
      ],
    ),
  );

  Widget _chip(String label, _DatePreset preset) => ChoiceChip(
    label: Text(label),
    selected: _preset == preset,
    onSelected: (_) => _setPreset(preset),
  );

  Widget _buildBody(
    BuildContext context,
    bool useCelsius,
    AsyncValue<List<FluidsEntry>> entriesAsync,
  ) => entriesAsync.when(
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (error, _) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error loading data: $error', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _retry, child: const Text('Retry')),
        ],
      ),
    ),
    data: (entries) {
      final bbtEntries = entries.where((e) => e.hasBBTData).toList();

      if (bbtEntries.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No BBT data recorded yet. Add BBT readings in the Fluids tab.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      }

      final dataPoints = bbtEntries
          .map(
            (e) => ChartDataPoint(
              x: e.entryDate,
              y: bbtToDisplay(e.basalBodyTemperature!, useCelsius: useCelsius),
            ),
          )
          .toList();

      final menstruationRanges = groupMenstruationRanges(entries);

      final unit = useCelsius ? '°C' : '°F';
      final yValues = dataPoints.map((p) => p.y).toList();
      final avg = yValues.reduce((a, b) => a + b) / yValues.length;
      final min = yValues.reduce((a, b) => a < b ? a : b);
      final max = yValues.reduce((a, b) => a > b ? a : b);

      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ShadowChart.bbt(
                dataPoints: dataPoints,
                label: 'Basal Body Temperature',
                height: 280,
                showDataTable: _showDataTable,
                dateRange: _dateRange,
                menstruationRanges: menstruationRanges.isNotEmpty
                    ? menstruationRanges
                    : null,
                useCelsius: useCelsius,
              ),
            ),
            _buildStatsRow(
              avg: avg,
              min: min,
              max: max,
              count: bbtEntries.length,
              unit: unit,
            ),
          ],
        ),
      );
    },
  );

  Widget _buildStatsRow({
    required double avg,
    required double min,
    required double max,
    required int count,
    required String unit,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem('Avg', '${avg.toStringAsFixed(1)} $unit'),
        _statItem('Min', '${min.toStringAsFixed(1)} $unit'),
        _statItem('Max', '${max.toStringAsFixed(1)} $unit'),
        _statItem('Readings', '$count'),
      ],
    ),
  );

  Widget _statItem(String label, String value) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
    ],
  );

  void _retry() {
    final startMs = _dateRange.start.millisecondsSinceEpoch;
    final endMs = _dateRange.end.millisecondsSinceEpoch;
    ref
        .read(
          fluidsEntryListProvider(widget.profileId, startMs, endMs).notifier,
        )
        .retry();
  }
}
