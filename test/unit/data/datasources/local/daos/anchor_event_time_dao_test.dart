// test/unit/data/datasources/local/daos/anchor_event_time_dao_test.dart
// Tests for AnchorEventTimeDao per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

void main() {
  group('AnchorEventTimeDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    AnchorEventTime createEvent({
      String? id,
      AnchorEventName name = AnchorEventName.wake,
      String timeOfDay = '07:00',
      bool isEnabled = true,
    }) => AnchorEventTime(
      id: id ?? 'evt-${name.value}',
      name: name,
      timeOfDay: timeOfDay,
      isEnabled: isEnabled,
    );

    group('insert', () {
      test('insert_validEvent_returnsSuccessWithEntity', () async {
        final event = createEvent(id: 'evt-001');

        final result = await database.anchorEventTimeDao.insert(event);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'evt-001');
        expect(result.valueOrNull?.name, AnchorEventName.wake);
        expect(result.valueOrNull?.timeOfDay, '07:00');
        expect(result.valueOrNull?.isEnabled, isTrue);
      });

      test('insert_duplicateId_returnsFailure', () async {
        final event1 = createEvent(id: 'evt-dup');
        final event2 = createEvent(
          id: 'evt-dup',
          name: AnchorEventName.breakfast,
        );

        await database.anchorEventTimeDao.insert(event1);
        final result = await database.anchorEventTimeDao.insert(event2);

        expect(result.isFailure, isTrue);
      });

      test('insert_preservesIsEnabledFalse', () async {
        final event = createEvent(
          id: 'evt-dis',
          name: AnchorEventName.lunch,
          isEnabled: false,
        );

        final result = await database.anchorEventTimeDao.insert(event);

        expect(result.valueOrNull?.isEnabled, isFalse);
      });
    });

    group('getAll', () {
      test('getAll_emptyDatabase_returnsEmptyList', () async {
        final result = await database.anchorEventTimeDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleEvents_returnsAllOrderedByName', () async {
        // Insert out of order
        await database.anchorEventTimeDao.insert(
          createEvent(id: 'e3', name: AnchorEventName.dinner),
        );
        await database.anchorEventTimeDao.insert(createEvent(id: 'e1'));
        await database.anchorEventTimeDao.insert(
          createEvent(id: 'e2', name: AnchorEventName.breakfast),
        );

        final result = await database.anchorEventTimeDao.getAll();

        expect(result.isSuccess, isTrue);
        final events = result.valueOrNull!;
        expect(events.length, 3);
        // Ordered by name.value: wake(0), breakfast(1), dinner(3)
        expect(events[0].name, AnchorEventName.wake);
        expect(events[1].name, AnchorEventName.breakfast);
        expect(events[2].name, AnchorEventName.dinner);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        final event = createEvent(id: 'evt-get', name: AnchorEventName.bedtime);
        await database.anchorEventTimeDao.insert(event);

        final result = await database.anchorEventTimeDao.getById('evt-get');

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'evt-get');
        expect(result.valueOrNull?.name, AnchorEventName.bedtime);
      });

      test('getById_nonExistentId_returnsNotFoundFailure', () async {
        final result = await database.anchorEventTimeDao.getById('no-such-id');

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });
    });

    group('getByName', () {
      test('getByName_existingName_returnsEntity', () async {
        final event = createEvent(
          id: 'evt-lunch',
          name: AnchorEventName.lunch,
          timeOfDay: '12:30',
        );
        await database.anchorEventTimeDao.insert(event);

        final result = await database.anchorEventTimeDao.getByName(
          AnchorEventName.lunch,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.timeOfDay, '12:30');
      });

      test('getByName_nonExistentName_returnsNullSuccess', () async {
        final result = await database.anchorEventTimeDao.getByName(
          AnchorEventName.dinner,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingEvent_updatesTimeOfDay', () async {
        final event = createEvent(id: 'evt-upd');
        await database.anchorEventTimeDao.insert(event);

        final updated = event.copyWith(timeOfDay: '06:30');
        final result = await database.anchorEventTimeDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.timeOfDay, '06:30');
        expect(result.valueOrNull?.name, AnchorEventName.wake); // unchanged
      });

      test('updateEntity_existingEvent_updatesIsEnabled', () async {
        final event = createEvent(id: 'evt-en', name: AnchorEventName.bedtime);
        await database.anchorEventTimeDao.insert(event);

        final updated = event.copyWith(isEnabled: false);
        final result = await database.anchorEventTimeDao.updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.isEnabled, isFalse);
      });

      test('updateEntity_nonExistentId_returnsFailure', () async {
        const event = AnchorEventTime(
          id: 'no-such',
          name: AnchorEventName.wake,
          timeOfDay: '07:00',
        );

        final result = await database.anchorEventTimeDao.updateEntity(event);

        expect(result.isFailure, isTrue);
      });
    });
  });
}
