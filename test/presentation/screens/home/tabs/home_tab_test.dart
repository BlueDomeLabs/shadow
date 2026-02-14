// test/presentation/screens/home/tabs/home_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/home_tab.dart';

void main() {
  group('HomeTab', () {
    Widget buildTab({String? profileName}) => ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: HomeTab(
            profileId: 'test-profile-001',
            profileName: profileName,
          ),
        ),
      ),
    );

    testWidgets('renders app branding section', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Shadow'), findsOneWidget);
      expect(find.text('Personal Health Tracking'), findsOneWidget);
    });

    testWidgets('renders profile selector card', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      // No profiles in test, shows create prompt
      expect(find.text('No Profile Selected'), findsOneWidget);
      expect(find.text('Tap to create a profile'), findsOneWidget);
    });

    testWidgets('renders quick action buttons', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Report a Flare-Up'), findsOneWidget);
      expect(find.text('Report Supplements'), findsOneWidget);
      expect(find.text('Log Food'), findsOneWidget);
      expect(find.text('Log Fluids'), findsOneWidget);
      expect(find.text('Start Photo Round'), findsOneWidget);
      expect(find.text('Going to Sleep'), findsOneWidget);
      expect(find.text('Waking Up'), findsOneWidget);
      expect(find.text('Journal'), findsOneWidget);
    });
  });
}
