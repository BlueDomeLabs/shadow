// test/unit/data/datasources/local/daos/health_sync_status_dao_test.dart
// Phase 16a — Tests for HealthSyncStatusDao
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('HealthSyncStatusDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    HealthSyncStatus createStatus({
      String profileId = 'profile-001',
      HealthDataType dataType = HealthDataType.heartRate,
      int? lastSyncedAt,
      int recordCount = 0,
      String? lastError,
    }) => HealthSyncStatus(
      id: HealthSyncStatus.makeId(profileId, dataType),
      profileId: profileId,
      dataType: dataType,
      lastSyncedAt: lastSyncedAt,
      recordCount: recordCount,
      lastError: lastError,
    );

    group('getByProfile', () {
      test('returns empty list when no status rows exist', () async {
        final result = await database.healthSyncStatusDao.getByProfile(
          'no-profile',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('returns all rows for a profile', () async {
        await database.healthSyncStatusDao.upsert(createStatus());
        await database.healthSyncStatusDao.upsert(
          createStatus(dataType: HealthDataType.weight),
        );

        final result = await database.healthSyncStatusDao.getByProfile(
          'profile-001',
        );

        expect(result.valueOrNull?.length, 2);
      });

      test('returns only rows for the requested profile', () async {
        await database.healthSyncStatusDao.upsert(
          createStatus(dataType: HealthDataType.steps),
        );
        await database.healthSyncStatusDao.upsert(
          createStatus(
            profileId: 'profile-002',
            dataType: HealthDataType.steps,
          ),
        );

        final result = await database.healthSyncStatusDao.getByProfile(
          'profile-001',
        );

        expect(result.valueOrNull?.length, 1);
        expect(result.valueOrNull?.first.profileId, 'profile-001');
      });
    });

    group('getByDataType', () {
      test('returns null when no row exists for dataType', () async {
        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test(
        'returns the row for a matching (profileId, dataType) pair',
        () async {
          await database.healthSyncStatusDao.upsert(createStatus());

          final result = await database.healthSyncStatusDao.getByDataType(
            'profile-001',
            HealthDataType.heartRate,
          );

          expect(result.isSuccess, isTrue);
          expect(result.valueOrNull?.dataType, HealthDataType.heartRate);
        },
      );

      test(
        'returns null when profileId matches but dataType does not',
        () async {
          await database.healthSyncStatusDao.upsert(createStatus());

          final result = await database.healthSyncStatusDao.getByDataType(
            'profile-001',
            HealthDataType.weight,
          );

          expect(result.valueOrNull, isNull);
        },
      );

      test(
        'returns null when dataType matches but profileId does not',
        () async {
          await database.healthSyncStatusDao.upsert(createStatus());

          final result = await database.healthSyncStatusDao.getByDataType(
            'profile-002',
            HealthDataType.heartRate,
          );

          expect(result.valueOrNull, isNull);
        },
      );
    });

    group('upsert', () {
      test('inserts a new row successfully', () async {
        final status = createStatus();

        final result = await database.healthSyncStatusDao.upsert(status);

        expect(result.isSuccess, isTrue);
      });

      test('updates existing row on conflict', () async {
        final original = createStatus(recordCount: 5);
        await database.healthSyncStatusDao.upsert(original);

        final updated = original.copyWith(recordCount: 42);
        await database.healthSyncStatusDao.upsert(updated);

        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull?.recordCount, 42);
      });

      test('stores nullable lastSyncedAt as null', () async {
        final status = createStatus();
        await database.healthSyncStatusDao.upsert(status);

        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull?.lastSyncedAt, isNull);
      });

      test('stores lastSyncedAt when provided', () async {
        final ts = DateTime(2024, 6).millisecondsSinceEpoch;
        final status = createStatus(lastSyncedAt: ts);
        await database.healthSyncStatusDao.upsert(status);

        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull?.lastSyncedAt, ts);
      });

      test('stores nullable lastError as null', () async {
        final status = createStatus();
        await database.healthSyncStatusDao.upsert(status);

        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull?.lastError, isNull);
      });

      test('stores lastError when provided', () async {
        final status = createStatus(lastError: 'Permission denied');
        await database.healthSyncStatusDao.upsert(status);

        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-001',
          HealthDataType.heartRate,
        );

        expect(result.valueOrNull?.lastError, 'Permission denied');
      });

      test('maps all fields correctly', () async {
        final ts = DateTime(2024, 3, 15).millisecondsSinceEpoch;
        final status = HealthSyncStatus(
          id: HealthSyncStatus.makeId('profile-abc', HealthDataType.weight),
          profileId: 'profile-abc',
          dataType: HealthDataType.weight,
          lastSyncedAt: ts,
          recordCount: 17,
        );
        await database.healthSyncStatusDao.upsert(status);

        final result = await database.healthSyncStatusDao.getByDataType(
          'profile-abc',
          HealthDataType.weight,
        );
        final s = result.valueOrNull!;

        expect(s.id, 'profile-abc_${HealthDataType.weight.value}');
        expect(s.profileId, 'profile-abc');
        expect(s.dataType, HealthDataType.weight);
        expect(s.lastSyncedAt, ts);
        expect(s.recordCount, 17);
        expect(s.lastError, isNull);
      });
    });
  });
}
