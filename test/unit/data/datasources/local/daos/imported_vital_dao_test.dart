// test/unit/data/datasources/local/daos/imported_vital_dao_test.dart
// Phase 16a — Tests for ImportedVitalDao
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/imported_vital.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('ImportedVitalDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    ImportedVital createVital({
      String? id,
      String profileId = 'profile-001',
      String clientId = 'client-001',
      HealthDataType dataType = HealthDataType.heartRate,
      double value = 72,
      String unit = 'bpm',
      int? recordedAt,
      HealthSourcePlatform sourcePlatform = HealthSourcePlatform.appleHealth,
      String? sourceDevice,
      int? importedAt,
      int? syncCreatedAt,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return ImportedVital(
        id: id ?? 'vital-${DateTime.now().microsecondsSinceEpoch}',
        clientId: clientId,
        profileId: profileId,
        dataType: dataType,
        value: value,
        unit: unit,
        recordedAt: recordedAt ?? now,
        sourcePlatform: sourcePlatform,
        sourceDevice: sourceDevice,
        importedAt: importedAt ?? now,
        syncMetadata: SyncMetadata(
          syncCreatedAt: syncCreatedAt ?? now,
          syncUpdatedAt: syncCreatedAt ?? now,
          syncDeviceId: 'test-device',
        ),
      );
    }

    group('insertIfNotDuplicate', () {
      test('inserts new vital successfully', () async {
        final vital = createVital(id: 'vital-001');

        final result = await database.importedVitalDao.insertIfNotDuplicate(
          vital,
        );

        expect(result.isSuccess, isTrue);
      });

      test('upserts on duplicate id (insertOnConflictUpdate)', () async {
        final vital = createVital(id: 'vital-dup', value: 70);
        await database.importedVitalDao.insertIfNotDuplicate(vital);

        final updated = vital.copyWith(value: 80);
        final result = await database.importedVitalDao.insertIfNotDuplicate(
          updated,
        );

        expect(result.isSuccess, isTrue);
      });

      test('stores nullable sourceDevice as null', () async {
        final vital = createVital(id: 'vital-no-device');
        await database.importedVitalDao.insertIfNotDuplicate(vital);

        final rows = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
        );
        expect(rows.valueOrNull?.first.sourceDevice, isNull);
      });

      test('stores sourceDevice when provided', () async {
        final vital = createVital(
          id: 'vital-dev',
          sourceDevice: 'Apple Watch Series 9',
        );
        await database.importedVitalDao.insertIfNotDuplicate(vital);

        final rows = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
        );
        expect(rows.valueOrNull?.first.sourceDevice, 'Apple Watch Series 9');
      });
    });

    group('getByProfile', () {
      test('returns empty list when no vitals', () async {
        final result = await database.importedVitalDao.getByProfile(
          profileId: 'no-profile',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('returns only vitals for the requested profile', () async {
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-p1'),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-p2', profileId: 'profile-002'),
        );

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
        );

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'v-p1');
      });

      test('filters by startEpoch', () async {
        final early = DateTime(2024).millisecondsSinceEpoch;
        final late_ = DateTime(2024, 6).millisecondsSinceEpoch;
        final mid = DateTime(2024, 3).millisecondsSinceEpoch;

        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-early', recordedAt: early),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-late', recordedAt: late_),
        );

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
          startEpoch: mid,
        );

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'v-late');
      });

      test('filters by endEpoch', () async {
        final early = DateTime(2024).millisecondsSinceEpoch;
        final late_ = DateTime(2024, 6).millisecondsSinceEpoch;
        final mid = DateTime(2024, 3).millisecondsSinceEpoch;

        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-early', recordedAt: early),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-late', recordedAt: late_),
        );

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
          endEpoch: mid,
        );

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'v-early');
      });

      test('filters by dataType', () async {
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-hr'),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-wt', dataType: HealthDataType.weight),
        );

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
          dataType: HealthDataType.weight,
        );

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.dataType, HealthDataType.weight);
      });

      test('excludes soft-deleted records', () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final vital = createVital(id: 'v-deleted').copyWith(
          syncMetadata: SyncMetadata(
            syncCreatedAt: now,
            syncUpdatedAt: now,
            syncDeletedAt: now,
            syncDeviceId: 'test-device',
          ),
        );
        await database.importedVitalDao.insertIfNotDuplicate(vital);

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
        );

        expect(result.valueOrNull, isEmpty);
      });

      test('orders results by recordedAt descending', () async {
        final t1 = DateTime(2024).millisecondsSinceEpoch;
        final t2 = DateTime(2024, 3).millisecondsSinceEpoch;
        final t3 = DateTime(2024, 6).millisecondsSinceEpoch;

        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-mid', recordedAt: t2),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-early', recordedAt: t1),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-late', recordedAt: t3),
        );

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
        );

        final ids = result.valueOrNull?.map((v) => v.id).toList();
        expect(ids, ['v-late', 'v-mid', 'v-early']);
      });

      test('maps all fields correctly', () async {
        final recordedAt = DateTime(2024, 5, 15).millisecondsSinceEpoch;
        final importedAt = DateTime(2024, 5, 16).millisecondsSinceEpoch;
        final vital = createVital(
          id: 'vital-map',
          dataType: HealthDataType.weight,
          value: 72.5,
          unit: 'kg',
          recordedAt: recordedAt,
          sourcePlatform: HealthSourcePlatform.googleHealthConnect,
          sourceDevice: 'Pixel Watch',
          importedAt: importedAt,
        );
        await database.importedVitalDao.insertIfNotDuplicate(vital);

        final result = await database.importedVitalDao.getByProfile(
          profileId: 'profile-001',
        );
        final v = result.valueOrNull?.first;

        expect(v?.id, 'vital-map');
        expect(v?.clientId, 'client-001');
        expect(v?.profileId, 'profile-001');
        expect(v?.dataType, HealthDataType.weight);
        expect(v?.value, 72.5);
        expect(v?.unit, 'kg');
        expect(v?.recordedAt, recordedAt);
        expect(v?.sourcePlatform, HealthSourcePlatform.googleHealthConnect);
        expect(v?.sourceDevice, 'Pixel Watch');
        expect(v?.importedAt, importedAt);
      });
    });

    group('getLastImportTime', () {
      test('returns null when no records exist', () async {
        final result = await database.importedVitalDao.getLastImportTime(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('returns most recent importedAt for the given type', () async {
        final t1 = DateTime(2024).millisecondsSinceEpoch;
        final t2 = DateTime(2024, 6).millisecondsSinceEpoch;

        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-hr-old', importedAt: t1),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-hr-new', importedAt: t2),
        );

        final result = await database.importedVitalDao.getLastImportTime(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull, t2);
      });

      test('ignores different data types', () async {
        final hrTime = DateTime(2024).millisecondsSinceEpoch;
        final wtTime = DateTime(2024, 6).millisecondsSinceEpoch;

        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-hr', importedAt: hrTime),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(
            id: 'v-wt',
            dataType: HealthDataType.weight,
            importedAt: wtTime,
          ),
        );

        final result = await database.importedVitalDao.getLastImportTime(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull, hrTime);
      });

      test('ignores soft-deleted records', () async {
        final now = DateTime.now().millisecondsSinceEpoch;
        final vital = createVital(id: 'v-del-hr', importedAt: now).copyWith(
          syncMetadata: SyncMetadata(
            syncCreatedAt: now,
            syncUpdatedAt: now,
            syncDeletedAt: now,
            syncDeviceId: 'test-device',
          ),
        );
        await database.importedVitalDao.insertIfNotDuplicate(vital);

        final result = await database.importedVitalDao.getLastImportTime(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull, isNull);
      });
    });

    group('getModifiedSince', () {
      test('returns empty list when nothing modified', () async {
        final result = await database.importedVitalDao.getModifiedSince(
          DateTime(2099).millisecondsSinceEpoch,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('returns records modified after the given timestamp', () async {
        final t0 = DateTime(2024).millisecondsSinceEpoch;
        final t1 = DateTime(2024, 3).millisecondsSinceEpoch;
        final t2 = DateTime(2024, 6).millisecondsSinceEpoch;

        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-old', syncCreatedAt: t0),
        );
        await database.importedVitalDao.insertIfNotDuplicate(
          createVital(id: 'v-new', syncCreatedAt: t2),
        );

        final result = await database.importedVitalDao.getModifiedSince(t1);

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.id, 'v-new');
      });
    });
  });
}
