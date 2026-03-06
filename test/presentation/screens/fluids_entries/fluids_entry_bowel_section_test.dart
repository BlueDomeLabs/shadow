// test/presentation/screens/fluids_entries/fluids_entry_bowel_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_bowel_section.dart';

void main() {
  late TextEditingController customConditionController;

  setUp(() {
    customConditionController = TextEditingController();
  });

  tearDown(() {
    customConditionController.dispose();
  });

  Widget buildWidget({
    bool hadBowelMovement = false,
    BowelCondition? bowelCondition,
    String? customConditionError,
    MovementSize bowelSize = MovementSize.medium,
    String? bowelPhotoPath,
    ValueChanged<bool>? onToggleChanged,
    void Function(BowelCondition?)? onConditionChanged,
    VoidCallback? onCustomConditionChanged,
    void Function(MovementSize)? onSizeChanged,
    VoidCallback? onAddPhoto,
    VoidCallback? onRemovePhoto,
  }) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: FluidsEntryBowelSection(
          hadBowelMovement: hadBowelMovement,
          bowelCondition: bowelCondition,
          customConditionController: customConditionController,
          customConditionError: customConditionError,
          bowelSize: bowelSize,
          bowelPhotoPath: bowelPhotoPath,
          onToggleChanged: onToggleChanged ?? (_) {},
          onConditionChanged: onConditionChanged ?? (_) {},
          onCustomConditionChanged: onCustomConditionChanged ?? () {},
          onSizeChanged: onSizeChanged ?? (_) {},
          onAddPhoto: onAddPhoto ?? () {},
          onRemovePhoto: onRemovePhoto ?? () {},
        ),
      ),
    ),
  );

  group('FluidsEntryBowelSection', () {
    group('toggle off (no bowel movement)', () {
      testWidgets('shows Had Bowel Movement toggle', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Had Bowel Movement'), findsOneWidget);
      });

      testWidgets('hides detail fields when toggle is off', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Condition'), findsNothing);
        expect(find.text('Size'), findsNothing);
        expect(find.text('Add photo'), findsNothing);
      });
    });

    group('toggle on (had bowel movement)', () {
      testWidgets('shows Condition dropdown when toggle is on', (tester) async {
        await tester.pumpWidget(buildWidget(hadBowelMovement: true));
        expect(find.text('Condition'), findsOneWidget);
      });

      testWidgets('shows Size dropdown when toggle is on', (tester) async {
        await tester.pumpWidget(buildWidget(hadBowelMovement: true));
        expect(find.text('Size'), findsOneWidget);
      });

      testWidgets('shows Add photo button when toggle is on', (tester) async {
        await tester.pumpWidget(buildWidget(hadBowelMovement: true));
        expect(find.text('Add photo'), findsOneWidget);
      });

      testWidgets('hides Custom Condition field when condition is not custom', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(
            hadBowelMovement: true,
            bowelCondition: BowelCondition.normal,
          ),
        );
        expect(find.text('Custom Condition'), findsNothing);
      });

      testWidgets('shows Custom Condition field when condition is custom', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(
            hadBowelMovement: true,
            bowelCondition: BowelCondition.custom,
          ),
        );
        expect(find.text('Custom Condition'), findsOneWidget);
      });
    });

    group('photo', () {
      testWidgets('shows Remove photo button when bowelPhotoPath is set', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(
            hadBowelMovement: true,
            bowelPhotoPath: '/fake/photo.jpg',
          ),
        );
        await tester.pump();
        expect(find.text('Remove photo'), findsOneWidget);
      });

      testWidgets('hides Remove photo button when no photo', (tester) async {
        await tester.pumpWidget(buildWidget(hadBowelMovement: true));
        expect(find.text('Remove photo'), findsNothing);
      });
    });

    group('callbacks', () {
      testWidgets('toggle fires onToggleChanged', (tester) async {
        bool? received;
        await tester.pumpWidget(
          buildWidget(onToggleChanged: (val) => received = val),
        );
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(received, isTrue);
      });

      testWidgets('onSizeChanged fires when size dropdown changes', (
        tester,
      ) async {
        MovementSize? received;
        await tester.pumpWidget(
          buildWidget(
            hadBowelMovement: true,
            onSizeChanged: (val) => received = val,
          ),
        );
        await tester.tap(find.text('Medium'));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        await tester.tap(find.text('Large').last);
        await tester.pumpAndSettle(const Duration(seconds: 5));
        expect(received, MovementSize.large);
      });

      testWidgets('Add photo button fires onAddPhoto', (tester) async {
        var called = false;
        await tester.pumpWidget(
          buildWidget(hadBowelMovement: true, onAddPhoto: () => called = true),
        );
        await tester.tap(find.text('Add photo'));
        expect(called, isTrue);
      });

      testWidgets('Remove photo button fires onRemovePhoto', (tester) async {
        var called = false;
        await tester.pumpWidget(
          buildWidget(
            hadBowelMovement: true,
            bowelPhotoPath: '/fake/photo.jpg',
            onRemovePhoto: () => called = true,
          ),
        );
        await tester.pump();
        await tester.tap(find.text('Remove photo'));
        expect(called, isTrue);
      });
    });
  });
}
