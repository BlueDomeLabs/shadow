// test/presentation/screens/supplements/supplement_scan_shortcuts_bar_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_scan_shortcuts_bar.dart';

void main() {
  Widget buildWidget({
    VoidCallback? onScanBarcode,
    VoidCallback? onScanLabel,
  }) => MaterialApp(
    home: Scaffold(
      body: SupplementScanShortcutsBar(
        onScanBarcode: onScanBarcode ?? () {},
        onScanLabel: onScanLabel ?? () {},
      ),
    ),
  );

  group('SupplementScanShortcutsBar', () {
    testWidgets('renders Scan Barcode button', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Scan Barcode'), findsOneWidget);
    });

    testWidgets('renders Scan Label button', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Scan Label'), findsOneWidget);
    });

    testWidgets('Scan Barcode button fires onScanBarcode', (tester) async {
      var called = false;
      await tester.pumpWidget(buildWidget(onScanBarcode: () => called = true));
      await tester.tap(find.text('Scan Barcode'));
      expect(called, isTrue);
    });

    testWidgets('Scan Label button fires onScanLabel', (tester) async {
      var called = false;
      await tester.pumpWidget(buildWidget(onScanLabel: () => called = true));
      await tester.tap(find.text('Scan Label'));
      expect(called, isTrue);
    });

    testWidgets('shows barcode scanner icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });

    testWidgets('shows camera icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });
}
