// test/presentation/screens/profiles/profiles_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/profiles/profiles_screen.dart';

void main() {
  group('ProfilesScreen', () {
    Widget buildScreen() => ProviderScope(
      overrides: [
        // Avoid UnimplementedError from repository/service providers not
        // wired in tests — profileProvider needs them via use cases.
        profileProvider.overrideWith(
          (ref) => ProfileNotifier.forTesting(const ProfileState()),
        ),
      ],
      child: const MaterialApp(home: ProfilesScreen()),
    );

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
        // Use a pre-populated profile state to avoid needing real use cases.
        final container = ProviderContainer(
          overrides: [
            profileProvider.overrideWith(
              (ref) => ProfileNotifier.forTesting(
                const ProfileState(
                  profiles: [
                    Profile(
                      id: 'profile-test-001',
                      clientId: 'client-001',
                      name: 'Test Profile',
                      syncMetadata: SyncMetadata(
                        syncCreatedAt: 0,
                        syncUpdatedAt: 0,
                        syncDeviceId: 'test-device',
                      ),
                    ),
                  ],
                  currentProfileId: 'profile-test-001',
                ),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(home: ProfilesScreen()),
          ),
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
