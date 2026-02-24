// lib/domain/services/supplement_barcode_service.dart
// Phase 15a — Port for NIH DSLD supplement barcode lookup
// Per 60_SUPPLEMENT_EXTENSION.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';

/// A single ingredient entry from a DSLD lookup response.
class DsldIngredient {
  final String name;
  final String? amountPerServing;

  const DsldIngredient({required this.name, this.amountPerServing});
}

/// Result of a successful barcode lookup from NIH DSLD.
class SupplementBarcodeLookupResult {
  final String? productName;
  final String? brand;
  final String? servingSize;
  final double? servingsPerContainer;
  final List<DsldIngredient> ingredients;
  final String? dsldId;

  const SupplementBarcodeLookupResult({
    this.productName,
    this.brand,
    this.servingSize,
    this.servingsPerContainer,
    this.ingredients = const [],
    this.dsldId,
  });
}

/// Service port for supplement barcode lookups against NIH DSLD.
///
/// Implementations check local cache first, then call the DSLD API.
/// Returns null (Success(null)) when a barcode is not found — this is not an error.
// ignore: one_member_abstracts
abstract interface class SupplementBarcodeService {
  /// Look up a barcode. Returns null if not found in cache or API.
  Future<Result<SupplementBarcodeLookupResult?, AppError>> lookup(
    String barcode,
  );
}
