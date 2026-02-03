// test/unit/domain/entities/sync_metadata_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

void main() {
  group('SyncMetadata', () {
    const testDeviceId = 'test-device-123';

    group('factory create()', () {
      test('creates with current timestamp', () {
        final before = DateTime.now().millisecondsSinceEpoch;
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        final after = DateTime.now().millisecondsSinceEpoch;

        expect(metadata.syncCreatedAt, greaterThanOrEqualTo(before));
        expect(metadata.syncCreatedAt, lessThanOrEqualTo(after));
        expect(metadata.syncUpdatedAt, equals(metadata.syncCreatedAt));
        expect(metadata.syncDeviceId, equals(testDeviceId));
      });

      test('creates with default sync status pending', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        expect(metadata.syncStatus, equals(SyncStatus.pending));
      });

      test('creates with default version 1', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        expect(metadata.syncVersion, equals(1));
      });

      test('creates with dirty flag true', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        expect(metadata.syncIsDirty, isTrue);
      });

      test('creates with null optional fields', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        expect(metadata.syncDeletedAt, isNull);
        expect(metadata.syncLastSyncedAt, isNull);
        expect(metadata.conflictData, isNull);
      });
    });

    group('factory empty()', () {
      test('creates with zero timestamps', () {
        final metadata = SyncMetadata.empty();

        expect(metadata.syncCreatedAt, equals(0));
        expect(metadata.syncUpdatedAt, equals(0));
      });

      test('creates with empty deviceId', () {
        final metadata = SyncMetadata.empty();

        expect(metadata.syncDeviceId, isEmpty);
      });

      test('needsInitialization returns true', () {
        final metadata = SyncMetadata.empty();

        expect(metadata.needsInitialization, isTrue);
      });
    });

    group('markModified()', () {
      test('updates timestamp', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        final originalUpdatedAt = metadata.syncUpdatedAt;

        // Small delay to ensure timestamp changes
        final modified = metadata.markModified('new-device');

        expect(modified.syncUpdatedAt, greaterThanOrEqualTo(originalUpdatedAt));
      });

      test('updates device id', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final modified = metadata.markModified('new-device-456');

        expect(modified.syncDeviceId, equals('new-device-456'));
      });

      test('sets dirty flag to true', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId).markSynced();
        expect(metadata.syncIsDirty, isFalse);

        final modified = metadata.markModified(testDeviceId);

        expect(modified.syncIsDirty, isTrue);
      });

      test('sets status to modified', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final modified = metadata.markModified(testDeviceId);

        expect(modified.syncStatus, equals(SyncStatus.modified));
      });

      test('increments version by 1', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        expect(metadata.syncVersion, equals(1));

        final modified = metadata.markModified(testDeviceId);

        expect(modified.syncVersion, equals(2));
      });

      test('preserves createdAt timestamp', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final modified = metadata.markModified('new-device');

        expect(modified.syncCreatedAt, equals(metadata.syncCreatedAt));
      });
    });

    group('markSynced()', () {
      test('clears dirty flag', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        expect(metadata.syncIsDirty, isTrue);

        final synced = metadata.markSynced();

        expect(synced.syncIsDirty, isFalse);
      });

      test('sets status to synced', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final synced = metadata.markSynced();

        expect(synced.syncStatus, equals(SyncStatus.synced));
      });

      test('updates lastSyncedAt timestamp', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        expect(metadata.syncLastSyncedAt, isNull);

        final before = DateTime.now().millisecondsSinceEpoch;
        final synced = metadata.markSynced();
        final after = DateTime.now().millisecondsSinceEpoch;

        expect(synced.syncLastSyncedAt, isNotNull);
        expect(synced.syncLastSyncedAt, greaterThanOrEqualTo(before));
        expect(synced.syncLastSyncedAt, lessThanOrEqualTo(after));
      });

      test('does NOT increment version (critical for conflict detection)', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        expect(metadata.syncVersion, equals(1));

        final synced = metadata.markSynced();

        expect(synced.syncVersion, equals(1));
      });
    });

    group('markDeleted()', () {
      test('sets deletedAt timestamp', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        expect(metadata.syncDeletedAt, isNull);

        final before = DateTime.now().millisecondsSinceEpoch;
        final deleted = metadata.markDeleted(testDeviceId);
        final after = DateTime.now().millisecondsSinceEpoch;

        expect(deleted.syncDeletedAt, isNotNull);
        expect(deleted.syncDeletedAt, greaterThanOrEqualTo(before));
        expect(deleted.syncDeletedAt, lessThanOrEqualTo(after));
      });

      test('updates updatedAt timestamp', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        final originalUpdatedAt = metadata.syncUpdatedAt;

        final deleted = metadata.markDeleted(testDeviceId);

        expect(deleted.syncUpdatedAt, greaterThanOrEqualTo(originalUpdatedAt));
      });

      test('updates device id', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final deleted = metadata.markDeleted('deleting-device');

        expect(deleted.syncDeviceId, equals('deleting-device'));
      });

      test('sets dirty flag to true', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId).markSynced();
        expect(metadata.syncIsDirty, isFalse);

        final deleted = metadata.markDeleted(testDeviceId);

        expect(deleted.syncIsDirty, isTrue);
      });

      test('sets status to deleted', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final deleted = metadata.markDeleted(testDeviceId);

        expect(deleted.syncStatus, equals(SyncStatus.deleted));
      });

      test('increments version by 1 (delete is a local change)', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);
        expect(metadata.syncVersion, equals(1));

        final deleted = metadata.markDeleted(testDeviceId);

        expect(deleted.syncVersion, equals(2));
      });
    });

    group('isDeleted getter', () {
      test('returns false when syncDeletedAt is null', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        expect(metadata.isDeleted, isFalse);
      });

      test('returns true when syncDeletedAt is set', () {
        final metadata =
            SyncMetadata.create(deviceId: testDeviceId).markDeleted(testDeviceId);

        expect(metadata.isDeleted, isTrue);
      });
    });

    group('needsInitialization getter', () {
      test('returns true when deviceId is empty', () {
        final metadata = SyncMetadata.empty();

        expect(metadata.needsInitialization, isTrue);
      });

      test('returns false when deviceId is set', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        expect(metadata.needsInitialization, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson uses snake_case keys', () {
        final metadata = SyncMetadata.create(deviceId: testDeviceId);

        final json = metadata.toJson();

        expect(json.containsKey('sync_created_at'), isTrue);
        expect(json.containsKey('sync_updated_at'), isTrue);
        expect(json.containsKey('sync_deleted_at'), isTrue);
        expect(json.containsKey('sync_last_synced_at'), isTrue);
        expect(json.containsKey('sync_status'), isTrue);
        expect(json.containsKey('sync_version'), isTrue);
        expect(json.containsKey('sync_device_id'), isTrue);
        expect(json.containsKey('sync_is_dirty'), isTrue);
        expect(json.containsKey('conflict_data'), isTrue);
      });

      test('fromJson parses snake_case keys', () {
        final json = {
          'sync_created_at': 1000,
          'sync_updated_at': 2000,
          'sync_deleted_at': null,
          'sync_last_synced_at': null,
          'sync_status': 'synced', // json_serializable uses enum names
          'sync_version': 5,
          'sync_device_id': 'device-abc',
          'sync_is_dirty': false,
          'conflict_data': null,
        };

        final metadata = SyncMetadata.fromJson(json);

        expect(metadata.syncCreatedAt, equals(1000));
        expect(metadata.syncUpdatedAt, equals(2000));
        expect(metadata.syncDeletedAt, isNull);
        expect(metadata.syncLastSyncedAt, isNull);
        expect(metadata.syncStatus, equals(SyncStatus.synced));
        expect(metadata.syncVersion, equals(5));
        expect(metadata.syncDeviceId, equals('device-abc'));
        expect(metadata.syncIsDirty, isFalse);
        expect(metadata.conflictData, isNull);
      });

      test('round-trip serialization preserves data', () {
        final original = SyncMetadata(
          syncCreatedAt: 1000,
          syncUpdatedAt: 2000,
          syncDeletedAt: 3000,
          syncLastSyncedAt: 4000,
          syncStatus: SyncStatus.conflict,
          syncVersion: 10,
          syncDeviceId: 'device-xyz',
          syncIsDirty: true,
          conflictData: '{"key": "value"}',
        );

        final json = original.toJson();
        final restored = SyncMetadata.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });

  group('SyncStatus', () {
    test('has correct integer values', () {
      expect(SyncStatus.pending.value, equals(0));
      expect(SyncStatus.synced.value, equals(1));
      expect(SyncStatus.modified.value, equals(2));
      expect(SyncStatus.conflict.value, equals(3));
      expect(SyncStatus.deleted.value, equals(4));
    });

    test('fromValue returns correct enum', () {
      expect(SyncStatus.fromValue(0), equals(SyncStatus.pending));
      expect(SyncStatus.fromValue(1), equals(SyncStatus.synced));
      expect(SyncStatus.fromValue(2), equals(SyncStatus.modified));
      expect(SyncStatus.fromValue(3), equals(SyncStatus.conflict));
      expect(SyncStatus.fromValue(4), equals(SyncStatus.deleted));
    });

    test('fromValue returns pending for invalid value', () {
      expect(SyncStatus.fromValue(-1), equals(SyncStatus.pending));
      expect(SyncStatus.fromValue(99), equals(SyncStatus.pending));
    });
  });
}
