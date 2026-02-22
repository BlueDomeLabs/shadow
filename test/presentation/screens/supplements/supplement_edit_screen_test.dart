// test/presentation/screens/supplements/supplement_edit_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/supplements/supplements_usecases.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('SupplementEditScreen', () {
    const testProfileId = 'profile-001';

    /// Scrolls the form ListView down by a given amount.
    Future<void> scrollDown(WidgetTester tester, {double by = 600}) async {
      await tester.drag(find.byType(ListView), Offset(0, -by));
      await tester.pumpAndSettle();
    }

    /// Scrolls the form ListView to the very bottom (multiple drags).
    Future<void> scrollToBottom(WidgetTester tester) async {
      // Form is very long now; scroll in steps
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();
    }

    /// Scrolls the form ListView back to the top.
    Future<void> scrollToTop(WidgetTester tester) async {
      await tester.drag(find.byType(ListView), const Offset(0, 2000));
      await tester.pumpAndSettle();
    }

    Supplement createTestSupplement({
      String id = 'supp-001',
      String name = 'Vitamin D3',
      SupplementForm form = SupplementForm.capsule,
      int dosageQuantity = 2000,
      DosageUnit dosageUnit = DosageUnit.iu,
      String brand = 'NOW Foods',
      String notes = '',
      String? customForm,
      String? customDosageUnit,
      List<SupplementIngredient> ingredients = const [],
      List<SupplementSchedule> schedules = const [],
      int? startDate,
      int? endDate,
    }) => Supplement(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      form: form,
      customForm: customForm,
      dosageQuantity: dosageQuantity,
      dosageUnit: dosageUnit,
      customDosageUnit: customDosageUnit,
      brand: brand,
      notes: notes,
      ingredients: ingredients,
      schedules: schedules,
      startDate: startDate,
      endDate: endDate,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        supplementListProvider(
          testProfileId,
        ).overrideWith(() => _MockSupplementList([])),
      ],
      child: const MaterialApp(
        home: SupplementEditScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(Supplement supplement) => ProviderScope(
      overrides: [
        supplementListProvider(
          testProfileId,
        ).overrideWith(() => _MockSupplementList([supplement])),
      ],
      child: MaterialApp(
        home: SupplementEditScreen(
          profileId: testProfileId,
          supplement: supplement,
        ),
      ),
    );

    group('add mode', () {
      testWidgets('renders Add Supplement title', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Add Supplement'), findsOneWidget);
      });

      testWidgets('renders all section headers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Basic Information'), findsOneWidget);
        expect(find.text('Dosage'), findsOneWidget);
        await scrollDown(tester);
        expect(find.text('Ingredients'), findsOneWidget);
        expect(find.text('Schedule'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Notes'), findsWidgets);
      });

      testWidgets('renders all form fields', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Supplement Name'), findsOneWidget);
        expect(find.text('Brand'), findsOneWidget);
        expect(find.text('Form'), findsOneWidget);
        expect(find.text('Dosage Amount'), findsOneWidget);
        expect(find.text('Dosage Unit'), findsOneWidget);
        expect(find.text('Quantity Per Dose'), findsOneWidget);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
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

      testWidgets('quantity per dose defaults to 1', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Find the Quantity Per Dose field by looking for its value
        expect(find.text('1'), findsWidgets);
      });

      testWidgets('form defaults to Capsule', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Capsule'), findsOneWidget);
      });

      testWidgets('dosage unit defaults to mg', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('mg'), findsWidgets);
      });

      testWidgets('Custom Form field is hidden when form is not Other', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Custom Form'), findsNothing);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Supplement title', (tester) async {
        final supplement = createTestSupplement();
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('Edit Supplement'), findsOneWidget);
      });

      testWidgets('populates name field from supplement', (tester) async {
        final supplement = createTestSupplement(name: 'Magnesium');
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('Magnesium'), findsOneWidget);
      });

      testWidgets('populates brand field from supplement', (tester) async {
        final supplement = createTestSupplement(brand: 'Thorne');
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('Thorne'), findsOneWidget);
      });

      testWidgets('populates dosage amount from supplement', (tester) async {
        final supplement = createTestSupplement(dosageQuantity: 5000);
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('5000'), findsOneWidget);
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final supplement = createTestSupplement();
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('populates form dropdown from supplement', (tester) async {
        final supplement = createTestSupplement(form: SupplementForm.powder);
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('Powder'), findsOneWidget);
      });

      testWidgets('populates dosage unit from supplement', (tester) async {
        final supplement = createTestSupplement(dosageUnit: DosageUnit.g);
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('g'), findsWidgets);
      });

      testWidgets('shows Custom Form field when form is Other', (tester) async {
        final supplement = createTestSupplement(
          form: SupplementForm.other,
          customForm: 'Lozenge',
        );
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('Custom Form'), findsOneWidget);
        expect(find.text('Lozenge'), findsOneWidget);
      });

      testWidgets('populates notes from supplement', (tester) async {
        final supplement = createTestSupplement(notes: 'Take with food');
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Take with food'), findsOneWidget);
      });
    });

    group('validation', () {
      testWidgets('shows error when name is empty on save', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter dosage amount to satisfy that validation
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Dosage amount, required, enter number',
            ),
            matching: find.byType(TextField),
          ),
          '100',
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Scroll back to top to see validation error in name field
        await scrollToTop(tester);
        expect(find.text('Supplement name is required'), findsOneWidget);
      });

      testWidgets('shows error when name is too short', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter a single character name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'A',
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(find.text('Name must be at least 2 characters'), findsOneWidget);
      });

      testWidgets('shows error when dosage amount is empty on save', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Vitamin D3',
        );
        await tester.pumpAndSettle();

        // Tap Save without entering dosage
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(find.text('Dosage amount is required'), findsOneWidget);
      });

      testWidgets('shows error when dosage amount is 0', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Vitamin D3',
        );

        // Enter 0 as dosage
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Dosage amount, required, enter number',
            ),
            matching: find.byType(TextField),
          ),
          '0',
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(find.text('Dosage must be greater than 0'), findsOneWidget);
      });

      testWidgets('shows error when quantity per dose is empty', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Clear the default quantity per dose value
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Quantity per dose, required, default is 1',
            ),
            matching: find.byType(TextField),
          ),
          '',
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(find.text('Quantity per dose is required'), findsOneWidget);
      });

      testWidgets('clears validation errors when valid input entered', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap Save to trigger validation
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(find.text('Supplement name is required'), findsOneWidget);

        // Enter valid name
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Vitamin D3',
        );
        await tester.pumpAndSettle();

        expect(find.text('Supplement name is required'), findsNothing);
      });
    });

    group('conditional fields', () {
      testWidgets('Custom Form field appears when Other is selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Initially no Custom Form field
        expect(find.text('Custom Form'), findsNothing);

        // Open Form dropdown and select Other
        await tester.tap(find.text('Capsule'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        // Custom Form field should now appear
        expect(find.text('Custom Form'), findsOneWidget);
      });

      testWidgets('Custom Form field disappears when switching from Other', (
        tester,
      ) async {
        final supplement = createTestSupplement(
          form: SupplementForm.other,
          customForm: 'Lozenge',
        );
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        // Custom Form visible
        expect(find.text('Custom Form'), findsOneWidget);

        // Switch to Capsule
        await tester.tap(find.text('Other'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Capsule').last);
        await tester.pumpAndSettle();

        // Custom Form should be gone
        expect(find.text('Custom Form'), findsNothing);
      });

      testWidgets('validates custom form required when form is Other on save', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Fill required fields
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Custom Supplement',
        );

        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Dosage amount, required, enter number',
            ),
            matching: find.byType(TextField),
          ),
          '100',
        );
        await tester.pumpAndSettle();

        // Select Other form
        await tester.tap(find.text('Capsule'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Other').last);
        await tester.pumpAndSettle();

        // Scroll to Save button in smaller steps (long form with lazy loading)
        await scrollDown(tester, by: 500);
        await scrollDown(tester, by: 500);
        await scrollDown(tester, by: 500);
        await scrollDown(tester, by: 500);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(
          find.text('Custom form is required when Form is Other'),
          findsOneWidget,
        );
      });
    });

    group('custom dosage unit', () {
      testWidgets('Custom Unit field is hidden when unit is not custom', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Custom Unit'), findsNothing);
      });

      testWidgets('Custom Unit field appears when custom is selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Open dosage unit dropdown
        await tester.tap(find.text('mg').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('custom').last);
        await tester.pumpAndSettle();

        expect(find.text('Custom Unit'), findsOneWidget);
        expect(find.text('e.g., billion CFU'), findsOneWidget);
      });

      testWidgets('validates Custom Unit required when custom selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Fill name and dosage
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Probiotic',
        );
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Dosage amount, required, enter number',
            ),
            matching: find.byType(TextField),
          ),
          '50',
        );
        await tester.pumpAndSettle();

        // Select custom unit
        await tester.tap(find.text('mg').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('custom').last);
        await tester.pumpAndSettle();

        // Scroll to Save button in smaller steps (long form with lazy loading)
        await scrollDown(tester, by: 500);
        await scrollDown(tester, by: 500);
        await scrollDown(tester, by: 500);
        await scrollDown(tester, by: 500);
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        await scrollToTop(tester);
        expect(
          find.text('Custom unit is required when Dosage Unit is custom'),
          findsOneWidget,
        );
      });

      testWidgets('populates custom dosage unit from supplement', (
        tester,
      ) async {
        final supplement = createTestSupplement(
          dosageUnit: DosageUnit.custom,
          customDosageUnit: 'billion CFU',
        );
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        expect(find.text('Custom Unit'), findsOneWidget);
        expect(find.text('billion CFU'), findsOneWidget);
      });

      testWidgets('has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Select custom unit to show the field
        await tester.tap(find.text('mg').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('custom').last);
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ShadowTextField &&
              widget.semanticLabel == 'Custom dosage unit, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('ingredients', () {
      testWidgets('shows Ingredients section header', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Ingredients'), findsOneWidget);
      });

      testWidgets('shows ingredient input field', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Add ingredient...'), findsWidgets);
      });

      testWidgets('adds ingredient on submit', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        // Type ingredient in the TextField (not ShadowTextField)
        final ingredientField = find.widgetWithText(
          TextField,
          'Add ingredient...',
        );
        await tester.enterText(ingredientField, 'Vitamin D3');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(find.text('Vitamin D3'), findsWidgets);
      });

      testWidgets('removes ingredient on delete', (tester) async {
        final supplement = createTestSupplement(
          ingredients: [
            const SupplementIngredient(name: 'Zinc'),
            const SupplementIngredient(name: 'Magnesium'),
          ],
        );
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Both ingredients should be visible as chips
        expect(find.text('Zinc'), findsOneWidget);
        expect(find.text('Magnesium'), findsOneWidget);

        // Invoke delete on Zinc chip
        final chip = tester.widget<InputChip>(
          find.widgetWithText(InputChip, 'Zinc'),
        );
        chip.onDeleted!();
        await tester.pumpAndSettle();

        expect(find.widgetWithText(InputChip, 'Zinc'), findsNothing);
        expect(find.text('Magnesium'), findsOneWidget);
      });

      testWidgets('populates ingredients from supplement', (tester) async {
        final supplement = createTestSupplement(
          ingredients: [
            const SupplementIngredient(name: 'Calcium'),
            const SupplementIngredient(name: 'Vitamin K2'),
          ],
        );
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Calcium'), findsOneWidget);
        expect(find.text('Vitamin K2'), findsOneWidget);
      });

      testWidgets('has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Ingredient list, optional, type and press enter to add',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('schedule section', () {
      testWidgets('shows Schedule section header', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Schedule'), findsOneWidget);
      });

      testWidgets('shows Frequency dropdown defaulting to Daily', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Daily'), findsOneWidget);
      });

      testWidgets('shows Anchor Event dropdown defaulting to Breakfast', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Breakfast'), findsOneWidget);
      });

      testWidgets('shows Timing dropdown defaulting to With', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('With'), findsOneWidget);
      });

      testWidgets('Every X Days field hidden when frequency is Daily', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Every X Days'), findsNothing);
      });

      testWidgets('Every X Days field shown when frequency is Every X Days', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Open frequency dropdown and select Every X Days
        await tester.tap(find.text('Daily'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Every X Days').last);
        await tester.pumpAndSettle();

        expect(find.text('Every X Days'), findsWidgets);
      });

      testWidgets('weekday picker shown when frequency is Specific Days', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Select Specific Days frequency
        await tester.tap(find.text('Daily'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Specific Days').last);
        await tester.pumpAndSettle();

        // The weekday picker should appear (ShadowPicker.weekday)
        expect(find.byType(ShadowPicker), findsWidgets);
        expect(find.text('Every day'), findsOneWidget);
      });

      testWidgets('Timing dropdown hidden when Specific Time selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Initially Timing should be visible
        expect(find.text('With'), findsOneWidget);

        // Open Anchor Event and select Specific Time
        await tester.tap(find.text('Breakfast'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Specific Time').last);
        await tester.pumpAndSettle();

        // Timing dropdown should be hidden, Specific Time picker visible
        expect(find.text('Timing'), findsNothing);
      });

      testWidgets('shows all anchor event options', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Open anchor event dropdown
        await tester.tap(find.text('Breakfast'));
        await tester.pumpAndSettle();

        expect(find.text('Morning'), findsOneWidget);
        expect(find.text('Breakfast'), findsWidgets);
        expect(find.text('Lunch'), findsOneWidget);
        expect(find.text('Dinner'), findsOneWidget);
        expect(find.text('Bedtime'), findsOneWidget);
        expect(find.text('Specific Time'), findsOneWidget);
      });

      testWidgets('shows all timing options', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Open timing dropdown
        await tester.tap(find.text('With'));
        await tester.pumpAndSettle();

        expect(find.text('With'), findsWidgets);
        expect(find.text('Before'), findsOneWidget);
        expect(find.text('After'), findsOneWidget);
      });

      testWidgets('Offset Minutes shown when Before selected', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);

        // Select Before timing
        await tester.tap(find.text('With'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Before').last);
        await tester.pumpAndSettle();

        expect(find.text('Offset Minutes'), findsOneWidget);
      });

      testWidgets('Offset Minutes hidden when With selected', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Offset Minutes'), findsNothing);
      });

      testWidgets('shows Start Date and End Date pickers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester, by: 900);
        expect(find.text('Start Date'), findsWidgets);
        expect(find.text('End Date'), findsWidgets);
      });

      testWidgets('populates schedule from supplement', (tester) async {
        final supplement = createTestSupplement(
          schedules: [
            const SupplementSchedule(
              anchorEvent: SupplementAnchorEvent.dinner,
              timingType: SupplementTimingType.beforeEvent,
              offsetMinutes: 30,
              frequencyType: SupplementFrequencyType.daily,
            ),
          ],
        );
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(find.text('Dinner'), findsOneWidget);
        expect(find.text('Before'), findsOneWidget);
      });

      testWidgets('has correct semantic labels', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollDown(tester);
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'How often to take, required',
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'When to take supplement, required',
          ),
          findsOneWidget,
        );
      });
    });

    group('form dropdown options', () {
      testWidgets('shows all supplement form options', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Open form dropdown
        await tester.tap(find.text('Capsule'));
        await tester.pumpAndSettle();

        expect(find.text('Capsule'), findsWidgets);
        expect(find.text('Tablet'), findsOneWidget);
        expect(find.text('Powder'), findsOneWidget);
        expect(find.text('Liquid'), findsOneWidget);
        expect(find.text('Gummy'), findsOneWidget);
        expect(find.text('Spray'), findsOneWidget);
        expect(find.text('Other'), findsOneWidget);
      });

      testWidgets('shows all dosage unit options', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Open dosage unit dropdown - find the mg text in the dropdown
        await tester.tap(find.text('mg').first);
        await tester.pumpAndSettle();

        expect(find.text('mg'), findsWidgets);
        expect(find.text('mcg'), findsOneWidget);
        expect(find.text('g'), findsWidgets);
        expect(find.text('IU'), findsOneWidget);
        expect(find.text('HDU'), findsOneWidget);
        expect(find.text('mL'), findsOneWidget);
        expect(find.text('drops'), findsOneWidget);
        expect(find.text('tsp'), findsOneWidget);
        expect(find.text('custom'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('body has semantic label for add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Add supplement form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('body has semantic label for edit mode', (tester) async {
        final supplement = createTestSupplement();
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit supplement form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('name field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Supplement name, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('brand field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Brand name, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('form dropdown has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Supplement form, required, capsule tablet powder or other',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('dosage amount has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Dosage amount, required, enter number',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('dosage unit has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Dosage unit, required, select unit',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('quantity per dose has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Quantity per dose, required, default is 1',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('notes field has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Supplement notes, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        // Basic Information, Dosage visible at top
        expect(headerFinder, findsAtLeastNWidgets(2));
        await scrollToBottom(tester);
        // Notes header visible at bottom
        expect(headerFinder, findsAtLeastNWidgets(1));
      });
    });

    group('dirty form and cancel', () {
      testWidgets('cancel pops without dialog when form is clean', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (context) => const SupplementEditScreen(
                            profileId: testProfileId,
                          ),
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

        // Navigate to edit screen
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        expect(find.text('Add Supplement'), findsOneWidget);

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Should have popped back
        expect(find.text('Add Supplement'), findsNothing);
        expect(find.text('Go'), findsOneWidget);
      });

      testWidgets('cancel shows discard dialog when form is dirty', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Make the form dirty by entering text
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Test',
        );
        await tester.pumpAndSettle();

        // Tap Cancel
        await scrollToBottom(tester);
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
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Test',
        );
        await tester.pumpAndSettle();

        // Tap Cancel
        await scrollToBottom(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Tap Keep Editing
        await tester.tap(find.text('Keep Editing'));
        await tester.pumpAndSettle();

        // Should still be on edit screen
        expect(find.text('Add Supplement'), findsOneWidget);
        expect(find.text('Discard Changes?'), findsNothing);
      });
    });

    group('save success', () {
      testWidgets('shows success snackbar on create', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Fill in required fields
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Vitamin D3',
        );

        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Dosage amount, required, enter number',
            ),
            matching: find.byType(TextField),
          ),
          '2000',
        );
        await tester.pumpAndSettle();

        // Tap Save
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester
            .pump(); // Use pump() to catch snackbar before 4s auto-dismiss

        expect(find.text('Supplement created successfully'), findsOneWidget);
      });

      testWidgets('shows success snackbar on update', (tester) async {
        final supplement = createTestSupplement();
        await tester.pumpWidget(buildEditScreen(supplement));
        await tester.pumpAndSettle();

        // Tap Save Changes (form already populated)
        await scrollToBottom(tester);
        await tester.tap(find.text('Save Changes'));
        await tester
            .pump(); // Use pump() to catch snackbar before 4s auto-dismiss

        expect(find.text('Supplement updated successfully'), findsOneWidget);
      });
    });

    group('save failure', () {
      testWidgets('shows error snackbar on save failure', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(_ErrorOnCreateSupplementList.new),
            ],
            child: const MaterialApp(
              home: SupplementEditScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Fill in required fields
        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label == 'Supplement name, required',
            ),
            matching: find.byType(TextField),
          ),
          'Vitamin D3',
        );

        await tester.enterText(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Dosage amount, required, enter number',
            ),
            matching: find.byType(TextField),
          ),
          '2000',
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

    group('placeholders', () {
      testWidgets('name field has correct placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('e.g., Vitamin D3'), findsOneWidget);
      });

      testWidgets('brand field has correct placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('e.g., NOW Foods'), findsOneWidget);
      });

      testWidgets('dosage amount has correct placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('e.g., 2000'), findsOneWidget);
      });

      testWidgets('notes has correct placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollToBottom(tester);
        expect(find.text('Any notes about this supplement'), findsOneWidget);
      });
    });

    group('widget types', () {
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

      testWidgets('uses DropdownButtonFormField for dropdowns', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byType(DropdownButtonFormField<SupplementForm>),
          findsOneWidget,
        );
        expect(
          find.byType(DropdownButtonFormField<DosageUnit>),
          findsOneWidget,
        );
      });

      testWidgets('uses Form widget', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });
    });
  });
}

/// Mock SupplementList notifier for testing.
class _MockSupplementList extends SupplementList {
  final List<Supplement> _supplements;

  _MockSupplementList(this._supplements);

  @override
  Future<List<Supplement>> build(String profileId) async => _supplements;

  @override
  Future<void> create(CreateSupplementInput input) async {
    // Success - no-op for testing
  }

  @override
  Future<void> updateSupplement(UpdateSupplementInput input) async {
    // Success - no-op for testing
  }
}

/// Mock notifier that simulates a failure on create.
class _ErrorOnCreateSupplementList extends SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async => [];

  @override
  Future<void> create(CreateSupplementInput input) async {
    throw DatabaseError.insertFailed('test');
  }
}
