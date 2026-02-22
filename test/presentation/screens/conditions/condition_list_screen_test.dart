// test/presentation/screens/conditions/condition_list_screen_test.dart
// Tests for ConditionListScreen per 38_UI_FIELD_SPECIFICATIONS.md Section 8
// and accessibility requirements from Section 18.7.
// Follows supplement_list_screen_test.dart reference pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/condition_list_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('ConditionListScreen', () {
    const testProfileId = 'profile-001';

    Condition createTestCondition({
      String id = 'cond-001',
      String name = 'Eczema',
      String category = 'Skin',
      List<String> bodyLocations = const ['Arms', 'Hands'],
      ConditionStatus status = ConditionStatus.active,
      bool isArchived = false,
      String? baselinePhotoPath,
    }) => Condition(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      category: category,
      bodyLocations: bodyLocations,
      startTimeframe: 1706745600000, // epoch ms
      status: status,
      isArchived: isArchived,
      baselinePhotoPath: baselinePhotoPath,
      syncMetadata: SyncMetadata.empty(),
    );

    testWidgets('renders app bar with title Conditions', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Conditions'), findsOneWidget);
    });

    testWidgets('renders filter button with tooltip Filter conditions', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      final iconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.filter_list),
      );
      expect(iconButton.tooltip, 'Filter conditions');
    });

    testWidgets('renders FAB for adding conditions', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no conditions', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No conditions yet'), findsOneWidget);
    });

    testWidgets('renders condition name and category when data present', (
      tester,
    ) async {
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Eczema'), findsOneWidget);
      expect(find.text('Skin'), findsOneWidget);
    });

    testWidgets('separates active and resolved conditions into sections', (
      tester,
    ) async {
      final activeCondition = createTestCondition(id: 'active-001');
      final resolvedCondition = createTestCondition(
        id: 'resolved-001',
        name: 'Rash',
        status: ConditionStatus.resolved,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(testProfileId).overrideWith(
              () => _MockConditionList([activeCondition, resolvedCondition]),
            ),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Active Conditions'), findsOneWidget);
      expect(find.text('Resolved Conditions'), findsOneWidget);
      expect(find.text('Eczema'), findsOneWidget);
      expect(find.text('Rash'), findsOneWidget);
    });

    testWidgets('section headers have header semantics', (tester) async {
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final headerFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.header ?? false),
      );
      expect(headerFinder, findsWidgets);
    });

    testWidgets('condition card has more options menu', (tester) async {
      final condition = createTestCondition();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              testProfileId,
            ).overrideWith(() => _MockConditionList([condition])),
          ],
          child: const MaterialApp(
            home: ConditionListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    group('list display', () {
      testWidgets('displays body locations on condition card', (tester) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Arms, Hands'), findsOneWidget);
      });

      testWidgets('shows photo indicator for condition with baseline photo', (
        tester,
      ) async {
        final condition = createTestCondition(
          baselinePhotoPath: '/path/to/photo.jpg',
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.photo_camera), findsOneWidget);
      });

      testWidgets('hides photo indicator when no baseline photo', (
        tester,
      ) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.photo_camera), findsNothing);
      });

      testWidgets('shows medical services icon on condition card', (
        tester,
      ) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.medical_services), findsOneWidget);
      });

      testWidgets('archived condition name has strikethrough', (tester) async {
        final archivedCondition = createTestCondition(
          isArchived: true,
          status: ConditionStatus.resolved,
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([archivedCondition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final nameWidget = tester.widget<Text>(find.text('Eczema'));
        expect(nameWidget.style?.decoration, TextDecoration.lineThrough);
      });
    });

    group('popup menu', () {
      testWidgets('shows Edit and Archive options', (tester) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Archive'), findsOneWidget);
      });

      testWidgets('shows Unarchive for archived conditions', (tester) async {
        final archivedCondition = createTestCondition(
          isArchived: true,
          status: ConditionStatus.resolved,
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([archivedCondition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Unarchive'), findsOneWidget);
      });
    });

    group('loading and error states', () {
      testWidgets('error state renders with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(_ErrorConditionList.new),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Failed to load conditions'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });

    group('filter bottom sheet', () {
      testWidgets('filter button opens bottom sheet', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        expect(find.text('Filter Conditions'), findsOneWidget);
        expect(find.text('Active only'), findsOneWidget);
        expect(find.text('Show archived'), findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('tapping FAB navigates to add screen', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Add Condition'), findsOneWidget);
      });

      testWidgets('tapping condition card navigates to edit screen', (
        tester,
      ) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ShadowCard));
        await tester.pumpAndSettle();

        expect(find.text('Edit Condition'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label Add new condition', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Add new condition'), findsOneWidget);
      });

      testWidgets('condition list body has semantic label Condition list', (
        tester,
      ) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Condition list',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('condition card has semantic label with name and category', (
        tester,
      ) async {
        final condition = createTestCondition();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final cardFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Eczema') ?? false),
        );
        expect(cardFinder, findsWidgets);
      });

      testWidgets('photo indicator has semantic label', (tester) async {
        final condition = createTestCondition(
          baselinePhotoPath: '/path/to/photo.jpg',
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([condition])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Has baseline photo',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('empty state is accessible', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(
                testProfileId,
              ).overrideWith(() => _MockConditionList([])),
            ],
            child: const MaterialApp(
              home: ConditionListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No conditions yet'), findsOneWidget);
        expect(
          find.text('Tap the + button to add your first condition'),
          findsOneWidget,
        );
      });
    });
  });
}

/// Mock ConditionList notifier for testing.
class _MockConditionList extends ConditionList {
  final List<Condition> _conditions;
  _MockConditionList(this._conditions);
  @override
  Future<List<Condition>> build(String profileId) async => _conditions;
}

/// Mock notifier that simulates an error.
class _ErrorConditionList extends ConditionList {
  @override
  Future<List<Condition>> build(String profileId) async {
    throw Exception('Failed to load conditions');
  }
}
