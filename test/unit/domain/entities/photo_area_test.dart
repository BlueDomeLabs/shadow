// test/unit/domain/entities/photo_area_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('PhotoArea', () {
    late PhotoArea photoArea;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      photoArea = PhotoArea(
        id: 'area-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        name: 'Left Arm',
        description: 'Inner left arm skin',
        consistencyNotes: 'Place arm flat, photo from 30cm distance',
        sortOrder: 1,
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(photoArea.id, equals('area-001'));
      });

      test('has clientId field', () {
        expect(photoArea.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(photoArea.profileId, equals('profile-001'));
      });

      test('has name field', () {
        expect(photoArea.name, equals('Left Arm'));
      });

      test('has syncMetadata field', () {
        expect(photoArea.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('description is nullable', () {
        expect(photoArea.description, equals('Inner left arm skin'));
      });

      test('consistencyNotes is nullable', () {
        expect(
          photoArea.consistencyNotes,
          equals('Place arm flat, photo from 30cm distance'),
        );
      });

      test('sortOrder defaults to 0', () {
        final minimal = PhotoArea(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.sortOrder, equals(0));
      });

      test('isArchived defaults to false', () {
        expect(photoArea.isArchived, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = photoArea.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('area-001'));
        expect(json['name'], equals('Left Arm'));
      });

      test('fromJson parses correctly', () {
        final json = photoArea.toJson();
        final parsed = PhotoArea.fromJson(json);

        expect(parsed.id, equals(photoArea.id));
        expect(parsed.name, equals(photoArea.name));
        expect(parsed.sortOrder, equals(photoArea.sortOrder));
      });

      test('round-trip serialization preserves data', () {
        final json = photoArea.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = PhotoArea.fromJson(decoded);

        expect(parsed, equals(photoArea));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = photoArea.copyWith(name: 'Right Arm');

        expect(updated.name, equals('Right Arm'));
        expect(updated.id, equals(photoArea.id));
        expect(photoArea.name, equals('Left Arm'));
      });
    });
  });
}
