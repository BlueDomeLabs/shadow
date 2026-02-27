// test/presentation/screens/fluids_entries/fluids_entry_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('FluidsEntryScreen', () {
    const testProfileId = 'profile-001';

    // Use a fixed date range for provider overrides
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));
    final startDate = startOfDay.millisecondsSinceEpoch;
    final endDate = endOfDay.millisecondsSinceEpoch;

    /// Scrolls the ListView until the given [finder] is visible.
    Future<void> scrollUntilFound(
      WidgetTester tester,
      Finder finder, {
      double step = 200,
      int maxScrolls = 30,
    }) async {
      for (var i = 0; i < maxScrolls; i++) {
        if (tester.any(finder)) return;
        await tester.drag(find.byType(Scrollable).first, Offset(0, -step));
        await tester.pumpAndSettle();
      }
    }

    FluidsEntry createTestFluidsEntry({
      String id = 'fluids-001',
      String clientId = 'client-001',
      int? entryDate,
      int? waterIntakeMl,
      String? waterIntakeNotes,
      BowelCondition? bowelCondition,
      MovementSize? bowelSize,
      String? bowelPhotoPath,
      UrineCondition? urineCondition,
      MovementSize? urineSize,
      MenstruationFlow? menstruationFlow,
      double? basalBodyTemperature,
      int? bbtRecordedTime,
      String? otherFluidName,
      String? otherFluidAmount,
      String? otherFluidNotes,
    }) => FluidsEntry(
      id: id,
      clientId: clientId,
      profileId: testProfileId,
      entryDate: entryDate ?? DateTime.now().millisecondsSinceEpoch,
      waterIntakeMl: waterIntakeMl,
      waterIntakeNotes: waterIntakeNotes,
      bowelCondition: bowelCondition,
      bowelSize: bowelSize,
      bowelPhotoPath: bowelPhotoPath,
      urineCondition: urineCondition,
      urineSize: urineSize,
      menstruationFlow: menstruationFlow,
      basalBodyTemperature: basalBodyTemperature,
      bbtRecordedTime: bbtRecordedTime,
      otherFluidName: otherFluidName,
      otherFluidAmount: otherFluidAmount,
      otherFluidNotes: otherFluidNotes,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        fluidsEntryListProvider(
          testProfileId,
          startDate,
          endDate,
        ).overrideWith(() => _MockFluidsEntryList([])),
      ],
      child: const MaterialApp(
        home: FluidsEntryScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(FluidsEntry entry) => ProviderScope(
      overrides: [
        fluidsEntryListProvider(
          testProfileId,
          startDate,
          endDate,
        ).overrideWith(() => _MockFluidsEntryList([entry])),
      ],
      child: MaterialApp(
        home: FluidsEntryScreen(profileId: testProfileId, fluidsEntry: entry),
      ),
    );

    group('rendering', () {
      testWidgets('renders Add Fluids Entry title in add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Add Fluids Entry'), findsOneWidget);
      });

      testWidgets('renders Edit Fluids Entry title in edit mode', (
        tester,
      ) async {
        final entry = createTestFluidsEntry();
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        expect(find.text('Edit Fluids Entry'), findsOneWidget);
      });

      testWidgets('renders top section headers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Date & Time'), findsWidgets);
        expect(find.text('Water Intake'), findsOneWidget);
        expect(find.text('Bowel Movement'), findsOneWidget);
      });

      testWidgets('renders Urine section header', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Urine'));
        expect(find.text('Urine'), findsOneWidget);
      });

      testWidgets('renders Menstruation section header', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Menstruation'));
        expect(find.text('Menstruation'), findsOneWidget);
      });

      testWidgets('renders BBT section header', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Basal Body Temperature'));
        expect(find.text('Basal Body Temperature'), findsOneWidget);
      });

      testWidgets('renders Other Fluid section header', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Other Fluid'));
        expect(find.text('Other Fluid'), findsOneWidget);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Save'));
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders Save Changes button in edit mode', (tester) async {
        final entry = createTestFluidsEntry();
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Save Changes'));
        expect(find.text('Save Changes'), findsOneWidget);
      });
    });

    group('water intake', () {
      testWidgets('renders water amount field with placeholder', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Water Amount'), findsOneWidget);
        expect(find.text('Amount'), findsOneWidget);
      });

      testWidgets('renders water unit dropdown', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Default unit is fl oz
        expect(find.text('fl oz'), findsOneWidget);
      });

      testWidgets('renders quick add buttons with correct labels', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('8 oz'), findsOneWidget);
        expect(find.text('12 oz'), findsOneWidget);
        expect(find.text('16 oz'), findsOneWidget);
      });

      testWidgets('quick add buttons add to water amount', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Tap 8 oz quick add
        await tester.tap(find.text('8 oz'));
        await tester.pumpAndSettle();

        // Water amount should have a value
        final amountField = tester.widget<TextField>(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Custom water amount, enter ounces',
            ),
            matching: find.byType(TextField),
          ),
        );
        expect(amountField.controller?.text, isNotEmpty);
      });

      testWidgets('renders water notes field with placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.text('Water Notes'), findsOneWidget);
        expect(find.text('e.g., with lemon'), findsOneWidget);
      });
    });

    group('bowel movement', () {
      testWidgets('bowel movement toggle starts as off', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final switchWidget = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile).first,
        );
        expect(switchWidget.value, isFalse);
      });

      testWidgets('bowel conditional fields hidden when toggle off', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // The bowel "Condition" label should not be visible anywhere
        expect(find.text('Condition'), findsNothing);
        expect(find.text('Add photo'), findsNothing);
      });

      testWidgets('bowel conditional fields shown when toggle on', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Scroll to the bowel movement toggle first
        await scrollUntilFound(tester, find.text('Had Bowel Movement'));
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Condition'));
        expect(find.text('Condition'), findsOneWidget);

        await scrollUntilFound(tester, find.text('Add photo'));
        expect(find.text('Add photo'), findsOneWidget);
      });

      testWidgets('bowel condition dropdown shows all options', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Scroll to and turn on bowel movement toggle
        await scrollUntilFound(tester, find.text('Had Bowel Movement'));
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Condition'));

        // Open the condition dropdown
        await tester.tap(find.text('Condition'));
        await tester.pumpAndSettle();

        expect(find.text('Diarrhea'), findsOneWidget);
        expect(find.text('Runny'), findsOneWidget);
        expect(find.text('Loose'), findsOneWidget);
        expect(find.text('Normal'), findsOneWidget);
        expect(find.text('Firm'), findsOneWidget);
        expect(find.text('Hard'), findsOneWidget);
        expect(find.text('Custom'), findsOneWidget);
      });
    });

    group('urine', () {
      testWidgets('urine toggle starts as off', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Had Urination'));

        // Find the urine SwitchListTile
        final switches = tester.widgetList<SwitchListTile>(
          find.byType(SwitchListTile),
        );
        // The urine switch should be the second one
        expect(switches.length, greaterThanOrEqualTo(2));
        expect(switches.elementAt(1).value, isFalse);
      });

      testWidgets('urine conditional fields hidden when toggle off', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Urine color/size semantic wrappers should not exist in tree
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Urine color, select from scale',
          ),
          findsNothing,
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label ==
                    'Urination volume, small medium or large',
          ),
          findsNothing,
        );
      });

      testWidgets('urine conditional fields shown when toggle on', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Had Urination'));

        // Find the urine SwitchListTile and tap the Switch within it
        final urineSwitchListTile = find.widgetWithText(
          SwitchListTile,
          'Had Urination',
        );
        await tester.tap(urineSwitchListTile);
        await tester.pumpAndSettle();

        // Scroll to find the color dropdown
        final colorFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Urine color, select from scale',
        );
        await scrollUntilFound(tester, colorFinder);
        expect(colorFinder, findsOneWidget);

        final sizeFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Urination volume, small medium or large',
        );
        await scrollUntilFound(tester, sizeFinder);
        expect(sizeFinder, findsOneWidget);
      });
    });

    group('menstruation', () {
      testWidgets('menstruation flow picker renders with 5 options', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Scroll to the menstruation section by finding its header
        await scrollUntilFound(tester, find.text('Menstruation'));

        // Then scroll a bit more to ensure the flow picker is fully visible
        await scrollUntilFound(tester, find.text('Spotty'));

        // ShadowPicker.flow renders 5 MenstruationFlow options as labels
        expect(find.text('None'), findsOneWidget);
        expect(find.text('Spotty'), findsOneWidget);
        expect(find.text('Heavy'), findsOneWidget);
        // Light and Medium may appear elsewhere so use findsWidgets
        expect(find.text('Light'), findsWidgets);
        expect(find.text('Medium'), findsWidgets);
      });
    });

    group('bbt', () {
      testWidgets('BBT field renders with placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Basal Body Temperature'));
        await scrollUntilFound(tester, find.text('e.g., 98.6'));
        expect(find.text('Temperature'), findsOneWidget);
        expect(find.text('e.g., 98.6'), findsOneWidget);
      });

      testWidgets('BBT validates range for Fahrenheit', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Scroll to BBT field
        final bbtSemantic = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Basal body temperature, required, degrees',
        );
        await scrollUntilFound(tester, bbtSemantic);

        // Enter invalid temperature (too low) - onChanged triggers _validateBBT
        final bbtField = find.descendant(
          of: bbtSemantic,
          matching: find.byType(TextField),
        );
        await tester.enterText(bbtField, '80');
        await tester.pumpAndSettle();

        // Error should appear immediately via onChanged validation
        final errorFinder = find.text(
          'Temperature must be between 95 and 105 \u00B0F',
        );
        await scrollUntilFound(tester, errorFinder);
        expect(errorFinder, findsOneWidget);
      });

      testWidgets('BBT unit dropdown renders with Fahrenheit default', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('\u00B0F'));
        expect(find.text('\u00B0F'), findsOneWidget);
      });

      testWidgets('BBT time picker renders', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Time Recorded'));
        expect(find.text('Time Recorded'), findsOneWidget);
      });
    });

    group('custom fluid', () {
      testWidgets('renders fluid name with placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Other Fluid'));
        await scrollUntilFound(tester, find.text('e.g., Sweat, Mucus'));
        expect(find.text('Fluid Name'), findsOneWidget);
        expect(find.text('e.g., Sweat, Mucus'), findsOneWidget);
      });

      testWidgets('renders fluid amount with placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('e.g., Light, Heavy, 2 tbsp'));
        expect(find.text('e.g., Light, Heavy, 2 tbsp'), findsOneWidget);
      });

      testWidgets('renders fluid notes with placeholder', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Additional details'));
        expect(find.text('Additional details'), findsOneWidget);
      });
    });

    group('conditional fields', () {
      testWidgets('bowel custom condition shown only when Custom selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on bowel movement
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Condition'));

        // Custom Condition should not be visible initially
        expect(find.text('Custom Condition'), findsNothing);

        // Open condition dropdown and select Custom
        await tester.tap(find.text('Condition'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Custom').last);
        await tester.pumpAndSettle();

        // Custom Condition should now be visible
        await scrollUntilFound(tester, find.text('Custom Condition'));
        expect(find.text('Custom Condition'), findsOneWidget);
        expect(find.text('Describe'), findsOneWidget);
      });

      testWidgets('urine custom color shown only when Custom selected', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on urine toggle
        await scrollUntilFound(tester, find.text('Had Urination'));
        await tester.tap(find.byType(Switch).at(1));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Color'));

        // Custom Color should not be visible
        expect(find.text('Custom Color'), findsNothing);

        // Open color dropdown and select Custom
        await tester.tap(find.text('Color'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Custom').last);
        await tester.pumpAndSettle();

        // Custom Color should now be visible
        await scrollUntilFound(tester, find.text('Custom Color'));
        expect(find.text('Custom Color'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('body has semantic label for add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Add fluids entry form',
          ),
          findsOneWidget,
        );
      });

      testWidgets('body has semantic label for edit mode', (tester) async {
        final entry = createTestFluidsEntry();
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Edit fluids entry form',
          ),
          findsOneWidget,
        );
      });

      testWidgets('water amount has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Custom water amount, enter ounces',
          ),
          findsOneWidget,
        );
      });

      testWidgets('water quick add 8oz has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Add 8 ounces water',
          ),
          findsOneWidget,
        );
      });

      testWidgets('water quick add 12oz has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Add 12 ounces water',
          ),
          findsOneWidget,
        );
      });

      testWidgets('water quick add 16oz has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Add 16 ounces water',
          ),
          findsOneWidget,
        );
      });

      testWidgets('water notes has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Water intake notes, optional',
          ),
          findsOneWidget,
        );
      });

      testWidgets('bowel movement toggle has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Had bowel movement, toggle',
          ),
          findsOneWidget,
        );
      });

      testWidgets('bristol scale has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on bowel movement
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Bristol stool scale, 1 to 7, required if bowel movement',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('bowel size has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on bowel movement
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Movement size, small medium or large',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('bowel photo has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on bowel movement
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Take photo of bowel movement, optional',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('urine toggle has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Had urination, toggle',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('urine color has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on urine toggle
        await scrollUntilFound(tester, find.text('Had Urination'));
        await tester.tap(find.byType(Switch).at(1));
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Urine color, select from scale',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('urine size has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Turn on urine toggle
        await scrollUntilFound(tester, find.text('Had Urination'));
        await tester.tap(find.byType(Switch).at(1));
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Urination volume, small medium or large',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('menstruation flow has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Menstruation flow intensity, none to heavy',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('BBT value has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Basal body temperature, required, degrees',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('BBT time has correct semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Temperature recorded time',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('other fluid name has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Other fluid name, optional',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('other fluid amount has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Other fluid amount, optional',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('other fluid notes has correct semantic label', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final finder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Other fluid notes, optional',
        );
        await scrollUntilFound(tester, finder);
        expect(finder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        // At least Date & Time, Water Intake, Bowel Movement visible initially
        expect(headerFinder, findsAtLeastNWidgets(3));
      });
    });

    group('validation', () {
      testWidgets('BBT validates temperature too high', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Scroll to BBT field
        final bbtSemantic = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Basal body temperature, required, degrees',
        );
        await scrollUntilFound(tester, bbtSemantic);

        final bbtField = find.descendant(
          of: bbtSemantic,
          matching: find.byType(TextField),
        );
        await tester.enterText(bbtField, '110');
        await tester.pumpAndSettle();

        // onChanged triggers _validateBBT immediately - error should appear
        final errorFinder = find.text(
          'Temperature must be between 95 and 105 \u00B0F',
        );
        await scrollUntilFound(tester, errorFinder);
        expect(errorFinder, findsOneWidget);
      });

      testWidgets('water amount validates invalid number', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Enter invalid number (multiple dots pass the [0-9.] formatter
        // but double.tryParse returns null)
        final waterField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Custom water amount, enter ounces',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(waterField, '1.2.3');
        await tester.pumpAndSettle();

        // onChanged triggers _validateWaterAmount immediately - error should appear
        expect(find.text('Please enter a valid number'), findsOneWidget);
      });
    });

    group('save', () {
      testWidgets('shows success snackbar on create', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Save'));
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(find.text('Fluids entry created successfully'), findsOneWidget);
      });

      testWidgets('shows success snackbar on update', (tester) async {
        final entry = createTestFluidsEntry(waterIntakeMl: 500);
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Save Changes'));
        await tester.tap(find.text('Save Changes'));
        await tester.pump();

        expect(find.text('Fluids entry updated successfully'), findsOneWidget);
      });

      testWidgets('shows error snackbar on save failure', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              fluidsEntryListProvider(
                testProfileId,
                startDate,
                endDate,
              ).overrideWith(_ErrorOnLogFluidsEntryList.new),
            ],
            child: const MaterialApp(
              home: FluidsEntryScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Save'));
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(
          find.text('Unable to save data. Please try again.'),
          findsOneWidget,
        );
      });
    });

    group('edit mode', () {
      testWidgets('populates water intake from existing entry', (tester) async {
        final entry = createTestFluidsEntry(
          waterIntakeMl: 473,
          waterIntakeNotes: 'cold water',
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        // Water amount should be populated
        final amountField = tester.widget<TextField>(
          find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.label ==
                      'Custom water amount, enter ounces',
            ),
            matching: find.byType(TextField),
          ),
        );
        expect(amountField.controller?.text, isNotEmpty);

        // Water notes should be populated
        expect(find.text('cold water'), findsOneWidget);
      });

      testWidgets('populates bowel data from existing entry', (tester) async {
        final entry = createTestFluidsEntry(
          bowelCondition: BowelCondition.normal,
          bowelSize: MovementSize.large,
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        // Bowel toggle should be on
        final switchWidget = tester.widget<SwitchListTile>(
          find.byType(SwitchListTile).first,
        );
        expect(switchWidget.value, isTrue);

        await scrollUntilFound(tester, find.text('Normal'));
        expect(find.text('Normal'), findsOneWidget);
      });

      testWidgets('populates BBT from existing entry', (tester) async {
        final entry = createTestFluidsEntry(
          basalBodyTemperature: 98.6,
          bbtRecordedTime: DateTime.now().millisecondsSinceEpoch,
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('98.6'));
        expect(find.text('98.6'), findsOneWidget);
      });

      testWidgets('populates menstruation flow from existing entry', (
        tester,
      ) async {
        final entry = createTestFluidsEntry(
          menstruationFlow: MenstruationFlow.heavy,
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Heavy'));
        expect(find.text('Heavy'), findsOneWidget);
      });

      testWidgets('populates other fluid from existing entry', (tester) async {
        final entry = createTestFluidsEntry(
          otherFluidName: 'Sweat',
          otherFluidAmount: 'Copious',
          otherFluidNotes: 'After workout',
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Sweat'));
        expect(find.text('Sweat'), findsOneWidget);

        await scrollUntilFound(tester, find.text('After workout'));
        expect(find.text('After workout'), findsOneWidget);
      });
    });

    group('dirty form and cancel', () {
      testWidgets('cancel shows discard dialog when form is dirty', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Make form dirty by entering text in the water notes field
        // (which is near the top and should stay accessible)
        final waterNotesField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Water intake notes, optional',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(waterNotesField, 'test');
        await tester.pumpAndSettle();

        // Scroll to the Cancel button at the bottom
        await scrollUntilFound(
          tester,
          find.widgetWithText(OutlinedButton, 'Cancel'),
        );
        await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
        await tester.pumpAndSettle();

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
        final waterNotesField = find.descendant(
          of: find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                widget.properties.label == 'Water intake notes, optional',
          ),
          matching: find.byType(TextField),
        );
        await tester.enterText(waterNotesField, 'test');
        await tester.pumpAndSettle();

        await scrollUntilFound(
          tester,
          find.widgetWithText(OutlinedButton, 'Cancel'),
        );
        await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Keep Editing'));
        await tester.pumpAndSettle();

        expect(find.text('Add Fluids Entry'), findsOneWidget);
        expect(find.text('Discard Changes?'), findsNothing);
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

        expect(find.byType(ShadowButton), findsWidgets);
      });

      testWidgets('uses ShadowPicker for menstruation flow', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.byType(ShadowPicker));
        expect(find.byType(ShadowPicker), findsOneWidget);
      });

      testWidgets('uses Form widget', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('uses SwitchListTile for toggles', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        expect(find.byType(SwitchListTile), findsWidgets);
      });
    });

    group('bowel photo', () {
      testWidgets('photo button renders when bowel movement toggled', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Scroll to and toggle the bowel movement switch
        await scrollUntilFound(tester, find.text('Had Bowel Movement'));
        await tester.tap(find.byType(Switch).first);
        await tester.pumpAndSettle();

        // Scroll until photo button is visible
        await scrollUntilFound(tester, find.text('Add photo'));
        expect(find.text('Add photo'), findsOneWidget);
      });

      testWidgets('Remove photo button shown when bowelPhotoPath set', (
        tester,
      ) async {
        final entry = createTestFluidsEntry(
          bowelPhotoPath: '/fake/bowel.jpg',
          bowelCondition: BowelCondition.normal,
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        // Scroll to the bowel photo section
        await scrollUntilFound(tester, find.text('Remove photo'));
        expect(find.text('Remove photo'), findsOneWidget);
      });

      testWidgets('Remove photo clears the bowel photo', (tester) async {
        final entry = createTestFluidsEntry(
          bowelPhotoPath: '/fake/bowel.jpg',
          bowelCondition: BowelCondition.normal,
        );
        await tester.pumpWidget(buildEditScreen(entry));
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Remove photo'));
        // Ensure visible before tapping (widget may be near scroll edge)
        await tester.ensureVisible(find.text('Remove photo'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Remove photo'));
        await tester.pumpAndSettle();

        expect(find.text('Remove photo'), findsNothing);
      });

      testWidgets('save includes bowelPhotoPath (null) in create mode', (
        tester,
      ) async {
        final mock = _CapturingFluidsEntryList();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              fluidsEntryListProvider(
                testProfileId,
                startDate,
                endDate,
              ).overrideWith(() => mock),
            ],
            child: const MaterialApp(
              home: FluidsEntryScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Scroll to Save and tap — no photo set, bowelPhotoPath should be null
        await scrollUntilFound(tester, find.text('Save'));
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mock.lastLogInput?.bowelPhotoPath, isNull);
      });

      testWidgets('save includes bowelPhotoPath in edit mode', (tester) async {
        final mock = _CapturingFluidsEntryList();
        final entry = createTestFluidsEntry(
          bowelPhotoPath: '/existing/bowel.jpg',
          bowelCondition: BowelCondition.normal,
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              fluidsEntryListProvider(
                testProfileId,
                startDate,
                endDate,
              ).overrideWith(() => mock),
            ],
            child: MaterialApp(
              home: FluidsEntryScreen(
                profileId: testProfileId,
                fluidsEntry: entry,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await scrollUntilFound(tester, find.text('Save Changes'));
        await tester.tap(find.text('Save Changes'));
        await tester.pump();

        expect(
          mock.lastUpdateInput?.bowelPhotoPath,
          equals('/existing/bowel.jpg'),
        );
      });
    });
  });
}

