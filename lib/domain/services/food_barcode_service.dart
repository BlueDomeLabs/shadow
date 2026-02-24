// lib/domain/services/food_barcode_service.dart
// Phase 15a — Port for Open Food Facts barcode lookup
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';

/// Result of a successful barcode lookup from Open Food Facts.
class BarcodeLookupResult {
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

  const BarcodeLookupResult({
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
  });
}

/// Service port for barcode lookups against Open Food Facts.
///
/// Implementations check local cache first, then call the Open Food Facts API.
/// Returns null (Success(null)) when a barcode is not found — this is not an error.
// ignore: one_member_abstracts
abstract interface class FoodBarcodeService {
  /// Look up a barcode. Returns null if not found in cache or API.
  Future<Result<BarcodeLookupResult?, AppError>> lookup(String barcode);
}
