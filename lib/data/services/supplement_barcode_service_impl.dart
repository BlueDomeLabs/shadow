// lib/data/services/supplement_barcode_service_impl.dart
// Phase 15a — NIH DSLD supplement barcode lookup with local cache
// Per 60_SUPPLEMENT_EXTENSION.md

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/datasources/local/daos/supplement_barcode_cache_dao.dart';
import 'package:shadow_app/domain/services/supplement_barcode_service.dart';
import 'package:uuid/uuid.dart';

/// Implementation of [SupplementBarcodeService] using NIH DSLD API.
///
/// Checks local cache before calling the API. Caches successful lookups
/// for 30 days. Returns null (not an error) when barcode is not found.
class SupplementBarcodeServiceImpl implements SupplementBarcodeService {
  static const _dsldBaseUrl = 'https://dsld.od.nih.gov/api/v8/dsld/supplement';

  final SupplementBarcodeCacheDao _cache;
  final http.Client _httpClient;

  SupplementBarcodeServiceImpl(this._cache, this._httpClient);

  @override
  Future<Result<SupplementBarcodeLookupResult?, AppError>> lookup(
    String barcode,
  ) async {
    // 1. Check cache
    final cached = await _cache.lookup(barcode);
    if (cached.isSuccess && cached.valueOrNull != null) {
      return Success(_entryToResult(cached.valueOrNull!));
    }

    // 2. Call NIH DSLD API
    try {
      final response = await _httpClient
          .get(Uri.parse('$_dsldBaseUrl?upc=$barcode'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 404) return const Success(null);
      if (response.statusCode != 200) {
        return Failure(
          NetworkError.serverError(response.statusCode, 'NIH DSLD API error'),
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded == null) return const Success(null);

      // DSLD may return a list or a single object
      final Map<String, dynamic> product;
      if (decoded is List) {
        if (decoded.isEmpty) return const Success(null);
        product = decoded.first as Map<String, dynamic>;
      } else if (decoded is Map<String, dynamic>) {
        product = decoded;
      } else {
        return const Success(null);
      }

      // Parse ingredients list
      final rawIngredients = product['ingredients'] as List<dynamic>? ?? [];
      final ingredientsJson = jsonEncode(rawIngredients);

      final entry = SupplementBarcodeCacheEntry(
        barcode: barcode,
        productName: product['productName'] as String?,
        brand: product['brandName'] as String?,
        servingSize: product['servingSize'] as String?,
        servingsPerContainer: _toDouble(product['servingsPerContainer']),
        ingredientsJson: ingredientsJson,
        dsldId: product['dsldId']?.toString(),
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
      return Failure(NetworkError.serverError(0, 'DSLD lookup failed: $e'));
    }
  }

  SupplementBarcodeLookupResult _entryToResult(SupplementBarcodeCacheEntry e) {
    // Parse ingredients from JSON
    var ingredients = <DsldIngredient>[];
    if (e.ingredientsJson != null) {
      try {
        final raw = jsonDecode(e.ingredientsJson!) as List<dynamic>;
        ingredients = raw
            .whereType<Map<String, dynamic>>()
            .map(
              (i) => DsldIngredient(
                name: i['name']?.toString() ?? '',
                amountPerServing: i['amount']?.toString(),
              ),
            )
            .toList();
      } on Exception {
        ingredients = [];
      }
    }

    return SupplementBarcodeLookupResult(
      productName: e.productName,
      brand: e.brand,
      servingSize: e.servingSize,
      servingsPerContainer: e.servingsPerContainer,
      ingredients: ingredients,
      dsldId: e.dsldId,
    );
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
