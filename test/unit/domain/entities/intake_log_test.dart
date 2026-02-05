// test/unit/domain/entities/intake_log_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('IntakeLog', () {
    IntakeLog createTestIntakeLog({
      String id = 'log-001',
      String clientId = 'client-001',
      String profileId = 'profile-001',
      String supplementId = 'supp-001',
      int scheduledTime = 1704067200000,
      int? actualTime,
      IntakeLogStatus status = IntakeLogStatus.pending,
      String? reason,
      String? note,
    }) => IntakeLog(
      id: id,
      clientId: clientId,
      profileId: profileId,
      supplementId: supplementId,
      scheduledTime: scheduledTime,
      actualTime: actualTime,
      status: status,
      reason: reason,
      note: note,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );

    group('computed properties', () {
      test('isTaken returns true when status is taken', () {
        final log = createTestIntakeLog(status: IntakeLogStatus.taken);
        expect(log.isTaken, isTrue);
        expect(log.isPending, isFalse);
      });

      test('isPending returns true when status is pending', () {
        final log = createTestIntakeLog();
        expect(log.isPending, isTrue);
        expect(log.isTaken, isFalse);
      });

      test('isSkipped returns true when status is skipped', () {
        final log = createTestIntakeLog(status: IntakeLogStatus.skipped);
        expect(log.isSkipped, isTrue);
      });

      test('isMissed returns true when status is missed', () {
        final log = createTestIntakeLog(status: IntakeLogStatus.missed);
        expect(log.isMissed, isTrue);
      });

      test('delayFromScheduled returns null when actualTime is null', () {
        final log = createTestIntakeLog();
        expect(log.delayFromScheduled, isNull);
      });

      test('delayFromScheduled calculates duration correctly', () {
        const scheduledTime = 1704067200000;
        final log = createTestIntakeLog(
          actualTime: scheduledTime + (30 * 60 * 1000), // 30 minutes later
        );
        expect(log.delayFromScheduled, equals(const Duration(minutes: 30)));
      });

      test('delayFromScheduled handles negative delay (taken early)', () {
        const scheduledTime = 1704067200000;
        final log = createTestIntakeLog(
          actualTime: scheduledTime - (15 * 60 * 1000), // 15 minutes early
        );
        expect(log.delayFromScheduled, equals(const Duration(minutes: -15)));
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final log = createTestIntakeLog(
          status: IntakeLogStatus.taken,
          actualTime: 1704067500000,
          note: 'Took with breakfast',
        );

        final json = log.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('log-001'));
        expect(json['clientId'], equals('client-001'));
        expect(json['profileId'], equals('profile-001'));
        expect(json['supplementId'], equals('supp-001'));
        expect(json['scheduledTime'], equals(1704067200000));
        expect(json['actualTime'], equals(1704067500000));
        expect(json['status'], equals('taken'));
        expect(json['note'], equals('Took with breakfast'));
      });

      test('fromJson parses correctly', () {
        final log = createTestIntakeLog(
          status: IntakeLogStatus.skipped,
          reason: 'Felt sick',
        );
        final json = log.toJson();
        final parsed = IntakeLog.fromJson(json);

        expect(parsed.id, equals(log.id));
        expect(parsed.supplementId, equals(log.supplementId));
        expect(parsed.status, equals(IntakeLogStatus.skipped));
        expect(parsed.reason, equals('Felt sick'));
      });

      test('round-trip serialization preserves all fields', () {
        final original = createTestIntakeLog(
          status: IntakeLogStatus.taken,
          actualTime: 1704067500000,
          reason: 'Test reason',
          note: 'Test note',
        );
        final json = original.toJson();
        final parsed = IntakeLog.fromJson(json);

        expect(parsed.id, equals(original.id));
        expect(parsed.clientId, equals(original.clientId));
        expect(parsed.profileId, equals(original.profileId));
        expect(parsed.supplementId, equals(original.supplementId));
        expect(parsed.scheduledTime, equals(original.scheduledTime));
        expect(parsed.actualTime, equals(original.actualTime));
        expect(parsed.status, equals(original.status));
        expect(parsed.reason, equals(original.reason));
        expect(parsed.note, equals(original.note));
      });
    });

    group('copyWith', () {
      test('copyWith creates new instance with updated fields', () {
        final original = createTestIntakeLog();
        final updated = original.copyWith(
          status: IntakeLogStatus.taken,
          actualTime: 1704067500000,
        );

        expect(updated.id, equals(original.id));
        expect(updated.status, equals(IntakeLogStatus.taken));
        expect(updated.actualTime, equals(1704067500000));
      });
    });
  });
}
