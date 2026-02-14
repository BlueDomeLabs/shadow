// test/presentation/screens/home/tabs/reports_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/reports_tab.dart';

void main() {
  group('ReportsTab', () {
    Widget buildTab({String? profileName}) =>
        MaterialApp(home: ReportsTab(profileName: profileName));

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Reports'), findsOneWidget);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Reports"), findsOneWidget);
    });

    testWidgets('renders health reports heading', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Health Reports'), findsOneWidget);
    });

    testWidgets('renders generate report button', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Generate New Report'), findsOneWidget);
    });

    testWidgets('shows coming soon dialog on button tap', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      await tester.tap(find.text('Generate New Report'));
      await tester.pumpAndSettle();

      expect(find.text('Coming Soon'), findsOneWidget);
    });
  });
}
