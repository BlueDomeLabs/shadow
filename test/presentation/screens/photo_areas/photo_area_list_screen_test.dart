// test/presentation/screens/photo_areas/photo_area_list_screen_test.dart
// Tests for PhotoAreaListScreen following ConditionListScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/screens/photo_areas/photo_area_list_screen.dart';

void main() {
  group('PhotoAreaListScreen', () {
    const testProfileId = 'profile-001';

    PhotoArea createTestArea({
      String id = 'area-001',
      String name = 'Left Arm',
      String? description,
      String? consistencyNotes,
      bool isArchived = false,
    }) => PhotoArea(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      description: description,
      consistencyNotes: consistencyNotes,
      isArchived: isArchived,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen([List<PhotoArea> areas = const []]) => ProviderScope(
      overrides: [
        photoAreaListProvider(
          testProfileId,
        ).overrideWith(() => _MockPhotoAreaList(areas)),
      ],
      child: const MaterialApp(
        home: PhotoAreaListScreen(profileId: testProfileId),
      ),
    );

    testWidgets('renders app bar with title Photo Areas', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Photo Areas'), findsOneWidget);
    });

    testWidgets('renders FAB for adding areas', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders empty state when no areas', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('No photo areas yet'), findsOneWidget);
    });

    testWidgets('renders area name when data present', (tester) async {
      final area = createTestArea();
      await tester.pumpWidget(buildScreen([area]));
      await tester.pumpAndSettle();
      expect(find.text('Left Arm'), findsOneWidget);
    });

    testWidgets('renders description when present', (tester) async {
      final area = createTestArea(description: 'Inner forearm area');
      await tester.pumpWidget(buildScreen([area]));
      await tester.pumpAndSettle();
      expect(find.text('Inner forearm area'), findsOneWidget);
    });

    testWidgets('separates active and archived areas into sections', (
      tester,
    ) async {
      final active = createTestArea();
      final archived = createTestArea(
        id: 'area-002',
        name: 'Right Arm',
        isArchived: true,
      );
      await tester.pumpWidget(buildScreen([active, archived]));
      await tester.pumpAndSettle();
      expect(find.text('Active Areas'), findsOneWidget);
      expect(find.text('Archived Areas'), findsOneWidget);
    });

    testWidgets('section headers have header semantics', (tester) async {
      final area = createTestArea();
      await tester.pumpWidget(buildScreen([area]));
      await tester.pumpAndSettle();
      final headerFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && (widget.properties.header ?? false),
      );
      expect(headerFinder, findsWidgets);
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label Add new photo area', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Add new photo area'), findsOneWidget);
      });

      testWidgets('body has semantic label Photo area list', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Photo area list',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('popup menu', () {
      testWidgets('shows Edit and Archive options', (tester) async {
        final area = createTestArea();
        await tester.pumpWidget(buildScreen([area]));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.more_vert));
        await tester.pumpAndSettle();
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Archive'), findsOneWidget);
      });

      testWidgets('shows Unarchive for archived areas', (tester) async {
        final archived = createTestArea(isArchived: true);
        await tester.pumpWidget(buildScreen([archived]));
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
              photoAreaListProvider(
                testProfileId,
              ).overrideWith(_ErrorPhotoAreaList.new),
            ],
            child: const MaterialApp(
              home: PhotoAreaListScreen(profileId: testProfileId),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Failed to load photo areas'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });
  });
}

class _MockPhotoAreaList extends PhotoAreaList {
  final List<PhotoArea> _areas;
  _MockPhotoAreaList(this._areas);
  @override
  Future<List<PhotoArea>> build(String profileId) async => _areas;
}

class _ErrorPhotoAreaList extends PhotoAreaList {
  @override
  Future<List<PhotoArea>> build(String profileId) async {
    throw Exception('Failed to load photo areas');
  }
}
