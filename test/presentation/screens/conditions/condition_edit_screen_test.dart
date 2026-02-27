// test/presentation/screens/conditions/condition_edit_screen_test.dart
// Tests for ConditionEditScreen per 38_UI_FIELD_SPECIFICATIONS.md Section 8.1
// and accessibility requirements from Section 18.7.
//
// NOTE: condition_edit_screen.dart is a PLACEHOLDER (1 line) as of writing.
// Tests are written based on what the SPEC says the implementation SHOULD have.
// The implementation team has the same spec.
//
// SPEC CONFLICT (documented for 53_SPEC_CLARIFICATIONS.md):
// Section 8.1 says Category is REQUIRED (Yes), but Section 18.7 says
// the semantic label is "Condition category, optional". Tests use the
// semantic label from Section 18.7 but validate that Category is a
// required field per Section 8.1. Implementation team should clarify.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/conditions/conditions_usecases.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/condition_edit_screen.dart';

void main() {
  group('ConditionEditScreen', () {
    const testProfileId = 'profile-001';

    Condition createTestCondition({
      String id = 'cond-001',
      String name = 'Eczema',
      String category = 'Skin',
      List<String> bodyLocations = const ['Arms', 'Hands'],
      String? description,
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
      description: description,
      startTimeframe: 1706745600000, // epoch ms
      status: status,
      isArchived: isArchived,
      baselinePhotoPath: baselinePhotoPath,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        conditionListProvider(
          testProfileId,
        ).overrideWith(() => _MockConditionList([])),
      ],
      child: const MaterialApp(
        home: ConditionEditScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(Condition condition) => ProviderScope(
      overrides: [
        conditionListProvider(
          testProfileId,
        ).overrideWith(() => _MockConditionList([condition])),
      ],
      child: MaterialApp(
        home: ConditionEditScreen(
          profileId: testProfileId,
          condition: condition,
        ),
      ),
    );

    /// Scrolls the form ListView down to make bottom widgets visible.
    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    group('add mode', () {
      testWidgets('renders Add Condition title in add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Add Condition'), findsOneWidget);
      });

      testWidgets('renders all form fields per spec Section 8.1', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        // Spec Section 8.1 fields:
        // Condition Name (required, text)
        expect(find.text('Condition Name'), findsOneWidget);
        // Category (required, dropdown)
        expect(find.text('Category'), findsOneWidget);
        // Body Locations (required, multi-select)
        expect(find.text('Body Locations'), findsOneWidget);
        // Description (optional, text area)
        expect(find.text('Description'), findsOneWidget);
        // Scroll to see remaining fields
        await scrollToBottom(tester);
        // Start Timeframe (required, dropdown)
        expect(find.text('Start Timeframe'), findsOneWidget);
        // Status (required, segment Active/Resolved)
        expect(find.text('Active'), findsOneWidget);
        expect(find.text('Resolved'), findsOneWidget);
        // Baseline Photo (optional, image picker) - rendered as button text
        expect(find.text('Add baseline photo'), findsOneWidget);
      });

      testWidgets('renders Save and Cancel buttons', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('renders section headers', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        // Basic Information is at top
        expect(find.text('Basic Information'), findsOneWidget);
        // Details and Photo are further down
        await scrollToBottom(tester);
        expect(find.text('Details'), findsOneWidget);
        expect(find.text('Photo'), findsOneWidget);
      });
    });

    group('accessibility', () {
      // Section 18.7 semantic labels
      testWidgets('condition name has semantic label per Section 18.7', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Condition name, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('category has semantic label per Section 18.7', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        // NOTE: Spec conflict - Section 8.1 says required, Section 18.7
        // says "Condition category, optional". Using Section 18.7 label.
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Condition category, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('baseline photo has semantic label per Section 18.7', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label ==
                  'Baseline photo for comparison, optional',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('body location chips', () {
      testWidgets('body location chips are shown', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        // Per spec Section 8.1, body location options:
        // Head, Face, Neck, Chest, Back, Stomach, Arms, Hands,
        // Legs, Feet, Joints, Internal, Whole Body, Other
        //
        // These should be displayed as selectable chips
        expect(find.text('Head'), findsOneWidget);
        expect(find.text('Face'), findsOneWidget);
        expect(find.text('Neck'), findsOneWidget);
        expect(find.text('Chest'), findsOneWidget);
        expect(find.text('Back'), findsOneWidget);
        expect(find.text('Stomach'), findsOneWidget);
        expect(find.text('Arms'), findsOneWidget);
        expect(find.text('Hands'), findsOneWidget);
        expect(find.text('Legs'), findsOneWidget);
        expect(find.text('Feet'), findsOneWidget);
        expect(find.text('Joints'), findsOneWidget);
        expect(find.text('Internal'), findsOneWidget);
        expect(find.text('Whole Body'), findsOneWidget);
        expect(find.text('Other'), findsOneWidget);
      });
    });

    group('category dropdown', () {
      testWidgets('category dropdown has all 7 options from spec', (
        tester,
      ) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();

        // Open the category dropdown
        await tester.tap(find.text('Category'));
        await tester.pumpAndSettle();

        // Per spec Section 8.1: Skin/Digestive/Respiratory/Autoimmune/
        // Mental Health/Pain/Other
        expect(find.text('Skin'), findsWidgets);
        expect(find.text('Digestive'), findsOneWidget);
        expect(find.text('Respiratory'), findsOneWidget);
        expect(find.text('Autoimmune'), findsOneWidget);
        expect(find.text('Mental Health'), findsOneWidget);
        expect(find.text('Pain'), findsOneWidget);
        // 'Other' may appear multiple times (body locations + category)
        expect(find.text('Other'), findsWidgets);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Condition title in edit mode', (tester) async {
        final condition = createTestCondition();
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        expect(find.text('Edit Condition'), findsOneWidget);
      });

      testWidgets('populates name field from condition', (tester) async {
        final condition = createTestCondition(name: 'Psoriasis');
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        expect(find.text('Psoriasis'), findsOneWidget);
      });

      testWidgets('populates category from condition', (tester) async {
        final condition = createTestCondition(category: 'Digestive');
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        // Category dropdown shows the selected value
        expect(find.text('Digestive'), findsOneWidget);
      });

      testWidgets('populates body locations from condition', (tester) async {
        final condition = createTestCondition(
          bodyLocations: const ['Arms', 'Legs'],
        );
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        // Arms and Legs chips should be selected (FilterChip selected state)
        final armsChip = tester.widget<FilterChip>(
          find.widgetWithText(FilterChip, 'Arms'),
        );
        expect(armsChip.selected, isTrue);
        final legsChip = tester.widget<FilterChip>(
          find.widgetWithText(FilterChip, 'Legs'),
        );
        expect(legsChip.selected, isTrue);
        // Head should NOT be selected
        final headChip = tester.widget<FilterChip>(
          find.widgetWithText(FilterChip, 'Head'),
        );
        expect(headChip.selected, isFalse);
      });

      testWidgets('populates description from condition', (tester) async {
        final condition = createTestCondition(
          description: 'Flares up in winter',
        );
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        expect(find.text('Flares up in winter'), findsOneWidget);
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final condition = createTestCondition();
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('body has edit mode semantic label', (tester) async {
        final condition = createTestCondition();
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit condition form',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('populates status from condition', (tester) async {
        final condition = createTestCondition(status: ConditionStatus.resolved);
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        // Resolved should be selected in the SegmentedButton
        final segmented = tester.widget<SegmentedButton<ConditionStatus>>(
          find.byType(SegmentedButton<ConditionStatus>),
        );
        expect(segmented.selected, contains(ConditionStatus.resolved));
      });
    });

    group('photo', () {
      testWidgets('photo button renders in add mode', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Add baseline photo'), findsOneWidget);
      });

      testWidgets('button label changes to Change when photo path set', (
        tester,
      ) async {
        final condition = createTestCondition(
          baselinePhotoPath: '/fake/path/photo.jpg',
        );
        await tester.pumpWidget(buildEditScreen(condition));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        // Button label changes to 'Change baseline photo' when photo is set
        expect(find.text('Change baseline photo'), findsOneWidget);
        // 'Add baseline photo' is no longer shown
        expect(find.text('Add baseline photo'), findsNothing);
      });

      testWidgets('save includes baselinePhotoPath (null) in create mode', (
        tester,
      ) async {
        final mock = _CapturingConditionList([]);
        // Build add screen — no photo selected, baselinePhotoPath should be null.
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(testProfileId).overrideWith(() => mock),
            ],
            child: const MaterialApp(
              home: ConditionEditScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Fill required fields
        await tester.enterText(find.byType(TextField).first, 'Eczema');
        await tester.pumpAndSettle();

        // Select Category
        await tester.tap(find.text('Category'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Skin').last);
        await tester.pumpAndSettle();

        // Select Body Location
        await tester.tap(find.text('Arms'));
        await tester.pumpAndSettle();

        // Select Start Timeframe
        await scrollToBottom(tester);
        await tester.tap(find.text('Start Timeframe'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('This year').last);
        await tester.pumpAndSettle();

        // The condition_edit_screen initializes _baselinePhotoPath from
        // widget.condition?.baselinePhotoPath. Since this is add mode with
        // no condition, we test that null is passed (no photo).
        await scrollToBottom(tester);
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(mock.lastCreate?.baselinePhotoPath, isNull);
      });

      testWidgets('save includes baselinePhotoPath when condition has photo', (
        tester,
      ) async {
        // Edit mode: condition already has a photo path.
        // Verify baselinePhotoPath is passed through in UpdateConditionInput.
        final mock = _CapturingConditionList([]);
        final condition = createTestCondition(
          baselinePhotoPath: '/existing/photo.jpg',
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              conditionListProvider(testProfileId).overrideWith(() => mock),
            ],
            child: MaterialApp(
              home: ConditionEditScreen(
                profileId: testProfileId,
                condition: condition,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        // Scroll twice to reach Save Changes (photo thumbnail makes form taller)
        await scrollToBottom(tester);
        await scrollToBottom(tester);
        await tester.tap(find.text('Save Changes'));
        await tester.pump();

        // baselinePhotoPath is now wired into UpdateConditionInput
        expect(mock.lastUpdate?.baselinePhotoPath, '/existing/photo.jpg');
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

/// Capturing mock that records the last create/update input.
class _CapturingConditionList extends ConditionList {
  final List<Condition> _conditions;
  _CapturingConditionList(this._conditions);

  CreateConditionInput? lastCreate;
  UpdateConditionInput? lastUpdate;

  @override
  Future<List<Condition>> build(String profileId) async => _conditions;

  @override
  Future<void> create(CreateConditionInput input) async {
    lastCreate = input;
  }

  @override
  Future<void> updateCondition(UpdateConditionInput input) async {
    lastUpdate = input;
  }
}
