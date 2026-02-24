// lib/data/datasources/local/tables/supplement_label_photos_table.dart
// Phase 15a — Drift table for supplement_label_photos
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:drift/drift.dart';

/// Table for supplement label photos stored locally.
///
/// Up to 3 photos per supplement for visual documentation.
/// Not synced to Google Drive (too large).
/// Per 60_SUPPLEMENT_EXTENSION.md.
@DataClassName('SupplementLabelPhotoRow')
class SupplementLabelPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get supplementId => text().named('supplement_id')();
  TextColumn get filePath => text().named('file_path')();
  IntColumn get capturedAt => integer().named('captured_at')(); // Epoch ms
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'supplement_label_photos';
}
