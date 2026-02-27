// Phase 18c
// test/presentation/screens/guest_invites/guest_invite_scan_screen_test.dart
// Tests for GuestInviteScanScreen.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/guest_invite.dart';
import 'package:shadow_app/domain/usecases/guest_invites/guest_invite_inputs.dart';
import 'package:shadow_app/domain/usecases/guest_invites/validate_guest_token_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_scan_screen.dart';

void main() {
  group('GuestInviteScanScreen', () {
    Widget buildScreen({ValidateGuestTokenUseCase? validateUseCase}) =>
        ProviderScope(
          overrides: [
            validateGuestTokenUseCaseProvider.overrideWithValue(
              validateUseCase ?? _ImmediateSuccessFakeValidateUseCase(),
            ),
          ],
          child: const MaterialApp(
            home: GuestInviteScanScreen(testDeviceId: 'test-device'),
          ),
        );

    testWidgets('renders app bar with Scan Invite Code title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Scan Invite Code'), findsOneWidget);
    });

    testWidgets('renders MobileScanner widget', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(MobileScanner), findsOneWidget);
    });

    testWidgets('processing flag prevents double activation', (tester) async {
      final fake = _HangingFakeValidateUseCase();

      await tester.pumpWidget(buildScreen(validateUseCase: fake));
      await tester.pumpAndSettle();

      const validCapture = BarcodeCapture(
        barcodes: [
          Barcode(
            rawValue: 'shadow://invite?token=test-token&profile=profile-001',
          ),
        ],
      );

      final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));

      // First detection — triggers processing.
      scanner.onDetect?.call(validCapture);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(fake.callCount, equals(1));

      // Second detection — must be ignored while processing.
      scanner.onDetect?.call(validCapture);
      await tester.pump();

      expect(fake.callCount, equals(1));
    });
  });
}

// ---------------------------------------------------------------------------
// Fake use cases
// ---------------------------------------------------------------------------

/// Succeeds immediately with a minimal GuestInvite.
class _ImmediateSuccessFakeValidateUseCase
    implements ValidateGuestTokenUseCase {
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

/// Hangs until manually completed — used to hold _processing = true.
class _HangingFakeValidateUseCase implements ValidateGuestTokenUseCase {
  int callCount = 0;
  final Completer<Result<GuestInvite, AppError>> _completer = Completer();

  @override
  Future<Result<GuestInvite, AppError>> call(ValidateGuestTokenInput input) {
    callCount++;
    return _completer.future;
  }
}
