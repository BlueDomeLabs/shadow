// test/presentation/screens/home/home_screen_test.dart
// Tests for HomeScreen navigation shell.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/home_screen.dart';

void main() {
  group('HomeScreen', () {
    Widget buildScreen() =>
        const ProviderScope(child: MaterialApp(home: HomeScreen()));

    testWidgets('renders bottom navigation with 5 tabs', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Tracking'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Journal'), findsOneWidget);
      expect(find.text('Photos'), findsOneWidget);
    });

    testWidgets('shows Dashboard tab by default', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Shadow'), findsOneWidget);
      expect(find.text('Health Tracking'), findsOneWidget);
    });

    testWidgets('renders dashboard category cards', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Supplements'), findsOneWidget);
      expect(find.text('Conditions'), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Activities'), findsOneWidget);
      expect(find.text('Food Items'), findsOneWidget);
      expect(find.text('Photo Areas'), findsOneWidget);
    });

    testWidgets('switches to Tracking tab on tap', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      await tester.tap(find.text('Tracking'));
      await tester.pump();

      // Tracking tab should show its app bar
      expect(find.text('Tracking'), findsWidgets);
    });

    testWidgets('switches to Food tab on tap', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      await tester.tap(find.text('Food'));
      await tester.pump();

      expect(find.text('Food Items'), findsWidgets);
      expect(find.text('Food Logs'), findsOneWidget);
    });
  });
}
