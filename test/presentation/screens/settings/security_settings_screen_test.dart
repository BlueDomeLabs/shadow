// test/presentation/screens/settings/security_settings_screen_test.dart
// Tests for SecuritySettingsScreen per 58_SETTINGS_SCREENS.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/repositories/user_settings_repository.dart';
import 'package:shadow_app/domain/services/security_service.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/settings/security_settings_screen.dart';

class _FakeRepo implements UserSettingsRepository {
  UserSettings _s;

  _FakeRepo([UserSettings? initial]) : _s = initial ?? UserSettings.defaults;

  @override
  Future<Result<UserSettings, AppError>> getSettings() async => Success(_s);

  @override
  Future<Result<UserSettings, AppError>> updateSettings(UserSettings s) async {
    _s = s;
    return Success(s);
  }
}

class _FakeSecurityService implements SecurityService {
  final bool pinSet;
  final bool biometricAvailable;

  const _FakeSecurityService({
    this.pinSet = false,
    this.biometricAvailable = false,
  });

  @override
  Future<bool> isPinSet() async => pinSet;

  @override
  Future<bool> isBiometricAvailable() async => biometricAvailable;

  @override
  Future<bool> verifyPin(String pin) async => false;

  @override
  Future<void> setPin(String pin) async {}

  @override
  Future<bool> removePin(String currentPin) async => false;

  @override
  Future<bool> authenticateWithBiometrics() async => false;
}

Widget _buildScreen({
  UserSettings? settings,
  bool pinSet = false,
  bool biometricAvailable = false,
}) => ProviderScope(
  overrides: [
    userSettingsRepositoryProvider.overrideWithValue(_FakeRepo(settings)),
    securityServiceProvider.overrideWithValue(
      _FakeSecurityService(
        pinSet: pinSet,
        biometricAvailable: biometricAvailable,
      ),
    ),
  ],
  child: const MaterialApp(home: SecuritySettingsScreen()),
);

void main() {
  group('SecuritySettingsScreen', () {
    testWidgets('shows Security app bar title', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('shows Enable App Lock switch', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Enable App Lock'), findsOneWidget);
    });

    testWidgets('hides authentication options when app lock is off', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      // Without app lock on, PIN / biometric options should not be visible.
      expect(find.text('Authentication Method'), findsNothing);
      expect(find.text('Set PIN'), findsNothing);
    });

    testWidgets('shows Set PIN option when app lock is on and no PIN is set', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildScreen(
          settings: UserSettings.defaults.copyWith(appLockEnabled: true),
        ),
      );
      await tester.pump();
      expect(find.text('Set PIN'), findsOneWidget);
    });

    testWidgets(
      'shows Change PIN and Remove PIN when app lock is on and PIN is set',
      (tester) async {
        await tester.pumpWidget(
          _buildScreen(
            settings: UserSettings.defaults.copyWith(appLockEnabled: true),
            pinSet: true,
          ),
        );
        await tester.pump();
        expect(find.text('Change PIN'), findsOneWidget);
        expect(find.text('Remove PIN'), findsOneWidget);
      },
    );

    testWidgets('shows auto-lock timing options when app lock is on', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildScreen(
          settings: UserSettings.defaults.copyWith(appLockEnabled: true),
          pinSet: true,
        ),
      );
      await tester.pump();
      expect(find.text('Auto-Lock Timing'), findsOneWidget);
      expect(find.text('Immediately'), findsOneWidget);
      expect(find.text('5 minutes'), findsOneWidget);
    });
  });
}
