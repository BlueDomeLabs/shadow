// lib/domain/usecases/food_items/scan_ingredient_photo_use_case.dart
// Phase 15a — Ingredient label photo scanning via Claude API
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'dart:typed_data';

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/anthropic_api_client.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

export 'package:shadow_app/core/services/anthropic_api_client.dart'
    show IngredientScanResult;

/// Input for ScanIngredientPhotoUseCase.
class ScanIngredientPhotoInput {
  final Uint8List imageBytes;
  const ScanIngredientPhotoInput({required this.imageBytes});
}

/// Sends a food label photo to Claude API and returns extracted nutritional data.
///
/// Returns null on extraction failure — not an error.
/// Returns NetworkError when the API is unreachable.
class ScanIngredientPhotoUseCase
    implements UseCase<ScanIngredientPhotoInput, IngredientScanResult?> {
  final AnthropicApiClient _client;

  ScanIngredientPhotoUseCase(this._client);

  @override
  Future<Result<IngredientScanResult?, AppError>> call(
    ScanIngredientPhotoInput input,
  ) => _client.scanIngredients(input.imageBytes);
}
