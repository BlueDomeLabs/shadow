// lib/core/services/photo_processing_service.dart
// Photo processing service — Phase 28
// Compresses, strips EXIF, and hashes photos before storage.
// See 18_PHOTO_PROCESSING.md for full pipeline specification.
// NOTE: Encryption is deferred — photos stored as plaintext .jpg for now.
//       See DECISIONS.md for rationale.

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Processes photos before storage: compress, strip EXIF, hash.
///
/// Plain Dart class — instantiate directly in screens:
///   `final service = PhotoProcessingService();`
///
/// Encryption is deferred to a future phase that will add key management.
class PhotoProcessingService {
  static const int _targetStandard = 500 * 1024; // 500 KB
  static const int _targetHighDetail = 1024 * 1024; // 1 MB
  static const int _maxInputBytes = 10 * 1024 * 1024; // 10 MB

  /// Override output directory path in tests to avoid path_provider dependency.
  @visibleForTesting
  static String? testOutputDirectory;

  /// Override compression function in tests to avoid platform plugin dependency.
  @visibleForTesting
  static Future<Uint8List?> Function(String path, int quality)?
  compressOverride;

  /// Standard photo: body area documentation, bowel tracking, etc.
  /// Target: ≤ 500 KB, JPEG quality 85→60.
  Future<ProcessedPhotoResult> processStandard(String sourcePath) =>
      _process(sourcePath, _targetStandard);

  /// High-detail photo: condition baselines, medical documentation.
  /// Target: ≤ 1024 KB, JPEG quality 85→60.
  Future<ProcessedPhotoResult> processHighDetail(String sourcePath) =>
      _process(sourcePath, _targetHighDetail);

  Future<ProcessedPhotoResult> _process(
    String sourcePath,
    int targetBytes,
  ) async {
    // 1. Validate: file must exist and size ≤ 10 MB.
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw const PhotoProcessingException('Image file not found.');
    }
    final inputSize = await file.length();
    if (inputSize > _maxInputBytes) {
      throw const PhotoProcessingException(
        'Image is too large (max 10 MB). Please choose a smaller image.',
      );
    }

    // 2. Compress with quality stepping: 85 → 75 → 65 → 60 (minimum).
    //    keepExif: false strips EXIF automatically.
    //    minWidth/minHeight: 1 prevents upscaling.
    Uint8List? compressed;
    var quality = 85;
    while (true) {
      compressed = await _compress(sourcePath, quality);
      if (compressed == null ||
          compressed.length <= targetBytes ||
          quality <= 60) {
        break;
      }
      quality -= 10;
      if (quality < 60) quality = 60;
    }

    if (compressed == null) {
      throw const PhotoProcessingException('Image compression failed.');
    }

    // 3. Write output to <documents>/photos/<uuid>.jpg.
    final outputDir = await _getOutputDirectory();
    final outputPath = '${outputDir.path}/${const Uuid().v4()}.jpg';
    await File(outputPath).writeAsBytes(compressed);

    // 4. Calculate SHA-256 hash of compressed bytes.
    final hash = sha256.convert(compressed).toString();

    return ProcessedPhotoResult(
      localPath: outputPath,
      fileSizeBytes: compressed.length,
      fileHash: hash,
    );
  }

  Future<Directory> _getOutputDirectory() async {
    if (testOutputDirectory != null) {
      final dir = Directory(testOutputDirectory!);
      await dir.create(recursive: true);
      return dir;
    }
    final docs = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${docs.path}/photos');
    await photosDir.create(recursive: true);
    return photosDir;
  }

  Future<Uint8List?> _compress(String path, int quality) {
    if (compressOverride != null) return compressOverride!(path, quality);
    return FlutterImageCompress.compressWithFile(
      path,
      minWidth: 1,
      minHeight: 1,
      quality: quality,
    );
  }
}

/// Result of a successful photo processing operation.
class ProcessedPhotoResult {
  final String localPath;
  final int fileSizeBytes;
  final String fileHash;

  const ProcessedPhotoResult({
    required this.localPath,
    required this.fileSizeBytes,
    required this.fileHash,
  });
}

/// Thrown when photo processing validation or compression fails.
class PhotoProcessingException implements Exception {
  final String message;

  const PhotoProcessingException(this.message);

  @override
  String toString() => 'PhotoProcessingException: $message';
}
