// lib/core/services/anthropic_api_client.dart
// Phase 15a — Anthropic Claude API client for photo scanning
// Per 59a_FOOD_DATABASE_EXTENSION.md and 60_SUPPLEMENT_EXTENSION.md
//
// Uses http.post to api.anthropic.com/v1/messages.
// API key read from FlutterSecureStorage under 'anthropic_api_key'.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shadow_app/core/config/secure_storage_keys.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';

/// Result of scanning an ingredient/nutrition label photo.
class IngredientScanResult {
  final String? productName;
  final List<String> ingredients;
  final double? calories;
  final double? carbs;
  final double? fat;
  final double? protein;
  final double? fiber;
  final double? sugar;
  final double? sodiumMg;

  const IngredientScanResult({
    this.productName,
    this.ingredients = const [],
    this.calories,
    this.carbs,
    this.fat,
    this.protein,
    this.fiber,
    this.sugar,
    this.sodiumMg,
  });
}

/// Result of scanning a supplement facts or prescription label photo.
class SupplementLabelScanResult {
  final String? productName;
  final String? brand;
  final String? servingSize;
  final double? servingsPerContainer;
  final List<Map<String, String>> ingredients;
  final bool isPrescription;

  const SupplementLabelScanResult({
    this.productName,
    this.brand,
    this.servingSize,
    this.servingsPerContainer,
    this.ingredients = const [],
    this.isPrescription = false,
  });
}

/// Abstract client for Anthropic Claude API image-scanning operations.
abstract class AnthropicApiClient {
  /// Scan an ingredient/nutrition label photo.
  Future<Result<IngredientScanResult?, AppError>> scanIngredients(
    Uint8List imageBytes,
  );

  /// Scan a supplement facts or prescription label photo.
  Future<Result<SupplementLabelScanResult?, AppError>> scanSupplementLabel(
    Uint8List imageBytes,
  );
}

// =============================================================================
// Implementation
// =============================================================================

/// Concrete Anthropic API client using http.post + FlutterSecureStorage.
class AnthropicApiClientImpl implements AnthropicApiClient {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-haiku-4-5-20251001';
  static const String _apiVersion = '2023-06-01';

  final FlutterSecureStorage _secureStorage;
  final http.Client _httpClient;

  AnthropicApiClientImpl(this._secureStorage, this._httpClient);

  @override
  Future<Result<IngredientScanResult?, AppError>> scanIngredients(
    Uint8List imageBytes,
  ) async {
    const prompt =
        'This is a photo of a food label or nutrition facts panel. '
        'Please extract and return the following as JSON: '
        'product_name (string or null), '
        'ingredients (array of strings — the ingredient names, or empty array if not visible), '
        'calories (number or null, kcal per serving), '
        'carbs (number or null, grams), '
        'fat (number or null, grams), '
        'protein (number or null, grams), '
        'fiber (number or null, grams), '
        'sugar (number or null, grams), '
        'sodium_mg (number or null, milligrams). '
        'Return only valid JSON with no additional text.';

    final result = await _callApi(imageBytes, prompt);
    return result.when(
      success: (json) {
        if (json == null) return const Success(null);
        try {
          return Success(
            IngredientScanResult(
              productName: json['product_name'] as String?,
              ingredients: _parseStringList(json['ingredients']),
              calories: _toDouble(json['calories']),
              carbs: _toDouble(json['carbs']),
              fat: _toDouble(json['fat']),
              protein: _toDouble(json['protein']),
              fiber: _toDouble(json['fiber']),
              sugar: _toDouble(json['sugar']),
              sodiumMg: _toDouble(json['sodium_mg']),
            ),
          );
        } on Exception {
          return const Success(null);
        }
      },
      failure: Failure.new,
    );
  }

