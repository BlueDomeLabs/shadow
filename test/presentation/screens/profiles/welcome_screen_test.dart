// test/presentation/screens/profiles/welcome_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/validate_guest_token_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_scan_screen.dart';
import 'package:shadow_app/presentation/screens/profiles/welcome_screen.dart';

void main() {
  group('WelcomeScreen', () {
    Widget buildScreen() => const MaterialApp(home: WelcomeScreen());

    Widget buildScreenWithProviders() => ProviderScope(
      overrides: [
        validateGuestTokenUseCaseProvider.overrideWithValue(
          _FakeValidateUseCase(),
        ),
      ],
      child: const MaterialApp(home: WelcomeScreen()),
    );

    testWidgets('renders welcome title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Welcome to Shadow'), findsOneWidget);
    });

    testWidgets('renders subtitle', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(
        find.text('Your personal health tracking companion'),
        findsOneWidget,
      );
    });

    testWidgets('renders feature list', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Track Supplements'), findsOneWidget);
      expect(find.text('Log Food & Reactions'), findsOneWidget);
      expect(find.text('Monitor Conditions'), findsOneWidget);
      expect(find.text('Photo Tracking'), findsOneWidget);
    });

    testWidgets('renders create account button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(find.text('Create New Account'), findsOneWidget);
    });

    testWidgets('renders privacy note', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pump();

      expect(
        find.textContaining('Your data stays on your device'),
        findsOneWidget,
      );
    });

    testWidgets('join button navigates to GuestInviteScanScreen', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreenWithProviders());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Join Existing Account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Join Existing Account'));
      // Pump two frames: first starts the push, second renders new route.
      await tester.pump();
      await tester.pump();

      expect(find.byType(GuestInviteScanScreen), findsOneWidget);
    });

    testWidgets('coming soon dialog does not appear when join button tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreenWithProviders());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Join Existing Account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Join Existing Account'));
      await tester.pump();
      await tester.pump();

      expect(
        find.text('Joining an existing account via QR code'),
        findsNothing,
      );
    });
  });
}

// ---------------------------------------------------------------------------
// Fake use case for navigation test
// ---------------------------------------------------------------------------

class _FakeValidateUseCase implements ValidateGuestTokenUseCase {
  @override
  Future<Result<GuestInvite, AppError>> call(
    ValidateGuestTokenInput input,
  ) async => Success(
    GuestInvite(
      id: 'invite-001',
      profileId: 'profile-001',
      token: input.token,
      createdAt: 0,
    ),
  );
}
