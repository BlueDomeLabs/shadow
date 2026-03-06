// test/presentation/screens/fluids_entries/fluids_entry_urine_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_urine_section.dart';

void main() {
  late TextEditingController customColorController;

  setUp(() {
    customColorController = TextEditingController();
  });

  tearDown(() {
    customColorController.dispose();
  });

  Widget buildWidget({
    bool hadUrination = false,
    UrineCondition? urineCondition,
    String? customColorError,
    MovementSize urineSize = MovementSize.medium,
    String? urinePhotoPath,
    ValueChanged<bool>? onToggleChanged,
    void Function(UrineCondition?)? onConditionChanged,
    VoidCallback? onCustomColorChanged,
    void Function(MovementSize)? onSizeChanged,
    VoidCallback? onAddPhoto,
    VoidCallback? onRemovePhoto,
  }) => MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: FluidsEntryUrineSection(
          hadUrination: hadUrination,
          urineCondition: urineCondition,
          customColorController: customColorController,
          customColorError: customColorError,
          urineSize: urineSize,
          urinePhotoPath: urinePhotoPath,
          onToggleChanged: onToggleChanged ?? (_) {},
          onConditionChanged: onConditionChanged ?? (_) {},
          onCustomColorChanged: onCustomColorChanged ?? () {},
          onSizeChanged: onSizeChanged ?? (_) {},
          onAddPhoto: onAddPhoto ?? () {},
          onRemovePhoto: onRemovePhoto ?? () {},
        ),
      ),
    ),
  );

  group('FluidsEntryUrineSection', () {
    group('toggle off (no urination)', () {
      testWidgets('shows Had Urination toggle', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Had Urination'), findsOneWidget);
      });

      testWidgets('hides detail fields when toggle is off', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Color'), findsNothing);
        expect(find.text('Size'), findsNothing);
        expect(find.text('Add photo'), findsNothing);
      });
    });

    group('toggle on (had urination)', () {
      testWidgets('shows Color dropdown when toggle is on', (tester) async {
        await tester.pumpWidget(buildWidget(hadUrination: true));
        expect(find.text('Color'), findsOneWidget);
      });

      testWidgets('shows Size dropdown when toggle is on', (tester) async {
        await tester.pumpWidget(buildWidget(hadUrination: true));
        expect(find.text('Size'), findsOneWidget);
      });

      testWidgets('shows Add photo button when toggle is on', (tester) async {
        await tester.pumpWidget(buildWidget(hadUrination: true));
        expect(find.text('Add photo'), findsOneWidget);
      });

      testWidgets('hides Custom Color field when condition is not custom', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(
            hadUrination: true,
            urineCondition: UrineCondition.yellow,
          ),
        );
        expect(find.text('Custom Color'), findsNothing);
      });

      testWidgets('shows Custom Color field when condition is custom', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(
            hadUrination: true,
            urineCondition: UrineCondition.custom,
          ),
        );
        expect(find.text('Custom Color'), findsOneWidget);
      });
    });

    group('photo', () {
      testWidgets('shows Remove photo button when urinePhotoPath is set', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(hadUrination: true, urinePhotoPath: '/fake/photo.jpg'),
        );
        await tester.pump();
        expect(find.text('Remove photo'), findsOneWidget);
      });

      testWidgets('hides Remove photo button when no photo', (tester) async {
        await tester.pumpWidget(buildWidget(hadUrination: true));
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
            hadUrination: true,
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
          buildWidget(hadUrination: true, onAddPhoto: () => called = true),
        );
        await tester.tap(find.text('Add photo'));
        expect(called, isTrue);
      });

      testWidgets('Remove photo button fires onRemovePhoto', (tester) async {
        var called = false;
        await tester.pumpWidget(
          buildWidget(
            hadUrination: true,
            urinePhotoPath: '/fake/photo.jpg',
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
