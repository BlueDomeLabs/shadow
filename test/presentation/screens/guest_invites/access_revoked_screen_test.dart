// test/presentation/screens/guest_invites/access_revoked_screen_test.dart
// Tests for AccessRevokedScreen reason-specific messages and deactivation.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shadow_app/presentation/screens/guest_invites/access_revoked_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildTestWidget(TokenRejectionReason reason) {
  SharedPreferences.setMockInitialValues({});
  return ProviderScope(
    child: MaterialApp(home: AccessRevokedScreen(reason: reason)),
  );
}

void main() {
  group('AccessRevokedScreen', () {
    testWidgets('shows lock icon', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.revoked));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('shows "Access Revoked" title', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.revoked));
      await tester.pumpAndSettle();

      expect(find.text('Access Revoked'), findsOneWidget);
    });

    testWidgets('shows revoked message', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.revoked));
      await tester.pumpAndSettle();

      expect(
        find.text('Your access to this profile has been revoked by the host.'),
        findsOneWidget,
      );
    });

    testWidgets('shows expired message', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.expired));
      await tester.pumpAndSettle();

      expect(find.text('Your guest access has expired.'), findsOneWidget);
    });

    testWidgets('shows notFound message', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.notFound));
      await tester.pumpAndSettle();

      expect(find.text('This invite is no longer valid.'), findsOneWidget);
    });

    testWidgets('shows alreadyActiveOnAnotherDevice message', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(TokenRejectionReason.alreadyActiveOnAnotherDevice),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'This invite is already in use on another device. '
          'Only one device can use an invite at a time.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows contact host prompt', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.revoked));
      await tester.pumpAndSettle();

      expect(
        find.text('Please contact your host for a new invite.'),
        findsOneWidget,
      );
    });

    testWidgets('shows OK button', (tester) async {
      await tester.pumpWidget(_buildTestWidget(TokenRejectionReason.revoked));
      await tester.pumpAndSettle();

      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('OK button deactivates guest mode', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final notifier = GuestModeNotifier()
        ..activateGuestMode(profileId: 'p1', token: 't1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [guestModeProvider.overrideWith((ref) => notifier)],
          child: const MaterialApp(
            home: AccessRevokedScreen(reason: TokenRejectionReason.revoked),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Confirm guest mode is active before tap
      expect(notifier.state.isGuestMode, isTrue);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Guest mode should be deactivated
      expect(notifier.state.isGuestMode, isFalse);
    });
  });
}
