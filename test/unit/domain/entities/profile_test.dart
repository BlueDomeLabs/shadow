// test/unit/domain/entities/profile_test.dart

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('Profile', () {
    late Profile profile;
    late SyncMetadata syncMetadata;

    setUp(() {
      syncMetadata = SyncMetadata.create(deviceId: 'test-device');
      profile = Profile(
        id: 'profile-001',
        clientId: 'client-001',
        name: 'Reid',
        birthDate: DateTime(1990, 6, 15).millisecondsSinceEpoch,
        biologicalSex: BiologicalSex.male,
        ethnicity: 'Caucasian',
        notes: 'Primary profile',
        ownerId: 'user-001',
        dietType: ProfileDietType.keto,
        // dietDescription intentionally omitted (null by default)
        syncMetadata: syncMetadata,
      );
    });

    group('required fields per 22_API_CONTRACTS.md', () {
      test('has id field', () {
        expect(profile.id, equals('profile-001'));
      });

      test('has clientId field', () {
        expect(profile.clientId, equals('client-001'));
      });

      test('has name field', () {
        expect(profile.name, equals('Reid'));
      });

      test('has syncMetadata field', () {
        expect(profile.syncMetadata, isNotNull);
      });
    });

    group('optional fields per 22_API_CONTRACTS.md', () {
      test('birthDate is nullable', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.birthDate, isNull);
      });

      test('biologicalSex is nullable', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.biologicalSex, isNull);
      });

      test('ethnicity is nullable — fully optional, self-reported only', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.ethnicity, isNull);
      });

      test('notes is nullable', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.notes, isNull);
      });

      test('ownerId is nullable', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.ownerId, isNull);
      });

      test('dietType defaults to none', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.dietType, equals(ProfileDietType.none));
      });

      test('dietDescription is nullable', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Test',
          syncMetadata: syncMetadata,
        );
        expect(minimal.dietDescription, isNull);
      });
    });

    group('Profile does NOT have profileId field', () {
      test('id is used as profileId by child entities', () {
        // Profile IS the profile — its id is the profileId for child entities
        expect(profile.id, equals('profile-001'));
      });
    });

    group('computed properties', () {
      test('ageYears returns null when birthDate is null', () {
        final noBirth = profile.copyWith(birthDate: null);
        expect(noBirth.ageYears, isNull);
      });

      test('ageYears calculates correct age', () {
        // Use a date far enough in the past that the age is stable
        final withBirth = profile.copyWith(
          birthDate: DateTime(2000).millisecondsSinceEpoch,
        );
        final now = DateTime.now();
        final expectedAge =
            now.year -
            2000 -
            ((now.month < 1 || (now.month == 1 && now.day < 1)) ? 1 : 0);
        expect(withBirth.ageYears, equals(expectedAge));
      });

      test('ageYears accounts for birthday not yet passed this year', () {
        // Set birthdate to December 31 of a past year
        final dec31 = DateTime(2000, 12, 31).millisecondsSinceEpoch;
        final withBirth = profile.copyWith(birthDate: dec31);
        final now = DateTime.now();
        // If today is before Dec 31, age should be year-diff minus 1
        final expectedAge =
            now.year -
            2000 -
            ((now.month < 12 || (now.month == 12 && now.day < 31)) ? 1 : 0);
        expect(withBirth.ageYears, equals(expectedAge));
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final json = profile.toJson();
        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('profile-001'));
        expect(json['name'], equals('Reid'));
      });

      test('fromJson parses correctly', () {
        final json = profile.toJson();
        final parsed = Profile.fromJson(json);

        expect(parsed.id, equals(profile.id));
        expect(parsed.name, equals(profile.name));
        expect(parsed.biologicalSex, equals(profile.biologicalSex));
        expect(parsed.dietType, equals(profile.dietType));
      });

      test('round-trip serialization preserves data', () {
        final json = profile.toJson();
        final jsonString = jsonEncode(json);
        final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
        final parsed = Profile.fromJson(decoded);

        expect(parsed, equals(profile));
      });

      test('round-trip preserves null optional fields', () {
        final minimal = Profile(
          id: 'id',
          clientId: 'cid',
          name: 'Minimal',
          syncMetadata: syncMetadata,
        );
        final json = minimal.toJson();
        final parsed = Profile.fromJson(json);

        expect(parsed.birthDate, isNull);
        expect(parsed.biologicalSex, isNull);
        expect(parsed.ethnicity, isNull);
        expect(parsed.notes, isNull);
        expect(parsed.ownerId, isNull);
        expect(parsed.dietDescription, isNull);
      });
    });

    group('copyWith', () {
      test('creates new instance with changed values', () {
        final updated = profile.copyWith(name: 'Updated Name');

        expect(updated.name, equals('Updated Name'));
        expect(updated.id, equals(profile.id));
        expect(profile.name, equals('Reid'));
      });
    });
  });

  group('BiologicalSex enum', () {
    test('has correct values', () {
      expect(BiologicalSex.male.value, equals(0));
      expect(BiologicalSex.female.value, equals(1));
      expect(BiologicalSex.other.value, equals(2));
    });

    test('fromValue returns correct enum', () {
      expect(BiologicalSex.fromValue(0), equals(BiologicalSex.male));
      expect(BiologicalSex.fromValue(1), equals(BiologicalSex.female));
      expect(BiologicalSex.fromValue(2), equals(BiologicalSex.other));
    });

    test('fromValue returns other for unknown value', () {
      expect(BiologicalSex.fromValue(99), equals(BiologicalSex.other));
    });
  });

  group('ProfileDietType enum', () {
    test('has correct values', () {
      expect(ProfileDietType.none.value, equals(0));
      expect(ProfileDietType.vegan.value, equals(1));
      expect(ProfileDietType.vegetarian.value, equals(2));
      expect(ProfileDietType.paleo.value, equals(3));
      expect(ProfileDietType.keto.value, equals(4));
      expect(ProfileDietType.glutenFree.value, equals(5));
      expect(ProfileDietType.other.value, equals(6));
    });

    test('fromValue returns correct enum', () {
      expect(ProfileDietType.fromValue(0), equals(ProfileDietType.none));
      expect(ProfileDietType.fromValue(1), equals(ProfileDietType.vegan));
      expect(ProfileDietType.fromValue(4), equals(ProfileDietType.keto));
      expect(ProfileDietType.fromValue(5), equals(ProfileDietType.glutenFree));
      expect(ProfileDietType.fromValue(6), equals(ProfileDietType.other));
    });

    test('fromValue returns none for unknown value', () {
      expect(ProfileDietType.fromValue(99), equals(ProfileDietType.none));
    });
  });
}
