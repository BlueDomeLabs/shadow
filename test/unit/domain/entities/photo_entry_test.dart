// test/unit/domain/entities/photo_entry_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('PhotoEntry', () {
    late PhotoEntry photoEntry;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      photoEntry = PhotoEntry(
        id: 'photo-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        photoAreaId: 'area-001',
        timestamp: 1704067200000,
        filePath: '/photos/entry001.jpg',
        notes: 'Morning photo',
        cloudStorageUrl: 'https://storage.example.com/photo001.jpg',
        fileHash: 'abc123hash',
        fileSizeBytes: 1024000,
        isFileUploaded: true,
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(photoEntry.id, equals('photo-001'));
      });

      test('has clientId field', () {
        expect(photoEntry.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(photoEntry.profileId, equals('profile-001'));
      });

      test('has photoAreaId field', () {
        expect(photoEntry.photoAreaId, equals('area-001'));
      });

      test('has timestamp field', () {
        expect(photoEntry.timestamp, equals(1704067200000));
      });

      test('has filePath field', () {
        expect(photoEntry.filePath, equals('/photos/entry001.jpg'));
      });

      test('has syncMetadata field', () {
        expect(photoEntry.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('notes is nullable', () {
        expect(photoEntry.notes, equals('Morning photo'));
      });

      test('cloudStorageUrl is nullable', () {
        expect(
          photoEntry.cloudStorageUrl,
          equals('https://storage.example.com/photo001.jpg'),
        );
      });

      test('fileHash is nullable', () {
        expect(photoEntry.fileHash, equals('abc123hash'));
      });

      test('fileSizeBytes is nullable', () {
        expect(photoEntry.fileSizeBytes, equals(1024000));
      });

      test('isFileUploaded defaults to false', () {
        final minimal = PhotoEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          photoAreaId: 'area-001',
          timestamp: 1704067200000,
          filePath: '/photos/test.jpg',
          syncMetadata: syncMetadata,
        );
        expect(minimal.isFileUploaded, isFalse);
      });
    });

    group('computed properties', () {
      test('isPendingUpload returns false when uploaded', () {
        expect(photoEntry.isPendingUpload, isFalse);
      });

      test('isPendingUpload returns true when not uploaded', () {
        final notUploaded = PhotoEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          photoAreaId: 'area-001',
          timestamp: 1704067200000,
          filePath: '/photos/test.jpg',
          syncMetadata: syncMetadata,
        );
        expect(notUploaded.isPendingUpload, isTrue);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = photoEntry.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('photo-001'));
        expect(json['filePath'], equals('/photos/entry001.jpg'));
      });

      test('fromJson parses correctly', () {
        final json = photoEntry.toJson();
        final parsed = PhotoEntry.fromJson(json);

        expect(parsed.id, equals(photoEntry.id));
        expect(parsed.photoAreaId, equals(photoEntry.photoAreaId));
        expect(parsed.filePath, equals(photoEntry.filePath));
      });

      test('round-trip serialization preserves data', () {
        final json = photoEntry.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = PhotoEntry.fromJson(decoded);

        expect(parsed, equals(photoEntry));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = photoEntry.copyWith(notes: 'Updated notes');

        expect(updated.notes, equals('Updated notes'));
        expect(updated.id, equals(photoEntry.id));
        expect(photoEntry.notes, equals('Morning photo'));
      });
    });
  });
}
