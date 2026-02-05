// test/unit/domain/entities/condition_log_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('ConditionLog', () {
    ConditionLog createTestConditionLog({
      String id = 'log-001',
      String clientId = 'client-001',
      String profileId = 'profile-001',
      String conditionId = 'cond-001',
      int timestamp = 1704067200000,
      int severity = 5,
      String? notes,
      bool isFlare = false,
      List<String> flarePhotoIds = const [],
      String? photoPath,
      String? triggers,
    }) => ConditionLog(
      id: id,
      clientId: clientId,
      profileId: profileId,
      conditionId: conditionId,
      timestamp: timestamp,
      severity: severity,
      notes: notes,
      isFlare: isFlare,
      flarePhotoIds: flarePhotoIds,
      photoPath: photoPath,
      triggers: triggers,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );

    group('computed properties', () {
      test('hasPhoto returns true when photo path is set', () {
        final log = createTestConditionLog(photoPath: '/path/to/photo.jpg');
        expect(log.hasPhoto, isTrue);
      });

      test('hasPhoto returns false when photo path is null', () {
        final log = createTestConditionLog();
        expect(log.hasPhoto, isFalse);
      });

      test('triggerList returns empty list when triggers is null', () {
        final log = createTestConditionLog();
        expect(log.triggerList, isEmpty);
      });

      test('triggerList parses comma-separated triggers', () {
        final log = createTestConditionLog(
          triggers: 'stress, lack of sleep, diet',
        );
        expect(log.triggerList, equals(['stress', 'lack of sleep', 'diet']));
      });

      test('triggerList handles whitespace correctly', () {
        final log = createTestConditionLog(triggers: '  stress ,  anxiety  ');
        expect(log.triggerList, equals(['stress', 'anxiety']));
      });

      test('triggerList handles empty string', () {
        final log = createTestConditionLog(triggers: '');
        expect(log.triggerList, isEmpty);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final log = createTestConditionLog(
          severity: 7,
          notes: 'Flare-up today',
          isFlare: true,
          flarePhotoIds: ['photo-1', 'photo-2'],
          triggers: 'stress, poor diet',
        );

        final json = log.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('log-001'));
        expect(json['conditionId'], equals('cond-001'));
        expect(json['severity'], equals(7));
        expect(json['notes'], equals('Flare-up today'));
        expect(json['isFlare'], isTrue);
        expect(json['flarePhotoIds'], equals(['photo-1', 'photo-2']));
        expect(json['triggers'], equals('stress, poor diet'));
      });

      test('fromJson parses correctly', () {
        final log = createTestConditionLog(
          severity: 8,
          isFlare: true,
          notes: 'Severe flare',
        );
        final json = log.toJson();
        final parsed = ConditionLog.fromJson(json);

        expect(parsed.id, equals(log.id));
        expect(parsed.conditionId, equals(log.conditionId));
        expect(parsed.severity, equals(8));
        expect(parsed.isFlare, isTrue);
        expect(parsed.notes, equals('Severe flare'));
      });

      test('round-trip serialization preserves all fields', () {
        final original = createTestConditionLog(
          severity: 9,
          notes: 'Full notes',
          isFlare: true,
          flarePhotoIds: ['photo-1', 'photo-2', 'photo-3'],
          photoPath: '/photos/condition.jpg',
          triggers: 'trigger1, trigger2',
        );
        final json = original.toJson();
        final parsed = ConditionLog.fromJson(json);

        expect(parsed.id, equals(original.id));
        expect(parsed.clientId, equals(original.clientId));
        expect(parsed.profileId, equals(original.profileId));
        expect(parsed.conditionId, equals(original.conditionId));
        expect(parsed.timestamp, equals(original.timestamp));
        expect(parsed.severity, equals(original.severity));
        expect(parsed.notes, equals(original.notes));
        expect(parsed.isFlare, equals(original.isFlare));
        expect(parsed.flarePhotoIds, equals(original.flarePhotoIds));
        expect(parsed.photoPath, equals(original.photoPath));
        expect(parsed.triggers, equals(original.triggers));
      });
    });

    group('copyWith', () {
      test('copyWith creates new instance with updated fields', () {
        final original = createTestConditionLog(severity: 3);
        final updated = original.copyWith(
          severity: 8,
          isFlare: true,
          notes: 'Updated notes',
        );

        expect(updated.id, equals(original.id));
        expect(updated.conditionId, equals(original.conditionId));
        expect(updated.severity, equals(8));
        expect(updated.isFlare, isTrue);
        expect(updated.notes, equals('Updated notes'));
      });
    });

    group('severity validation', () {
      test('severity within valid range 1-10', () {
        final logMin = createTestConditionLog(severity: 1);
        final logMax = createTestConditionLog(severity: 10);

        expect(logMin.severity, equals(1));
        expect(logMax.severity, equals(10));
      });
    });
  });
}
