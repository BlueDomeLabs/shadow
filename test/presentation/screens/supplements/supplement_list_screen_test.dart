// test/presentation/screens/supplements/supplement_list_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_list_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

void main() {
  group('SupplementListScreen', () {
    const testProfileId = 'profile-001';

    Supplement createTestSupplement({
      String id = 'supp-001',
      String name = 'Vitamin D3',
      SupplementForm form = SupplementForm.capsule,
      bool isArchived = false,
      String brand = 'NOW Foods',
    }) => Supplement(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      form: form,
      dosageQuantity: 2000,
      dosageUnit: DosageUnit.iu,
      brand: brand,
      isArchived: isArchived,
      syncMetadata: SyncMetadata.empty(),
    );

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Supplements'), findsOneWidget);
    });

    testWidgets('renders filter button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('renders FAB for adding supplements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no supplements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No supplements yet'), findsOneWidget);
    });

    testWidgets('renders supplement when data available', (tester) async {
      final supplement = createTestSupplement();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([supplement])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vitamin D3'), findsOneWidget);
      expect(find.text('NOW Foods'), findsOneWidget);
    });

    testWidgets('renders Active Supplements header', (tester) async {
      final supplement = createTestSupplement();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([supplement])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Active Supplements'), findsOneWidget);
    });

    testWidgets('renders Archived header when archived supplements exist', (
      tester,
    ) async {
      final archivedSupplement = createTestSupplement(
        id: 'arch-001',
        name: 'Old Vitamin',
        isArchived: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([archivedSupplement])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Archived'), findsOneWidget);
    });

    testWidgets('supplement card has more options menu', (tester) async {
      final supplement = createTestSupplement();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supplementListProvider(
              testProfileId,
            ).overrideWith(() => _MockSupplementList([supplement])),
          ],
          child: const MaterialApp(
            home: SupplementListScreen(profileId: testProfileId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    group('loading and error states', () {
      testWidgets('shows error state with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(_ErrorSupplementList.new),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Failed to load supplements'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });

    group('list display', () {
      testWidgets('renders both active and archived sections', (tester) async {
        final activeSupplement = createTestSupplement(id: 'active-001');
        final archivedSupplement = createTestSupplement(
          id: 'archived-001',
          name: 'Old Vitamin',
          isArchived: true,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(testProfileId).overrideWith(
                () =>
                    _MockSupplementList([activeSupplement, archivedSupplement]),
              ),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Active Supplements'), findsOneWidget);
        expect(find.text('Archived'), findsOneWidget);
        expect(find.text('Vitamin D3'), findsOneWidget);
        expect(find.text('Old Vitamin'), findsOneWidget);
      });

      testWidgets('displays dosage information', (tester) async {
        final supplement = createTestSupplement();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([supplement])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should show dosage from displayDosage getter
        expect(find.textContaining('2000'), findsOneWidget);
      });

      testWidgets('shows correct icon for each supplement form', (
        tester,
      ) async {
        final capsule = createTestSupplement(id: '1');
        final powder = createTestSupplement(
          id: '2',
          form: SupplementForm.powder,
        );
        final liquid = createTestSupplement(
          id: '3',
          form: SupplementForm.liquid,
        );
        final tablet = createTestSupplement(
          id: '4',
          form: SupplementForm.tablet,
        );
        final gummy = createTestSupplement(id: '5', form: SupplementForm.gummy);
        final spray = createTestSupplement(id: '6', form: SupplementForm.spray);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(testProfileId).overrideWith(
                () => _MockSupplementList([
                  capsule,
                  powder,
                  liquid,
                  tablet,
                  gummy,
                  spray,
                ]),
              ),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify form icons are present
        expect(find.byIcon(Icons.medication), findsOneWidget); // capsule
        expect(find.byIcon(Icons.grain), findsOneWidget); // powder
        expect(find.byIcon(Icons.water_drop), findsOneWidget); // liquid
        expect(find.byIcon(Icons.circle), findsOneWidget); // tablet
        expect(find.byIcon(Icons.cookie_outlined), findsOneWidget); // gummy
        expect(find.byIcon(Icons.air), findsOneWidget); // spray
      });
    });

    group('popup menu', () {
      testWidgets('shows Edit, Log Intake, and Archive options', (
        tester,
      ) async {
        final supplement = createTestSupplement();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([supplement])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the more options button
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Log Intake'), findsOneWidget);
        expect(find.text('Archive'), findsOneWidget);
      });

      testWidgets('shows Unarchive for archived supplements', (tester) async {
        final archivedSupplement = createTestSupplement(isArchived: true);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([archivedSupplement])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();

        expect(find.text('Unarchive'), findsOneWidget);
      });
    });

    group('filter bottom sheet', () {
      testWidgets('filter button opens bottom sheet', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();

        expect(find.text('Filter Supplements'), findsOneWidget);
        expect(find.text('Active only'), findsOneWidget);
        expect(find.text('Show archived'), findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('tapping FAB navigates to add screen', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();

        expect(find.text('Add Supplement'), findsOneWidget);
      });

      testWidgets('tapping supplement card navigates to edit screen', (
        tester,
      ) async {
        final supplement = createTestSupplement();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([supplement])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the ShadowCard
        await tester.tap(find.byType(ShadowCard));
        await tester.pumpAndSettle();

        expect(find.text('Edit Supplement'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Add new supplement'), findsOneWidget);
      });

      testWidgets('supplement list body has semantic label', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify the body has semantic labeling
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Supplement list',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('section headers have header semantics', (tester) async {
        final supplement = createTestSupplement();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([supplement])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify section header exists with header semantics
        final headerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.header ?? false),
        );
        expect(headerFinder, findsWidgets);
      });

      testWidgets('supplement card has semantic label with name and dosage', (
        tester,
      ) async {
        final supplement = createTestSupplement();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([supplement])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The card should have semantic label containing name and dosage
        final cardFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.contains('Vitamin D3') ?? false),
        );
        expect(cardFinder, findsWidgets);
      });

      testWidgets('filter button has tooltip', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final iconButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.filter_list),
        );
        expect(iconButton.tooltip, 'Filter supplements');
      });

      testWidgets('empty state is accessible', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              supplementListProvider(
                testProfileId,
              ).overrideWith(() => _MockSupplementList([])),
            ],
            child: const MaterialApp(
              home: SupplementListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No supplements yet'), findsOneWidget);
        expect(
          find.text('Tap the + button to add your first supplement'),
          findsOneWidget,
        );
      });
    });
  });
}

/// Mock SupplementList notifier for testing.
class _MockSupplementList extends SupplementList {
  final List<Supplement> _supplements;

  _MockSupplementList(this._supplements);

  @override
  Future<List<Supplement>> build(String profileId) async => _supplements;
}

/// Mock notifier that simulates an error.
class _ErrorSupplementList extends SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    throw Exception('Failed to load supplements');
  }
}
