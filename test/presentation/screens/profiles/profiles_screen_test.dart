// test/presentation/screens/profiles/profiles_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/profiles/profiles_screen.dart';

void main() {
  group('ProfilesScreen', () {
    Widget buildScreen() =>
        const ProviderScope(child: MaterialApp(home: ProfilesScreen()));

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Profiles'), findsOneWidget);
    });

    testWidgets('renders FAB for adding profiles', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows empty state when no profiles', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('No profiles yet'), findsOneWidget);
      expect(find.text('Tap + to add your first profile'), findsOneWidget);
    });

    testWidgets('renders version footer', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Shadow v1.0.0'), findsOneWidget);
    });

    testWidgets('renders privacy policy link', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Privacy Policy'), findsOneWidget);
    });
  });
}
