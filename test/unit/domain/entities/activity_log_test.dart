// test/unit/domain/entities/activity_log_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('ActivityLog', () {
    late ActivityLog activityLog;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      activityLog = ActivityLog(
        id: 'alog-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        timestamp: 1704067200000,
        activityIds: ['act-001', 'act-002'],
        adHocActivities: ['Gardening'],
        duration: 45,
        notes: 'Felt good',
        importSource: 'healthkit',
        importExternalId: 'ext-123',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(activityLog.id, equals('alog-001'));
      });

      test('has clientId field', () {
        expect(activityLog.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(activityLog.profileId, equals('profile-001'));
      });

      test('has timestamp field', () {
        expect(activityLog.timestamp, equals(1704067200000));
      });

      test('has syncMetadata field', () {
        expect(activityLog.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('activityIds defaults to empty list', () {
        final minimal = ActivityLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.activityIds, isEmpty);
      });

      test('adHocActivities defaults to empty list', () {
        final minimal = ActivityLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(minimal.adHocActivities, isEmpty);
      });

      test('duration is nullable', () {
        expect(activityLog.duration, equals(45));
      });

      test('notes is nullable', () {
        expect(activityLog.notes, equals('Felt good'));
      });

      test('importSource is nullable', () {
        expect(activityLog.importSource, equals('healthkit'));
      });

      test('importExternalId is nullable', () {
        expect(activityLog.importExternalId, equals('ext-123'));
      });
    });

    group('computed properties', () {
      test('hasActivities returns true when activityIds present', () {
        expect(activityLog.hasActivities, isTrue);
      });

      test('hasActivities returns true when adHocActivities present', () {
        final adHocOnly = ActivityLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          adHocActivities: ['Running'],
          syncMetadata: syncMetadata,
        );
        expect(adHocOnly.hasActivities, isTrue);
      });

      test('hasActivities returns false when both empty', () {
        final empty = ActivityLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(empty.hasActivities, isFalse);
      });

      test('isImported returns true when importSource set', () {
        expect(activityLog.isImported, isTrue);
      });

      test('isImported returns false when importSource null', () {
        final notImported = ActivityLog(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          syncMetadata: syncMetadata,
        );
        expect(notImported.isImported, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = activityLog.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('alog-001'));
        expect(json['timestamp'], equals(1704067200000));
      });

      test('fromJson parses correctly', () {
        final json = activityLog.toJson();
        final parsed = ActivityLog.fromJson(json);

        expect(parsed.id, equals(activityLog.id));
        expect(parsed.activityIds, equals(activityLog.activityIds));
        expect(parsed.adHocActivities, equals(activityLog.adHocActivities));
      });

      test('round-trip serialization preserves data', () {
        final json = activityLog.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = ActivityLog.fromJson(decoded);

        expect(parsed, equals(activityLog));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = activityLog.copyWith(duration: 60);

        expect(updated.duration, equals(60));
        expect(updated.id, equals(activityLog.id));
        expect(activityLog.duration, equals(45));
      });
    });
  });
}
