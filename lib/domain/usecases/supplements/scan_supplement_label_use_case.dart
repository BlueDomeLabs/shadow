// lib/domain/usecases/supplements/scan_supplement_label_use_case.dart
// Phase 15a — Supplement label photo scanning via Claude API
// Per 60_SUPPLEMENT_EXTENSION.md

import 'dart:typed_data';

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/services/anthropic_api_client.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';

export 'package:shadow_app/core/services/anthropic_api_client.dart'
    show SupplementLabelScanResult;

/// Input for ScanSupplementLabelUseCase.
class ScanSupplementLabelInput {
  final Uint8List imageBytes;
  const ScanSupplementLabelInput({required this.imageBytes});
}

/// Sends a supplement facts or prescription label photo to Claude API.
///
/// Returns null on extraction failure — not an error.
/// Returns NetworkError when the API is unreachable.
class ScanSupplementLabelUseCase
    implements UseCase<ScanSupplementLabelInput, SupplementLabelScanResult?> {
  final AnthropicApiClient _client;

  ScanSupplementLabelUseCase(this._client);

  @override
  Future<Result<SupplementLabelScanResult?, AppError>> call(
    ScanSupplementLabelInput input,
  ) => _client.scanSupplementLabel(input.imageBytes);
}
