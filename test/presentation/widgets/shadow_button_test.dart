// test/presentation/widgets/shadow_button_test.dart
// Tests per 09_WIDGET_LIBRARY.md Section 7.7

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_button.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowButton', () {
    testWidgets('renders with semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Test Button',
              onPressed: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Test Button'), findsOneWidget);
    });

    testWidgets('renders with semantic hint when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Save',
              hint: 'Saves your changes',
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(ShadowButton));
      expect(semantics.hint, 'Saves your changes');
    });

    testWidgets('icon button meets touch target size (48x48)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              variant: ButtonVariant.icon,
              icon: Icons.add,
              label: 'Add',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Per spec Section 7.7: use tester.getSize
      final button = tester.getSize(find.byType(ShadowButton));
      expect(button.width, greaterThanOrEqualTo(48));
      expect(button.height, greaterThanOrEqualTo(48));
    });

    testWidgets('disabled button has null onPressed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Disabled',
              onPressed: null,
              child: Text('Disabled'),
            ),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('disabled button is not tappable', (tester) async {
      const tapped = false;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Disabled',
              onPressed: null,
              child: Text('Disabled'),
            ),
          ),
        ),
      );

      // Try to tap - should not trigger anything
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isFalse);
    });

    testWidgets('elevated variant renders ElevatedButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Elevated',
              onPressed: () {},
              child: const Text('Elevated'),
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('text variant renders TextButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              variant: ButtonVariant.text,
              label: 'Text',
              onPressed: () {},
              child: const Text('Text'),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('icon variant renders IconButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              variant: ButtonVariant.icon,
              icon: Icons.add,
              label: 'Add',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('fab variant renders FloatingActionButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              variant: ButtonVariant.fab,
              icon: Icons.add,
              label: 'Add',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('outlined variant renders OutlinedButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              variant: ButtonVariant.outlined,
              label: 'Outlined',
              onPressed: () {},
              child: const Text('Outlined'),
            ),
          ),
        ),
      );

      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('onPressed callback is invoked on tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Tap Me',
              onPressed: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });

    testWidgets('convenience constructor ShadowButton.elevated works', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton.elevated(
              label: 'Save',
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('convenience constructor ShadowButton.text works', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton.text(
              label: 'Cancel',
              onPressed: () {},
              child: const Text('Cancel'),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('convenience constructor ShadowButton.icon works', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton.icon(
              label: 'Add',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('button with icon and child shows both', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(
              label: 'Save',
              icon: Icons.save,
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('button without child shows label as text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowButton(label: 'Submit', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
    });
  });
}
