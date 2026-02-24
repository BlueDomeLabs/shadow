// lib/domain/usecases/food_items/lookup_barcode_use_case.dart
// Phase 15a — Barcode lookup via Open Food Facts
// Per 59a_FOOD_DATABASE_EXTENSION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/services/food_barcode_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/food_items/food_item_inputs.dart';

export 'package:shadow_app/domain/services/food_barcode_service.dart'
    show BarcodeLookupResult;

/// Looks up a food barcode in cache then Open Food Facts.
///
/// Returns null on cache/API miss — not an error.
/// Returns NetworkError on connectivity failure.
class LookupBarcodeUseCase
    implements UseCase<LookupBarcodeInput, BarcodeLookupResult?> {
  final FoodBarcodeService _service;

  LookupBarcodeUseCase(this._service);

  @override
  Future<Result<BarcodeLookupResult?, AppError>> call(
    LookupBarcodeInput input,
  ) => _service.lookup(input.barcode);
}
