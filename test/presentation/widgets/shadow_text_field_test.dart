// test/presentation/widgets/shadow_text_field_test.dart
// Tests per 09_WIDGET_LIBRARY.md Section 7.7

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/widgets/shadow_text_field.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

void main() {
  group('ShadowTextField', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField(label: 'Supplement Name')),
        ),
      );

      expect(find.text('Supplement Name'), findsOneWidget);
    });

    testWidgets('renders with semantic label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              label: 'Name',
              semanticLabel: 'Enter supplement name',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Enter supplement name'), findsOneWidget);
    });

    testWidgets('uses label as semantic label when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField(label: 'Supplement Name')),
        ),
      );

      expect(find.bySemanticsLabel('Supplement Name'), findsOneWidget);
    });

    testWidgets('displays hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(label: 'Name', hintText: 'e.g., Vitamin D3'),
          ),
        ),
      );

      expect(find.text('e.g., Vitamin D3'), findsOneWidget);
    });

    testWidgets('displays helper text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              label: 'Name',
              helperText: 'Enter the brand and product name',
            ),
          ),
        ),
      );

      expect(find.text('Enter the brand and product name'), findsOneWidget);
    });

    testWidgets('displays error text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(label: 'Name', errorText: 'Name is required'),
          ),
        ),
      );

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('text input type uses text keyboard', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField(label: 'Name')),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.text);
    });

    testWidgets('numeric input type uses number keyboard', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              inputType: InputType.numeric,
              label: 'Dosage',
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.number);
    });

    testWidgets('password input type obscures text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              inputType: InputType.password,
              label: 'Password',
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('numeric input has number formatter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              inputType: InputType.numeric,
              label: 'Amount',
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.inputFormatters, isNotNull);
      expect(textField.inputFormatters!.length, 1);
    });

    testWidgets('onChanged callback is invoked', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              label: 'Name',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test Value');
      expect(changedValue, 'Test Value');
    });

    testWidgets('disabled field is not editable', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField(label: 'Name', enabled: false)),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('convenience constructor ShadowTextField.text works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField.text(label: 'Name')),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.text);
      expect(textField.obscureText, isFalse);
    });

    testWidgets('convenience constructor ShadowTextField.numeric works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField.numeric(label: 'Amount')),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, TextInputType.number);
    });

    testWidgets('convenience constructor ShadowTextField.password works', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField.password(label: 'Password')),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('prefix icon is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShadowTextField(label: 'Search', prefixIcon: Icons.search),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('suffix icon is displayed and tappable', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShadowTextField(
              label: 'Password',
              suffixIcon: Icons.visibility,
              onSuffixTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility));
      expect(tapped, isTrue);
    });

    testWidgets('max length is enforced', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField(label: 'Name', maxLength: 10)),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLength, 10);
    });

    testWidgets('multiline is supported', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ShadowTextField(label: 'Notes', maxLines: 5)),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.maxLines, 5);
    });
  });
}
