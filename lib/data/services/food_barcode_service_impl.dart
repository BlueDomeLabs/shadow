// lib/data/services/food_barcode_service_impl.dart
// Phase 15a — Open Food Facts barcode lookup with local cache
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/food_barcode_cache_dao.dart';
import 'package:shadow_app/domain/services/food_barcode_service.dart';
import 'package:uuid/uuid.dart';

/// Implementation of [FoodBarcodeService] using Open Food Facts API.
///
/// Checks local cache before calling the API. Caches successful lookups
/// for 30 days. Returns null (not an error) when barcode is not found.
class FoodBarcodeServiceImpl implements FoodBarcodeService {
  static const _offBaseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  final FoodBarcodeCacheDao _cache;
  final http.Client _httpClient;

  FoodBarcodeServiceImpl(this._cache, this._httpClient);

  @override
  Future<Result<BarcodeLookupResult?, AppError>> lookup(String barcode) async {
    // 1. Check cache
    final cached = await _cache.lookup(barcode);
    if (cached.isSuccess && cached.valueOrNull != null) {
      return Success(_entryToResult(cached.valueOrNull!));
    }

    // 2. Call Open Food Facts API
    try {
      final response = await _httpClient
          .get(Uri.parse('$_offBaseUrl/$barcode.json'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 404) return const Success(null);
      if (response.statusCode != 200) {
        return Failure(
          NetworkError.serverError(
            response.statusCode,
            'Open Food Facts API error',
          ),
        );
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final status = decoded['status'] as int? ?? 0;
      if (status == 0) return const Success(null); // Product not found

      final product = decoded['product'] as Map<String, dynamic>? ?? {};
      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};

      final entry = FoodBarcodeCacheEntry(
        barcode: barcode,
        productName: product['product_name'] as String?,
        brand: product['brands'] as String?,
        ingredientsText: product['ingredients_text'] as String?,
        calories: _toDouble(nutriments['energy-kcal_100g']),
        carbs: _toDouble(nutriments['carbohydrates_100g']),
        fat: _toDouble(nutriments['fat_100g']),
        protein: _toDouble(nutriments['proteins_100g']),
        fiber: _toDouble(nutriments['fiber_100g']),
        sugar: _toDouble(nutriments['sugars_100g']),
        sodiumMg: _sodiumMg(nutriments),
        openFoodFactsId: product['id'] as String?,
        imageUrl: product['image_url'] as String?,
        rawResponse: response.body,
      );

      // 3. Cache the result
      await _cache.store(id: const Uuid().v4(), entry: entry);

      return Success(_entryToResult(entry));
    } on Exception catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException') ||
          e.toString().contains('TimeoutException')) {
        return Failure(NetworkError.noConnection());
      }
      return Failure(
        NetworkError.serverError(0, 'Open Food Facts lookup failed: $e'),
      );
    }
  }

  BarcodeLookupResult _entryToResult(FoodBarcodeCacheEntry e) =>
      BarcodeLookupResult(
        productName: e.productName,
        brand: e.brand,
        ingredientsText: e.ingredientsText,
        calories: e.calories,
        carbs: e.carbs,
        fat: e.fat,
        protein: e.protein,
        fiber: e.fiber,
        sugar: e.sugar,
        sodiumMg: e.sodiumMg,
        openFoodFactsId: e.openFoodFactsId,
        imageUrl: e.imageUrl,
      );

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Open Food Facts stores sodium in grams (sodium_100g). Convert to mg.
  double? _sodiumMg(Map<String, dynamic> nutriments) {
    final sodiumG = _toDouble(nutriments['sodium_100g']);
    if (sodiumG == null) return null;
    return sodiumG * 1000;
  }
}
