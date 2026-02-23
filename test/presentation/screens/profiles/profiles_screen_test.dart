// test/presentation/screens/profiles/profiles_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/profiles/profiles_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    group('profile options menu', () {
      testWidgets('shows Invite Device and Manage Invites options', (
        tester,
      ) async {
        SharedPreferences.setMockInitialValues({});

        // Create a screen with a pre-populated profile
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: ProfilesScreen()),
          ),
        );
        await tester.pump();

        // Add a profile programmatically
        await container
            .read(profileProvider.notifier)
            .addProfile(
              Profile(id: '', name: 'Test Profile', createdAt: DateTime.now()),
            );
        await tester.pumpAndSettle();

        // Open the options menu for the profile
        await tester.tap(find.byIcon(Icons.more_vert).first);
        await tester.pumpAndSettle();

        // Verify the new menu items exist
        expect(find.text('Invite Device'), findsOneWidget);
        expect(find.text('Manage Invites'), findsOneWidget);
      });
    });
  });
}
