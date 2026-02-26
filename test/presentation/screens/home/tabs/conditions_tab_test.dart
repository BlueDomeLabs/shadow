// test/presentation/screens/home/tabs/conditions_tab_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/providers/flare_ups/flare_up_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/flare_up_list_screen.dart';
import 'package:shadow_app/presentation/screens/home/tabs/conditions_tab.dart';

void main() {
  group('ConditionsTab', () {
    Widget buildTab({String? profileName}) => ProviderScope(
      child: MaterialApp(
        home: ConditionsTab(
          profileId: 'test-profile-001',
          profileName: profileName,
        ),
      ),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Conditions'), findsWidgets);
    });

    testWidgets('shows profile name in title when provided', (tester) async {
      await tester.pumpWidget(buildTab(profileName: 'Alice'));
      await tester.pump();

      expect(find.text("Alice's Conditions"), findsOneWidget);
    });

    testWidgets('renders flare-ups button', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.text('Flare-Ups'), findsOneWidget);
    });

    testWidgets('renders FAB for adding conditions', (tester) async {
      await tester.pumpWidget(buildTab());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Flare-Ups button navigates to FlareUpListScreen', (
      tester,
    ) async {
      const profileId = 'test-profile-001';
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            conditionListProvider(
              profileId,
            ).overrideWith(() => _MockConditionList([])),
            flareUpListProvider(
              profileId,
            ).overrideWith(() => _MockFlareUpList([])),
          ],
          child: const MaterialApp(home: ConditionsTab(profileId: profileId)),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flare-Ups'));
      await tester.pumpAndSettle();

      expect(find.byType(FlareUpListScreen), findsOneWidget);
    });
  });
}

// ── Mock Notifiers ────────────────────────────────────────────────────────────

class _MockConditionList extends ConditionList {
  final List<Condition> _conditions;
  _MockConditionList(this._conditions);
  @override
  Future<List<Condition>> build(String profileId) async => _conditions;
}

class _MockFlareUpList extends FlareUpList {
  final List<FlareUp> _items;
  _MockFlareUpList(this._items);
  @override
  Future<List<FlareUp>> build(String profileId) async => _items;
}
