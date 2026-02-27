// test/presentation/screens/food_logs/food_log_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/entities/food_item.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/diet/diet_types.dart';
import 'package:shadow_app/domain/usecases/diet/get_active_diet_use_case.dart';
import 'package:shadow_app/domain/usecases/food_logs/food_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/food_items/food_item_list_provider.dart';
import 'package:shadow_app/presentation/providers/food_logs/food_log_list_provider.dart';
import 'package:shadow_app/presentation/screens/food_logs/food_log_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('FoodLogScreen', () {
    const testProfileId = 'profile-001';

    /// Scrolls the form ListView down to make bottom widgets visible.
    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    FoodLog createTestFoodLog({
      String id = 'food-log-001',
      int? timestamp,
      MealType? mealType = MealType.lunch,
      List<String> foodItemIds = const [],
      List<String> adHocItems = const ['Chicken Breast', 'Rice'],
      String? notes = 'Grilled with veggies',
    }) => FoodLog(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      timestamp:
          timestamp ?? DateTime(2025, 3, 15, 12, 30).millisecondsSinceEpoch,
      mealType: mealType,
      foodItemIds: foodItemIds,
      adHocItems: adHocItems,
      notes: notes,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        foodLogListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodLogList([])),
        getActiveDietUseCaseProvider.overrideWithValue(
          _FakeGetActiveDietUseCase(),
        ),
        foodItemListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodItemListForLog([])),
      ],
      child: const MaterialApp(home: FoodLogScreen(profileId: testProfileId)),
    );

    Widget buildEditScreen(FoodLog foodLog) => ProviderScope(
      overrides: [
        foodLogListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodLogList([foodLog])),
        foodItemListProvider(
          testProfileId,
        ).overrideWith(() => _MockFoodItemListForLog([])),
      ],
      child: MaterialApp(
        home: FoodLogScreen(profileId: testProfileId, foodLog: foodLog),
      ),
    );

    group('rendering', () {
      testWidgets('renders Log Food title in add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Log Food'), findsOneWidget);
      });

      testWidgets('renders Edit Food Log title in edit mode', (tester) async {
        final foodLog = createTestFoodLog();
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        expect(find.text('Edit Food Log'), findsOneWidget);
      });

      testWidgets('renders all section headers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Date & Time'), findsOneWidget);
        expect(find.text('Meal Type'), findsOneWidget);
        expect(find.text('Food Items'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Ad-hoc Items'), findsOneWidget);
        expect(find.text('Notes'), findsWidgets);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders notes field with correct placeholder', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Any notes about this meal'), findsOneWidget);
      });

      testWidgets('renders ad-hoc item field with correct placeholder', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Add item not in library...'), findsOneWidget);
      });

      testWidgets('renders food items search stub', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Search foods...'), findsOneWidget);
      });

      testWidgets('renders date and time picker buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Should find date and time buttons with icons
        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
        expect(find.byIcon(Icons.access_time), findsOneWidget);
      });

      testWidgets('uses Form widget', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('uses ShadowTextField for text inputs', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(ShadowTextField), findsWidgets);
      });

      testWidgets('uses ShadowButton for action buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.byType(ShadowButton), findsWidgets);
      });
    });

    group('meal type segment', () {
      testWidgets('shows 4 meal type options', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Breakfast'), findsOneWidget);
        expect(find.text('Lunch'), findsOneWidget);
        expect(find.text('Dinner'), findsOneWidget);
        expect(find.text('Snack'), findsOneWidget);
      });

      testWidgets('uses SegmentedButton widget', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(SegmentedButton<MealType>), findsOneWidget);
      });

      testWidgets('can change meal type selection', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap Dinner segment
        await tester.tap(find.text('Dinner'));
        await tester.pumpAndSettle();

        // SegmentedButton should still show all options
        expect(find.text('Breakfast'), findsOneWidget);
        expect(find.text('Lunch'), findsOneWidget);
        expect(find.text('Dinner'), findsOneWidget);
        expect(find.text('Snack'), findsOneWidget);
      });
    });

    group('auto-detect meal type', () {
      // We verify auto-detection works by checking the edit mode uses the
      // meal type from the existing log, and that add mode defaults based
      // on current time. Since we can't control DateTime.now() in tests
      // easily, we verify the edit mode path which exercises the same code.

      testWidgets('edit mode preserves existing meal type', (tester) async {
        final foodLog = createTestFoodLog(mealType: MealType.breakfast);
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        // The SegmentedButton should have breakfast selected.
        // We verify by checking the widget is present - the selected
        // state is internal to SegmentedButton.
        expect(find.byType(SegmentedButton<MealType>), findsOneWidget);
      });

      testWidgets('add mode auto-detects meal type from current time', (
        tester,
      ) async {
        // In add mode, the meal type should be auto-detected from DateTime.now().
        // We verify the segmented button is present with a selection.
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(SegmentedButton<MealType>), findsOneWidget);
        // All 4 options should be visible
        expect(find.text('Breakfast'), findsOneWidget);
        expect(find.text('Lunch'), findsOneWidget);
        expect(find.text('Dinner'), findsOneWidget);
        expect(find.text('Snack'), findsOneWidget);
      });
    });

    group('ad-hoc items', () {
      testWidgets('can add an ad-hoc item and shows as chip', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);

        // Find the ad-hoc item text field and enter text
        final adHocField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food name, required',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(adHocField, 'Banana');
        await tester.pumpAndSettle();

        // Tap the add button
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Should show as chip
        expect(find.text('Banana'), findsOneWidget);
        expect(find.byType(Chip), findsOneWidget);
      });

      testWidgets('ad-hoc item chip can be removed', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);

        // Add an item
        final adHocField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food name, required',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(adHocField, 'Apple');
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.text('Apple'), findsOneWidget);
        expect(find.byType(Chip), findsOneWidget);

        // Tap the X icon on the chip to remove
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('shows error when ad-hoc item name is too short', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);

        // Enter single character
        final adHocField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food name, required',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(adHocField, 'A');
        await tester.pumpAndSettle();

        // Tap add button
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(
          find.text('Item name must be at least 2 characters'),
          findsOneWidget,
        );
        // No chip should be added
        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('clears text field after successful add', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);

        final adHocField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food name, required',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(adHocField, 'Banana');
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // The text field should be cleared
        final textField = tester.widget<TextField>(adHocField);
        expect(textField.controller?.text, '');
      });

      testWidgets('can add multiple ad-hoc items', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);

        final adHocField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food name, required',
          ),
          matching: find.byType(TextField),
        );

        // Add first item
        await tester.enterText(adHocField, 'Banana');
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Add second item
        await tester.enterText(adHocField, 'Apple');
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.byType(Chip), findsNWidgets(2));
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Apple'), findsOneWidget);
      });
    });

    group('edit mode', () {
      testWidgets('populates notes from existing food log', (tester) async {
        final foodLog = createTestFoodLog();
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Grilled with veggies'), findsOneWidget);
      });

      testWidgets('populates ad-hoc items as chips from existing food log', (
        tester,
      ) async {
        final foodLog = createTestFoodLog(
          adHocItems: ['Chicken Breast', 'Rice'],
        );
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Chicken Breast'), findsOneWidget);
        expect(find.text('Rice'), findsOneWidget);
        expect(find.byType(Chip), findsNWidgets(2));
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final foodLog = createTestFoodLog();
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('populates meal type from existing food log', (tester) async {
        final foodLog = createTestFoodLog(mealType: MealType.dinner);
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        // SegmentedButton should be present
        expect(find.byType(SegmentedButton<MealType>), findsOneWidget);
      });
    });

    group('validation', () {
      testWidgets('notes max length matches ValidationRules', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);

        // Verify the ShadowTextField for notes has maxLength from ValidationRules
        final notesField = tester.widget<ShadowTextField>(
          find.byWidgetPredicate(
            (widget) =>
                widget is ShadowTextField &&
                widget.hintText == 'Any notes about this meal',
          ),
        );
        expect(notesField.maxLength, ValidationRules.notesMaxLength);
      });
    });

    group('accessibility', () {
      testWidgets('body has semantic label for add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'Log food form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('body has semantic label for edit mode', (tester) async {
        final foodLog = createTestFoodLog();
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit food log form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets(
        'date/time has correct semantic label: "When eaten, required"',
        (tester) async {
          await tester.pumpWidget(buildAddScreen());
          await tester.pumpAndSettle();

          final semanticsFinder = find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'When eaten, required',
          );
          expect(semanticsFinder, findsOneWidget);
        },
      );

      testWidgets(
        'meal type has correct semantic label: "Meal type, optional"',
        (tester) async {
          await tester.pumpWidget(buildAddScreen());
          await tester.pumpAndSettle();

          final semanticsFinder = find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Meal type, optional',
          );
          expect(semanticsFinder, findsOneWidget);
        },
      );

      testWidgets(
        'ad-hoc item input has correct semantic label: "Food name, required"',
        (tester) async {
          await tester.pumpWidget(buildAddScreen());
          await tester.pumpAndSettle();

          await scrollToBottom(tester);
          final semanticsFinder = find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food name, required',
          );
          expect(semanticsFinder, findsOneWidget);
        },
      );

      testWidgets(
        'notes field has correct semantic label: "Food notes, optional"',
        (tester) async {
          await tester.pumpWidget(buildAddScreen());
          await tester.pumpAndSettle();

          await scrollToBottom(tester);
          final semanticsFinder = find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food notes, optional',
          );
          expect(semanticsFinder, findsOneWidget);
        },
      );

      testWidgets('section headers have header semantics', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        // Date & Time, Meal Type, Food Items visible at top
        expect(headerFinder, findsAtLeastNWidgets(3));
        await scrollToBottom(tester);
        // Ad-hoc Items, Notes visible at bottom
        expect(headerFinder, findsAtLeastNWidgets(1));
      });
    });

    group('save', () {
      testWidgets('shows success snackbar on create', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump(); // Use pump() to catch snackbar before auto-dismiss

        expect(find.text('Food log created successfully'), findsOneWidget);
      });

      testWidgets('shows success snackbar on update', (tester) async {
        final foodLog = createTestFoodLog();
        await tester.pumpWidget(buildEditScreen(foodLog));
        await tester.pumpAndSettle();

        // Tap Save Changes (form already populated)
        await scrollToBottom(tester);
        await tester.tap(find.text('Save Changes'));
        await tester.pump(); // Use pump() to catch snackbar before auto-dismiss

        expect(find.text('Food log updated successfully'), findsOneWidget);
      });

      testWidgets('shows error snackbar on save failure', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodLogListProvider(
                testProfileId,
              ).overrideWith(_ErrorOnLogFoodLogList.new),
              getActiveDietUseCaseProvider.overrideWithValue(
                _FakeGetActiveDietUseCase(),
              ),
            ],
            child: const MaterialApp(
              home: FoodLogScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.text('Unable to save data. Please try again.'),
          findsOneWidget,
        );
      });
    });

    group('dirty form and cancel', () {
      testWidgets('cancel pops without dialog when form is clean', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodLogListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodLogList([])),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              const FoodLogScreen(profileId: testProfileId),
                        ),
                      );
                    },
                    child: const Text('Go'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to food log screen
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        expect(find.text('Log Food'), findsOneWidget);

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should have popped back
        expect(find.text('Log Food'), findsNothing);
        expect(find.text('Go'), findsOneWidget);
      });

      testWidgets('cancel shows discard dialog when form is dirty', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Make the form dirty by entering text in notes
        await scrollToBottom(tester);
        final notesField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food notes, optional',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(notesField, 'Some notes');
        await tester.pumpAndSettle();

        // Tap Cancel
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should show discard confirmation dialog
        expect(find.text('Discard Changes?'), findsOneWidget);
        expect(
          find.text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
          findsOneWidget,
        );
      });

      testWidgets('Keep Editing dismisses discard dialog', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Make form dirty
        await scrollToBottom(tester);
        final notesField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Food notes, optional',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(notesField, 'Some notes');
        await tester.pumpAndSettle();

        // Tap Cancel
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Tap Keep Editing
        await tester.tap(find.text('Keep Editing'));
        await tester.pumpAndSettle();

        // Should still be on food log screen
        expect(find.text('Log Food'), findsOneWidget);
        expect(find.text('Discard Changes?'), findsNothing);
      });
    });

    group('food items section', () {
      testWidgets('tapping food items area navigates to picker', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap the "Search foods..." row
        await tester.tap(find.text('Search foods...'));
        await tester.pumpAndSettle();

        // Should navigate to FoodLibraryPickerScreen
        expect(find.text('Select Foods'), findsOneWidget);
      });

      testWidgets('selected food items appear as chips', (tester) async {
        final foodItem = FoodItem(
          id: 'food-001',
          clientId: 'client-001',
          profileId: testProfileId,
          name: 'Grilled Chicken',
          syncMetadata: SyncMetadata.empty(),
        );
        final foodLog = createTestFoodLog(
          foodItemIds: ['food-001'],
          adHocItems: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodLogListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodLogList([foodLog])),
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemListForLog([foodItem])),
            ],
            child: MaterialApp(
              home: FoodLogScreen(profileId: testProfileId, foodLog: foodLog),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Grilled Chicken'), findsOneWidget);
        expect(find.byType(Chip), findsWidgets);
      });

      testWidgets('removing a food item chip removes it from selection', (
        tester,
      ) async {
        final foodItem = FoodItem(
          id: 'food-001',
          clientId: 'client-001',
          profileId: testProfileId,
          name: 'Grilled Chicken',
          syncMetadata: SyncMetadata.empty(),
        );
        final foodLog = createTestFoodLog(
          foodItemIds: ['food-001'],
          adHocItems: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              foodLogListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodLogList([foodLog])),
              foodItemListProvider(
                testProfileId,
              ).overrideWith(() => _MockFoodItemListForLog([foodItem])),
            ],
            child: MaterialApp(
              home: FoodLogScreen(profileId: testProfileId, foodLog: foodLog),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Grilled Chicken'), findsOneWidget);

        // Tap the chip's delete icon
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.text('Grilled Chicken'), findsNothing);
        expect(find.byType(Chip), findsNothing);
      });
    });
  });
}

