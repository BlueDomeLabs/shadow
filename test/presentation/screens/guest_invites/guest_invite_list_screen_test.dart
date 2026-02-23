// test/presentation/screens/guest_invites/guest_invite_list_screen_test.dart
// Tests for GuestInviteListScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/create_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/list_guest_invites_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/remove_guest_device_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_list_screen.dart';

void main() {
  group('GuestInviteListScreen', () {
    const testProfileId = 'profile-001';
    const testProfileName = 'Test Patient';

    GuestInvite createTestInvite({
      String id = 'invite-001',
      String label = "John's iPhone",
      bool isRevoked = false,
      int? expiresAt,
      int? lastSeenAt,
      String? activeDeviceId,
    }) => GuestInvite(
      id: id,
      profileId: testProfileId,
      token: 'token-$id',
      label: label,
      createdAt: DateTime(2026).millisecondsSinceEpoch,
      isRevoked: isRevoked,
      expiresAt: expiresAt,
      lastSeenAt: lastSeenAt,
      activeDeviceId: activeDeviceId,
    );

    Widget buildScreen({List<GuestInvite> invites = const []}) => ProviderScope(
      overrides: [
        listGuestInvitesUseCaseProvider.overrideWithValue(
          _FakeListUseCase(invites),
        ),
        createGuestInviteUseCaseProvider.overrideWithValue(
          _FakeCreateUseCase(createTestInvite()),
        ),
        revokeGuestInviteUseCaseProvider.overrideWithValue(
          _FakeRevokeUseCase(),
        ),
        removeGuestDeviceUseCaseProvider.overrideWithValue(
          _FakeRemoveDeviceUseCase(),
        ),
      ],
      child: const MaterialApp(
        home: GuestInviteListScreen(
          profileId: testProfileId,
          profileName: testProfileName,
        ),
      ),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Manage Invites'), findsOneWidget);
    });

    testWidgets('shows empty state when no invites', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('No active invites'), findsOneWidget);
      expect(
        find.text('Tap + to create an invite for this profile'),
        findsOneWidget,
      );
    });

    testWidgets('shows invite cards with status', (tester) async {
      final invites = [
        createTestInvite(label: "Patient's Phone"),
        createTestInvite(
          id: 'invite-002',
          label: 'Revoked Device',
          isRevoked: true,
        ),
      ];

      await tester.pumpWidget(buildScreen(invites: invites));
      await tester.pumpAndSettle();

      expect(find.text("Patient's Phone"), findsOneWidget);
      expect(find.text('Revoked Device'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Revoked'), findsOneWidget);
    });

    testWidgets('Remove Device shows confirmation dialog', (tester) async {
      final invites = [createTestInvite()];

      await tester.pumpWidget(buildScreen(invites: invites));
      await tester.pumpAndSettle();

      // Open popup menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap Remove Device
      await tester.tap(find.text('Remove Device'));
      await tester.pumpAndSettle();

      // First confirmation dialog should appear
      expect(find.text('Remove Device'), findsWidgets);
      expect(
        find.textContaining('Are you sure you want to remove'),
        findsOneWidget,
      );
    });

    testWidgets('shows create invite FAB', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows device connected indicator for activated invite', (
      tester,
    ) async {
      final invites = [createTestInvite(activeDeviceId: 'device-123')];

      await tester.pumpWidget(buildScreen(invites: invites));
      await tester.pumpAndSettle();

      expect(find.text('Device connected'), findsOneWidget);
    });

    testWidgets('shows last seen date when available', (tester) async {
      final invites = [
        createTestInvite(
          lastSeenAt: DateTime(2026, 2, 20).millisecondsSinceEpoch,
        ),
      ];

      await tester.pumpWidget(buildScreen(invites: invites));
      await tester.pumpAndSettle();

      expect(find.textContaining('Last seen:'), findsOneWidget);
    });
  });
}

// Fake use cases

class _FakeListUseCase implements ListGuestInvitesUseCase {
  final List<GuestInvite> _invites;
  _FakeListUseCase(this._invites);

  @override
  Future<Result<List<GuestInvite>, AppError>> call(String profileId) async =>
      Success(_invites);
}

class _FakeCreateUseCase implements CreateGuestInviteUseCase {
  final GuestInvite _result;
  _FakeCreateUseCase(this._result);

  @override
  Future<Result<GuestInvite, AppError>> call(
    CreateGuestInviteInput input,
  ) async => Success(_result);
}

class _FakeRevokeUseCase implements RevokeGuestInviteUseCase {
  @override
  Future<Result<void, AppError>> call(RevokeGuestInviteInput input) async =>
      const Success(null);
}

class _FakeRemoveDeviceUseCase implements RemoveGuestDeviceUseCase {
  @override
  Future<Result<void, AppError>> call(RemoveGuestDeviceInput input) async =>
      const Success(null);
}
