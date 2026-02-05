// test/unit/domain/entities/condition_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

void main() {
  group('Condition', () {
    Condition createTestCondition({
      String id = 'cond-001',
      String clientId = 'client-001',
      String profileId = 'profile-001',
      String name = 'Test Condition',
      String category = 'skin',
      List<String> bodyLocations = const ['arm', 'leg'],
      String? description,
      String? baselinePhotoPath,
      int startTimeframe = 1704067200000,
      int? endDate,
      ConditionStatus status = ConditionStatus.active,
      bool isArchived = false,
    }) => Condition(
      id: id,
      clientId: clientId,
      profileId: profileId,
      name: name,
      category: category,
      bodyLocations: bodyLocations,
      description: description,
      baselinePhotoPath: baselinePhotoPath,
      startTimeframe: startTimeframe,
      endDate: endDate,
      status: status,
      isArchived: isArchived,
      syncMetadata: SyncMetadata.create(deviceId: 'test-device'),
    );

    group('computed properties', () {
      test('hasBaselinePhoto returns true when photo path is set', () {
        final condition = createTestCondition(
          baselinePhotoPath: '/path/to/photo.jpg',
        );
        expect(condition.hasBaselinePhoto, isTrue);
      });

      test('hasBaselinePhoto returns false when photo path is null', () {
        final condition = createTestCondition();
        expect(condition.hasBaselinePhoto, isFalse);
      });

      test('isResolved returns true when status is resolved', () {
        final condition = createTestCondition(status: ConditionStatus.resolved);
        expect(condition.isResolved, isTrue);
      });

      test('isResolved returns false when status is active', () {
        final condition = createTestCondition();
        expect(condition.isResolved, isFalse);
      });

      test('isActive returns true for active non-archived condition', () {
        final condition = createTestCondition();
        expect(condition.isActive, isTrue);
      });

      test('isActive returns false for archived condition', () {
        final condition = createTestCondition(isArchived: true);
        expect(condition.isActive, isFalse);
      });

      test('isActive returns false for resolved condition', () {
        final condition = createTestCondition(status: ConditionStatus.resolved);
        expect(condition.isActive, isFalse);
      });
    });

    group('JSON serialization', () {
      test('toJson produces valid JSON', () {
        final condition = createTestCondition(
          description: 'Test description',
          bodyLocations: ['arm', 'leg', 'back'],
        );

        final json = condition.toJson();

        expect(json, isA<Map<String, dynamic>>());
        expect(json['id'], equals('cond-001'));
        expect(json['clientId'], equals('client-001'));
        expect(json['name'], equals('Test Condition'));
        expect(json['category'], equals('skin'));
        expect(json['bodyLocations'], equals(['arm', 'leg', 'back']));
        expect(json['description'], equals('Test description'));
        expect(json['status'], equals('active'));
      });

      test('fromJson parses correctly', () {
        final condition = createTestCondition(
          status: ConditionStatus.resolved,
          endDate: 1704153600000,
        );
        final json = condition.toJson();
        final parsed = Condition.fromJson(json);

        expect(parsed.id, equals(condition.id));
        expect(parsed.name, equals(condition.name));
        expect(parsed.status, equals(ConditionStatus.resolved));
        expect(parsed.endDate, equals(1704153600000));
      });

      test('round-trip serialization preserves all fields', () {
        final original = createTestCondition(
          description: 'Full description',
          baselinePhotoPath: '/photos/baseline.jpg',
          bodyLocations: ['face', 'neck'],
          endDate: 1704153600000,
          status: ConditionStatus.resolved,
          isArchived: true,
        );
        final json = original.toJson();
        final parsed = Condition.fromJson(json);

        expect(parsed.id, equals(original.id));
        expect(parsed.clientId, equals(original.clientId));
        expect(parsed.profileId, equals(original.profileId));
        expect(parsed.name, equals(original.name));
        expect(parsed.category, equals(original.category));
        expect(parsed.bodyLocations, equals(original.bodyLocations));
        expect(parsed.description, equals(original.description));
        expect(parsed.baselinePhotoPath, equals(original.baselinePhotoPath));
        expect(parsed.startTimeframe, equals(original.startTimeframe));
        expect(parsed.endDate, equals(original.endDate));
        expect(parsed.status, equals(original.status));
        expect(parsed.isArchived, equals(original.isArchived));
      });
    });

    group('copyWith', () {
      test('copyWith creates new instance with updated fields', () {
        final original = createTestCondition();
        final updated = original.copyWith(
          status: ConditionStatus.resolved,
          endDate: 1704153600000,
          isArchived: true,
        );

        expect(updated.id, equals(original.id));
        expect(updated.status, equals(ConditionStatus.resolved));
        expect(updated.endDate, equals(1704153600000));
        expect(updated.isArchived, isTrue);
      });
    });
  });
}
