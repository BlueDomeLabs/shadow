// lib/data/datasources/local/daos/supplement_label_photo_dao.dart
// Phase 15a — DAO for supplement_label_photos table
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/supplement_label_photos_table.dart';
import 'package:shadow_app/domain/entities/supplement_label_photo.dart';

part 'supplement_label_photo_dao.g.dart';

/// Data Access Object for the supplement_label_photos table.
@DriftAccessor(tables: [SupplementLabelPhotos])
class SupplementLabelPhotoDao extends DatabaseAccessor<AppDatabase>
    with _$SupplementLabelPhotoDaoMixin {
  SupplementLabelPhotoDao(super.db);

  /// Get all photos for a supplement, ordered by sort_order.
  Future<Result<List<SupplementLabelPhoto>, AppError>> getForSupplement(
    String supplementId,
  ) async {
    try {
      final rows =
          await (select(supplementLabelPhotos)
                ..where((p) => p.supplementId.equals(supplementId))
                ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
              .get();
      return Success(rows.map(_rowToEntity).toList());
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed(
          'supplement_label_photos',
          e.toString(),
          stack,
        ),
      );
    }
  }

  /// Add a new label photo.
  Future<Result<SupplementLabelPhoto, AppError>> add(
    SupplementLabelPhoto photo,
  ) async {
    try {
      await into(supplementLabelPhotos).insert(_entityToCompanion(photo));
      final row = await (select(
        supplementLabelPhotos,
      )..where((p) => p.id.equals(photo.id))).getSingleOrNull();
      if (row == null) {
        return Failure(
          DatabaseError.notFound('SupplementLabelPhoto', photo.id),
        );
      }
      return Success(_rowToEntity(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('supplement_label_photos', e, stack),
      );
    }
  }

  /// Delete a label photo by ID.
  Future<Result<void, AppError>> deleteById(String id) async {
    try {
      final rows = await (delete(
        supplementLabelPhotos,
      )..where((p) => p.id.equals(id))).go();
      if (rows == 0) {
        return Failure(DatabaseError.notFound('SupplementLabelPhoto', id));
      }
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.deleteFailed('supplement_label_photos', id, e, stack),
      );
    }
  }

  /// Delete all photos for a supplement (when supplement is deleted).
  Future<void> deleteForSupplement(String supplementId) async {
    await (delete(
      supplementLabelPhotos,
    )..where((p) => p.supplementId.equals(supplementId))).go();
  }

  SupplementLabelPhoto _rowToEntity(SupplementLabelPhotoRow row) =>
      SupplementLabelPhoto(
        id: row.id,
        supplementId: row.supplementId,
        filePath: row.filePath,
        capturedAt: row.capturedAt,
        sortOrder: row.sortOrder,
      );

  SupplementLabelPhotosCompanion _entityToCompanion(SupplementLabelPhoto e) =>
      SupplementLabelPhotosCompanion(
        id: Value(e.id),
        supplementId: Value(e.supplementId),
        filePath: Value(e.filePath),
        capturedAt: Value(e.capturedAt),
        sortOrder: Value(e.sortOrder),
      );
}
