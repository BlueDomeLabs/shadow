// test/unit/core/repositories/base_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';
import 'package:shadow_app/core/repositories/base_repository.dart';
import 'package:shadow_app/core/services/device_info_service.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

@GenerateMocks([DeviceInfoService])
import 'base_repository_test.mocks.dart';

/// Concrete implementation for testing abstract BaseRepository
class TestRepository extends BaseRepository<TestEntity> {
  TestRepository(super.uuid, super.deviceInfoService);
}

/// Test entity for BaseRepository tests
class TestEntity {
  final String id;
  final String name;
  final SyncMetadata syncMetadata;

  TestEntity({
    required this.id,
    required this.name,
    required this.syncMetadata,
  });

  TestEntity copyWithIdAndSync(String id, SyncMetadata syncMetadata) {
    return TestEntity(id: id, name: name, syncMetadata: syncMetadata);
  }

  TestEntity copyWithSync(SyncMetadata syncMetadata) {
    return TestEntity(id: id, name: name, syncMetadata: syncMetadata);
  }
}

void main() {
  group('BaseRepository', () {
    late MockDeviceInfoService mockDeviceInfoService;
    late Uuid uuid;
    late TestRepository repository;

    const testDeviceId = 'test-device-123';

    setUp(() {
      mockDeviceInfoService = MockDeviceInfoService();
      uuid = const Uuid();
      repository = TestRepository(uuid, mockDeviceInfoService);

      when(
        mockDeviceInfoService.getDeviceId(),
      ).thenAnswer((_) async => testDeviceId);
    });

    group('generateId()', () {
      test('returns existing ID when provided and non-empty', () {
        const existingId = 'existing-id-456';

        final result = repository.generateId(existingId);

        expect(result, equals(existingId));
      });

      test('generates new UUID when existing ID is null', () {
        final result = repository.generateId(null);

        expect(result, isNotEmpty);
        // UUID v4 format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
        expect(result.length, equals(36));
        expect(result.contains('-'), isTrue);
      });

      test('generates new UUID when existing ID is empty', () {
        final result = repository.generateId('');

        expect(result, isNotEmpty);
        expect(result.length, equals(36));
      });

      test('generates unique IDs on each call', () {
        final id1 = repository.generateId(null);
        final id2 = repository.generateId(null);

        expect(id1, isNot(equals(id2)));
      });
    });

    group('createSyncMetadata()', () {
      test('creates metadata with correct device ID', () async {
        final metadata = await repository.createSyncMetadata();

        expect(metadata.syncDeviceId, equals(testDeviceId));
        verify(mockDeviceInfoService.getDeviceId()).called(1);
      });

      test('creates metadata with current timestamp', () async {
        final before = DateTime.now().millisecondsSinceEpoch;
        final metadata = await repository.createSyncMetadata();
        final after = DateTime.now().millisecondsSinceEpoch;

        expect(metadata.syncCreatedAt, greaterThanOrEqualTo(before));
        expect(metadata.syncCreatedAt, lessThanOrEqualTo(after));
      });

      test('creates metadata with pending status', () async {
        final metadata = await repository.createSyncMetadata();

        expect(metadata.syncStatus, equals(SyncStatus.pending));
      });

      test('creates metadata with version 1', () async {
        final metadata = await repository.createSyncMetadata();

        expect(metadata.syncVersion, equals(1));
      });

      test('creates metadata with dirty flag true', () async {
        final metadata = await repository.createSyncMetadata();

        expect(metadata.syncIsDirty, isTrue);
      });
    });

    group('prepareForCreate()', () {
      test('generates ID and creates sync metadata', () async {
        final entity = TestEntity(
          id: '',
          name: 'Test',
          syncMetadata: SyncMetadata.empty(),
        );

        final result = await repository.prepareForCreate<TestEntity>(
          entity,
          (id, syncMetadata) => entity.copyWithIdAndSync(id, syncMetadata),
        );

        expect(result.id, isNotEmpty);
        expect(result.id.length, equals(36)); // UUID format
        expect(result.syncMetadata.syncDeviceId, equals(testDeviceId));
        expect(result.syncMetadata.syncStatus, equals(SyncStatus.pending));
      });

      test('uses existing ID when provided', () async {
        const existingId = 'my-custom-id';
        final entity = TestEntity(
          id: '',
          name: 'Test',
          syncMetadata: SyncMetadata.empty(),
        );

        final result = await repository.prepareForCreate<TestEntity>(
          entity,
          (id, syncMetadata) => entity.copyWithIdAndSync(id, syncMetadata),
          existingId: existingId,
        );

        expect(result.id, equals(existingId));
      });
    });

    group('prepareForUpdate()', () {
      test('updates sync metadata with markModified', () async {
        final originalMetadata = SyncMetadata.create(deviceId: 'old-device');
        final entity = TestEntity(
          id: 'entity-1',
          name: 'Test',
          syncMetadata: originalMetadata,
        );

        final result = await repository.prepareForUpdate<TestEntity>(
          entity,
          (syncMetadata) => entity.copyWithSync(syncMetadata),
          getSyncMetadata: (e) => e.syncMetadata,
        );

        expect(result.syncMetadata.syncDeviceId, equals(testDeviceId));
        expect(result.syncMetadata.syncStatus, equals(SyncStatus.modified));
        expect(
          result.syncMetadata.syncVersion,
          equals(originalMetadata.syncVersion + 1),
        );
        expect(result.syncMetadata.syncIsDirty, isTrue);
      });

      test('returns entity unchanged when markDirty is false', () async {
        final originalMetadata = SyncMetadata.create(deviceId: 'old-device');
        final entity = TestEntity(
          id: 'entity-1',
          name: 'Test',
          syncMetadata: originalMetadata,
        );

        final result = await repository.prepareForUpdate<TestEntity>(
          entity,
          (syncMetadata) => entity.copyWithSync(syncMetadata),
          markDirty: false,
          getSyncMetadata: (e) => e.syncMetadata,
        );

        expect(result, same(entity));
        verifyNever(mockDeviceInfoService.getDeviceId());
      });
    });

    group('prepareForDelete()', () {
      test('marks entity as deleted with markDeleted', () async {
        final originalMetadata = SyncMetadata.create(deviceId: 'old-device');
        final entity = TestEntity(
          id: 'entity-1',
          name: 'Test',
          syncMetadata: originalMetadata,
        );

        final result = await repository.prepareForDelete<TestEntity>(
          entity,
          (syncMetadata) => entity.copyWithSync(syncMetadata),
          getSyncMetadata: (e) => e.syncMetadata,
        );

        expect(result.syncMetadata.syncDeviceId, equals(testDeviceId));
        expect(result.syncMetadata.syncStatus, equals(SyncStatus.deleted));
        expect(result.syncMetadata.syncDeletedAt, isNotNull);
        expect(
          result.syncMetadata.syncVersion,
          equals(originalMetadata.syncVersion + 1),
        );
        expect(result.syncMetadata.syncIsDirty, isTrue);
      });

      test('sets deletedAt timestamp', () async {
        final entity = TestEntity(
          id: 'entity-1',
          name: 'Test',
          syncMetadata: SyncMetadata.create(deviceId: 'old-device'),
        );

        final before = DateTime.now().millisecondsSinceEpoch;
        final result = await repository.prepareForDelete<TestEntity>(
          entity,
          (syncMetadata) => entity.copyWithSync(syncMetadata),
          getSyncMetadata: (e) => e.syncMetadata,
        );
        final after = DateTime.now().millisecondsSinceEpoch;

        expect(result.syncMetadata.syncDeletedAt, greaterThanOrEqualTo(before));
        expect(result.syncMetadata.syncDeletedAt, lessThanOrEqualTo(after));
      });
    });
  });
}
