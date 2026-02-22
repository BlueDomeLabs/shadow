// test/unit/domain/entities/guest_invite_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';

void main() {
  group('GuestInvite', () {
    GuestInvite createTestInvite({
      String id = 'invite-001',
      String profileId = 'profile-001',
      String token = 'token-001',
      String label = 'Test Device',
      int createdAt = 1000,
      int? expiresAt,
      bool isRevoked = false,
      String? activeDeviceId,
    }) => GuestInvite(
      id: id,
      profileId: profileId,
      token: token,
      label: label,
      createdAt: createdAt,
      expiresAt: expiresAt,
      isRevoked: isRevoked,
      activeDeviceId: activeDeviceId,
    );

    group('isActive', () {
      test('isActive_notRevokedNoExpiry_returnsTrue', () {
        final invite = createTestInvite();
        expect(invite.isActive, isTrue);
      });

      test('isActive_revoked_returnsFalse', () {
        final invite = createTestInvite(isRevoked: true);
        expect(invite.isActive, isFalse);
      });

      test('isActive_expired_returnsFalse', () {
        final invite = createTestInvite(expiresAt: 1); // epoch 1ms = expired
        expect(invite.isActive, isFalse);
      });

      test('isActive_futureExpiry_returnsTrue', () {
        final farFuture = DateTime.now().millisecondsSinceEpoch + 999999999;
        final invite = createTestInvite(expiresAt: farFuture);
        expect(invite.isActive, isTrue);
      });

      test('isActive_revokedAndExpired_returnsFalse', () {
        final invite = createTestInvite(isRevoked: true, expiresAt: 1);
        expect(invite.isActive, isFalse);
      });
    });

    group('isActivated', () {
      test('isActivated_withDeviceId_returnsTrue', () {
        final invite = createTestInvite(activeDeviceId: 'device-A');
        expect(invite.isActivated, isTrue);
      });

      test('isActivated_noDeviceId_returnsFalse', () {
        final invite = createTestInvite();
        expect(invite.isActivated, isFalse);
      });
    });

    group('defaults', () {
      test('defaultLabel_isEmptyString', () {
        const invite = GuestInvite(
          id: 'id',
          profileId: 'p',
          token: 't',
          createdAt: 0,
        );
        expect(invite.label, '');
      });

      test('defaultIsRevoked_isFalse', () {
        const invite = GuestInvite(
          id: 'id',
          profileId: 'p',
          token: 't',
          createdAt: 0,
        );
        expect(invite.isRevoked, isFalse);
      });

      test('nullableFieldsDefaultToNull', () {
        const invite = GuestInvite(
          id: 'id',
          profileId: 'p',
          token: 't',
          createdAt: 0,
        );
        expect(invite.expiresAt, isNull);
        expect(invite.lastSeenAt, isNull);
        expect(invite.activeDeviceId, isNull);
      });
    });

    group('copyWith', () {
      test('copyWith_updatesSpecifiedFields', () {
        final invite = createTestInvite();
        final updated = invite.copyWith(
          label: 'New Label',
          activeDeviceId: 'device-B',
        );

        expect(updated.label, 'New Label');
        expect(updated.activeDeviceId, 'device-B');
        // Other fields unchanged
        expect(updated.id, invite.id);
        expect(updated.profileId, invite.profileId);
        expect(updated.token, invite.token);
        expect(updated.createdAt, invite.createdAt);
      });
    });

    group('JSON serialization', () {
      test('toJson_containsAllFields', () {
        final invite = createTestInvite(
          expiresAt: 9999,
          activeDeviceId: 'device-A',
        );
        final json = invite.toJson();

        expect(json['id'], 'invite-001');
        expect(json['profileId'], 'profile-001');
        expect(json['token'], 'token-001');
        expect(json['label'], 'Test Device');
        expect(json['createdAt'], 1000);
        expect(json['expiresAt'], 9999);
        expect(json['isRevoked'], isFalse);
        expect(json['activeDeviceId'], 'device-A');
      });

      test('fromJson_roundTrip', () {
        final invite = createTestInvite(
          expiresAt: 9999,
          activeDeviceId: 'device-A',
        );
        final json = invite.toJson();
        final restored = GuestInvite.fromJson(json);

        expect(restored, invite);
      });

      test('fromJson_withNullOptionalFields', () {
        final invite = createTestInvite();
        final json = invite.toJson();
        final restored = GuestInvite.fromJson(json);

        expect(restored.expiresAt, isNull);
        expect(restored.lastSeenAt, isNull);
        expect(restored.activeDeviceId, isNull);
      });
    });

    group('equality', () {
      test('sameValues_areEqual', () {
        final a = createTestInvite();
        final b = createTestInvite();
        expect(a, b);
      });

      test('differentValues_areNotEqual', () {
        final a = createTestInvite(id: 'a');
        final b = createTestInvite(id: 'b');
        expect(a, isNot(b));
      });
    });
  });
}
