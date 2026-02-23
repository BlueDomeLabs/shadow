/// Access Revoked screen shown when a guest's token is invalid.
///
/// Displayed when: token is revoked, expired, or fails validation.
/// Clears local guest data and prompts the guest to contact the host.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';

/// Screen shown when guest access has been revoked or is no longer valid.
class AccessRevokedScreen extends ConsumerWidget {
  final TokenRejectionReason reason;

  const AccessRevokedScreen({super.key, required this.reason});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Access Revoked',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _messageForReason(reason),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 32),
            Text(
              'Please contact your host for a new invite.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(guestModeProvider.notifier).deactivateGuestMode();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  String _messageForReason(TokenRejectionReason reason) {
    switch (reason) {
      case TokenRejectionReason.revoked:
        return 'Your access to this profile has been revoked by the host.';
      case TokenRejectionReason.expired:
        return 'Your guest access has expired.';
      case TokenRejectionReason.notFound:
        return 'This invite is no longer valid.';
      case TokenRejectionReason.alreadyActiveOnAnotherDevice:
        return 'This invite is already in use on another device. '
            'Only one device can use an invite at a time.';
    }
  }
}
