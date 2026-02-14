// test/presentation/screens/home/tabs/supplements_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/supplements_tab.dart';

void main() {
  group('SupplementsTab', () {
    Widget buildTab({String? profileName}) => ProviderScope(
      child: MaterialApp(
        home: SupplementsTab(
          profileId: 'test-profile-001',
          profileName: profileName,
        ),
      ),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Daily Protocol'), findsOneWidget);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Daily Protocol"), findsOneWidget);
    });

    testWidgets('renders FAB for adding supplements', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders with async provider state', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      // Provider resolves asynchronously; verify no crash
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
