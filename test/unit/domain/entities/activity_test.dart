// test/unit/domain/entities/activity_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('Activity', () {
    late Activity activity;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      activity = Activity(
        id: 'act-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        name: 'Morning Walk',
        description: 'A brisk walk around the park',
        location: 'Local Park',
        triggers: 'good weather,daylight',
        durationMinutes: 30,
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(activity.id, equals('act-001'));
      });

      test('has clientId field', () {
        expect(activity.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(activity.profileId, equals('profile-001'));
      });

      test('has name field', () {
        expect(activity.name, equals('Morning Walk'));
      });

      test('has durationMinutes field', () {
        expect(activity.durationMinutes, equals(30));
      });

      test('has syncMetadata field', () {
        expect(activity.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('description is nullable', () {
        expect(activity.description, equals('A brisk walk around the park'));

        final noDesc = Activity(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          durationMinutes: 10,
          syncMetadata: syncMetadata,
        );
        expect(noDesc.description, isNull);
      });

      test('location is nullable', () {
        expect(activity.location, equals('Local Park'));
      });

      test('triggers is nullable', () {
        expect(activity.triggers, equals('good weather,daylight'));
      });

      test('isArchived defaults to false', () {
        expect(activity.isArchived, isFalse);
      });
    });

    group('computed properties', () {
      test('isActive returns true when not archived and not deleted', () {
        expect(activity.isActive, isTrue);
      });

      test('isActive returns false when archived', () {
        final archived = activity.copyWith(isArchived: true);
        expect(archived.isActive, isFalse);
      });

      test('isActive returns false when soft deleted', () {
        final deleted = activity.copyWith(
          syncMetadata: syncMetadata.markDeleted('test-device'),
        );
        expect(deleted.isActive, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = activity.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('act-001'));
        expect(json['name'], equals('Morning Walk'));
      });

      test('fromJson parses correctly', () {
        final json = activity.toJson();
        final parsed = Activity.fromJson(json);

        expect(parsed.id, equals(activity.id));
        expect(parsed.name, equals(activity.name));
        expect(parsed.durationMinutes, equals(activity.durationMinutes));
      });

      test('round-trip serialization preserves data', () {
        final json = activity.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = Activity.fromJson(decoded);

        expect(parsed, equals(activity));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = activity.copyWith(name: 'Evening Jog');

        expect(updated.name, equals('Evening Jog'));
        expect(updated.id, equals(activity.id));
        expect(activity.name, equals('Morning Walk'));
      });
    });
  });
}
