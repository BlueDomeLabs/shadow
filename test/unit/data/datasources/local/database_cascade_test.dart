// test/unit/data/datasources/local/database_cascade_test.dart
// Integration tests for AppDatabase.deleteProfileCascade

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/datasources/local/database.dart';

void main() {
  group('AppDatabase.deleteProfileCascade', () {
    late AppDatabase database;

    const profileId = 'cascade-profile-001';
    const otherProfileId = 'other-profile-999';

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    Future<void> insertSupplement(String id, String pid) async {
      await database.customStatement(
        'INSERT INTO supplements '
        '(id, client_id, profile_id, name, form, dosage_quantity, dosage_unit, '
        'sync_created_at, sync_updated_at, sync_device_id) '
        "VALUES ('$id', 'client-$id', '$pid', 'Supplement $id', 0, 0, 0, 0, 0, 'device-001')",
      );
    }

    Future<void> insertSleepEntry(String id, String pid) async {
      await database.customStatement(
        'INSERT INTO sleep_entries '
        '(id, client_id, profile_id, bed_time, wake_time, '
        'deep_sleep_minutes, light_sleep_minutes, restless_sleep_minutes, '
        'dream_type, waking_feeling, '
        'sync_created_at, sync_updated_at, sync_device_id) '
        "VALUES ('$id', 'client-$id', '$pid', 0, 0, 0, 0, 0, 0, 0, 0, 0, 'device-001')",
      );
    }

    Future<void> insertGuestInvite(String id, String pid) async {
      await database.customStatement(
        'INSERT INTO guest_invites (id, profile_id, token, created_at) '
        "VALUES ('$id', '$pid', 'token-$id', 0)",
      );
    }

    Future<void> insertProfile(String id) async {
      await database.customStatement(
        'INSERT INTO profiles '
        '(id, client_id, name, sync_created_at, sync_updated_at, sync_device_id) '
        "VALUES ('$id', 'client-$id', 'Profile $id', 0, 0, 'device-001')",
      );
    }

    test('soft-deletes supplements for the profile', () async {
      await insertProfile(profileId);
      await insertSupplement('supp-001', profileId);
      await insertSupplement('supp-002', profileId);

      await database.deleteProfileCascade(profileId);

      final rows = await database
          .customSelect(
            'SELECT sync_deleted_at, sync_status FROM supplements '
            "WHERE profile_id = '$profileId'",
          )
          .get();

      expect(rows, hasLength(2));
      for (final row in rows) {
        expect(row.read<int?>('sync_deleted_at'), isNotNull);
        expect(row.read<int>('sync_status'), equals(4)); // SyncStatus.deleted
      }
    });

    test('does not affect rows belonging to other profiles', () async {
      await insertProfile(profileId);
      await insertProfile(otherProfileId);
      await insertSupplement('supp-mine', profileId);
      await insertSupplement('supp-other', otherProfileId);

      await database.deleteProfileCascade(profileId);

      final otherRow = await database
          .customSelect(
            "SELECT sync_deleted_at FROM supplements WHERE id = 'supp-other'",
          )
          .getSingle();

      expect(otherRow.read<int?>('sync_deleted_at'), isNull);
    });

    test('soft-deletes sleep entries for the profile', () async {
      await insertProfile(profileId);
      await insertSleepEntry('sleep-001', profileId);

      await database.deleteProfileCascade(profileId);

      final row = await database
          .customSelect(
            'SELECT sync_deleted_at FROM sleep_entries '
            "WHERE profile_id = '$profileId'",
          )
          .getSingle();

      expect(row.read<int?>('sync_deleted_at'), isNotNull);
    });

    test('hard-deletes guest_invites for the profile', () async {
      await insertProfile(profileId);
      await insertGuestInvite('invite-001', profileId);
      await insertGuestInvite('invite-002', profileId);

      await database.deleteProfileCascade(profileId);

      final rows = await database
          .customSelect(
            "SELECT id FROM guest_invites WHERE profile_id = '$profileId'",
          )
          .get();

      expect(rows, isEmpty);
    });

    test('soft-deletes the profile itself', () async {
      await insertProfile(profileId);

      await database.deleteProfileCascade(profileId);

      final row = await database
          .customSelect(
            'SELECT sync_deleted_at, sync_status FROM profiles '
            "WHERE id = '$profileId'",
          )
          .getSingle();

      expect(row.read<int?>('sync_deleted_at'), isNotNull);
      expect(row.read<int>('sync_status'), equals(4)); // SyncStatus.deleted
    });
  });
}
