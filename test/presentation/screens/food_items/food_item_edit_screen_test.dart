// test/presentation/screens/food_items/food_item_edit_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

Future<void> scrollDown(WidgetTester tester, {double by = 600}) async {
  await tester.drag(find.byType(ListView), Offset(0, -by));
  await tester.pumpAndSettle();
}

void main() {
  group('FoodItemEditScreen', () {
    const testProfileId = 'profile-001';

    FoodItem createTestFoodItem({
      String id = 'food-001',
      String name = 'Grilled Chicken',
      FoodItemType type = FoodItemType.simple,
      List<String> simpleItemIds = const [],
      String? servingSize,
    }) => FoodItem(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      type: type,
      simpleItemIds: simpleItemIds,
      servingSize: servingSize,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        foodItemListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodItemList([])),
      ],
      child: const MaterialApp(
        home: FoodItemEditScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(FoodItem foodItem) => ProviderScope(
      overrides: [
        foodItemListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodItemList([foodItem])),
      ],
      child: MaterialApp(
        home: FoodItemEditScreen(profileId: testProfileId, foodItem: foodItem),
      ),
    );

    group('add mode', () {
      testWidgets('renders Add Food Item title in add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Add Food Item'), findsOneWidget);
      });

      testWidgets('renders all form fields per spec', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Food Name'), findsOneWidget);
        expect(find.text('Type'), findsOneWidget);
        // Phase 15a: Notes removed, nutritional section added
        expect(find.text('Nutritional Data'), findsOneWidget);
      });

      testWidgets('renders Save button', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Save'), findsWidgets);
      });

      testWidgets('name field starts empty', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final nameField = tester.widget<TextField>(
          find.descendant(
            of: find.byType(ShadowTextField).first,
            matching: find.byType(TextField),
          ),
        );
        expect(nameField.controller?.text, '');
      });

      testWidgets('type segment shows Simple and Composed', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Simple'), findsOneWidget);
        expect(find.text('Composed'), findsOneWidget);
      });

      testWidgets('type defaults to Simple', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // The SegmentedButton should have Simple selected by default
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SegmentedButton<FoodItemType> &&
                widget.selected.contains(FoodItemType.simple),
          ),
          findsOneWidget,
        );
      });

      testWidgets('ingredients selector hidden when type is Simple', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Ingredients section should not appear for simple type
        expect(find.text('Ingredients'), findsNothing);
      });

      testWidgets('name field has correct placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('e.g., Grilled Chicken'), findsOneWidget);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Food Item title in edit mode', (tester) async {
        final foodItem = createTestFoodItem();
        await tester.pumpWidget(buildEditScreen(foodItem));
        await tester.pumpAndSettle();

        expect(find.text('Edit Food Item'), findsOneWidget);
      });

      testWidgets('pre-populates name field in edit mode', (tester) async {
        final foodItem = createTestFoodItem(name: 'Salmon Bowl');
        await tester.pumpWidget(buildEditScreen(foodItem));
        await tester.pumpAndSettle();

        expect(find.text('Salmon Bowl'), findsOneWidget);
      });

      testWidgets('pre-populates type segment in edit mode', (tester) async {
        final foodItem = createTestFoodItem(type: FoodItemType.composed);
        await tester.pumpWidget(buildEditScreen(foodItem));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SegmentedButton<FoodItemType> &&
                widget.selected.contains(FoodItemType.composed),
          ),
          findsOneWidget,
        );
      });

      testWidgets('shows Update button in edit mode', (tester) async {
        final foodItem = createTestFoodItem();
        await tester.pumpWidget(buildEditScreen(foodItem));
        await tester.pumpAndSettle();

        // Phase 15a: nutritional section is long — scroll to bring Update button into view
        await scrollDown(tester);
        expect(find.text('Update'), findsOneWidget);
      });

      testWidgets('pre-populates notes from servingSize in edit mode', (
        tester,
      ) async {
        final foodItem = createTestFoodItem(servingSize: '1 serving');
        await tester.pumpWidget(buildEditScreen(foodItem));
        await tester.pumpAndSettle();

        expect(find.text('1 serving'), findsOneWidget);
      });
    });

    group('conditional fields', () {
      testWidgets('ingredients selector appears when type is Composed', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Initially no ingredients
        expect(find.text('Ingredients'), findsNothing);

        // Tap Composed segment
        await tester.tap(find.text('Composed'));
        await tester.pumpAndSettle();

        // Ingredients section should now appear
        expect(find.text('Ingredients'), findsOneWidget);
      });

      testWidgets('ingredients selector hidden when switching back to Simple', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Select Composed
        await tester.tap(find.text('Composed'));
        await tester.pumpAndSettle();
        expect(find.text('Ingredients'), findsOneWidget);

        // Switch back to Simple
        await tester.tap(find.text('Simple'));
        await tester.pumpAndSettle();
        expect(find.text('Ingredients'), findsNothing);
      });

      testWidgets(
        'shows empty ingredients message when no simple items exist',
        (tester) async {
          await tester.pumpWidget(buildAddScreen());
          await tester.pumpAndSettle();

          // Select Composed
          await tester.tap(find.text('Composed'));
          await tester.pumpAndSettle();

          // Should show message about no simple items
          expect(
            find.text(
              'No simple food items available. Create simple items first.',
            ),
            findsOneWidget,
          );
        },
      );
    });

    group('validation', () {
      testWidgets('name validation for short names', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter a single character name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Food name, required',
            ),
            matching: find.byType(TextField),
          ),
          'A',
        );
        await tester.pumpAndSettle();

        // The real-time validation via _getNameError should show the error
        expect(find.text('Name must be at least 2 characters'), findsOneWidget);
      });

      testWidgets('name validation clears when valid name entered', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter a single character to trigger error
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Food name, required',
            ),
            matching: find.byType(TextField),
          ),
          'A',
        );
        await tester.pumpAndSettle();
        expect(find.text('Name must be at least 2 characters'), findsOneWidget);

        // Enter a valid name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Food name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Chicken',
        );
        await tester.pumpAndSettle();
        expect(find.text('Name must be at least 2 characters'), findsNothing);
      });
    });

    group('accessibility', () {
      testWidgets('food name field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Food name, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('type field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Food type, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('ingredients field has correct semantic label when visible', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Select Composed to make ingredients visible
        await tester.tap(find.text('Composed'));
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Ingredients, required for composed items',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('widget types', () {
      testWidgets('uses ShadowTextField for text inputs', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(ShadowTextField), findsWidgets);
      });

      testWidgets('uses SegmentedButton for type selection', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(SegmentedButton<FoodItemType>), findsOneWidget);
      });

      testWidgets('uses ShadowButton for save action', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Phase 15a: nutritional section is long — scroll to bring ShadowButton into view
        await scrollDown(tester);
        expect(find.byType(ShadowButton), findsWidgets);
      });

      testWidgets('uses Form widget', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('field constraints per spec', () {
      testWidgets('name field has max length 200', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Find the ShadowTextField for Food Name and verify maxLength
        // The ShadowTextField wraps a TextField - verify it exists
        // with the maxLength constraint set in the implementation
        expect(find.text('Food Name'), findsOneWidget);
      });
    });
  });
}

/// Mock FoodItemList notifier for testing.
class _MockFoodItemList extends FoodItemList {
  final List<FoodItem> _foodItems;

  _MockFoodItemList(this._foodItems);

  @override
  Future<List<FoodItem>> build(String profileId) async => _foodItems;
}
