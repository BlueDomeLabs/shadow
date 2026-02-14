// test/presentation/screens/profiles/add_edit_profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/profiles/add_edit_profile_screen.dart';

void main() {
  group('AddEditProfileScreen', () {
    Widget buildScreen() =>
        const ProviderScope(child: MaterialApp(home: AddEditProfileScreen()));

    testWidgets('renders create profile title for new profile', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Create Profile'), findsWidgets);
    });

    testWidgets('renders name field', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('renders date of birth picker', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Date of Birth'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
    });

    testWidgets('renders notes field', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Notes'), findsOneWidget);
    });

    testWidgets('validates name is required', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      // Scroll to and tap save button without entering name
      final button = find.byType(ElevatedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Name is required'), findsOneWidget);
    });
  });
}
