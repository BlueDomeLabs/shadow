// test/unit/data/services/report_export_service_impl_test.dart
// Unit tests for ReportExportServiceImpl — Phase 25

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/data/services/report_export_service_impl.dart';
import 'package:shadow_app/domain/reports/report_data_service.dart';
import 'package:shadow_app/domain/reports/report_types.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ReportRow _makeRow({
  String category = 'Food Log',
  String title = 'Breakfast',
  String details = 'Items: 1',
  int timestampMs = 1_000_000,
}) => ReportRow(
  timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMs),
  category: category,
  title: title,
  details: details,
);

// Returns a [ReportExportServiceImpl] that writes to [Directory.systemTemp].
ReportExportServiceImpl _makeService() =>
    ReportExportServiceImpl(getDirectory: () async => Directory.systemTemp);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // exportActivityCsv
  // -------------------------------------------------------------------------

  group('exportActivityCsv', () {
    test('produces correct header row', () async {
      final sut = _makeService();
      final file = await sut.exportActivityCsv(profileId: 'p1', rows: []);
      final lines = await file.readAsLines();

      expect(lines.first, 'Date,Time,Category,Title,Details');
    });

    test('row count matches input rows', () async {
      final sut = _makeService();
      final rows = [
        _makeRow(),
        _makeRow(title: 'Lunch'),
        _makeRow(title: 'Dinner'),
      ];
      final file = await sut.exportActivityCsv(profileId: 'p1', rows: rows);
      final lines = (await file.readAsLines())
          .where((l) => l.isNotEmpty)
          .toList();

      // 1 header + 3 data rows
      expect(lines.length, 4);
    });

    test('escapes double-quotes in fields', () async {
      final sut = _makeService();
      final rows = [_makeRow(title: 'Say "hello"')];
      final file = await sut.exportActivityCsv(profileId: 'p1', rows: rows);
      final content = await file.readAsString();

      expect(content, contains('Say ""hello""'));
    });

    test('file is created on disk', () async {
      final sut = _makeService();
      final file = await sut.exportActivityCsv(profileId: 'p1', rows: []);

      expect(await file.exists(), isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // exportReferenceCsv
  // -------------------------------------------------------------------------

  group('exportReferenceCsv', () {
    test('produces correct header row', () async {
      final sut = _makeService();
      final file = await sut.exportReferenceCsv(profileId: 'p1', data: {});
      final lines = await file.readAsLines();

      expect(lines.first, 'Category,Title,Details');
    });

    test('produces correct structure with two categories', () async {
      final sut = _makeService();
      final data = {
        ReferenceCategory.foodLibrary: [
          _makeRow(category: 'Food Library', title: 'Chicken'),
        ],
        ReferenceCategory.supplementLibrary: [
          _makeRow(category: 'Supplement Library', title: 'Vitamin D'),
          _makeRow(category: 'Supplement Library', title: 'Magnesium'),
        ],
      };
      final file = await sut.exportReferenceCsv(profileId: 'p1', data: data);
      final lines = (await file.readAsLines())
          .where((l) => l.isNotEmpty)
          .toList();

      // 1 header + 1 food + 2 supplement rows
      expect(lines.length, 4);
      expect(lines[1], contains('Food Library'));
      expect(lines[2], contains('Supplement Library'));
    });

    test('file is created on disk', () async {
      final sut = _makeService();
      final file = await sut.exportReferenceCsv(profileId: 'p1', data: {});

      expect(await file.exists(), isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // exportActivityPdf
  // -------------------------------------------------------------------------

  group('exportActivityPdf', () {
    test('file is created on disk', () async {
      final sut = _makeService();
      final file = await sut.exportActivityPdf(
        profileId: 'p1',
        profileName: 'Alice',
        rows: [_makeRow()],
        categories: {ActivityCategory.foodLogs},
      );

      expect(await file.exists(), isTrue);
    });

    test('empty rows still produces a file', () async {
      final sut = _makeService();
      final file = await sut.exportActivityPdf(
        profileId: 'p1',
        profileName: 'Alice',
        rows: [],
        categories: {ActivityCategory.sleep},
      );

      expect(await file.exists(), isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // exportReferencePdf
  // -------------------------------------------------------------------------

  group('exportReferencePdf', () {
    test('file is created on disk', () async {
      final sut = _makeService();
      final file = await sut.exportReferencePdf(
        profileId: 'p1',
        profileName: 'Alice',
        data: {
          ReferenceCategory.foodLibrary: [_makeRow(title: 'Chicken')],
        },
      );

      expect(await file.exists(), isTrue);
    });

    test('empty data still produces a file', () async {
      final sut = _makeService();
      final file = await sut.exportReferencePdf(
        profileId: 'p1',
        profileName: 'Alice',
        data: {},
      );

      expect(await file.exists(), isTrue);
    });
  });
}
