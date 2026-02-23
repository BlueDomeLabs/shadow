// test/presentation/screens/notifications/quick_entry/food_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_log_inputs.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/providers/food_logs/food_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/food_quick_entry_sheet.dart';

void main() {
  group('FoodQuickEntrySheet', () {
    const profileId = 'profile-001';

    FoodItem createTestFoodItem({
      String id = 'food-001',
      String name = 'Oatmeal',
    }) => FoodItem(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      name: name,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildSheet({
      List<FoodItem> foodItems = const [],
      String? mealLabel,
      FoodLogList Function()? logMockFactory,
    }) => ProviderScope(
      overrides: [
        foodItemListProvider(
          profileId,
        ).overrideWith(() => _MockFoodItemList(foodItems)),
        foodLogListProvider(
          profileId,
        ).overrideWith(logMockFactory ?? _MockFoodLogList.new),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: FoodQuickEntrySheet(profileId: profileId, mealLabel: mealLabel),
        ),
      ),
    );

    testWidgets('renders Log Meal title when no meal label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Log Meal'), findsWidgets);
    });

    testWidgets('renders meal label in title when provided', (tester) async {
      await tester.pumpWidget(buildSheet(mealLabel: 'Breakfast'));
      await tester.pumpAndSettle();

      expect(find.text('Log Breakfast'), findsOneWidget);
    });

    testWidgets('renders search field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('renders add new food field', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Add new food'), findsOneWidget);
    });

    testWidgets('renders Log Meal button', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Log Meal'), findsWidgets);
    });

    testWidgets('renders food items as checkboxes', (tester) async {
      await tester.pumpWidget(buildSheet(foodItems: [createTestFoodItem()]));
      await tester.pumpAndSettle();

      expect(find.text('Oatmeal'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsOneWidget);
    });

    testWidgets('shows no food items message when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('No food items defined yet.'), findsOneWidget);
    });

    testWidgets(
      'shows error snackbar when no food selected and no ad-hoc text',
      (tester) async {
        await tester.pumpWidget(buildSheet());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Log Meal').last);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets('calls log when ad-hoc food entered and save tapped', (
      tester,
    ) async {
      final mock = _MockFoodLogList();
      await tester.pumpWidget(buildSheet(logMockFactory: () => mock));
      await tester.pumpAndSettle();

      // Enter ad-hoc food in the last text field
      await tester.enterText(find.byType(TextField).last, 'Banana');
      await tester.tap(find.text('Log Meal').last);
      await tester.pump();

      expect(mock.logCalled, isTrue);
    });

    testWidgets('passes ad-hoc item to log input', (tester) async {
      final mock = _MockFoodLogList();
      await tester.pumpWidget(buildSheet(logMockFactory: () => mock));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Banana');
      await tester.tap(find.text('Log Meal').last);
      await tester.pump();

      expect(mock.lastInput?.adHocItems, contains('Banana'));
    });

    testWidgets('shows error snackbar on save failure', (tester) async {
      await tester.pumpWidget(
        buildSheet(logMockFactory: _ErrorFoodLogList.new),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).last, 'Banana');
      await tester.tap(find.text('Log Meal').last);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('sheet has correct semantic label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics && w.properties.label == 'Food quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockFoodItemList extends FoodItemList {
  final List<FoodItem> _items;
  _MockFoodItemList(this._items);

  @override
  Future<List<FoodItem>> build(String profileId) async => _items;
}

class _MockFoodLogList extends FoodLogList {
  bool logCalled = false;
  LogFoodInput? lastInput;

  @override
  Future<List<FoodLog>> build(String profileId) async => [];

  @override
  Future<void> log(LogFoodInput input) async {
    logCalled = true;
    lastInput = input;
  }
}

class _ErrorFoodLogList extends FoodLogList {
  @override
  Future<List<FoodLog>> build(String profileId) async => [];

  @override
  Future<void> log(LogFoodInput input) async {
    throw DatabaseError.insertFailed('food_logs');
  }
}
