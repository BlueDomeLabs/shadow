// test/core/services/photo_processing_service_test.dart
// Unit tests for PhotoProcessingService.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/core/services/photo_processing_service.dart';

void main() {
  group('PhotoProcessingService', () {
    late Directory tempDir;
    late File testImageFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('photo_test_');
      PhotoProcessingService.testOutputDirectory = tempDir.path;

      // Small test file (100 bytes) simulating a captured photo.
      testImageFile = File('${tempDir.path}/input.jpg');
      await testImageFile.writeAsBytes(Uint8List.fromList(List.filled(100, 0)));

      // Override compression to return 1 KB of fixed bytes —
      // avoids flutter_image_compress platform plugin in unit tests.
      PhotoProcessingService.compressOverride = (path, quality) async =>
          Uint8List.fromList(List.filled(1024, 42));
    });

    tearDown(() async {
      PhotoProcessingService.testOutputDirectory = null;
      PhotoProcessingService.compressOverride = null;
      await tempDir.delete(recursive: true);
    });

    test('processStandard produces output ≤ 500 KB', () async {
      final service = PhotoProcessingService();
      final result = await service.processStandard(testImageFile.path);
      expect(result.fileSizeBytes, lessThanOrEqualTo(500 * 1024));
    });

    test('processHighDetail produces output ≤ 1024 KB', () async {
      final service = PhotoProcessingService();
      final result = await service.processHighDetail(testImageFile.path);
      expect(result.fileSizeBytes, lessThanOrEqualTo(1024 * 1024));
    });

    test('fileHash is a 64-character lowercase hex string', () async {
      final service = PhotoProcessingService();
      final result = await service.processStandard(testImageFile.path);
      expect(result.fileHash, hasLength(64));
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(result.fileHash), isTrue);
    });

    test('localPath ends in .jpg', () async {
      final service = PhotoProcessingService();
      final result = await service.processStandard(testImageFile.path);
      expect(result.localPath, endsWith('.jpg'));
    });

    test('file > 10 MB throws PhotoProcessingException', () async {
      final largeFile = File('${tempDir.path}/large.jpg');
      await largeFile.writeAsBytes(Uint8List(11 * 1024 * 1024));

      final service = PhotoProcessingService();
      await expectLater(
        service.processStandard(largeFile.path),
        throwsA(isA<PhotoProcessingException>()),
      );
    });
  });
}
