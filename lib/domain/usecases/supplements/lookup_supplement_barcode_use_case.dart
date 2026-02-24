// lib/domain/usecases/supplements/lookup_supplement_barcode_use_case.dart
// Phase 15a — Supplement barcode lookup via NIH DSLD
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/services/supplement_barcode_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';

export 'package:shadow_app/domain/services/supplement_barcode_service.dart'
    show DsldIngredient, SupplementBarcodeLookupResult;

/// Looks up a supplement barcode in cache then NIH DSLD.
///
/// Returns null on cache/API miss — not an error.
/// Returns NetworkError on connectivity failure.
class LookupSupplementBarcodeUseCase
    implements
        UseCase<LookupSupplementBarcodeInput, SupplementBarcodeLookupResult?> {
  final SupplementBarcodeService _service;

  LookupSupplementBarcodeUseCase(this._service);

  @override
  Future<Result<SupplementBarcodeLookupResult?, AppError>> call(
    LookupSupplementBarcodeInput input,
  ) => _service.lookup(input.barcode);
}
