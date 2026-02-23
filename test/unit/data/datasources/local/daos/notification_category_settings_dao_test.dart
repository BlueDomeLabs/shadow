// test/unit/data/datasources/local/daos/notification_category_settings_dao_test.dart
// Tests for NotificationCategorySettingsDao per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

void main() {
  group('NotificationCategorySettingsDao', () {
    late AppDatabase database;

    setUp(() {
      database = AppDatabase(DatabaseConnection.inMemoryUnencrypted());
    });

    tearDown(() async {
      await database.close();
    });

    NotificationCategorySettings createSettings({
      String? id,
      NotificationCategory category = NotificationCategory.supplements,
      bool isEnabled = false,
      NotificationSchedulingMode schedulingMode =
          NotificationSchedulingMode.anchorEvents,
      List<int> anchorEventValues = const [],
      int? intervalHours,
      String? intervalStartTime,
      String? intervalEndTime,
      List<String> specificTimes = const [],
      int expiresAfterMinutes = 60,
    }) => NotificationCategorySettings(
      id: id ?? 'ncs-${category.value}',
      category: category,
      isEnabled: isEnabled,
      schedulingMode: schedulingMode,
      anchorEventValues: anchorEventValues,
      intervalHours: intervalHours,
      intervalStartTime: intervalStartTime,
      intervalEndTime: intervalEndTime,
      specificTimes: specificTimes,
      expiresAfterMinutes: expiresAfterMinutes,
    );

    group('insert', () {
      test('insert_validSettings_returnsSuccessWithEntity', () async {
        final settings = createSettings(
          id: 'ncs-001',
          anchorEventValues: [1, 3],
        );

        final result = await database.notificationCategorySettingsDao.insert(
          settings,
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'ncs-001');
        expect(result.valueOrNull?.category, NotificationCategory.supplements);
        expect(result.valueOrNull?.anchorEventValues, [1, 3]);
      });

      test('insert_duplicateId_returnsFailure', () async {
        final s1 = createSettings(id: 'ncs-dup');
        final s2 = createSettings(
          id: 'ncs-dup',
          category: NotificationCategory.fluids,
        );

        await database.notificationCategorySettingsDao.insert(s1);
        final result = await database.notificationCategorySettingsDao.insert(
          s2,
        );

        expect(result.isFailure, isTrue);
      });

      test('insert_intervalMode_persistsIntervalFields', () async {
        final settings = createSettings(
          id: 'ncs-int',
          category: NotificationCategory.fluids,
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 2,
          intervalStartTime: '08:00',
          intervalEndTime: '22:00',
        );

        final result = await database.notificationCategorySettingsDao.insert(
          settings,
        );

        expect(result.valueOrNull?.intervalHours, 2);
        expect(result.valueOrNull?.intervalStartTime, '08:00');
        expect(result.valueOrNull?.intervalEndTime, '22:00');
      });

      test('insert_specificTimesMode_persistsTimesList', () async {
        final settings = createSettings(
          id: 'ncs-spt',
          category: NotificationCategory.journalEntries,
          schedulingMode: NotificationSchedulingMode.specificTimes,
          specificTimes: ['09:00', '21:00'],
        );

        final result = await database.notificationCategorySettingsDao.insert(
          settings,
        );

        expect(result.valueOrNull?.specificTimes, ['09:00', '21:00']);
      });
    });

    group('getAll', () {
      test('getAll_emptyDatabase_returnsEmptyList', () async {
        final result = await database.notificationCategorySettingsDao.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isEmpty);
      });

      test('getAll_multipleSettings_returnsAllOrderedByCategory', () async {
        await database.notificationCategorySettingsDao.insert(
          createSettings(id: 's3', category: NotificationCategory.fluids),
        );
        await database.notificationCategorySettingsDao.insert(
          createSettings(id: 's1'),
        );
        await database.notificationCategorySettingsDao.insert(
          createSettings(id: 's2', category: NotificationCategory.foodMeals),
        );

        final result = await database.notificationCategorySettingsDao.getAll();

        expect(result.isSuccess, isTrue);
        final items = result.valueOrNull!;
        expect(items.length, 3);
        // Ordered by category.value: supplements(0), foodMeals(1), fluids(2)
        expect(items[0].category, NotificationCategory.supplements);
        expect(items[1].category, NotificationCategory.foodMeals);
        expect(items[2].category, NotificationCategory.fluids);
      });
    });

    group('getByCategory', () {
      test('getByCategory_existingCategory_returnsEntity', () async {
        final settings = createSettings(
          id: 'ncs-bc',
          category: NotificationCategory.photos,
        );
        await database.notificationCategorySettingsDao.insert(settings);

        final result = await database.notificationCategorySettingsDao
            .getByCategory(NotificationCategory.photos);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.id, 'ncs-bc');
      });

      test('getByCategory_nonExistentCategory_returnsNullSuccess', () async {
        final result = await database.notificationCategorySettingsDao
            .getByCategory(NotificationCategory.bbtVitals);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull, isNull);
      });
    });

    group('getById', () {
      test('getById_existingId_returnsSuccess', () async {
        final settings = createSettings(
          id: 'ncs-gi',
          category: NotificationCategory.activities,
        );
        await database.notificationCategorySettingsDao.insert(settings);

        final result = await database.notificationCategorySettingsDao.getById(
          'ncs-gi',
        );

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.category, NotificationCategory.activities);
      });

      test('getById_nonExistentId_returnsFailure', () async {
        final result = await database.notificationCategorySettingsDao.getById(
          'no-such',
        );

        expect(result.isFailure, isTrue);
        expect(result.errorOrNull, isA<DatabaseError>());
      });
    });

    group('updateEntity', () {
      test('updateEntity_existingSettings_updatesIsEnabled', () async {
        final settings = createSettings(id: 'ncs-en');
        await database.notificationCategorySettingsDao.insert(settings);

        final updated = settings.copyWith(isEnabled: true);
        final result = await database.notificationCategorySettingsDao
            .updateEntity(updated);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrNull?.isEnabled, isTrue);
        expect(
          result.valueOrNull?.category,
          NotificationCategory.supplements,
        ); // unchanged
      });

      test('updateEntity_existingSettings_updatesSchedulingMode', () async {
        final settings = createSettings(
          id: 'ncs-mode',
          category: NotificationCategory.fluids,
        );
        await database.notificationCategorySettingsDao.insert(settings);

        final updated = settings.copyWith(
          schedulingMode: NotificationSchedulingMode.interval,
          intervalHours: 3,
          intervalStartTime: '07:00',
          intervalEndTime: '21:00',
        );
        final result = await database.notificationCategorySettingsDao
            .updateEntity(updated);

        expect(
          result.valueOrNull?.schedulingMode,
          NotificationSchedulingMode.interval,
        );
        expect(result.valueOrNull?.intervalHours, 3);
      });

      test('updateEntity_existingSettings_updatesAnchorEventValues', () async {
        final settings = createSettings(id: 'ncs-anch', anchorEventValues: [1]);
        await database.notificationCategorySettingsDao.insert(settings);

        final updated = settings.copyWith(anchorEventValues: [1, 3]);
        final result = await database.notificationCategorySettingsDao
            .updateEntity(updated);

        expect(result.valueOrNull?.anchorEventValues, [1, 3]);
      });

      test('updateEntity_nonExistentId_returnsFailure', () async {
        const settings = NotificationCategorySettings(
          id: 'no-such',
          category: NotificationCategory.supplements,
          schedulingMode: NotificationSchedulingMode.anchorEvents,
        );

        final result = await database.notificationCategorySettingsDao
            .updateEntity(settings);

        expect(result.isFailure, isTrue);
      });
    });
  });
}
