// test/unit/domain/entities/voice_logging/voice_logging_settings_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/voice_logging/voice_logging_settings.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('VoiceLoggingSettings', () {
    const profileId = 'profile-001';
    const now = 1700000000000;

    test('construction_setsAllFields', () {
      const s = VoiceLoggingSettings(
        id: profileId,
        profileId: profileId,
        closingStyle: ClosingStyle.fixed,
        fixedFarewell: 'See you tomorrow!',
        categoryPriorityOrder: [0, 1, 2],
        createdAt: now,
        updatedAt: now + 1000,
      );

      expect(s.id, profileId);
      expect(s.profileId, profileId);
      expect(s.closingStyle, ClosingStyle.fixed);
      expect(s.fixedFarewell, 'See you tomorrow!');
      expect(s.categoryPriorityOrder, [0, 1, 2]);
      expect(s.createdAt, now);
      expect(s.updatedAt, now + 1000);
    });

    test('construction_optionalFieldsDefaultToNull', () {
      const s = VoiceLoggingSettings(
        id: profileId,
        profileId: profileId,
        closingStyle: ClosingStyle.random,
        createdAt: now,
      );

      expect(s.fixedFarewell, isNull);
      expect(s.categoryPriorityOrder, isNull);
      expect(s.updatedAt, isNull);
    });

    test('copyWith_updatesClosingStyle', () {
      const original = VoiceLoggingSettings(
        id: profileId,
        profileId: profileId,
        closingStyle: ClosingStyle.random,
        createdAt: now,
      );
      final updated = original.copyWith(closingStyle: ClosingStyle.none);
      expect(updated.closingStyle, ClosingStyle.none);
      expect(updated.profileId, profileId); // unchanged
    });

    test('copyWith_updatesFixedFarewell', () {
      const original = VoiceLoggingSettings(
        id: profileId,
        profileId: profileId,
        closingStyle: ClosingStyle.fixed,
        createdAt: now,
      );
      final updated = original.copyWith(fixedFarewell: 'Goodbye!');
      expect(updated.fixedFarewell, 'Goodbye!');
    });

    test('copyWith_updatesCategoryPriorityOrder', () {
      const original = VoiceLoggingSettings(
        id: profileId,
        profileId: profileId,
        closingStyle: ClosingStyle.random,
        createdAt: now,
      );
      final updated = original.copyWith(categoryPriorityOrder: [2, 0, 1]);
      expect(updated.categoryPriorityOrder, [2, 0, 1]);
    });

    test('copyWith_preservesUnchangedFields', () {
      const original = VoiceLoggingSettings(
        id: profileId,
        profileId: profileId,
        closingStyle: ClosingStyle.fixed,
        fixedFarewell: 'Bye!',
        categoryPriorityOrder: [1, 0],
        createdAt: now,
        updatedAt: now + 1000,
      );
      final updated = original.copyWith(updatedAt: now + 9999);
      expect(updated.closingStyle, ClosingStyle.fixed);
      expect(updated.fixedFarewell, 'Bye!');
      expect(updated.categoryPriorityOrder, [1, 0]);
      expect(updated.createdAt, now);
      expect(updated.updatedAt, now + 9999);
    });
  });
}
