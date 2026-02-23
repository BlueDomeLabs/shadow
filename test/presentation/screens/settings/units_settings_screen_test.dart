// test/presentation/screens/settings/units_settings_screen_test.dart
// Tests for UnitsSettingsScreen per 58_SETTINGS_SCREENS.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/repositories/user_settings_repository.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/settings/units_settings_screen.dart';

class _FakeRepo implements UserSettingsRepository {
  UserSettings _s = UserSettings.defaults;

  @override
  Future<Result<UserSettings, AppError>> getSettings() async => Success(_s);

  @override
  Future<Result<UserSettings, AppError>> updateSettings(UserSettings s) async {
    _s = s;
    return Success(s);
  }
}

Widget _buildScreen() => ProviderScope(
  overrides: [userSettingsRepositoryProvider.overrideWithValue(_FakeRepo())],
  child: const MaterialApp(home: UnitsSettingsScreen()),
);

void main() {
  group('UnitsSettingsScreen', () {
    testWidgets('shows Units app bar title', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Units'), findsOneWidget);
    });

    testWidgets('shows Body weight row', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Body weight'), findsOneWidget);
    });

    testWidgets('shows Food weight row', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Food weight'), findsOneWidget);
    });

    testWidgets('shows Fluids row', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Fluids'), findsOneWidget);
    });

    testWidgets('shows Body temperature row', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Body temperature'), findsOneWidget);
    });

    testWidgets('shows Energy row', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.text('Energy'), findsOneWidget);
    });

    testWidgets('shows BBT consistency note', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pump();
      expect(find.textContaining('BBT tracking'), findsOneWidget);
    });
  });
}
