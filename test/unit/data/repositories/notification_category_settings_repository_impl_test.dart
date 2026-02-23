// test/unit/data/repositories/notification_category_settings_repository_impl_test.dart
// Tests for NotificationCategorySettingsRepositoryImpl per 57_NOTIFICATION_SYSTEM.md

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/notification_category_settings_dao.dart';
import 'package:shadow_app/data/repositories/notification_category_settings_repository_impl.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';

@GenerateMocks([NotificationCategorySettingsDao])
import 'notification_category_settings_repository_impl_test.mocks.dart';

void main() {
  provideDummy<Result<List<NotificationCategorySettings>, AppError>>(
    const Success([]),
  );
  provideDummy<Result<NotificationCategorySettings, AppError>>(
    const Success(
      NotificationCategorySettings(
        id: 'dummy',
        category: NotificationCategory.supplements,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
      ),
    ),
  );
  provideDummy<Result<NotificationCategorySettings?, AppError>>(
    const Success(null),
  );

  const testSettings = NotificationCategorySettings(
    id: 'ncs-001',
    category: NotificationCategory.supplements,
    schedulingMode: NotificationSchedulingMode.anchorEvents,
    anchorEventValues: [1, 3],
  );

  group('NotificationCategorySettingsRepositoryImpl', () {
    late MockNotificationCategorySettingsDao mockDao;
    late NotificationCategorySettingsRepositoryImpl repository;

    setUp(() {
      mockDao = MockNotificationCategorySettingsDao();
      repository = NotificationCategorySettingsRepositoryImpl(mockDao);
    });

    test('getAll delegates to dao', () async {
      when(
        mockDao.getAll(),
      ).thenAnswer((_) async => const Success([testSettings]));

      final result = await repository.getAll();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.length, 1);
      verify(mockDao.getAll()).called(1);
    });

    test('getByCategory delegates to dao', () async {
      when(
        mockDao.getByCategory(NotificationCategory.supplements),
      ).thenAnswer((_) async => const Success(testSettings));

      final result = await repository.getByCategory(
        NotificationCategory.supplements,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.category, NotificationCategory.supplements);
      verify(mockDao.getByCategory(NotificationCategory.supplements)).called(1);
    });

    test('getById delegates to dao', () async {
      when(
        mockDao.getById('ncs-001'),
      ).thenAnswer((_) async => const Success(testSettings));

      final result = await repository.getById('ncs-001');

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.id, 'ncs-001');
      verify(mockDao.getById('ncs-001')).called(1);
    });

    test('create delegates to dao insert', () async {
      when(
        mockDao.insert(any),
      ).thenAnswer((_) async => const Success(testSettings));

      final result = await repository.create(testSettings);

      expect(result.isSuccess, isTrue);
      verify(mockDao.insert(testSettings)).called(1);
    });

    test('update delegates to dao updateEntity', () async {
      when(
        mockDao.updateEntity(any),
      ).thenAnswer((_) async => const Success(testSettings));

      final result = await repository.update(testSettings);

      expect(result.isSuccess, isTrue);
      verify(mockDao.updateEntity(testSettings)).called(1);
    });

    test('propagates dao failure', () async {
      when(mockDao.getAll()).thenAnswer(
        (_) async => Failure(
          DatabaseError.queryFailed(
            'notification_category_settings',
            'error',
            StackTrace.empty,
          ),
        ),
      );

      final result = await repository.getAll();

      expect(result.isFailure, isTrue);
    });
  });
}
