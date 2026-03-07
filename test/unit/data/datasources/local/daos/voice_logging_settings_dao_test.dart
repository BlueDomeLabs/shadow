// test/unit/data/datasources/local/daos/voice_logging_settings_dao_test.dart

import 'package:drift/drift.dart' hide DatabaseConnection, isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('VoiceLoggingSettingsDao', () {
    late AppDatabase database;

    const profileId = 'profile-001';
    const now = 1700000000000;

    VoiceLoggingSettingsTableCompanion makeCompanion({
      String id = profileId,
      String pId = profileId,
      int closingStyle = 1,
      String? fixedFarewell,
      String? categoryPriorityOrder,
    }) => VoiceLoggingSettingsTableCompanion(
      id: Value(id),
      profileId: Value(pId),
      closingStyle: Value(closingStyle),
      fixedFarewell: Value(fixedFarewell),
      categoryPriorityOrder: Value(categoryPriorityOrder),
      createdAt: const Value(now),
    );

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    test('getByProfileId_returnsNull_whenAbsent', () async {
      final row = await database.voiceLoggingSettingsDao.getByProfileId(
        'nonexistent',
      );
      expect(row, isNull);
    });

    test('upsert_insertsRow_andGetByProfileId_returnsIt', () async {
      await database.voiceLoggingSettingsDao.upsert(makeCompanion());
      final row = await database.voiceLoggingSettingsDao.getByProfileId(
        profileId,
      );
      expect(row, isNotNull);
      expect(row!.profileId, profileId);
      expect(row.closingStyle, 1);
    });

    test('upsert_updatesExistingRow_onConflict', () async {
      await database.voiceLoggingSettingsDao.upsert(makeCompanion());
      await database.voiceLoggingSettingsDao.upsert(
        makeCompanion(closingStyle: 2, fixedFarewell: 'Bye!'),
      );

      final row = await database.voiceLoggingSettingsDao.getByProfileId(
        profileId,
      );
      expect(row!.closingStyle, 2);
      expect(row.fixedFarewell, 'Bye!');
    });

    test('upsert_storesFixedFarewell', () async {
      await database.voiceLoggingSettingsDao.upsert(
        makeCompanion(fixedFarewell: 'See you later!'),
      );
      final row = await database.voiceLoggingSettingsDao.getByProfileId(
        profileId,
      );
      expect(row!.fixedFarewell, 'See you later!');
    });

    test('upsert_storesCategoryPriorityOrder_asJson', () async {
      await database.voiceLoggingSettingsDao.upsert(
        makeCompanion(categoryPriorityOrder: '[0,2,1]'),
      );
      final row = await database.voiceLoggingSettingsDao.getByProfileId(
        profileId,
      );
      expect(row!.categoryPriorityOrder, '[0,2,1]');
    });

    test('getByProfileId_returnsNull_forDifferentProfile', () async {
      await database.voiceLoggingSettingsDao.upsert(makeCompanion());
      final row = await database.voiceLoggingSettingsDao.getByProfileId(
        'profile-999',
      );
      expect(row, isNull);
    });
  });
}
