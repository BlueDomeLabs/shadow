// test/presentation/screens/notifications/quick_entry/condition_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/usecases/condition_logs/condition_log_inputs.dart';
import 'package:shadow_app/presentation/providers/condition_logs/condition_log_list_provider.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/condition_quick_entry_sheet.dart';

void main() {
  group('ConditionQuickEntrySheet', () {
    const profileId = 'profile-001';

    Condition createTestCondition({
      String id = 'cond-001',
      String name = 'Eczema',
    }) => Condition(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      name: name,
      category: 'Skin',
      bodyLocations: ['arm'],
      startTimeframe: 0,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildSheet({
      List<Condition> conditions = const [],
      ConditionLogList Function(String conditionId)? logMockFactory,
    }) {
      final overrides = <Override>[
        conditionListProvider(
          profileId,
        ).overrideWith(() => _MockConditionList(conditions)),
        for (final c in conditions)
          conditionLogListProvider(profileId, c.id).overrideWith(
            () => logMockFactory?.call(c.id) ?? _MockConditionLogList(),
          ),
      ];
      return ProviderScope(
        overrides: overrides,
        child: const MaterialApp(
          home: Scaffold(body: ConditionQuickEntrySheet(profileId: profileId)),
        ),
      );
    }

    testWidgets('renders Condition Check-in title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Condition Check-in'), findsOneWidget);
    });

    testWidgets('shows message when no active conditions', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('No active conditions to check in on.'), findsOneWidget);
    });

    testWidgets('renders severity slider for each active condition', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet(conditions: [createTestCondition()]));
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('renders condition name', (tester) async {
      await tester.pumpWidget(buildSheet(conditions: [createTestCondition()]));
      await tester.pumpAndSettle();

      expect(find.text('Eczema'), findsOneWidget);
    });

    testWidgets('renders Save Check-in button when conditions present', (
      tester,
    ) async {
      await tester.pumpWidget(buildSheet(conditions: [createTestCondition()]));
      await tester.pumpAndSettle();

      expect(find.text('Save Check-in'), findsOneWidget);
    });

    testWidgets('renders notes field when conditions present', (tester) async {
      await tester.pumpWidget(buildSheet(conditions: [createTestCondition()]));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls log for each active condition on save', (tester) async {
      final mock = _MockConditionLogList();
      await tester.pumpWidget(
        buildSheet(
          conditions: [createTestCondition()],
          logMockFactory: (_) => mock,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Check-in'));
      await tester.pump();

      expect(mock.logCalled, isTrue);
    });

    testWidgets('shows error snackbar on save failure', (tester) async {
      await tester.pumpWidget(
        buildSheet(
          conditions: [createTestCondition()],
          logMockFactory: (_) => _ErrorConditionLogList(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Check-in'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('sheet has correct semantic label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Condition check-in quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockConditionList extends ConditionList {
  final List<Condition> _items;
  _MockConditionList(this._items);

  @override
  Future<List<Condition>> build(String profileId) async => _items;
}

class _MockConditionLogList extends ConditionLogList {
  bool logCalled = false;
  LogConditionInput? lastInput;

  @override
  Future<List<ConditionLog>> build(
    String profileId,
    String conditionId,
  ) async => [];

  @override
  Future<void> log(LogConditionInput input) async {
    logCalled = true;
    lastInput = input;
  }
}

class _ErrorConditionLogList extends ConditionLogList {
  @override
  Future<List<ConditionLog>> build(
    String profileId,
    String conditionId,
  ) async => [];

  @override
  Future<void> log(LogConditionInput input) async {
    throw DatabaseError.insertFailed('condition_logs');
  }
}
