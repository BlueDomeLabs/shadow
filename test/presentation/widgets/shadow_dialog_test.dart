// test/presentation/widgets/shadow_dialog_test.dart
// Tests per 09_WIDGET_LIBRARY.md Section 7.7

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_button.dart';
import 'package:shadow_app/presentation/widgets/shadow_dialog.dart';

void main() {
  group('ShadowDialog', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ShadowDialog(
                      title: 'Test Dialog',
                      content: 'Dialog content',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);
    });

    testWidgets('renders content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ShadowDialog(
                      title: 'Title',
                      content: 'This is the content',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('This is the content'), findsOneWidget);
    });

    testWidgets('renders actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => ShadowDialog(
                      title: 'Title',
                      content: 'Content',
                      actions: [
                        ShadowButton.text(
                          label: 'Cancel',
                          onPressed: () {},
                          child: const Text('Cancel'),
                        ),
                        ShadowButton.elevated(
                          label: 'OK',
                          onPressed: () {},
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('has semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ShadowDialog(
                      title: 'Delete Item',
                      content: 'Are you sure?',
                      semanticLabel: 'Confirmation dialog',
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Confirmation dialog'), findsOneWidget);
    });

    testWidgets('alert convenience constructor works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ShadowDialog.alert(
                      title: 'Alert',
                      content: 'This is an alert',
                    ),
                  );
                },
                child: const Text('Show Alert'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Alert'), findsOneWidget);
      expect(find.text('This is an alert'), findsOneWidget);
    });

    testWidgets('confirm convenience constructor works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ShadowDialog.confirm(
                      title: 'Confirm',
                      content: 'Please confirm',
                    ),
                  );
                },
                child: const Text('Show Confirm'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('custom content widget is rendered', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => const ShadowDialog(
                      title: 'Custom Content',
                      contentWidget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning),
                          Text('Custom widget content'),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.text('Custom widget content'), findsOneWidget);
    });
  });

  group('showDeleteConfirmationDialog', () {
    testWidgets('returns true when confirmed', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDeleteConfirmationDialog(
                    context: context,
                    title: 'Delete Item',
                    contentText: 'Are you sure?',
                  );
                },
                child: const Text('Delete'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Tap the confirm button
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('returns false when cancelled', (tester) async {
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showDeleteConfirmationDialog(
                    context: context,
                    title: 'Delete Item',
                    contentText: 'Are you sure?',
                  );
                },
                child: const Text('Delete'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Tap the cancel button
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('custom button text is displayed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDeleteConfirmationDialog(
                    context: context,
                    title: 'Remove',
                    contentText: 'Remove this item?',
                    confirmButtonText: 'Remove',
                    cancelButtonText: 'Keep',
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Remove'), findsWidgets);
      expect(find.text('Keep'), findsOneWidget);
    });
  });

  group('showTextInputDialog', () {
    testWidgets('returns entered text when confirmed', (tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showTextInputDialog(
                    context: context,
                    title: 'Enter Name',
                    labelText: 'Name',
                  );
                },
                child: const Text('Input'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Input'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test Name');
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, 'Test Name');
    });

    testWidgets('returns null when cancelled', (tester) async {
      String? result = 'initial';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await showTextInputDialog(
                    context: context,
                    title: 'Enter Name',
                    labelText: 'Name',
                  );
                },
                child: const Text('Input'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Input'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('initial value is populated', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showTextInputDialog(
                    context: context,
                    title: 'Edit Name',
                    labelText: 'Name',
                    initialValue: 'Existing Name',
                  );
                },
                child: const Text('Edit'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Existing Name'), findsOneWidget);
    });
  });

  group('showAccessibleSnackBar', () {
    testWidgets('displays message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAccessibleSnackBar(
                    context: context,
                    message: 'Item saved successfully',
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      await tester.pump();

      expect(find.text('Item saved successfully'), findsOneWidget);
    });

    testWidgets('displays action button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAccessibleSnackBar(
                    context: context,
                    message: 'Item deleted',
                    actionLabel: 'Undo',
                    onAction: () {},
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      await tester.pump();

      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('action callback is invoked', (tester) async {
      var actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showAccessibleSnackBar(
                    context: context,
                    message: 'Deleted',
                    actionLabel: 'Undo',
                    onAction: () => actionTapped = true,
                  );
                },
                child: const Text('Show SnackBar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      // Wait for snackbar animation to complete
      await tester.pumpAndSettle();

      await tester.tap(find.text('Undo'));
      expect(actionTapped, isTrue);
    });
  });
}
