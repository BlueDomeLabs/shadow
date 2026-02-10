// test/unit/domain/entities/flare_up_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('FlareUp', () {
    late FlareUp flareUp;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      flareUp = FlareUp(
        id: 'flare-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        conditionId: 'cond-001',
        startDate: 1704067200000,
        endDate: 1704153600000, // 24 hours later
        severity: 7,
        notes: 'Triggered by stress',
        triggers: ['stress', 'lack of sleep'],
        activityId: 'act-001',
        photoPath: '/photos/flare001.jpg',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(flareUp.id, equals('flare-001'));
      });

      test('has clientId field', () {
        expect(flareUp.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(flareUp.profileId, equals('profile-001'));
      });

      test('has conditionId field', () {
        expect(flareUp.conditionId, equals('cond-001'));
      });

      test('has startDate field', () {
        expect(flareUp.startDate, equals(1704067200000));
      });

      test('has severity field', () {
        expect(flareUp.severity, equals(7));
      });

      test('has triggers field', () {
        expect(flareUp.triggers, equals(['stress', 'lack of sleep']));
      });

      test('has syncMetadata field', () {
        expect(flareUp.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('endDate is nullable', () {
        expect(flareUp.endDate, equals(1704153600000));

        final ongoing = FlareUp(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          conditionId: 'cond-001',
          startDate: 1704067200000,
          severity: 5,
          triggers: [],
          syncMetadata: syncMetadata,
        );
        expect(ongoing.endDate, isNull);
      });

      test('notes is nullable', () {
        expect(flareUp.notes, equals('Triggered by stress'));
      });

      test('activityId is nullable', () {
        expect(flareUp.activityId, equals('act-001'));
      });

      test('photoPath is nullable', () {
        expect(flareUp.photoPath, equals('/photos/flare001.jpg'));
      });
    });

    group('computed properties', () {
      test('durationMs returns difference when endDate set', () {
        expect(flareUp.durationMs, equals(86400000));
      });

      test('durationMs returns null when endDate null', () {
        final ongoing = flareUp.copyWith(endDate: null);
        expect(ongoing.durationMs, isNull);
      });

      test('isOngoing returns false when endDate set', () {
        expect(flareUp.isOngoing, isFalse);
      });

      test('isOngoing returns true when endDate null', () {
        final ongoing = flareUp.copyWith(endDate: null);
        expect(ongoing.isOngoing, isTrue);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = flareUp.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('flare-001'));
        expect(json['severity'], equals(7));
      });

      test('fromJson parses correctly', () {
        final json = flareUp.toJson();
        final parsed = FlareUp.fromJson(json);

        expect(parsed.id, equals(flareUp.id));
        expect(parsed.conditionId, equals(flareUp.conditionId));
        expect(parsed.triggers, equals(flareUp.triggers));
      });

      test('round-trip serialization preserves data', () {
        final json = flareUp.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = FlareUp.fromJson(decoded);

        expect(parsed, equals(flareUp));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = flareUp.copyWith(severity: 9);

        expect(updated.severity, equals(9));
        expect(updated.id, equals(flareUp.id));
        expect(flareUp.severity, equals(7));
      });
    });
  });
}
