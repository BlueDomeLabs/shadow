import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/shadow_badge.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowBadge', () {
    group('diet badge', () {
      testWidgets('renders diet type with icon and label', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.diet(dietType: DietPresetType.vegan),
            ),
          ),
        );

        expect(find.text('Vegan'), findsOneWidget);
        expect(find.byIcon(Icons.eco), findsOneWidget);
      });

      testWidgets('hides icon when showIcon is false', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.diet(
                dietType: DietPresetType.keto,
                showIcon: false,
              ),
            ),
          ),
        );

        expect(find.text('Keto'), findsOneWidget);
        expect(find.byIcon(Icons.egg), findsNothing);
      });

      testWidgets('renders different sizes', (tester) async {
        for (final size in BadgeSize.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ShadowBadge.diet(
                  dietType: DietPresetType.paleo,
                  size: size,
                ),
              ),
            ),
          );

          expect(find.text('Paleo'), findsOneWidget);
        }
      });
    });

    group('status badge', () {
      testWidgets('renders status text', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.status(status: 'Active', color: Colors.green),
            ),
          ),
        );

        expect(find.text('Active'), findsOneWidget);
      });

      testWidgets('renders with icon', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.status(
                status: 'Synced',
                color: Colors.blue,
                icon: Icons.cloud_done,
              ),
            ),
          ),
        );

        expect(find.text('Synced'), findsOneWidget);
        expect(find.byIcon(Icons.cloud_done), findsOneWidget);
      });

      testWidgets('uses theme color when no color specified', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ShadowBadge.status(status: 'Default')),
          ),
        );

        expect(find.text('Default'), findsOneWidget);
      });
    });

    group('count badge', () {
      testWidgets('renders count', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: ShadowBadge.count(count: 5))),
        );

        expect(find.text('5'), findsOneWidget);
      });

      testWidgets('shows max+ when count exceeds max', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ShadowBadge.count(count: 150)),
          ),
        );

        expect(find.text('99+'), findsOneWidget);
      });

      testWidgets('uses custom color', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.count(count: 3, color: Colors.blue),
            ),
          ),
        );

        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('renders different sizes', (tester) async {
        for (final size in BadgeSize.values) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: ShadowBadge.count(count: 7, size: size)),
            ),
          );

          expect(find.text('7'), findsOneWidget);
        }
      });
    });

    group('accessibility', () {
      testWidgets('diet badge is wrapped in Semantics', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.diet(dietType: DietPresetType.mediterranean),
            ),
          ),
        );

        expect(find.byType(ShadowBadge), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
        expect(find.text('Mediterranean'), findsOneWidget);
      });

      testWidgets('status badge is wrapped in Semantics', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ShadowBadge.status(status: 'Connected')),
          ),
        );

        expect(find.byType(ShadowBadge), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
        expect(find.text('Connected'), findsOneWidget);
      });

      testWidgets('count badge shows overflow text', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: ShadowBadge.count(count: 200)),
          ),
        );

        expect(find.byType(ShadowBadge), findsOneWidget);
        expect(find.text('99+'), findsOneWidget);
      });

      testWidgets('custom semantic label is accessible', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ShadowBadge.diet(
                dietType: DietPresetType.vegan,
                semanticLabel: 'Current diet: Vegan',
              ),
            ),
          ),
        );

        expect(find.byType(ShadowBadge), findsOneWidget);
        expect(find.byType(Semantics), findsWidgets);
      });
    });
  });
}
