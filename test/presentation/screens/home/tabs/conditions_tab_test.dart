// test/presentation/screens/home/tabs/conditions_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/conditions_tab.dart';

void main() {
  group('ConditionsTab', () {
    Widget buildTab({String? profileName}) => ProviderScope(
      child: MaterialApp(
        home: ConditionsTab(
          profileId: 'test-profile-001',
          profileName: profileName,
        ),
      ),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Conditions'), findsWidgets);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Conditions"), findsOneWidget);
    });

    testWidgets('renders flare-ups button', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Flare-Ups'), findsOneWidget);
    });

    testWidgets('renders FAB for adding conditions', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
