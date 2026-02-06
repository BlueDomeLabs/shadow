import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_image.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowImage', () {
    group('picker mode', () {
      testWidgets('shows placeholder when no file selected', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowImage.picker(
                onTap: () {},
                semanticLabel: 'Add photo',
                width: 200,
                height: 200,
              ),
            ),
          ),
        );

        expect(find.text('Add Photo'), findsOneWidget);
        expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowImage.picker(
                onTap: () => tapped = true,
                semanticLabel: 'Add photo',
                width: 200,
                height: 200,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Photo'));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('shows custom placeholder icon', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowImage.picker(
                onTap: () {},
                semanticLabel: 'Add photo',
                width: 200,
                height: 200,
                placeholderIcon: Icons.camera_alt,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      });
    });

    group('widget structure', () {
      testWidgets('ShadowImage widget is created', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowImage.picker(
                onTap: () {},
                semanticLabel: 'Test image',
                width: 100,
                height: 100,
              ),
            ),
          ),
        );

        expect(find.byType(ShadowImage), findsOneWidget);
      });

      testWidgets('picker shows border outline', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowImage.picker(
                onTap: () {},
                semanticLabel: 'Add photo',
                width: 200,
                height: 200,
              ),
            ),
          ),
        );

        // The picker should have a Container with border
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('configuration', () {
      testWidgets('ImageSource.asset creates correct source', (tester) async {
        const image = ShadowImage.asset(
          assetPath: 'test.png',
          semanticLabel: 'Test',
          width: 100,
          height: 100,
        );

        expect(image.source, equals(ImageSource.asset));
        expect(image.assetPath, equals('test.png'));
      });

      testWidgets('ImageSource.file creates correct source', (tester) async {
        const image = ShadowImage.file(
          filePath: '/path/to/file.png',
          semanticLabel: 'Test',
          width: 100,
          height: 100,
        );

        expect(image.source, equals(ImageSource.file));
        expect(image.filePath, equals('/path/to/file.png'));
      });

      testWidgets('ImageSource.network creates correct source', (tester) async {
        const image = ShadowImage.network(
          url: 'https://example.com/image.png',
          semanticLabel: 'Test',
          width: 100,
          height: 100,
        );

        expect(image.source, equals(ImageSource.network));
        expect(image.url, equals('https://example.com/image.png'));
      });

      testWidgets('ImageSource.picker creates correct source', (tester) async {
        final image = ShadowImage.picker(
          onTap: () {},
          semanticLabel: 'Test',
          width: 100,
          height: 100,
        );

        expect(image.source, equals(ImageSource.picker));
      });

      testWidgets('decorative flag is set correctly', (tester) async {
        const image = ShadowImage.asset(
          assetPath: 'test.png',
          isDecorative: true,
          width: 48,
          height: 48,
        );

        expect(image.isDecorative, isTrue);
      });

      testWidgets('cache dimensions are set correctly', (tester) async {
        const image = ShadowImage.asset(
          assetPath: 'test.png',
          semanticLabel: 'Test',
          width: 100,
          height: 100,
          cacheWidth: 200,
          cacheHeight: 200,
        );

        expect(image.cacheWidth, equals(200));
        expect(image.cacheHeight, equals(200));
      });

      testWidgets('border radius is set correctly', (tester) async {
        const radius = BorderRadius.all(Radius.circular(16));
        const image = ShadowImage.asset(
          assetPath: 'test.png',
          semanticLabel: 'Test',
          width: 100,
          height: 100,
          borderRadius: radius,
        );

        expect(image.borderRadius, equals(radius));
      });
    });

    group('accessibility', () {
      testWidgets('picker has Semantics wrapper', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ShadowImage.picker(
                onTap: () {},
                semanticLabel: 'Add photo',
                width: 200,
                height: 200,
              ),
            ),
          ),
        );

        expect(find.byType(Semantics), findsWidgets);
      });

      testWidgets('semantic label is required unless decorative', (
        tester,
      ) async {
        // This should not throw - decorative image without semantic label
        const image = ShadowImage.asset(
          assetPath: 'test.png',
          isDecorative: true,
          width: 48,
          height: 48,
        );

        expect(image.semanticLabel, isNull);
        expect(image.isDecorative, isTrue);
      });
    });
  });
}
