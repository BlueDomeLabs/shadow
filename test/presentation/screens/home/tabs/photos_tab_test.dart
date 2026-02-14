// test/presentation/screens/home/tabs/photos_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/home/tabs/photos_tab.dart';

void main() {
  group('PhotosTab', () {
    Widget buildTab({String? profileName}) => ProviderScope(
      child: MaterialApp(
        home: PhotosTab(
          profileId: 'test-profile-001',
          profileName: profileName,
        ),
      ),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Photo Tracking'), findsOneWidget);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Photo Tracking"), findsOneWidget);
    });

    testWidgets('renders manage photo areas button', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Manage Photo Areas'), findsOneWidget);
    });
  });
}
