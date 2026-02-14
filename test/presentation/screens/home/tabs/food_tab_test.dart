// test/presentation/screens/home/tabs/food_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/food_tab.dart';

void main() {
  group('FoodTab', () {
    Widget buildTab({String? profileName}) => ProviderScope(
      child: MaterialApp(
        home: FoodTab(profileId: 'test-profile-001', profileName: profileName),
      ),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Food Library'), findsOneWidget);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Food Library"), findsOneWidget);
    });

    testWidgets('renders search bar', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search food items...'), findsOneWidget);
    });

    testWidgets('renders history button', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('renders FAB for adding food', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
