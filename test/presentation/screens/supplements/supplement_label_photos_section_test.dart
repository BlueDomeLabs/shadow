// test/presentation/screens/supplements/supplement_label_photos_section_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_label_photos_section.dart';

void main() {
  Widget buildWidget({
    List<String> photoPaths = const [],
    VoidCallback? onTakePhoto,
    VoidCallback? onPickFromLibrary,
    void Function(int)? onRemovePhoto,
  }) => MaterialApp(
    home: Scaffold(
      body: SupplementLabelPhotosSection(
        photoPaths: photoPaths,
        onTakePhoto: onTakePhoto ?? () {},
        onPickFromLibrary: onPickFromLibrary ?? () {},
        onRemovePhoto: onRemovePhoto ?? (_) {},
      ),
    ),
  );

  group('SupplementLabelPhotosSection', () {
    group('empty state (no photos)', () {
      testWidgets('shows Take Photo button', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Take Photo'), findsOneWidget);
      });

      testWidgets('shows Choose from Library button', (tester) async {
        await tester.pumpWidget(buildWidget());
        expect(find.text('Choose from Library'), findsOneWidget);
      });

      testWidgets('does not show max-photos message when below limit', (
        tester,
      ) async {
        await tester.pumpWidget(buildWidget());
        expect(
          find.text('Maximum 3 label photos per supplement'),
          findsNothing,
        );
      });
    });

    group('photo thumbnails', () {
      testWidgets('shows close (remove) button for each photo', (tester) async {
        // Use non-existent paths — errorBuilder shows broken_image icon
        await tester.pumpWidget(
          buildWidget(photoPaths: ['/fake/photo1.jpg', '/fake/photo2.jpg']),
        );
        await tester.pump();
        // Two remove buttons (one per photo)
        expect(find.byIcon(Icons.close), findsNWidgets(2));
      });

      testWidgets('shows remove button for each photo path', (tester) async {
        // Widget tests cannot load real files from disk, but the close button
        // is always rendered for each photo entry regardless of load success.
        await tester.pumpWidget(buildWidget(photoPaths: ['/fake/a.jpg']));
        await tester.pump();
        expect(find.byIcon(Icons.close), findsOneWidget);
      });
    });

    group('max photos reached (3 photos)', () {
      testWidgets('hides Take Photo and Choose from Library buttons', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildWidget(photoPaths: ['/a.jpg', '/b.jpg', '/c.jpg']),
        );
        await tester.pump();
        expect(find.text('Take Photo'), findsNothing);
        expect(find.text('Choose from Library'), findsNothing);
      });

      testWidgets('shows max-photos message', (tester) async {
        await tester.pumpWidget(
          buildWidget(photoPaths: ['/a.jpg', '/b.jpg', '/c.jpg']),
        );
        await tester.pump();
        expect(
          find.text('Maximum 3 label photos per supplement'),
          findsOneWidget,
        );
      });
    });

    group('callbacks', () {
      testWidgets('Take Photo button fires onTakePhoto', (tester) async {
        var called = false;
        await tester.pumpWidget(buildWidget(onTakePhoto: () => called = true));
        await tester.tap(find.text('Take Photo'));
        expect(called, isTrue);
      });

      testWidgets('Choose from Library button fires onPickFromLibrary', (
        tester,
      ) async {
        var called = false;
        await tester.pumpWidget(
          buildWidget(onPickFromLibrary: () => called = true),
        );
        await tester.tap(find.text('Choose from Library'));
        expect(called, isTrue);
      });

      testWidgets('remove button fires onRemovePhoto with correct index', (
        tester,
      ) async {
        int? removedIndex;
        await tester.pumpWidget(
          buildWidget(
            photoPaths: ['/fake/a.jpg', '/fake/b.jpg'],
            onRemovePhoto: (i) => removedIndex = i,
          ),
        );
        await tester.pump();

        // Tap the first remove button (index 0)
        await tester.tap(find.byIcon(Icons.close).first);
        expect(removedIndex, 0);
      });
    });
  });
}
