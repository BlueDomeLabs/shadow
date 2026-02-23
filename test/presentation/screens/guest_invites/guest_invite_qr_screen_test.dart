// test/presentation/screens/guest_invites/guest_invite_qr_screen_test.dart
// Tests for GuestInviteQrScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/create_guest_invite_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/list_guest_invites_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/remove_guest_device_use_case.dart';
import 'package:shadow_app/domain/usecases/guest_invites/revoke_guest_invite_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_qr_screen.dart';

void main() {
  group('GuestInviteQrScreen', () {
    const testProfileId = 'profile-001';
    const testProfileName = 'Test Patient';

    final testInvite = GuestInvite(
      id: 'invite-001',
      profileId: testProfileId,
      token: 'token-abc-123',
      createdAt: DateTime(2026).millisecondsSinceEpoch,
    );

    Widget buildScreen() => ProviderScope(
      overrides: [
        listGuestInvitesUseCaseProvider.overrideWithValue(_FakeListUseCase([])),
        createGuestInviteUseCaseProvider.overrideWithValue(
          _FakeCreateUseCase(testInvite),
        ),
        revokeGuestInviteUseCaseProvider.overrideWithValue(
          _FakeRevokeUseCase(),
        ),
        removeGuestDeviceUseCaseProvider.overrideWithValue(
          _FakeRemoveDeviceUseCase(),
        ),
      ],
      child: const MaterialApp(
        home: GuestInviteQrScreen(
          profileId: testProfileId,
          profileName: testProfileName,
        ),
      ),
    );

    testWidgets('renders app bar with "Invite Device" title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Invite Device'), findsOneWidget);
    });

    testWidgets('shows QR code widget', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('shows Share button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Share Invite Link'), findsOneWidget);
    });

    testWidgets('shows invite label field', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Invite Label'), findsOneWidget);
    });

    testWidgets('shows profile name in header', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Share access to $testProfileName'), findsOneWidget);
    });

    testWidgets('shows creation date', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Created'), findsOneWidget);
    });

    testWidgets('shows expiry information', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Expires'), findsOneWidget);
      expect(find.text('Never'), findsOneWidget);
    });
  });
}

// Fake use cases for testing

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
