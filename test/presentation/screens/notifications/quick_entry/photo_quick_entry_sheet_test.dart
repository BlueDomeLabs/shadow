// test/presentation/screens/notifications/quick_entry/photo_quick_entry_sheet_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/photo_quick_entry_sheet.dart';

void main() {
  group('PhotoQuickEntrySheet', () {
    const profileId = 'profile-001';

    PhotoArea createTestArea({
      String id = 'area-001',
      String name = 'Forearm',
      String? description,
      int sortOrder = 0,
    }) => PhotoArea(
      id: id,
      clientId: 'client-001',
      profileId: profileId,
      name: name,
      description: description,
      sortOrder: sortOrder,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildSheet({
      List<PhotoArea> areas = const [],
      void Function(PhotoArea)? onAreaSelected,
    }) => ProviderScope(
      overrides: [
        photoAreaListProvider(
          profileId,
        ).overrideWith(() => _MockPhotoAreaList(areas)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: PhotoQuickEntrySheet(
            profileId: profileId,
            onAreaSelected: onAreaSelected,
          ),
        ),
      ),
    );

    testWidgets('renders Photo Check-in title', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Photo Check-in'), findsOneWidget);
    });

    testWidgets('shows no photo areas message when empty', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.textContaining('No photo areas defined yet'), findsOneWidget);
    });

    testWidgets('renders Dismiss button when no photo areas', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Dismiss'), findsOneWidget);
    });

    testWidgets('renders photo area names when areas defined', (tester) async {
      await tester.pumpWidget(buildSheet(areas: [createTestArea()]));
      await tester.pumpAndSettle();

      expect(find.text('Forearm'), findsOneWidget);
    });

    testWidgets('renders camera icon for each photo area', (tester) async {
      await tester.pumpWidget(buildSheet(areas: [createTestArea()]));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets('renders area description when present', (tester) async {
      await tester.pumpWidget(
        buildSheet(areas: [createTestArea(description: 'Inner forearm')]),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inner forearm'), findsOneWidget);
    });

    testWidgets('calls onAreaSelected when area tapped', (tester) async {
      PhotoArea? selected;
      final area = createTestArea();
      await tester.pumpWidget(
        buildSheet(areas: [area], onAreaSelected: (a) => selected = a),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forearm'));
      await tester.pump();

      expect(selected, equals(area));
    });

    testWidgets('sorts areas by sortOrder', (tester) async {
      await tester.pumpWidget(
        buildSheet(
          areas: [
            createTestArea(id: 'area-002', name: 'Back', sortOrder: 2),
            createTestArea(sortOrder: 1),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final forearmPos = tester.getTopLeft(find.text('Forearm')).dy;
      final backPos = tester.getTopLeft(find.text('Back')).dy;
      expect(forearmPos, lessThan(backPos));
    });

    testWidgets('sheet has correct semantic label', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.properties.label == 'Photo check-in quick-entry sheet',
        ),
        findsOneWidget,
      );
    });
  });
}

class _MockPhotoAreaList extends PhotoAreaList {
  final List<PhotoArea> _items;
  _MockPhotoAreaList(this._items);

  @override
  Future<List<PhotoArea>> build(String profileId) async => _items;
}