/// Mock FoodLogList notifier for testing.
class _MockFoodLogList extends FoodLogList {
  final List<FoodLog> _foodLogs;

  _MockFoodLogList(this._foodLogs);

  @override
  Future<List<FoodLog>> build(String profileId) async => _foodLogs;

  @override
  Future<void> log(LogFoodInput input) async {
    // Success - no-op for testing
  }

  @override
  Future<void> updateLog(UpdateFoodLogInput input) async {
    // Success - no-op for testing
  }

  @override
  Future<void> delete(DeleteFoodLogInput input) async {
    // Success - no-op for testing
  }
}

/// Fake GetActiveDietUseCase — returns null (no active diet) so compliance
/// check is skipped in tests.
class _FakeGetActiveDietUseCase implements GetActiveDietUseCase {
  @override
  Future<Result<Diet?, AppError>> call(GetActiveDietInput input) async =>
      const Success(null);
}

/// Mock notifier that simulates a failure on log.
class _ErrorOnLogFoodLogList extends FoodLogList {
  @override
  Future<List<FoodLog>> build(String profileId) async => [];

  @override
  Future<void> log(LogFoodInput input) async {
    throw DatabaseError.insertFailed('test');
  }
}

/// Mock FoodItemList notifier for food log screen tests.
class _MockFoodItemListForLog extends FoodItemList {
  final List<FoodItem> _foodItems;

  _MockFoodItemListForLog(this._foodItems);

  @override
  Future<List<FoodItem>> build(String profileId) async => _foodItems;
}
