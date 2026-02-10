// test/unit/domain/entities/sleep_entry_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('SleepEntry', () {
    late SleepEntry sleepEntry;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      sleepEntry = SleepEntry(
        id: 'sleep-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        bedTime: 1704067200000, // 10 PM
        wakeTime: 1704096000000, // 6 AM (8 hours later)
        deepSleepMinutes: 120,
        lightSleepMinutes: 240,
        restlessSleepMinutes: 30,
        dreamType: DreamType.vivid,
        wakingFeeling: WakingFeeling.rested,
        notes: 'Slept well',
        importSource: 'healthkit',
        importExternalId: 'hk-sleep-001',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(sleepEntry.id, equals('sleep-001'));
      });

      test('has clientId field', () {
        expect(sleepEntry.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(sleepEntry.profileId, equals('profile-001'));
      });

      test('has bedTime field', () {
        expect(sleepEntry.bedTime, equals(1704067200000));
      });

      test('has syncMetadata field', () {
        expect(sleepEntry.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('wakeTime is nullable', () {
        expect(sleepEntry.wakeTime, equals(1704096000000));

        final noWake = SleepEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          bedTime: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(noWake.wakeTime, isNull);
      });

      test('deepSleepMinutes defaults to 0', () {
        final minimal = SleepEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          bedTime: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.deepSleepMinutes, equals(0));
      });

      test('lightSleepMinutes defaults to 0', () {
        final minimal = SleepEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          bedTime: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.lightSleepMinutes, equals(0));
      });

      test('restlessSleepMinutes defaults to 0', () {
        final minimal = SleepEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          bedTime: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.restlessSleepMinutes, equals(0));
      });

      test('dreamType defaults to noDreams', () {
        final minimal = SleepEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          bedTime: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.dreamType, equals(DreamType.noDreams));
      });

      test('wakingFeeling defaults to neutral', () {
        final minimal = SleepEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          bedTime: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.wakingFeeling, equals(WakingFeeling.neutral));
      });

      test('notes is nullable', () {
        expect(sleepEntry.notes, equals('Slept well'));
      });

      test('importSource is nullable', () {
        expect(sleepEntry.importSource, equals('healthkit'));
      });

      test('importExternalId is nullable', () {
        expect(sleepEntry.importExternalId, equals('hk-sleep-001'));
      });
    });

    group('computed properties', () {
      test('totalSleepMinutes calculates correctly', () {
        // 8 hours = 480 minutes
        expect(sleepEntry.totalSleepMinutes, equals(480));
      });

      test('totalSleepMinutes returns null when wakeTime null', () {
        final noWake = sleepEntry.copyWith(wakeTime: null);
        expect(noWake.totalSleepMinutes, isNull);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = sleepEntry.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('sleep-001'));
        expect(json['bedTime'], equals(1704067200000));
      });

      test('fromJson parses correctly', () {
        final json = sleepEntry.toJson();
        final parsed = SleepEntry.fromJson(json);

        expect(parsed.id, equals(sleepEntry.id));
        expect(parsed.bedTime, equals(sleepEntry.bedTime));
        expect(parsed.dreamType, equals(sleepEntry.dreamType));
        expect(parsed.wakingFeeling, equals(sleepEntry.wakingFeeling));
      });

      test('round-trip serialization preserves data', () {
        final json = sleepEntry.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = SleepEntry.fromJson(decoded);

        expect(parsed, equals(sleepEntry));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = sleepEntry.copyWith(deepSleepMinutes: 150);

        expect(updated.deepSleepMinutes, equals(150));
        expect(updated.id, equals(sleepEntry.id));
        expect(sleepEntry.deepSleepMinutes, equals(120));
      });
    });
  });
}
