// test/presentation/screens/food_items/food_library_picker_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_items/food_library_picker_screen.dart';

void main() {
  group('FoodLibraryPickerScreen', () {
    const testProfileId = 'profile-001';

    FoodItem createTestFoodItem({
      String id = 'food-001',
      String name = 'Grilled Chicken',
      FoodItemType type = FoodItemType.simple,
      bool isArchived = false,
    }) => FoodItem(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      type: type,
      isArchived: isArchived,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen({
      List<String> initialSelectedIds = const [],
      List<FoodItem> foodItems = const [],
    }) => ProviderScope(
      overrides: [
        foodItemListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodItemList(foodItems)),
      ],
      child: MaterialApp(
        home: FoodLibraryPickerScreen(
          profileId: testProfileId,
          initialSelectedIds: initialSelectedIds,
        ),
      ),
    );

    testWidgets('renders app bar titled Select Foods', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Select Foods'), findsOneWidget);
    });

    testWidgets('renders Done button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('renders FAB for adding food items', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders empty state when no food items', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('No foods in your library'), findsOneWidget);
      expect(find.text('Tap + to add one.'), findsOneWidget);
    });

    testWidgets('renders food items list', (tester) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(buildScreen(foodItems: [foodItem]));
      await tester.pumpAndSettle();

      expect(find.text('Grilled Chicken'), findsOneWidget);
    });

    testWidgets('tapping an item selects it (checkbox becomes checked)', (
      tester,
    ) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(buildScreen(foodItems: [foodItem]));
      await tester.pumpAndSettle();

      // Initially unchecked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, false);

      // Tap the row
      await tester.tap(find.text('Grilled Chicken'));
      await tester.pumpAndSettle();

      final checkboxAfter = tester.widget<Checkbox>(
        find.byType(Checkbox).first,
      );
      expect(checkboxAfter.value, true);
    });

    testWidgets('tapping a selected item deselects it (checkbox unchecked)', (
      tester,
    ) async {
      final foodItem = createTestFoodItem();

      // Start with item pre-selected
      await tester.pumpWidget(
        buildScreen(foodItems: [foodItem], initialSelectedIds: [foodItem.id]),
      );
      await tester.pumpAndSettle();

      // Initially checked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, true);

      // Tap to deselect
      await tester.tap(find.text('Grilled Chicken'));
      await tester.pumpAndSettle();

      final checkboxAfter = tester.widget<Checkbox>(
        find.byType(Checkbox).first,
      );
      expect(checkboxAfter.value, false);
    });

    testWidgets('Done button pops with correct selected IDs', (tester) async {
      List<String>? poppedResult;
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([foodItem])),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    poppedResult = await Navigator.of(context)
                        .push<List<String>>(
                          MaterialPageRoute<List<String>>(
                            builder: (context) => const FoodLibraryPickerScreen(
                              profileId: testProfileId,
                              initialSelectedIds: [],
                            ),
                          ),
                        );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      // Navigate to picker
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Select the food item
      await tester.tap(find.text('Grilled Chicken'));
      await tester.pumpAndSettle();

      // Tap Done
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, isNotNull);
      expect(poppedResult, contains('food-001'));
    });

    testWidgets('Done button with no selection pops with empty list', (
      tester,
    ) async {
      List<String>? poppedResult;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([])),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    poppedResult = await Navigator.of(context)
                        .push<List<String>>(
                          MaterialPageRoute<List<String>>(
                            builder: (context) => const FoodLibraryPickerScreen(
                              profileId: testProfileId,
                              initialSelectedIds: [],
                            ),
                          ),
                        );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(poppedResult, isNotNull);
      expect(poppedResult, isEmpty);
    });

    testWidgets('search filters the list', (tester) async {
      final apple = createTestFoodItem(id: 'apple', name: 'Apple');
      final banana = createTestFoodItem(id: 'banana', name: 'Banana');

      await tester.pumpWidget(buildScreen(foodItems: [apple, banana]));
      await tester.pumpAndSettle();

      // Both visible initially
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);

      // Open search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Type 'app' — case insensitive filter
      await tester.enterText(find.byType(TextField), 'app');
      await tester.pumpAndSettle();

      // Only Apple should be visible
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('clearing search restores full list', (tester) async {
      final apple = createTestFoodItem(id: 'apple', name: 'Apple');
      final banana = createTestFoodItem(id: 'banana', name: 'Banana');

      await tester.pumpWidget(buildScreen(foodItems: [apple, banana]));
      await tester.pumpAndSettle();

      // Open search and filter
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'app');
      await tester.pumpAndSettle();

      expect(find.text('Banana'), findsNothing);

      // Clear search
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Both visible again
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('selected count shown in title when items selected', (
      tester,
    ) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(buildScreen(foodItems: [foodItem]));
      await tester.pumpAndSettle();

      // No selection initially
      expect(find.text('Select Foods'), findsOneWidget);

      // Select item
      await tester.tap(find.text('Grilled Chicken'));
      await tester.pumpAndSettle();

      // Title should now show count
      expect(find.text('Select Foods (1)'), findsOneWidget);
    });

    testWidgets('archived items are not shown in picker', (tester) async {
      final active = createTestFoodItem(id: 'active', name: 'Active Food');
      final archived = createTestFoodItem(
        id: 'archived',
        name: 'Archived Food',
        isArchived: true,
      );

      await tester.pumpWidget(buildScreen(foodItems: [active, archived]));
      await tester.pumpAndSettle();

      expect(find.text('Active Food'), findsOneWidget);
      expect(find.text('Archived Food'), findsNothing);
    });

    testWidgets('initialSelectedIds pre-checks items', (tester) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(
        buildScreen(foodItems: [foodItem], initialSelectedIds: [foodItem.id]),
      );
      await tester.pumpAndSettle();

      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, true);
    });

    testWidgets('shows no matching foods empty state during search', (
      tester,
    ) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(buildScreen(foodItems: [foodItem]));
      await tester.pumpAndSettle();

      // Open search and type something that doesn't match
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pumpAndSettle();

      expect(find.text('No matching foods'), findsOneWidget);
      expect(find.text('Try a different search term'), findsOneWidget);
    });
  });
}

/// Mock FoodItemList notifier for picker screen tests.
class _MockFoodItemList extends FoodItemList {
  final List<FoodItem> _foodItems;

  _MockFoodItemList(this._foodItems);

  @override
  Future<List<FoodItem>> build(String profileId) async => _foodItems;
}
