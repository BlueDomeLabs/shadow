// test/presentation/providers/settings/user_settings_provider_test.dart
// Tests for UserSettingsNotifier per 58_SETTINGS_SCREENS.md

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';
import 'package:shadow_app/domain/repositories/user_settings_repository.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';

class _FakeUserSettingsRepository implements UserSettingsRepository {
  UserSettings _settings = UserSettings.defaults;

  @override
  Future<Result<UserSettings, AppError>> getSettings() async =>
      Success(_settings);

  @override
  Future<Result<UserSettings, AppError>> updateSettings(
    UserSettings settings,
  ) async {
    _settings = settings;
    return Success(settings);
  }
}

ProviderContainer _makeContainer() => ProviderContainer(
  overrides: [
    userSettingsRepositoryProvider.overrideWithValue(
      _FakeUserSettingsRepository(),
    ),
  ],
);

void main() {
  group('UserSettingsNotifier', () {
    test('build() returns defaults on first load', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final settings = await container.read(
        userSettingsNotifierProvider.future,
      );

      expect(settings.weightUnit, WeightUnit.kg);
      expect(settings.fluidUnit, FluidUnit.ml);
      expect(settings.temperatureUnit, TemperatureUnit.celsius);
      expect(settings.energyUnit, EnergyUnit.kcal);
      expect(settings.appLockEnabled, isFalse);
    });

    test('update() saves changed settings and state reflects them', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await container.read(userSettingsNotifierProvider.future);
      final notifier = container.read(userSettingsNotifierProvider.notifier);

      await notifier.save(
        UserSettings.defaults.copyWith(weightUnit: WeightUnit.lbs),
      );

      final updated = container.read(userSettingsNotifierProvider).valueOrNull;
      expect(updated?.weightUnit, WeightUnit.lbs);
    });

    test('update() persists energyUnit change', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await container.read(userSettingsNotifierProvider.future);
      await container
          .read(userSettingsNotifierProvider.notifier)
          .save(UserSettings.defaults.copyWith(energyUnit: EnergyUnit.kJ));

      final updated = container.read(userSettingsNotifierProvider).valueOrNull;
      expect(updated?.energyUnit, EnergyUnit.kJ);
    });

    test('update() persists security settings', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await container.read(userSettingsNotifierProvider.future);
      await container
          .read(userSettingsNotifierProvider.notifier)
          .save(
            UserSettings.defaults.copyWith(
              appLockEnabled: true,
              autoLockDuration: AutoLockDuration.oneMinute,
            ),
          );

      final updated = container.read(userSettingsNotifierProvider).valueOrNull;
      expect(updated?.appLockEnabled, isTrue);
      expect(updated?.autoLockDuration, AutoLockDuration.oneMinute);
    });
  });
}
