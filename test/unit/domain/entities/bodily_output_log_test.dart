// test/unit/domain/entities/bodily_output_log_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';

void main() {
  late SyncMetadata syncMetadata;

  setUp(() {
    syncMetadata = const SyncMetadata(
      syncCreatedAt: 1000000,
      syncUpdatedAt: 1000000,
      syncDeviceId: 'device-001',
    );
  });

  BodilyOutputLog makeUrine() => BodilyOutputLog(
    id: 'log-001',
    clientId: 'client-001',
    profileId: 'profile-001',
    occurredAt: 1700000000000,
    outputType: BodyOutputType.urine,
    urineCondition: UrineCondition.yellow,
    urineSize: OutputSize.medium,
    syncMetadata: syncMetadata,
  );

  group('BodilyOutputLog entity', () {
    test('required fields are stored correctly', () {
      final log = makeUrine();
      expect(log.id, 'log-001');
      expect(log.clientId, 'client-001');
      expect(log.profileId, 'profile-001');
      expect(log.occurredAt, 1700000000000);
      expect(log.outputType, BodyOutputType.urine);
    });

    test('nullable type-specific fields default to null', () {
      final log = makeUrine();
      expect(log.gasSeverity, isNull);
      expect(log.bowelCondition, isNull);
      expect(log.menstruationFlow, isNull);
      expect(log.temperatureValue, isNull);
      expect(log.customTypeLabel, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final original = makeUrine();
      final updated = original.copyWith(notes: 'test note');
      expect(updated.id, original.id);
      expect(updated.profileId, original.profileId);
      expect(updated.notes, 'test note');
      expect(original.notes, isNull);
    });

    test('toJson / fromJson round-trip', () {
      final log = BodilyOutputLog(
        id: 'log-bbt-001',
        clientId: 'c1',
        profileId: 'p1',
        occurredAt: 1700000000000,
        outputType: BodyOutputType.bbt,
        temperatureValue: 36.7,
        temperatureUnit: TemperatureUnit.celsius,
        syncMetadata: syncMetadata,
      );
      final json = log.toJson();
      final restored = BodilyOutputLog.fromJson(json);
      expect(restored.id, log.id);
      expect(restored.outputType, log.outputType);
      expect(restored.temperatureValue, log.temperatureValue);
    });

    test('implements Syncable interface', () {
      final log = makeUrine();
      expect(log.id, isA<String>());
      expect(log.clientId, isA<String>());
      expect(log.profileId, isA<String>());
      expect(log.syncMetadata, isA<SyncMetadata>());
      expect(log.toJson(), isA<Map<String, dynamic>>());
    });

    test('isFileUploaded defaults to false', () {
      final log = makeUrine();
      expect(log.isFileUploaded, isFalse);
    });
  });
}
