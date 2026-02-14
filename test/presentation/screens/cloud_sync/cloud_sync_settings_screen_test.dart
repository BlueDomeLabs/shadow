// test/presentation/screens/cloud_sync/cloud_sync_settings_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart';

void main() {
  group('CloudSyncSettingsScreen', () {
    Widget buildScreen() => const MaterialApp(home: CloudSyncSettingsScreen());

    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Cloud Sync'), findsOneWidget);
    });

    testWidgets('renders sync status section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Sync Status'), findsOneWidget);
      expect(find.text('Not configured'), findsOneWidget);
    });

    testWidgets('renders sync settings section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Sync Settings'), findsOneWidget);
      expect(find.text('Auto Sync'), findsOneWidget);
      expect(find.text('WiFi Only'), findsOneWidget);
      expect(find.text('Sync Frequency'), findsOneWidget);
    });

    testWidgets('renders setup button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Set Up Cloud Sync'), findsOneWidget);
    });

    testWidgets('renders device info section', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Device Info'), findsOneWidget);
      expect(find.text('Sync Provider'), findsOneWidget);
      expect(find.text('Last Sync'), findsOneWidget);
    });

    testWidgets('tapping Auto Sync shows Coming Soon', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Tap the switch for Auto Sync
      final switches = find.byType(Switch);
      expect(switches, findsWidgets);

      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      expect(find.text('Coming Soon'), findsOneWidget);
    });

    testWidgets('renders setup button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Set Up Cloud Sync'), findsOneWidget);
    });
  });
}
