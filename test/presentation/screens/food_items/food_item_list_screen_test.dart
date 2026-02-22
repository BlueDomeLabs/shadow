// test/presentation/screens/food_items/food_item_list_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_list_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('FoodItemListScreen', () {
    const testProfileId = 'profile-001';

    FoodItem createTestFoodItem({
      String id = 'food-001',
      String name = 'Grilled Chicken',
      FoodItemType type = FoodItemType.simple,
      bool isArchived = false,
      String? servingSize,
      double? calories,
    }) => FoodItem(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      type: type,
      isArchived: isArchived,
      servingSize: servingSize,
      calories: calories,
      syncMetadata: SyncMetadata.empty(),
    );

    testWidgets('renders app bar with correct title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Food Library'), findsOneWidget);
    });

    testWidgets('renders FAB for adding food items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no food items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No food items yet'), findsOneWidget);
      expect(
        find.text('Tap the + button to add your first food item'),
        findsOneWidget,
      );
    });

    testWidgets('renders food item name when data present', (tester) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([foodItem])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Grilled Chicken'), findsOneWidget);
    });

    testWidgets('separates active and archived items', (tester) async {
      final activeItem = createTestFoodItem(id: 'active-001');
      final archivedItem = createTestFoodItem(
        id: 'archived-001',
        name: 'Old Food',
        isArchived: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([activeItem, archivedItem])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Food Items'), findsOneWidget);
      expect(find.text('Archived'), findsOneWidget);
      expect(find.text('Grilled Chicken'), findsOneWidget);
      expect(find.text('Old Food'), findsOneWidget);
    });

    testWidgets('section headers have header semantics', (tester) async {
      final foodItem = createTestFoodItem();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([foodItem])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final headerFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.header ?? false),
      );
      expect(headerFinder, findsWidgets);
    });

    testWidgets('FAB has correct semantic label', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Add new food item'), findsOneWidget);
    });

    testWidgets('list body has correct semantic label', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            foodItemListProvider(
              testProfileId,
            ).overrideWith(() => _MockFoodItemList([])),
          ],
          child: const MaterialApp(
            home: FoodItemListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Food item list',
      );
      expect(semanticsFinder, findsOneWidget);
    });

    group('popup menu', () {
      testWidgets('shows Edit and Archive options', (tester) async {
        final foodItem = createTestFoodItem();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the more options button
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Archive'), findsOneWidget);
      });

      testWidgets('shows Unarchive for archived food items', (tester) async {
        final archivedItem = createTestFoodItem(
          isArchived: true,
          name: 'Archived Food',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([archivedItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        expect(find.text('Unarchive'), findsOneWidget);
      });
    });

    group('loading and error states', () {
      testWidgets('shows error state with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(_ErrorFoodItemList.new),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Failed to load food items'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });

    group('list display', () {
      testWidgets('renders both active and archived sections', (tester) async {
        final activeItem = createTestFoodItem(id: 'active-001');
        final archivedItem = createTestFoodItem(
          id: 'archived-001',
          name: 'Old Food',
          isArchived: true,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(testProfileId).overrideWith(
                () => _MockFoodItemList([activeItem, archivedItem]),
              ),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Food Items'), findsOneWidget);
        expect(find.text('Archived'), findsOneWidget);
        expect(find.text('Grilled Chicken'), findsOneWidget);
        expect(find.text('Old Food'), findsOneWidget);
      });

      testWidgets('shows correct icon for simple type', (tester) async {
        final simpleItem = createTestFoodItem();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([simpleItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('shows correct icon for complex type', (tester) async {
        final complexItem = createTestFoodItem(
          id: 'complex-001',
          name: 'Chicken Salad',
          type: FoodItemType.complex,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([complexItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.menu_book), findsOneWidget);
      });

      testWidgets('displays composed type label', (tester) async {
        final complexItem = createTestFoodItem(
          id: 'complex-001',
          name: 'Chicken Salad',
          type: FoodItemType.complex,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([complexItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Composed'), findsOneWidget);
      });

      testWidgets('displays serving size when present', (tester) async {
        final foodItem = createTestFoodItem(servingSize: '1 cup');

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('1 cup'), findsOneWidget);
      });

      testWidgets('shows nutritional info icon when present', (tester) async {
        final foodItem = createTestFoodItem(calories: 250);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.info_outline), findsOneWidget);
      });

      testWidgets('hides nutritional info icon when no nutrition data', (
        tester,
      ) async {
        final foodItem = createTestFoodItem(); // no calories set

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.info_outline), findsNothing);
      });

      testWidgets('archived food item name has strikethrough', (tester) async {
        final archivedItem = createTestFoodItem(
          isArchived: true,
          name: 'Old Food',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([archivedItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final textWidget = tester.widget<Text>(find.text('Old Food'));
        expect(textWidget.style?.decoration, TextDecoration.lineThrough);
      });

      testWidgets('food item card has more options menu', (tester) async {
        final foodItem = createTestFoodItem();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.more_vert), findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('tapping FAB navigates to add screen', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Add Food Item'), findsOneWidget);
      });

      testWidgets('tapping food item card navigates to edit screen', (
        tester,
      ) async {
        final foodItem = createTestFoodItem();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the ShadowCard
        await tester.tap(find.byType(ShadowCard));
        await tester.pumpAndSettle();

        expect(find.text('Edit Food Item'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('search button has tooltip', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final iconButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.search),
        );
        expect(iconButton.tooltip, 'Search food items');
      });

      testWidgets('empty state is accessible', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No food items yet'), findsOneWidget);
        expect(
          find.text('Tap the + button to add your first food item'),
          findsOneWidget,
        );
      });

      testWidgets('nutritional info icon has semantic label', (tester) async {
        final foodItem = createTestFoodItem(calories: 250);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Has nutritional info',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('food item card has semantic label with name and type', (
        tester,
      ) async {
        final foodItem = createTestFoodItem();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemList([foodItem])),
            ],
            child: const MaterialApp(
              home: FoodItemListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The card should have semantic label containing name and type
        final cardFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Grilled Chicken') ?? false),
        );
        expect(cardFinder, findsWidgets);
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

/// Mock notifier that simulates an error.
class _ErrorFoodItemList extends FoodItemList {
  @override
  Future<List<FoodItem>> build(String profileId) async {
    throw Exception('Failed to load food items');
  }
}
