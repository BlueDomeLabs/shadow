// test/presentation/widgets/shadow_status_test.dart
// Tests per 09_WIDGET_LIBRARY.md Section 7.7

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_status.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowStatus', () {
    testWidgets('loading variant renders CircularProgressIndicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus(label: 'Loading')),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loading variant has semantic label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus(label: 'Loading supplements')),
        ),
      );

      // Per spec Section 7.7: use find.bySemanticsLabel
      expect(find.bySemanticsLabel('Loading supplements'), findsOneWidget);
    });

    testWidgets('progress variant shows value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowStatus(
              variant: StatusVariant.progress,
              label: '75% complete',
              value: 0.75,
            ),
          ),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, 0.75);
    });

    testWidgets('progress variant with null value is indeterminate', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowStatus(
              variant: StatusVariant.progress,
              label: 'Loading',
            ),
          ),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, isNull);
    });

    testWidgets('status variant renders icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowStatus(
              variant: StatusVariant.status,
              label: 'Synced',
              icon: Icons.cloud_done,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });

    testWidgets('status variant applies color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowStatus(
              variant: StatusVariant.status,
              label: 'Error',
              icon: Icons.error,
              color: Colors.red,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.red);
    });

    testWidgets('sync variant renders cloud icon by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus.sync(label: 'Synced')),
        ),
      );

      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });

    testWidgets('showLabel true displays text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus(label: 'Loading data')),
        ),
      );

      expect(find.text('Loading data'), findsOneWidget);
    });

    testWidgets('showLabel false hides text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowStatus(label: 'Loading data', showLabel: false),
          ),
        ),
      );

      expect(find.text('Loading data'), findsNothing);
    });

    testWidgets('custom size is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus(label: 'Loading', size: 48)),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 48);
      expect(sizedBox.height, 48);
    });

    testWidgets('convenience constructor ShadowStatus.loading works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus.loading(label: 'Loading')),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('convenience constructor ShadowStatus.progress works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus.progress(label: '50%', value: 0.5)),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.value, 0.5);
    });

    testWidgets('convenience constructor ShadowStatus.status works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowStatus.status(label: 'Online', icon: Icons.wifi),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi), findsOneWidget);
    });

    testWidgets('convenience constructor ShadowStatus.sync works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowStatus.sync(label: 'Synced')),
        ),
      );

      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });
  });

  group('EmptyStateWidget', () {
    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(icon: Icons.inbox, message: 'No items'),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              message: 'No supplements added',
            ),
          ),
        ),
      );

      expect(find.text('No supplements added'), findsOneWidget);
    });

    testWidgets('renders submessage when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              message: 'No items',
              submessage: 'Tap + to add your first item',
            ),
          ),
        ),
      );

      expect(find.text('Tap + to add your first item'), findsOneWidget);
    });

    testWidgets('does not render submessage when null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(icon: Icons.inbox, message: 'No items'),
          ),
        ),
      );

      // Should only have the message, not a submessage
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('renders action widget when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              message: 'No items',
              action: ElevatedButton(
                onPressed: () {},
                child: const Text('Add Item'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
    });

    testWidgets('custom icon size is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              message: 'No items',
              iconSize: 100,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 100);
    });

    testWidgets('custom icon color is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              message: 'No items',
              iconColor: Colors.blue,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.blue);
    });

    testWidgets('action button is tappable', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              message: 'No items',
              action: ElevatedButton(
                onPressed: () => tapped = true,
                child: const Text('Add'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add'));
      expect(tapped, isTrue);
    });
  });
}
