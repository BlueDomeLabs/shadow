// test/presentation/screens/food_items/food_item_packaged_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_packaged_section.dart';

void main() {
  late TextEditingController brandController;
  late TextEditingController barcodeController;
  late TextEditingController ingredientsTextController;

  setUp(() {
    brandController = TextEditingController();
    barcodeController = TextEditingController();
    ingredientsTextController = TextEditingController();
  });

  tearDown(() {
    brandController.dispose();
    barcodeController.dispose();
    ingredientsTextController.dispose();
  });

  Widget buildWidget({
    String? importSource,
    String? imageUrl,
    VoidCallback? onScanBarcode,
    VoidCallback? onScanLabel,
  }) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: FoodItemPackagedSection(
          brandController: brandController,
          barcodeController: barcodeController,
          ingredientsTextController: ingredientsTextController,
          importSource: importSource,
          imageUrl: imageUrl,
          onScanBarcode: onScanBarcode ?? () {},
          onScanLabel: onScanLabel ?? () {},
        ),
      ),
    ),
  );

  group('FoodItemPackagedSection', () {
    group('rendering', () {
      testWidgets('renders Brand field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Brand'), findsOneWidget);
      });

      testWidgets('renders Barcode field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Barcode'), findsOneWidget);
      });

      testWidgets('renders Ingredients field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Ingredients'), findsOneWidget);
      });

      testWidgets('renders Scan Barcode button', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Scan Barcode'), findsWidgets);
      });

      testWidgets('renders Scan Label button', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Scan Label'), findsOneWidget);
      });
    });

    group('import source badge', () {
      testWidgets('shows badge when importSource is non-null', (tester) async {
        await tester.pumpWidget(buildWidget(importSource: 'open_food_facts'));
        expect(find.textContaining('Source:'), findsOneWidget);
        expect(find.textContaining('Open Food Facts'), findsOneWidget);
      });

      testWidgets('shows Photo Scan label for claude_scan', (tester) async {
        await tester.pumpWidget(buildWidget(importSource: 'claude_scan'));
        expect(find.textContaining('Photo Scan'), findsOneWidget);
      });

      testWidgets('hides badge when importSource is null', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.textContaining('Source:'), findsNothing);
      });
    });

    group('callbacks', () {
      testWidgets('Scan Barcode top button fires onScanBarcode', (
        tester,
      ) async {
        var called = false;
        await tester.pumpWidget(
          buildWidget(onScanBarcode: () => called = true),
        );
        await tester.tap(find.text('Scan Barcode').first);
        expect(called, isTrue);
      });

      testWidgets('Scan Label button fires onScanLabel', (tester) async {
        var called = false;
        await tester.pumpWidget(buildWidget(onScanLabel: () => called = true));
        await tester.tap(find.text('Scan Label'));
        expect(called, isTrue);
      });
    });
  });
}
