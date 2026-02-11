// test/presentation/screens/photo_entries/photo_entry_gallery_screen_test.dart
// Tests for PhotoEntryGalleryScreen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/photo_entries/photo_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/photo_entries/photo_entry_gallery_screen.dart';

void main() {
  group('PhotoEntryGalleryScreen', () {
    const testProfileId = 'profile-001';
    const testAreaId = 'area-001';

    final testPhotoArea = PhotoArea(
      id: testAreaId,
      clientId: 'client-001',
      profileId: testProfileId,
      name: 'Left Arm',
      description: 'Inner forearm',
      consistencyNotes: 'Hold at 45 degrees',
      syncMetadata: SyncMetadata.empty(),
    );

    PhotoEntry createTestEntry({
      String id = 'entry-001',
      String photoAreaId = testAreaId,
      String filePath = '/tmp/test.jpg',
      int? timestamp,
    }) => PhotoEntry(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      photoAreaId: photoAreaId,
      timestamp: timestamp ?? DateTime(2024, 1, 15).millisecondsSinceEpoch,
      filePath: filePath,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildScreen([List<PhotoEntry> entries = const []]) => ProviderScope(
      overrides: [
        photoEntryListProvider(
          testProfileId,
        ).overrideWith(() => _MockPhotoEntryList(entries)),
      ],
      child: MaterialApp(
        home: PhotoEntryGalleryScreen(
          profileId: testProfileId,
          photoArea: testPhotoArea,
        ),
      ),
    );

    testWidgets('renders app bar with area name', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Left Arm'), findsOneWidget);
    });

    testWidgets('renders info button for consistency notes', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('renders FAB with camera icon', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
    });

    testWidgets('renders empty state when no photos', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('No photos yet'), findsOneWidget);
    });

    testWidgets('renders grid when photos present', (tester) async {
      final entry = createTestEntry();
      await tester.pumpWidget(buildScreen([entry]));
      await tester.pumpAndSettle();
      // Should find a GridView
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('filters photos by area', (tester) async {
      final matchingEntry = createTestEntry();
      final otherEntry = createTestEntry(
        id: 'entry-002',
        photoAreaId: 'other-area',
      );
      await tester.pumpWidget(buildScreen([matchingEntry, otherEntry]));
      await tester.pumpAndSettle();
      // Grid should exist (at least one photo matches)
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('shows consistency notes dialog when info tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();
      expect(find.text('Photo Tips'), findsOneWidget);
      expect(find.text('Hold at 45 degrees'), findsOneWidget);
    });

    group('accessibility', () {
      testWidgets('FAB has semantic label Add new photo', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel('Add new photo'), findsOneWidget);
      });

      testWidgets('body has semantic label with area name', (tester) async {
        await tester.pumpWidget(buildScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Photo gallery for Left Arm',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('loading and error states', () {
      testWidgets('error state renders with retry button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              photoEntryListProvider(
                testProfileId,
              ).overrideWith(_ErrorPhotoEntryList.new),
            ],
            child: MaterialApp(
              home: PhotoEntryGalleryScreen(
                profileId: testProfileId,
                photoArea: testPhotoArea,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Failed to load photos'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      });
    });
  });
}

class _MockPhotoEntryList extends PhotoEntryList {
  final List<PhotoEntry> _entries;
  _MockPhotoEntryList(this._entries);
  @override
  Future<List<PhotoEntry>> build(String profileId) async => _entries;
}

class _ErrorPhotoEntryList extends PhotoEntryList {
  @override
  Future<List<PhotoEntry>> build(String profileId) async {
    throw Exception('Failed to load photos');
  }
}