  @override
  Future<Result<SupplementLabelScanResult?, AppError>> scanSupplementLabel(
    Uint8List imageBytes,
  ) async {
    const prompt =
        'This is a photo of a supplement facts panel or prescription medication label. '
        'Please extract and return the following as JSON: '
        'product_name (string or null), '
        'brand (string or null), '
        'serving_size (string or null), '
        'servings_per_container (number or null), '
        'ingredients (array of objects with "name" and "amount_per_serving" strings), '
        'is_prescription (boolean — true if this appears to be a prescription medication label). '
        'Return only valid JSON with no additional text.';

    final result = await _callApi(imageBytes, prompt);
    return result.when(
      success: (json) {
        if (json == null) return const Success(null);
        try {
          final rawIngredients = json['ingredients'] as List<dynamic>? ?? [];
          final ingredients = rawIngredients
              .whereType<Map<String, dynamic>>()
              .map(
                (i) => {
                  'name': (i['name'] ?? '') as String,
                  'amount_per_serving':
                      (i['amount_per_serving'] ?? '') as String,
                },
              )
              .toList();

          return Success(
            SupplementLabelScanResult(
              productName: json['product_name'] as String?,
              brand: json['brand'] as String?,
              servingSize: json['serving_size'] as String?,
              servingsPerContainer: _toDouble(json['servings_per_container']),
              ingredients: ingredients,
              isPrescription: json['is_prescription'] as bool? ?? false,
            ),
          );
        } on Exception {
          return const Success(null);
        }
      },
      failure: Failure.new,
    );
  }

  /// Makes the actual API call. Returns parsed JSON map or null.
  Future<Result<Map<String, dynamic>?, AppError>> _callApi(
    Uint8List imageBytes,
    String prompt,
  ) async {
    // 1. Get API key
    final apiKey = await _secureStorage.read(
      key: SecureStorageKeys.anthropicApiKey,
    );
    if (apiKey == null || apiKey.isEmpty) {
      return Failure(
        NetworkError.serverError(401, 'Anthropic API key not configured'),
      );
    }

    // 2. Encode image as base64
    final base64Image = base64Encode(imageBytes);

    // 3. Build request body
    final body = jsonEncode({
      'model': _model,
      'max_tokens': 1024,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': 'image/jpeg',
                'data': base64Image,
              },
            },
            {'type': 'text', 'text': prompt},
          ],
        },
      ],
    });

    // 4. Call API
    try {
      final response = await _httpClient
          .post(
            Uri.parse(_apiUrl),
            headers: {
              'x-api-key': apiKey,
              'anthropic-version': _apiVersion,
              'content-type': 'application/json',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 429) {
        return Failure(NetworkError.rateLimited('Claude API'));
      }
      if (response.statusCode != 200) {
        return Failure(
          NetworkError.serverError(response.statusCode, 'Claude API error'),
        );
      }

      // 5. Parse response
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final contentList = decoded['content'] as List<dynamic>?;
      if (contentList == null || contentList.isEmpty) {
        return const Success(null);
      }
      final content = contentList.first as Map<String, dynamic>?;
      if (content == null) return const Success(null);
      final text = content['text'] as String?;
      if (text == null || text.isEmpty) return const Success(null);

      // 6. Parse JSON from text response
      try {
        final jsonStr = _extractJson(text);
        final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
        return Success(parsed);
      } on FormatException {
        return const Success(null); // Claude couldn't extract structured data
      }
    } on Exception catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('ClientException') ||
          e.toString().contains('TimeoutException')) {
        return Failure(NetworkError.noConnection());
      }
      return Failure(NetworkError.serverError(0, 'Claude API error: $e'));
    }
  }

  /// Extracts a JSON block from text that may contain markdown code fences.
  String _extractJson(String text) {
    final jsonRegex = RegExp(r'```(?:json)?\s*([\s\S]+?)\s*```');
    final match = jsonRegex.firstMatch(text);
    if (match != null) return match.group(1)!;
    return text.trim();
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  List<String> _parseStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) return value.whereType<String>().toList();
    return const [];
  }
}
