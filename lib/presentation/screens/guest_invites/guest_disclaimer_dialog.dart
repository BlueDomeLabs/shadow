/// Guest disclaimer dialog.
///
/// Shown to guest users on first launch. Contains the required
/// disclaimer text from 56_GUEST_PROFILE_ACCESS.md.
library;

import 'package:flutter/material.dart';

/// Disclaimer text required by 56_GUEST_PROFILE_ACCESS.md.
const guestDisclaimerText =
    'Shadow is a personal health tracking tool. It is not a HIPAA-compliant '
    'medical records system and is not intended for use as a clinical tool. '
    'Do not use Shadow to store or transmit protected health information (PHI) '
    'in a regulated medical context. By using this app, you acknowledge that '
    "data is stored in your host's personal Google Drive account and is "
    "subject to Google's terms of service.";

/// Shows the guest disclaimer dialog.
///
/// Returns true when the user acknowledges the disclaimer.
Future<bool> showGuestDisclaimerDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _GuestDisclaimerDialog(),
  );
  return result ?? false;
}

class _GuestDisclaimerDialog extends StatelessWidget {
  const _GuestDisclaimerDialog();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Row(
      children: [
        Icon(Icons.info_outline, color: Colors.indigo),
        SizedBox(width: 8),
        Expanded(child: Text('Important Notice')),
      ],
    ),
    content: const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Guest Access Disclaimer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 12),
          Text(
            guestDisclaimerText,
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    ),
    actions: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          child: const Text('I Understand'),
        ),
      ),
    ],
  );
}
