// test/presentation/screens/home/tabs/sleep_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/sleep_tab.dart';

void main() {
  group('SleepTab', () {
    Widget buildTab() => const ProviderScope(
      child: MaterialApp(home: SleepTab(profileId: 'test-profile-001')),
    );

    testWidgets('renders sleep entry list screen', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      // SleepTab wraps SleepEntryListScreen which has its own app bar
      expect(find.text('Sleep Log'), findsOneWidget);
    });
  });
}
