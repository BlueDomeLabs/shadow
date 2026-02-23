// test/presentation/providers/notifications/notification_settings_provider_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/usecases/notifications/get_notification_settings_use_case.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/domain/usecases/notifications/update_notification_category_settings_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/notifications/notification_settings_provider.dart';

void main() {
  group('NotificationSettings', () {
    List<NotificationCategorySettings> makeTestSettings() =>
        NotificationCategory.values
            .map(
              (c) => NotificationCategorySettings(
                id: 'setting-${c.value}',
                category: c,
                schedulingMode: NotificationSchedulingMode.anchorEvents,
              ),
            )
            .toList();

    ProviderContainer makeContainer({
      List<NotificationCategorySettings>? settings,
      _FakeUpdateNotificationCategorySettings? fakeUpdate,
    }) => ProviderContainer(
      overrides: [
        getNotificationSettingsUseCaseProvider.overrideWithValue(
          _FakeGetNotificationSettings(settings ?? makeTestSettings()),
        ),
        updateNotificationCategorySettingsUseCaseProvider.overrideWithValue(
          fakeUpdate ?? _FakeUpdateNotificationCategorySettings(),
        ),
      ],
    );

    test('build loads all 8 category settings', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final result = await container.read(notificationSettingsProvider.future);

      expect(result, hasLength(8));
      expect(result.first.category, NotificationCategory.supplements);
    });

    test('build throws on use case failure', () async {
      final container = ProviderContainer(
        overrides: [
          getNotificationSettingsUseCaseProvider.overrideWithValue(
            _FakeGetNotificationSettingsError(),
          ),
          updateNotificationCategorySettingsUseCaseProvider.overrideWithValue(
            _FakeUpdateNotificationCategorySettings(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(notificationSettingsProvider.future),
        throwsA(isA<AppError>()),
      );
    });

    test('updateSettings calls use case and refreshes', () async {
      final fakeUpdate = _FakeUpdateNotificationCategorySettings();
      final container = makeContainer(fakeUpdate: fakeUpdate);
      addTearDown(container.dispose);

      await container.read(notificationSettingsProvider.future);

      await container
          .read(notificationSettingsProvider.notifier)
          .updateSettings(
            const UpdateNotificationCategorySettingsInput(
              id: 'setting-0',
              isEnabled: true,
            ),
          );

      expect(fakeUpdate.calledWithId, 'setting-0');
    });

    test('setAllExpiry updates all categories with given minutes', () async {
      final fakeUpdate = _FakeUpdateNotificationCategorySettings();
      final twoSettings = [
        const NotificationCategorySettings(
          id: 'setting-0',
          category: NotificationCategory.supplements,
          schedulingMode: NotificationSchedulingMode.anchorEvents,
        ),
        const NotificationCategorySettings(
          id: 'setting-1',
          category: NotificationCategory.foodMeals,
          schedulingMode: NotificationSchedulingMode.anchorEvents,
        ),
      ];
      final container = makeContainer(
        settings: twoSettings,
        fakeUpdate: fakeUpdate,
      );
      addTearDown(container.dispose);

      await container.read(notificationSettingsProvider.future);

      await container
          .read(notificationSettingsProvider.notifier)
          .setAllExpiry(120);

      expect(fakeUpdate.callCount, 2);
      expect(fakeUpdate.lastExpiryMinutes, 120);
    });
  });
}

// Fakes

class _FakeGetNotificationSettings implements GetNotificationSettingsUseCase {
  final List<NotificationCategorySettings> _settings;
  _FakeGetNotificationSettings(this._settings);

  @override
  Future<Result<List<NotificationCategorySettings>, AppError>> call() async =>
      Success(_settings);
}

class _FakeGetNotificationSettingsError
    implements GetNotificationSettingsUseCase {
  @override
  Future<Result<List<NotificationCategorySettings>, AppError>> call() async =>
      Failure(DatabaseError.queryFailed('test', Exception('db error')));
}

class _FakeUpdateNotificationCategorySettings
    implements UpdateNotificationCategorySettingsUseCase {
  String? calledWithId;
  int callCount = 0;
  int? lastExpiryMinutes;

  @override
  Future<Result<NotificationCategorySettings, AppError>> call(
    UpdateNotificationCategorySettingsInput input,
  ) async {
    calledWithId = input.id;
    callCount++;
    lastExpiryMinutes = input.expiresAfterMinutes;
    return Success(
      NotificationCategorySettings(
        id: input.id,
        category: NotificationCategory.supplements,
        schedulingMode: NotificationSchedulingMode.anchorEvents,
        isEnabled: input.isEnabled ?? false,
        expiresAfterMinutes: input.expiresAfterMinutes ?? 60,
      ),
    );
  }
}
