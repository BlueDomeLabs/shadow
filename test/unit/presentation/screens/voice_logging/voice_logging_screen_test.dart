// test/unit/presentation/screens/voice_logging/voice_logging_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/screens/voice_logging/voice_logging_screen.dart';

Widget _buildApp({int pendingItemCount = 0}) =>
    MaterialApp(home: VoiceLoggingScreen(pendingItemCount: pendingItemCount));

void main() {
  group('VoiceLoggingScreen', () {
    testWidgets('renders_withoutError', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(VoiceLoggingScreen), findsOneWidget);
    });

    testWidgets('shows_assistantText', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Good morning. How can I help?'), findsOneWidget);
    });

    testWidgets('xButton_isPresent', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('textInputField_isPresent', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('micButton_isPresent', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.byIcon(Icons.mic), findsWidgets);
    });

    testWidgets('progressDots_renderForPendingItems', (tester) async {
      await tester.pumpWidget(_buildApp(pendingItemCount: 3));
      await tester.pumpAndSettle(const Duration(seconds: 5));
      // Progress dots row is present when pendingItemCount > 0
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Row &&
              w.children.length == 3 &&
              w.children.every((c) => c is Padding),
        ),
        findsWidgets,
      );
    });

    testWidgets('logsNavItem_isPresent', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));
      expect(find.text('Logs'), findsOneWidget);
      expect(find.byIcon(Icons.grid_view), findsOneWidget);
    });
  });
}
