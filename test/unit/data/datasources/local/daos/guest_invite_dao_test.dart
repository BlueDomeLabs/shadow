// test/unit/data/datasources/local/daos/guest_invite_dao_test.dart
// Tests for GuestInviteDao per 22_API_CONTRACTS.md Section 18

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';

void main() {
  group('GuestInviteDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    // Helper to create test invites
    GuestInvite createTestInvite({
      String? id,
      String profileId = 'profile-001',
      String? token,
      String label = 'Test Device',
      int? createdAt,
      int? expiresAt,
      bool isRevoked = false,
      int? lastSeenAt,
      String? activeDeviceId,
    }) {
      final now = DateTime.now().millisecondsSinceEpoch;
      return GuestInvite(
        id: id ?? 'invite-${DateTime.now().microsecondsSinceEpoch}',
        profileId: profileId,
        token: token ?? 'token-${DateTime.now().microsecondsSinceEpoch}',
        label: label,
        createdAt: createdAt ?? now,
        expiresAt: expiresAt,
        isRevoked: isRevoked,
        lastSeenAt: lastSeenAt,
        activeDeviceId: activeDeviceId,
      );
    }

    group('create', () {
      test('create_validInvite_returnsSuccessWithCreatedEntity', () async {
        final invite = createTestInvite(id: 'invite-001', label: 'Phone A');

        final result = await database.guestInviteDao.create(invite);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'invite-001');
        expect(result.valueOrNull?.label, 'Phone A');
      });

      test('create_duplicateId_returnsFailure', () async {
        final invite1 = createTestInvite(id: 'invite-dup', token: 'tok-1');
        final invite2 = createTestInvite(id: 'invite-dup', token: 'tok-2');

        await database.guestInviteDao.create(invite1);
        final result = await database.guestInviteDao.create(invite2);

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });

      test('create_duplicateToken_returnsFailure', () async {
        final invite1 = createTestInvite(id: 'inv-1', token: 'same-token');
        final invite2 = createTestInvite(id: 'inv-2', token: 'same-token');

        await database.guestInviteDao.create(invite1);
        final result = await database.guestInviteDao.create(invite2);

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });

      test('create_withAllFields_preservesAllData', () async {
        final invite = createTestInvite(
          id: 'invite-full',
          profileId: 'profile-full',
          token: 'token-full',
          label: 'Full Invite',
          createdAt: 1000,
          expiresAt: 9999,
          lastSeenAt: 5000,
          activeDeviceId: 'device-abc',
        );

        final result = await database.guestInviteDao.create(invite);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.profileId, 'profile-full');
        expect(created.token, 'token-full');
        expect(created.label, 'Full Invite');
        expect(created.createdAt, 1000);
        expect(created.expiresAt, 9999);
        expect(created.isRevoked, isFalse);
        expect(created.lastSeenAt, 5000);
        expect(created.activeDeviceId, 'device-abc');
      });

      test('create_withNullOptionalFields_preservesNulls', () async {
        final invite = createTestInvite(id: 'invite-min');

        final result = await database.guestInviteDao.create(invite);

        expect(result.isSuccess, isTrue);
        final created = result.valueOrNull!;
        expect(created.expiresAt, isNull);
        expect(created.lastSeenAt, isNull);
        expect(created.activeDeviceId, isNull);
      });
    });

    group('getById', () {
      test('getById_existingInvite_returnsSuccess', () async {
        final invite = createTestInvite(id: 'invite-get');
        await database.guestInviteDao.create(invite);

        final result = await database.guestInviteDao.getById('invite-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'invite-get');
      });

      test('getById_nonExistent_returnsNotFoundError', () async {
        final result = await database.guestInviteDao.getById('nonexistent');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });
    });

    group('getByToken', () {
      test('getByToken_existingToken_returnsInvite', () async {
        final invite = createTestInvite(token: 'find-me-token');
        await database.guestInviteDao.create(invite);

        final result = await database.guestInviteDao.getByToken(
          'find-me-token',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNotNull);
        expect(result.valueOrNull?.token, 'find-me-token');
      });

      test('getByToken_nonExistent_returnsNull', () async {
        final result = await database.guestInviteDao.getByToken(
          'no-such-token',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('getByProfile', () {
      test('getByProfile_returnsOnlyInvitesForProfile', () async {
        await database.guestInviteDao.create(
          createTestInvite(id: 'i1', profileId: 'p-A', token: 't1'),
        );
        await database.guestInviteDao.create(
          createTestInvite(id: 'i2', profileId: 'p-B', token: 't2'),
        );
        await database.guestInviteDao.create(
          createTestInvite(id: 'i3', profileId: 'p-A', token: 't3'),
        );

        final result = await database.guestInviteDao.getByProfile('p-A');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
        expect(result.valueOrNull?.every((i) => i.profileId == 'p-A'), isTrue);
      });

      test('getByProfile_orderedByCreatedAtDescending', () async {
        await database.guestInviteDao.create(
          createTestInvite(
            id: 'i-early',
            profileId: 'p-ord',
            token: 't-early',
            createdAt: 1000,
          ),
        );
        await database.guestInviteDao.create(
          createTestInvite(
            id: 'i-late',
            profileId: 'p-ord',
            token: 't-late',
            createdAt: 3000,
          ),
        );

        final result = await database.guestInviteDao.getByProfile('p-ord');

        expect(result.isSuccess, isTrue);
        final invites = result.valueOrNull!;
        expect(invites[0].id, 'i-late'); // Most recent first
        expect(invites[1].id, 'i-early');
      });

      test('getByProfile_noInvites_returnsEmptyList', () async {
        final result = await database.guestInviteDao.getByProfile('p-empty');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getByProfile_includesRevokedInvites', () async {
        await database.guestInviteDao.create(
          createTestInvite(id: 'i-active', profileId: 'p-rev', token: 'ta'),
        );
        await database.guestInviteDao.create(
          createTestInvite(id: 'i-revoked', profileId: 'p-rev', token: 'tr'),
        );
        await database.guestInviteDao.revoke('i-revoked');

        final result = await database.guestInviteDao.getByProfile('p-rev');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.length, 2);
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingInvite_returnsUpdatedEntity', () async {
        final invite = createTestInvite(id: 'i-update');
        await database.guestInviteDao.create(invite);

        final updated = invite.copyWith(
          label: 'Updated Label',
          lastSeenAt: 5000,
        );
        final result = await database.guestInviteDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.label, 'Updated Label');
        expect(result.valueOrNull?.lastSeenAt, 5000);
      });

      test('updateEntity_nonExistent_returnsNotFoundError', () async {
        final invite = createTestInvite(id: 'nonexistent');

        final result = await database.guestInviteDao.updateEntity(invite);

        expect(result.isFailure, isTrue);
      });

      test('updateEntity_setsActiveDeviceId', () async {
        final invite = createTestInvite(id: 'i-activate');
        await database.guestInviteDao.create(invite);

        final updated = invite.copyWith(activeDeviceId: 'device-123');
        final result = await database.guestInviteDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.activeDeviceId, 'device-123');
      });
    });

    group('revoke', () {
      test('revoke_existingInvite_setsIsRevokedAndClearsDevice', () async {
        final invite = createTestInvite(
          id: 'i-rev',
          activeDeviceId: 'device-old',
        );
        await database.guestInviteDao.create(invite);

        final result = await database.guestInviteDao.revoke('i-rev');

        expect(result.isSuccess, isTrue);

        // Verify the invite was actually revoked
        final getResult = await database.guestInviteDao.getById('i-rev');
        expect(getResult.valueOrNull?.isRevoked, isTrue);
        expect(getResult.valueOrNull?.activeDeviceId, isNull);
      });

      test('revoke_nonExistent_returnsNotFoundError', () async {
        final result = await database.guestInviteDao.revoke('nonexistent');

        expect(result.isFailure, isTrue);
      });
    });

    group('hardDelete', () {
      test('hardDelete_existingInvite_returnsSuccess', () async {
        final invite = createTestInvite(id: 'i-hard');
        await database.guestInviteDao.create(invite);

        final result = await database.guestInviteDao.hardDelete('i-hard');

        expect(result.isSuccess, isTrue);

        // Verify it's gone
        final getResult = await database.guestInviteDao.getById('i-hard');
        expect(getResult.isFailure, isTrue);
      });

      test('hardDelete_nonExistent_returnsNotFoundError', () async {
        final result = await database.guestInviteDao.hardDelete('nonexistent');

        expect(result.isFailure, isTrue);
      });
    });

    group('field mapping', () {
      test('allFields_roundTripCorrectly', () async {
        final invite = createTestInvite(
          id: 'i-round',
          profileId: 'p-round',
          token: 'tok-round',
          label: 'Round Trip',
          createdAt: 1000,
          expiresAt: 9999,
          lastSeenAt: 5000,
          activeDeviceId: 'dev-round',
        );

        await database.guestInviteDao.create(invite);
        final result = await database.guestInviteDao.getById('i-round');

        expect(result.isSuccess, isTrue);
        final entity = result.valueOrNull!;
        expect(entity.id, 'i-round');
        expect(entity.profileId, 'p-round');
        expect(entity.token, 'tok-round');
        expect(entity.label, 'Round Trip');
        expect(entity.createdAt, 1000);
        expect(entity.expiresAt, 9999);
        expect(entity.isRevoked, isFalse);
        expect(entity.lastSeenAt, 5000);
        expect(entity.activeDeviceId, 'dev-round');
      });

      test('defaultLabel_isEmptyString', () async {
        const invite = GuestInvite(
          id: 'i-default',
          profileId: 'p-def',
          token: 'tok-def',
          createdAt: 1000,
        );

        await database.guestInviteDao.create(invite);
        final result = await database.guestInviteDao.getById('i-default');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.label, '');
      });
    });
  });
}
