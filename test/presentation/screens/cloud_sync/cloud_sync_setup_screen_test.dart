// test/presentation/screens/cloud_sync/cloud_sync_setup_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart';

void main() {
  group('CloudSyncSetupScreen', () {
    Widget buildScreen() => const MaterialApp(home: CloudSyncSetupScreen());

    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Set Up Cloud Sync'), findsOneWidget);
    });

    testWidgets('renders header title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Back Up and Sync Your Data'), findsOneWidget);
    });

    testWidgets('renders benefit items', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Automatic Backup'), findsOneWidget);
      expect(find.text('Multi-Device Sync'), findsOneWidget);
      expect(find.text('Secure & Private'), findsOneWidget);
    });

    testWidgets('renders Google Drive provider button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Google Drive'), findsOneWidget);
    });

    testWidgets('renders Local Only provider button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Local Only'), findsOneWidget);
    });

    testWidgets('renders Maybe Later skip button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Maybe Later'), findsOneWidget);
    });

    testWidgets('Google Drive button shows Coming Soon dialog', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Scroll to make Google Drive visible
      await tester.scrollUntilVisible(
        find.text('Google Drive'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      await tester.tap(find.text('Google Drive'));
      await tester.pumpAndSettle();

      expect(find.text('Coming Soon'), findsOneWidget);
    });

    testWidgets('Local Only button exists', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Scroll to make Local Only visible
      await tester.scrollUntilVisible(
        find.text('Local Only'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Local Only'), findsOneWidget);
    });
  });
}
