// test/presentation/screens/photo_areas/photo_area_edit_screen_test.dart
// Tests for PhotoAreaEditScreen following ConditionEditScreen test pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/screens/photo_areas/photo_area_edit_screen.dart';

void main() {
  group('PhotoAreaEditScreen', () {
    const testProfileId = 'profile-001';

    PhotoArea createTestArea({
      String id = 'area-001',
      String name = 'Left Arm',
      String? description,
      String? consistencyNotes,
    }) => PhotoArea(
      id: id,
      clientId: 'client-001',
      profileId: testProfileId,
      name: name,
      description: description,
      consistencyNotes: consistencyNotes,
      syncMetadata: SyncMetadata.empty(),
    );

    Widget buildAddScreen() => ProviderScope(
      overrides: [
        photoAreaListProvider(
          testProfileId,
        ).overrideWith(() => _MockPhotoAreaList([])),
      ],
      child: const MaterialApp(
        home: PhotoAreaEditScreen(profileId: testProfileId),
      ),
    );

    Widget buildEditScreen(PhotoArea area) => ProviderScope(
      overrides: [
        photoAreaListProvider(
          testProfileId,
        ).overrideWith(() => _MockPhotoAreaList([area])),
      ],
      child: MaterialApp(
        home: PhotoAreaEditScreen(profileId: testProfileId, photoArea: area),
      ),
    );

    Future<void> scrollToBottom(WidgetTester tester) async {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pumpAndSettle();
    }

    group('add mode', () {
      testWidgets('renders Add Photo Area title', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Add Photo Area'), findsOneWidget);
      });

      testWidgets('renders all form fields', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        expect(find.text('Area Name'), findsOneWidget);
        expect(find.text('Description'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Consistency Notes'), findsOneWidget);
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
        expect(find.text('Basic Information'), findsOneWidget);
        await scrollToBottom(tester);
        expect(find.text('Photo Guidance'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('area name has semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Photo area name, required',
        );
        expect(semanticsFinder, findsOneWidget);
      });

      testWidgets('body has form semantic label', (tester) async {
        await tester.pumpWidget(buildAddScreen());
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Add photo area form',
        );
        expect(semanticsFinder, findsOneWidget);
      });
    });

    group('edit mode', () {
      testWidgets('renders Edit Photo Area title', (tester) async {
        final area = createTestArea();
        await tester.pumpWidget(buildEditScreen(area));
        await tester.pumpAndSettle();
        expect(find.text('Edit Photo Area'), findsOneWidget);
      });

      testWidgets('populates name from area', (tester) async {
        final area = createTestArea(name: 'Face');
        await tester.pumpWidget(buildEditScreen(area));
        await tester.pumpAndSettle();
        expect(find.text('Face'), findsOneWidget);
      });

      testWidgets('populates description from area', (tester) async {
        final area = createTestArea(description: 'Left forearm');
        await tester.pumpWidget(buildEditScreen(area));
        await tester.pumpAndSettle();
        expect(find.text('Left forearm'), findsOneWidget);
      });

      testWidgets('populates consistency notes from area', (tester) async {
        final area = createTestArea(consistencyNotes: 'Hold at 45 degrees');
        await tester.pumpWidget(buildEditScreen(area));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Hold at 45 degrees'), findsOneWidget);
      });

      testWidgets('shows Save Changes button in edit mode', (tester) async {
        final area = createTestArea();
        await tester.pumpWidget(buildEditScreen(area));
        await tester.pumpAndSettle();
        await scrollToBottom(tester);
        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('body has edit mode semantic label', (tester) async {
        final area = createTestArea();
        await tester.pumpWidget(buildEditScreen(area));
        await tester.pumpAndSettle();
        final semanticsFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Edit photo area form',
        );
        expect(semanticsFinder, findsOneWidget);
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
