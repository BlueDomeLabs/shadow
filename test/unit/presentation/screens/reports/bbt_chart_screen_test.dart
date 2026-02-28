// test/unit/presentation/screens/reports/bbt_chart_screen_test.dart
// Unit tests for pure Dart helper functions in BBTChartScreen — Phase 26.

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/screens/reports/bbt_chart_screen.dart';

// ---------------------------------------------------------------------------
// Entity stubs
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

/// Returns epoch ms for a calendar day (midnight local time).
int _day(int year, int month, int day) =>
    DateTime(year, month, day).millisecondsSinceEpoch;

// ---------------------------------------------------------------------------
// bbtToDisplay
// ---------------------------------------------------------------------------

void main() {
  group('bbtToDisplay — Fahrenheit mode', () {
    test('returns value unchanged when useCelsius is false', () {
      expect(bbtToDisplay(98.6, useCelsius: false), equals(98.6));
    });

    test('identity for extreme low value', () {
      expect(bbtToDisplay(96, useCelsius: false), equals(96));
    });

    test('identity for extreme high value', () {
      expect(bbtToDisplay(100, useCelsius: false), equals(100));
    });
  });

  group('bbtToDisplay — Celsius mode', () {
    test('converts 98.6 °F → 37.0 °C', () {
      expect(bbtToDisplay(98.6, useCelsius: true), closeTo(37.0, 0.01));
    });

    test('converts 96.0 °F → 35.56 °C', () {
      expect(bbtToDisplay(96, useCelsius: true), closeTo(35.56, 0.01));
    });

    test('converts 100.0 °F → 37.78 °C', () {
      expect(bbtToDisplay(100, useCelsius: true), closeTo(37.78, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // groupMenstruationRanges
  // ---------------------------------------------------------------------------

  group('groupMenstruationRanges — empty input', () {
    test('returns empty list for empty entries', () {
      expect(groupMenstruationRanges([]), isEmpty);
    });

    test('returns empty list when no entry has menstruation data', () {
      final entries = [
        _makeEntry(entryDate: _day(2025, 1, 1), basalBodyTemperature: 98.6),
        _makeEntry(entryDate: _day(2025, 1, 2), basalBodyTemperature: 98.4),
      ];
      expect(groupMenstruationRanges(entries), isEmpty);
    });

    test('returns empty list when all menstruation flows are none', () {
      final entries = [
        _makeEntry(
          entryDate: _day(2025, 1, 1),
          menstruationFlow: MenstruationFlow.none,
        ),
        _makeEntry(
          entryDate: _day(2025, 1, 2),
          menstruationFlow: MenstruationFlow.none,
        ),
      ];
      expect(groupMenstruationRanges(entries), isEmpty);
    });
  });

  group('groupMenstruationRanges — single entry', () {
    test('single menstruation day → one DateTimeRange spanning that day', () {
      final entries = [
        _makeEntry(
          entryDate: _day(2025, 3, 5),
          menstruationFlow: MenstruationFlow.medium,
        ),
      ];
      final ranges = groupMenstruationRanges(entries);
      expect(ranges, hasLength(1));
      final range = ranges.first;
      // start == midnight of March 5 (local time).
      expect(range.start, equals(DateTime(2025, 3, 5)));
    });
  });

  group('groupMenstruationRanges — consecutive days', () {
    test('consecutive days produce a single DateTimeRange', () {
      final entries = [
        _makeEntry(
          entryDate: _day(2025, 6, 1),
          menstruationFlow: MenstruationFlow.light,
        ),
        _makeEntry(
          entryDate: _day(2025, 6, 2),
          menstruationFlow: MenstruationFlow.medium,
        ),
        _makeEntry(
          entryDate: _day(2025, 6, 3),
          menstruationFlow: MenstruationFlow.heavy,
        ),
      ];
      final ranges = groupMenstruationRanges(entries);
      expect(ranges, hasLength(1));
    });
  });

  group('groupMenstruationRanges — non-consecutive days', () {
    test('two separate periods produce two DateTimeRanges', () {
      final entries = [
        // Period 1: Jan 5-6
        _makeEntry(
          entryDate: _day(2025, 1, 5),
          menstruationFlow: MenstruationFlow.medium,
        ),
        _makeEntry(
          entryDate: _day(2025, 1, 6),
          menstruationFlow: MenstruationFlow.medium,
        ),
        // Gap: Jan 7 (no entry)
        // Period 2: Jan 20-21
        _makeEntry(
          entryDate: _day(2025, 1, 20),
          menstruationFlow: MenstruationFlow.light,
        ),
        _makeEntry(
          entryDate: _day(2025, 1, 21),
          menstruationFlow: MenstruationFlow.spotty,
        ),
      ];
      final ranges = groupMenstruationRanges(entries);
      expect(ranges, hasLength(2));
    });
  });

  group('groupMenstruationRanges — mixed entries', () {
    test('entries without BBT are still included in menstruation grouping', () {
      final entries = [
        _makeEntry(
          entryDate: _day(2025, 2, 10),
          basalBodyTemperature: 98,
          menstruationFlow: MenstruationFlow.heavy,
        ),
        _makeEntry(
          entryDate: _day(2025, 2, 11),
          menstruationFlow: MenstruationFlow.heavy,
        ),
      ];
      final ranges = groupMenstruationRanges(entries);
      expect(ranges, hasLength(1));
    });

    test('entries with MenstruationFlow.none are excluded', () {
      final entries = [
        _makeEntry(
          entryDate: _day(2025, 4, 1),
          menstruationFlow: MenstruationFlow.medium,
        ),
        _makeEntry(
          entryDate: _day(2025, 4, 2),
          menstruationFlow: MenstruationFlow.none,
        ),
        _makeEntry(
          entryDate: _day(2025, 4, 3),
          menstruationFlow: MenstruationFlow.light,
        ),
      ];
      // Days 1 and 3 are active, day 2 is none — two separate ranges.
      final ranges = groupMenstruationRanges(entries);
      expect(ranges, hasLength(2));
    });
  });

  group('groupMenstruationRanges — BBT-only entries', () {
    test('entries without BBT data are filtered out from dataPoints', () {
      // This test verifies the in-screen filter logic (hasBBTData) rather than
      // groupMenstruationRanges, but exercises the interaction.
      final entries = [
        _makeEntry(entryDate: _day(2025, 1, 1)), // no BBT, no flow
        _makeEntry(
          entryDate: _day(2025, 1, 2),
          basalBodyTemperature: 98.2,
        ), // BBT only
      ];
      final bbtEntries = entries.where((e) => e.hasBBTData).toList();
      expect(bbtEntries, hasLength(1));
      expect(groupMenstruationRanges(entries), isEmpty);
    });
  });
}
