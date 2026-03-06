// test/presentation/screens/food_items/food_item_editable_nutrition_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_editable_nutrition_section.dart';

void main() {
  late TextEditingController servingSizeAmountController;
  late TextEditingController servingUnitController;
  late TextEditingController caloriesController;
  late TextEditingController proteinController;
  late TextEditingController carbsController;
  late TextEditingController fiberController;
  late TextEditingController sugarController;
  late TextEditingController fatController;
  late TextEditingController sodiumController;

  setUp(() {
    servingSizeAmountController = TextEditingController();
    servingUnitController = TextEditingController();
    caloriesController = TextEditingController();
    proteinController = TextEditingController();
    carbsController = TextEditingController();
    fiberController = TextEditingController();
    sugarController = TextEditingController();
    fatController = TextEditingController();
    sodiumController = TextEditingController();
  });

  tearDown(() {
    servingSizeAmountController.dispose();
    servingUnitController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fiberController.dispose();
    sugarController.dispose();
    fatController.dispose();
    sodiumController.dispose();
  });

  Widget buildWidget({
    String servingSizeAmount = '',
    String servingUnit = '',
    String calories = '',
    String protein = '',
    String carbs = '',
    String fiber = '',
    String sugar = '',
    String fat = '',
    String sodium = '',
  }) {
    servingSizeAmountController.text = servingSizeAmount;
    servingUnitController.text = servingUnit;
    caloriesController.text = calories;
    proteinController.text = protein;
    carbsController.text = carbs;
    fiberController.text = fiber;
    sugarController.text = sugar;
    fatController.text = fat;
    sodiumController.text = sodium;

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: FoodItemEditableNutritionSection(
            servingSizeAmountController: servingSizeAmountController,
            servingUnitController: servingUnitController,
            caloriesController: caloriesController,
            proteinController: proteinController,
            carbsController: carbsController,
            fiberController: fiberController,
            sugarController: sugarController,
            fatController: fatController,
            sodiumController: sodiumController,
          ),
        ),
      ),
    );
  }

  group('FoodItemEditableNutritionSection', () {
    group('renders all 9 fields', () {
      testWidgets('shows Serving Size field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Serving Size'), findsOneWidget);
      });

      testWidgets('shows Unit field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Unit'), findsOneWidget);
      });

      testWidgets('shows Calories field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Calories'), findsOneWidget);
      });

      testWidgets('shows Protein field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Protein'), findsOneWidget);
      });

      testWidgets('shows Total Carbohydrates field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Total Carbohydrates'), findsOneWidget);
      });

      testWidgets('shows Dietary Fiber field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Dietary Fiber'), findsOneWidget);
      });

      testWidgets('shows Sugar field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Sugar'), findsOneWidget);
      });

      testWidgets('shows Total Fat field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Total Fat'), findsOneWidget);
      });

      testWidgets('shows Sodium field', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Sodium'), findsOneWidget);
      });
    });

    group('controllers pre-populated', () {
      testWidgets('serving size value renders correctly', (tester) async {
        await tester.pumpWidget(buildWidget(servingSizeAmount: '100'));
        expect(find.text('100'), findsOneWidget);
      });

      testWidgets('unit value renders in unit field', (tester) async {
        await tester.pumpWidget(buildWidget(servingUnit: 'cup'));
        // 'cup' is a unique value (not also a nutrient unit label)
        expect(find.text('cup'), findsOneWidget);
      });

      testWidgets('calories value renders correctly', (tester) async {
        await tester.pumpWidget(buildWidget(calories: '250'));
        expect(find.text('250'), findsOneWidget);
      });
    });

    group('empty controllers', () {
      testWidgets('shows hint text when empty', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('e.g., 100'), findsOneWidget);
        expect(find.text('optional'), findsWidgets);
      });
    });
  });
}
