// test/presentation/screens/food_items/food_item_composed_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_composed_section.dart';

FoodItem makeFoodItem({
  String id = 'food-001',
  String name = 'Chicken',
  double? servingSize,
  String? servingUnit,
  double? calories,
  double? proteinGrams,
}) => FoodItem(
  id: id,
  clientId: 'client-001',
  profileId: 'profile-001',
  name: name,
  servingSize: servingSize,
  servingUnit: servingUnit,
  calories: calories,
  proteinGrams: proteinGrams,
  syncMetadata: SyncMetadata.empty(),
);

void main() {
  late TextEditingController servingSizeAmountController;
  late TextEditingController servingUnitController;

  setUp(() {
    servingSizeAmountController = TextEditingController();
    servingUnitController = TextEditingController();
  });

  tearDown(() {
    servingSizeAmountController.dispose();
    servingUnitController.dispose();
  });

  Widget buildWidget({
    List<FoodItemComponentEntry> components = const [],
    List<FoodItem> allItems = const [],
    void Function(List<FoodItemComponentEntry>)? onComponentsChanged,
  }) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: FoodItemComposedSection(
          components: components,
          allItems: allItems,
          servingSizeAmountController: servingSizeAmountController,
          servingUnitController: servingUnitController,
          onComponentsChanged: onComponentsChanged ?? (_) {},
        ),
      ),
    ),
  );

  group('FoodItemComposedSection', () {
    group('empty state', () {
      testWidgets('shows Add Ingredient button when no components', (
        tester,
      ) async {
        final item = makeFoodItem();
        await tester.pumpWidget(buildWidget(allItems: [item]));
        expect(find.text('Add Ingredient'), findsOneWidget);
      });

      testWidgets('shows nutrition prompt when no components', (tester) async {
        final item = makeFoodItem();
        await tester.pumpWidget(buildWidget(allItems: [item]));
        expect(
          find.text('Add ingredients to see nutritional totals.'),
          findsOneWidget,
        );
      });

      testWidgets('shows no simple items message when allItems is empty', (
        tester,
      ) async {
        await tester.pumpWidget(buildWidget());
        expect(
          find.text(
            'No simple food items available. Create simple items first.',
          ),
          findsOneWidget,
        );
      });
    });

    group('with components', () {
      testWidgets('renders component rows with item name', (tester) async {
        final item = makeFoodItem();
        final components = [
          FoodItemComponentEntry(simpleFoodItemId: 'food-001', quantity: 1),
        ];
        await tester.pumpWidget(
          buildWidget(components: components, allItems: [item]),
        );
        expect(find.text('Chicken'), findsOneWidget);
      });

      testWidgets('renders quantity field for each component', (tester) async {
        final item = makeFoodItem(name: 'Rice');
        final components = [
          FoodItemComponentEntry(simpleFoodItemId: 'food-001', quantity: 2),
        ];
        await tester.pumpWidget(
          buildWidget(components: components, allItems: [item]),
        );
        expect(find.text('Qty'), findsOneWidget);
      });

      testWidgets('shows nutrition totals when components are present', (
        tester,
      ) async {
        final item = makeFoodItem(calories: 150, proteinGrams: 30);
        final components = [
          FoodItemComponentEntry(simpleFoodItemId: 'food-001', quantity: 1),
        ];
        await tester.pumpWidget(
          buildWidget(components: components, allItems: [item]),
        );
        expect(find.text('Calories:'), findsOneWidget);
        expect(find.text('Protein:'), findsOneWidget);
      });
    });

    group('callbacks', () {
      testWidgets(
        'Remove ingredient fires onComponentsChanged with item removed',
        (tester) async {
          List<FoodItemComponentEntry>? received;
          final item = makeFoodItem();
          final components = [
            FoodItemComponentEntry(simpleFoodItemId: 'food-001', quantity: 1),
          ];
          await tester.pumpWidget(
            buildWidget(
              components: components,
              allItems: [item],
              onComponentsChanged: (updated) => received = updated,
            ),
          );
          await tester.tap(find.byIcon(Icons.close));
          expect(received, isNotNull);
          expect(received!.isEmpty, isTrue);
        },
      );
    });
  });
}
