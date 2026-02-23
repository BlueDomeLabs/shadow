// test/presentation/screens/settings/settings_screen_test.dart
// Tests for SettingsScreen hub per 58_SETTINGS_SCREENS.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/settings/settings_screen.dart';

Widget _buildScreen() =>
    const ProviderScope(child: MaterialApp(home: SettingsScreen()));

void main() {
  group('SettingsScreen', () {
    testWidgets('shows Settings app bar title', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows Notifications tile', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('shows Units tile', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Units'), findsOneWidget);
    });

    testWidgets('shows Security tile', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Security'), findsOneWidget);
    });

    testWidgets('shows Cloud Sync tile', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Cloud Sync'), findsOneWidget);
    });
  });
}
