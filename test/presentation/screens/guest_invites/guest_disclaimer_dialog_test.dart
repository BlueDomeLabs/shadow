// test/presentation/screens/guest_invites/guest_disclaimer_dialog_test.dart
// Tests for the guest disclaimer dialog.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_disclaimer_dialog.dart';

void main() {
  group('GuestDisclaimerDialog', () {
    testWidgets('shows disclaimer text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showGuestDisclaimerDialog(context),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Important Notice'), findsOneWidget);
      expect(find.text('Guest Access Disclaimer'), findsOneWidget);
      expect(
        find.textContaining('Shadow is a personal health tracking tool'),
        findsOneWidget,
      );
      expect(find.textContaining('not a HIPAA-compliant'), findsOneWidget);
    });

    testWidgets('"I Understand" button dismisses dialog', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                dialogResult = await showGuestDisclaimerDialog(context);
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.text('I Understand'), findsOneWidget);

      // Tap the button
      await tester.tap(find.text('I Understand'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.text('Important Notice'), findsNothing);
      expect(dialogResult, isTrue);
    });

    testWidgets('dialog is not dismissible by tapping outside', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showGuestDisclaimerDialog(context),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      // Try tapping the barrier (outside the dialog)
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      // Dialog should still be shown
      expect(find.text('Important Notice'), findsOneWidget);
    });
  });
}
