// test/presentation/screens/profiles/welcome_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/profiles/welcome_screen.dart';

void main() {
  group('WelcomeScreen', () {
    Widget buildScreen() => const MaterialApp(home: WelcomeScreen());

    testWidgets('renders welcome title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Welcome to Shadow'), findsOneWidget);
    });

    testWidgets('renders subtitle', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(
        find.text('Your personal health tracking companion'),
        findsOneWidget,
      );
    });

    testWidgets('renders feature list', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Track Supplements'), findsOneWidget);
      expect(find.text('Log Food & Reactions'), findsOneWidget);
      expect(find.text('Monitor Conditions'), findsOneWidget);
      expect(find.text('Photo Tracking'), findsOneWidget);
    });

    testWidgets('renders create account button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Create New Account'), findsOneWidget);
    });

    testWidgets('renders privacy note', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(
        find.textContaining('Your data stays on your device'),
        findsOneWidget,
      );
    });
  });
}
