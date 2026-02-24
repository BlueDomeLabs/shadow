// lib/data/datasources/local/daos/food_barcode_cache_dao.dart
// Phase 15a — DAO for food_barcode_cache table
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:drift/drift.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/database.dart';
import 'package:shadow_app/data/datasources/local/tables/food_barcode_cache_table.dart';

part 'food_barcode_cache_dao.g.dart';

/// Cached result from an Open Food Facts barcode lookup.
class FoodBarcodeCacheEntry {
  final String barcode;
  final String? productName;
  final String? brand;
  final String? ingredientsText;
  final double? calories;
  final double? carbs;
  final double? fat;
  final double? protein;
  final double? fiber;
  final double? sugar;
  final double? sodiumMg;
  final String? openFoodFactsId;
  final String? imageUrl;
  final String? rawResponse;

  const FoodBarcodeCacheEntry({
    required this.barcode,
    this.productName,
    this.brand,
    this.ingredientsText,
    this.calories,
    this.carbs,
    this.fat,
    this.protein,
    this.fiber,
    this.sugar,
    this.sodiumMg,
    this.openFoodFactsId,
    this.imageUrl,
    this.rawResponse,
  });
}

/// Data Access Object for the food_barcode_cache table.
@DriftAccessor(tables: [FoodBarcodeCache])
class FoodBarcodeCacheDao extends DatabaseAccessor<AppDatabase>
    with _$FoodBarcodeCacheDaoMixin {
  FoodBarcodeCacheDao(super.db);

  /// Look up a barcode — returns null if not cached or if entry is expired.
  Future<Result<FoodBarcodeCacheEntry?, AppError>> lookup(
    String barcode,
  ) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final row =
          await (select(foodBarcodeCache)..where(
                (c) =>
                    c.barcode.equals(barcode) &
                    c.expiresAt.isBiggerThanValue(now),
              ))
              .getSingleOrNull();
      if (row == null) return const Success(null);
      return Success(_rowToEntry(row));
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.queryFailed('food_barcode_cache', e.toString(), stack),
      );
    }
  }

  /// Store a barcode lookup result. Upserts existing entries.
  Future<Result<void, AppError>> store({
    required String id,
    required FoodBarcodeCacheEntry entry,
  }) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      const thirtyDaysMs = 30 * 24 * 60 * 60 * 1000;
      await into(foodBarcodeCache).insertOnConflictUpdate(
        FoodBarcodeCacheCompanion(
          id: Value(id),
          barcode: Value(entry.barcode),
          productName: Value(entry.productName),
          brand: Value(entry.brand),
          ingredientsText: Value(entry.ingredientsText),
          calories: Value(entry.calories),
          carbs: Value(entry.carbs),
          fat: Value(entry.fat),
          protein: Value(entry.protein),
          fiber: Value(entry.fiber),
          sugar: Value(entry.sugar),
          sodiumMg: Value(entry.sodiumMg),
          openFoodFactsId: Value(entry.openFoodFactsId),
          imageUrl: Value(entry.imageUrl),
          rawResponse: Value(entry.rawResponse),
          fetchedAt: Value(now),
          expiresAt: Value(now + thirtyDaysMs),
        ),
      );
      return const Success(null);
    } on Exception catch (e, stack) {
      return Failure(
        DatabaseError.insertFailed('food_barcode_cache', e, stack),
      );
    }
  }

  /// Delete expired entries to free up space.
  Future<void> purgeExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await (delete(
      foodBarcodeCache,
    )..where((c) => c.expiresAt.isSmallerOrEqualValue(now))).go();
  }

  FoodBarcodeCacheEntry _rowToEntry(FoodBarcodeCacheRow row) =>
      FoodBarcodeCacheEntry(
        barcode: row.barcode,
        productName: row.productName,
        brand: row.brand,
        ingredientsText: row.ingredientsText,
        calories: row.calories,
        carbs: row.carbs,
        fat: row.fat,
        protein: row.protein,
        fiber: row.fiber,
        sugar: row.sugar,
        sodiumMg: row.sodiumMg,
        openFoodFactsId: row.openFoodFactsId,
        imageUrl: row.imageUrl,
        rawResponse: row.rawResponse,
      );
}