/// Mock FluidsEntryList notifier for testing.
class _MockFluidsEntryList extends FluidsEntryList {
  final List<FluidsEntry> _entries;

  _MockFluidsEntryList(this._entries);

  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async => _entries;

  @override
  Future<void> log(LogFluidsEntryInput input) async {
    // Success - no-op for testing
  }

  @override
  Future<void> updateEntry(UpdateFluidsEntryInput input) async {
    // Success - no-op for testing
  }

  @override
  Future<void> delete(DeleteFluidsEntryInput input) async {
    // Success - no-op for testing
  }
}

/// Capturing mock that records the last log/updateEntry input.
class _CapturingFluidsEntryList extends FluidsEntryList {
  LogFluidsEntryInput? lastLogInput;
  UpdateFluidsEntryInput? lastUpdateInput;

  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async => [];

  @override
  Future<void> log(LogFluidsEntryInput input) async {
    lastLogInput = input;
  }

  @override
  Future<void> updateEntry(UpdateFluidsEntryInput input) async {
    lastUpdateInput = input;
  }

  @override
  Future<void> delete(DeleteFluidsEntryInput input) async {
    // no-op
  }
}

/// Mock notifier that simulates a failure on log.
class _ErrorOnLogFluidsEntryList extends FluidsEntryList {
  @override
  Future<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  ) async => [];

  @override
  Future<void> log(LogFluidsEntryInput input) async {
    throw DatabaseError.insertFailed('test');
  }
}
