// lib/data/datasources/local/daos/supplement_barcode_cache_dao.dart
// Phase 15a — DAO for supplement_barcode_cache table (NIH DSLD)
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/supplement_barcode_cache_table.dart';

part 'supplement_barcode_cache_dao.g.dart';

/// Cached result from a NIH DSLD barcode lookup.
class SupplementBarcodeCacheEntry {
  final String barcode;
  final String? productName;
  final String? brand;
  final String? servingSize;
  final double? servingsPerContainer;
  final String? ingredientsJson; // JSON array of ingredient objects
  final String? dsldId;
  final String? rawResponse;

  const SupplementBarcodeCacheEntry({
    required this.barcode,
    this.productName,
    this.brand,
    this.servingSize,
    this.servingsPerContainer,
    this.ingredientsJson,
    this.dsldId,
    this.rawResponse,
  });
}

/// Data Access Object for the supplement_barcode_cache table.
@DriftAccessor(tables: [SupplementBarcodeCache])
class SupplementBarcodeCacheDao extends DatabaseAccessor<AppDatabase>
    with _$SupplementBarcodeCacheDaoMixin {
  SupplementBarcodeCacheDao(super.db);

  /// Look up a barcode — returns null if not cached or if entry is expired.
  Future<Result<SupplementBarcodeCacheEntry?, AppError>> lookup(
    String barcode,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final row =
          await (select(supplementBarcodeCache)..where(
                (c) =>
                    c.barcode.equals(barcode) &
                    c.expiresAt.isBiggerThanValue(now),
              ))
              .getSingleOrNull();
      if (row == null) return const Success(null);
      return Success(_rowToEntry(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed(
          'supplement_barcode_cache',
          e.toString(),
          stack,
        ),
      );
    }
  }

  /// Store a barcode lookup result. Upserts existing entries.
  Future<Result<void, AppError>> store({
    required String id,
    required SupplementBarcodeCacheEntry entry,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      const thirtyDaysMs = 30 * 24 * 60 * 60 * 1000;
      await into(supplementBarcodeCache).insertOnConflictUpdate(
        SupplementBarcodeCacheCompanion(
          id: Value(id),
          barcode: Value(entry.barcode),
          productName: Value(entry.productName),
          brand: Value(entry.brand),
          servingSize: Value(entry.servingSize),
          servingsPerContainer: Value(entry.servingsPerContainer),
          ingredientsJson: Value(entry.ingredientsJson),
          dsldId: Value(entry.dsldId),
          rawResponse: Value(entry.rawResponse),
          fetchedAt: Value(now),
          expiresAt: Value(now + thirtyDaysMs),
        ),
      );
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('supplement_barcode_cache', e, stack),
      );
    }
  }

  /// Delete expired entries to free up space.
  Future<void> purgeExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (delete(
      supplementBarcodeCache,
    )..where((c) => c.expiresAt.isSmallerOrEqualValue(now))).go();
  }

  SupplementBarcodeCacheEntry _rowToEntry(SupplementBarcodeCacheRow row) =>
      SupplementBarcodeCacheEntry(
        barcode: row.barcode,
        productName: row.productName,
        brand: row.brand,
        servingSize: row.servingSize,
        servingsPerContainer: row.servingsPerContainer,
        ingredientsJson: row.ingredientsJson,
        dsldId: row.dsldId,
        rawResponse: row.rawResponse,
      );
}
