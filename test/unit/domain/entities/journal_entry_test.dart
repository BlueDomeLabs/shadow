// test/unit/domain/entities/journal_entry_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('JournalEntry', () {
    late JournalEntry journalEntry;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      journalEntry = JournalEntry(
        id: 'journal-001',
        clientId: 'client-001',
        profileId: 'profile-001',
        timestamp: 1704067200000,
        content: 'Today was a good day.',
        title: 'Good Day',
        mood: 7,
        tags: ['positive', 'health'],
        audioUrl: 'file:///audio/entry001.m4a',
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(journalEntry.id, equals('journal-001'));
      });

      test('has clientId field', () {
        expect(journalEntry.clientId, equals('client-001'));
      });

      test('has profileId field', () {
        expect(journalEntry.profileId, equals('profile-001'));
      });

      test('has timestamp field', () {
        expect(journalEntry.timestamp, equals(1704067200000));
      });

      test('has content field', () {
        expect(journalEntry.content, equals('Today was a good day.'));
      });

      test('has syncMetadata field', () {
        expect(journalEntry.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('title is nullable', () {
        expect(journalEntry.title, equals('Good Day'));

        final noTitle = JournalEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          content: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(noTitle.title, isNull);
      });

      test('mood is nullable', () {
        expect(journalEntry.mood, equals(7));
      });

      test('tags is nullable', () {
        expect(journalEntry.tags, equals(['positive', 'health']));

        final noTags = JournalEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          content: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(noTags.tags, isNull);
      });

      test('audioUrl is nullable', () {
        expect(journalEntry.audioUrl, equals('file:///audio/entry001.m4a'));
      });
    });

    group('computed properties', () {
      test('hasMood returns true when mood set', () {
        expect(journalEntry.hasMood, isTrue);
      });

      test('hasMood returns false when mood null', () {
        final noMood = JournalEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          content: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(noMood.hasMood, isFalse);
      });

      test('hasAudio returns true when audioUrl set', () {
        expect(journalEntry.hasAudio, isTrue);
      });

      test('hasAudio returns false when audioUrl null', () {
        final noAudio = JournalEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          content: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(noAudio.hasAudio, isFalse);
      });

      test('hasAudio returns false when audioUrl empty', () {
        final emptyAudio = journalEntry.copyWith(audioUrl: '');
        expect(emptyAudio.hasAudio, isFalse);
      });

      test('hasTags returns true when tags present', () {
        expect(journalEntry.hasTags, isTrue);
      });

      test('hasTags returns false when tags null', () {
        final noTags = JournalEntry(
          id: 'id',
          clientId: 'cid',
          profileId: 'pid',
          timestamp: 1704067200000,
          content: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(noTags.hasTags, isFalse);
      });

      test('hasTags returns false when tags empty', () {
        final emptyTags = journalEntry.copyWith(tags: []);
        expect(emptyTags.hasTags, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = journalEntry.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('journal-001'));
        expect(json['content'], equals('Today was a good day.'));
      });

      test('fromJson parses correctly', () {
        final json = journalEntry.toJson();
        final parsed = JournalEntry.fromJson(json);

        expect(parsed.id, equals(journalEntry.id));
        expect(parsed.content, equals(journalEntry.content));
        expect(parsed.mood, equals(journalEntry.mood));
        expect(parsed.tags, equals(journalEntry.tags));
      });

      test('round-trip serialization preserves data', () {
        final json = journalEntry.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = JournalEntry.fromJson(decoded);

        expect(parsed, equals(journalEntry));
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = journalEntry.copyWith(content: 'Updated content');

        expect(updated.content, equals('Updated content'));
        expect(updated.id, equals(journalEntry.id));
        expect(journalEntry.content, equals('Today was a good day.'));
      });
    });
  });
}
