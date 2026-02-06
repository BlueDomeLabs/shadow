// test/presentation/widgets/shadow_card_test.dart
// Tests per 09_WIDGET_LIBRARY.md Section 7.7

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_card.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowCard(child: Text('Card Content'))),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('standard variant has elevation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowCard(child: Text('Content'))),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2); // Default elevation for standard
    });

    testWidgets('listItem variant has no elevation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowCard(
              variant: CardVariant.listItem,
              child: Text('Content'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0);
    });

    testWidgets('tappable card has semantic label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowCard(
              onTap: () {},
              semanticLabel: 'Vitamin D supplement card',
              child: const Text('Vitamin D'),
            ),
          ),
        ),
      );

      expect(
        find.bySemanticsLabel('Vitamin D supplement card'),
        findsOneWidget,
      );
    });

    testWidgets('tappable card has semantic hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowCard(
              onTap: () {},
              semanticLabel: 'Card',
              semanticHint: 'Double tap to view details',
              child: const Text('Content'),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(InkWell));
      expect(semantics.hint, 'Double tap to view details');
    });

    testWidgets('onTap callback is invoked', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowCard(
              onTap: () => tapped = true,
              semanticLabel: 'Tappable',
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('non-tappable card has no InkWell', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowCard(child: Text('Content'))),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('custom elevation is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowCard(elevation: 8, child: Text('Content')),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 8);
    });

    testWidgets('custom color is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowCard(color: Colors.blue, child: Text('Content')),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.blue);
    });

    testWidgets('convenience constructor ShadowCard.standard works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowCard.standard(child: Text('Standard Card')),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    testWidgets('convenience constructor ShadowCard.listItem works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowCard.listItem(child: Text('List Item'))),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 0);
    });

    testWidgets('custom padding is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowCard(
              padding: EdgeInsets.all(32),
              child: Text('Content'),
            ),
          ),
        ),
      );

      // Find the Padding widget that directly contains the Text child
      final paddingFinder = find.ancestor(
        of: find.text('Content'),
        matching: find.byType(Padding),
      );
      expect(paddingFinder, findsWidgets);

      // Get the first one (direct parent of Text)
      final padding = tester.widget<Padding>(paddingFinder.first);
      expect(padding.padding, const EdgeInsets.all(32));
    });

    testWidgets('custom margin is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowCard(
              margin: EdgeInsets.all(24),
              child: Text('Content'),
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.margin, const EdgeInsets.all(24));
    });
  });
}
