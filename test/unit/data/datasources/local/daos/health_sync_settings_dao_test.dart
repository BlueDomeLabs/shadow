// test/unit/data/datasources/local/daos/health_sync_settings_dao_test.dart
// Phase 16a — Tests for HealthSyncSettingsDao
// Per 61_HEALTH_PLATFORM_INTEGRATION.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/health_sync_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('HealthSyncSettingsDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    HealthSyncSettings createSettings({
      String profileId = 'profile-001',
      List<HealthDataType>? enabledDataTypes,
      int dateRangeDays = 30,
    }) => HealthSyncSettings(
      id: profileId,
      profileId: profileId,
      enabledDataTypes: enabledDataTypes ?? HealthDataType.values.toList(),
      dateRangeDays: dateRangeDays,
    );

    group('getByProfile', () {
      test('returns null when no settings exist', () async {
        final result = await database.healthSyncSettingsDao.getByProfile(
          'no-profile',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });

      test('returns settings when found', () async {
        final settings = createSettings();
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-001',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNotNull);
        expect(result.valueOrNull?.profileId, 'profile-001');
      });

      test('returns null for different profile', () async {
        final settings = createSettings();
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-002',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('save', () {
      test('creates new settings successfully', () async {
        final settings = createSettings();

        final result = await database.healthSyncSettingsDao.save(settings);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.profileId, 'profile-001');
      });

      test('updates existing settings on conflict', () async {
        final original = createSettings();
        await database.healthSyncSettingsDao.save(original);

        final updated = original.copyWith(dateRangeDays: 90);
        final result = await database.healthSyncSettingsDao.save(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.dateRangeDays, 90);
      });

      test('encodes and decodes enabledDataTypes correctly', () async {
        final types = [HealthDataType.heartRate, HealthDataType.weight];
        final settings = createSettings(enabledDataTypes: types);
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-001',
        );

        expect(result.valueOrNull?.enabledDataTypes, types);
      });

      test('stores empty enabledDataTypes as empty list', () async {
        final settings = createSettings(enabledDataTypes: []);
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-001',
        );

        expect(result.valueOrNull?.enabledDataTypes, isEmpty);
      });

      test('stores all data types when all enabled', () async {
        final settings = createSettings(
          enabledDataTypes: HealthDataType.values.toList(),
        );
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-001',
        );

        expect(
          result.valueOrNull?.enabledDataTypes,
          HealthDataType.values.toList(),
        );
      });

      test('maps all fields correctly', () async {
        const settings = HealthSyncSettings(
          id: 'profile-abc',
          profileId: 'profile-abc',
          enabledDataTypes: [
            HealthDataType.steps,
            HealthDataType.sleepDuration,
          ],
          dateRangeDays: 60,
        );
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-abc',
        );
        final s = result.valueOrNull!;

        expect(s.id, 'profile-abc');
        expect(s.profileId, 'profile-abc');
        expect(s.enabledDataTypes, [
          HealthDataType.steps,
          HealthDataType.sleepDuration,
        ]);
        expect(s.dateRangeDays, 60);
      });

      test('dateRangeDays default is 30', () async {
        final settings = createSettings();
        await database.healthSyncSettingsDao.save(settings);

        final result = await database.healthSyncSettingsDao.getByProfile(
          'profile-001',
        );

        expect(result.valueOrNull?.dateRangeDays, 30);
      });
    });
  });
}
