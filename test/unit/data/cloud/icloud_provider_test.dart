// test/unit/data/cloud/icloud_provider_test.dart
// Tests for ICloudProvider implementing CloudStorageProvider.
//
// Uses a mock ICloudStorageWrapper to verify:
// - Platform guard (non-Apple platforms return false)
// - isAvailable / isAuthenticated / authenticate / signOut
// - uploadEntity / downloadEntity / deleteEntity
// - getChangesSince (gather + filter + download)
// - uploadFile / downloadFile
// - providerType returns CloudProviderType.icloud

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/data/cloud/icloud_provider.dart';
import 'package:shadow_app/data/datasources/remote/cloud_storage_provider.dart';

@GenerateMocks([ICloudStorageWrapper])
import 'icloud_provider_test.mocks.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Build a minimal [ICloudFile] map for testing.
Map<dynamic, dynamic> _icloudFileMap({
  required String relativePath,
  required double contentChangeDateSecs,
  double creationDateSecs = 1000000.0,
  int sizeInBytes = 512,
  bool isDownloading = false,
  String downloadStatus = 'NSMetadataUbiquitousItemDownloadingStatusCurrent',
  bool isUploading = false,
  bool isUploaded = true,
  bool hasUnresolvedConflicts = false,
}) => {
  'relativePath': relativePath,
  'sizeInBytes': sizeInBytes,
  'creationDate': creationDateSecs,
  'contentChangeDate': contentChangeDateSecs,
  'isDownloading': isDownloading,
  'downloadStatus': downloadStatus,
  'isUploading': isUploading,
  'isUploaded': isUploaded,
  'hasUnresolvedConflicts': hasUnresolvedConflicts,
};

/// Configure mock [download()] to write [content] to the destination path
/// and complete the progress stream (simulating iCloud download completion).
void _setupDownloadSuccess(
  MockICloudStorageWrapper mockStorage,
  String content,
) {
  when(
    mockStorage.download(
      containerId: anyNamed('containerId'),
      relativePath: anyNamed('relativePath'),
      destinationFilePath: anyNamed('destinationFilePath'),
      onProgress: anyNamed('onProgress'),
    ),
  ).thenAnswer((invocation) async {
    final destPath = invocation.namedArguments[#destinationFilePath] as String;
    final onProgress =
        invocation.namedArguments[#onProgress]
            as void Function(Stream<double>)?;
    await File(destPath).writeAsString(content);
    if (onProgress != null) {
      final controller = StreamController<double>();
      onProgress(controller.stream);
      await controller.close();
    }
  });
}

/// Configure mock [download()] to throw a file-not-found PlatformException.
void _setupDownloadNotFound(MockICloudStorageWrapper mockStorage) {
  when(
    mockStorage.download(
      containerId: anyNamed('containerId'),
      relativePath: anyNamed('relativePath'),
      destinationFilePath: anyNamed('destinationFilePath'),
      onProgress: anyNamed('onProgress'),
    ),
  ).thenThrow(PlatformException(code: PlatformExceptionCode.fileNotFound));
}

/// Configure mock [download()] to throw a generic exception.
void _setupDownloadError(MockICloudStorageWrapper mockStorage) {
  when(
    mockStorage.download(
      containerId: anyNamed('containerId'),
      relativePath: anyNamed('relativePath'),
      destinationFilePath: anyNamed('destinationFilePath'),
      onProgress: anyNamed('onProgress'),
    ),
  ).thenThrow(Exception('network error'));
}

void main() {
  // Required for Mockito with Result return types
  provideDummy<Result<void, AppError>>(const Success(null));
  provideDummy<Result<Map<String, dynamic>?, AppError>>(const Success(null));
  provideDummy<Result<List<SyncChange>, AppError>>(const Success([]));
  provideDummy<Result<String, AppError>>(const Success(''));

  group('ICloudProvider', () {
    late MockICloudStorageWrapper mockStorage;
    late ICloudProvider provider;

    late Directory tempDir;

    setUp(() async {
      mockStorage = MockICloudStorageWrapper();
      provider = ICloudProvider(storage: mockStorage);
      // Create a real temp directory for file I/O in tests
      tempDir = await Directory.systemTemp.createTemp('icloud_test_');
      ICloudProvider.testTempDirectory = tempDir.path;
      // Reset platform override before each test
      ICloudProvider.testIsApplePlatform = null;
    });

    tearDown(() async {
      ICloudProvider.testIsApplePlatform = null;
      ICloudProvider.testTempDirectory = null;
      // Clean up temp directory
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });

    // -----------------------------------------------------------------------
    // providerType
    // -----------------------------------------------------------------------

    group('providerType', () {
      test('returns CloudProviderType.icloud', () {
        expect(provider.providerType, CloudProviderType.icloud);
      });

      test('providerType value is 1 per spec', () {
        expect(provider.providerType.value, 1);
      });
    });

    // -----------------------------------------------------------------------
    // isAvailable
    // -----------------------------------------------------------------------

    group('isAvailable', () {
      test('returns false on non-Apple platforms', () async {
        ICloudProvider.testIsApplePlatform = false;
        expect(await provider.isAvailable(), isFalse);
        verifyNever(mockStorage.gather(containerId: anyNamed('containerId')));
      });

      test('returns true when gather succeeds on Apple platform', () async {
        ICloudProvider.testIsApplePlatform = true;
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenAnswer((_) async => []);
        expect(await provider.isAvailable(), isTrue);
      });

      test(
        'returns false when gather throws iCloud connection error',
        () async {
          ICloudProvider.testIsApplePlatform = true;
          when(
            mockStorage.gather(containerId: anyNamed('containerId')),
          ).thenThrow(
            PlatformException(
              code: PlatformExceptionCode.iCloudConnectionOrPermission,
            ),
          );
          expect(await provider.isAvailable(), isFalse);
        },
      );

      test('returns false when gather throws generic exception', () async {
        ICloudProvider.testIsApplePlatform = true;
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenThrow(Exception('unexpected error'));
        expect(await provider.isAvailable(), isFalse);
      });
    });

    // -----------------------------------------------------------------------
    // authenticate / signOut / isAuthenticated
    // -----------------------------------------------------------------------

    group('authenticate', () {
      test('returns Success when iCloud is available', () async {
        ICloudProvider.testIsApplePlatform = true;
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenAnswer((_) async => []);
        final result = await provider.authenticate();
        expect(result.isSuccess, isTrue);
      });

      test('returns Failure when iCloud is not available', () async {
        ICloudProvider.testIsApplePlatform = false;
        final result = await provider.authenticate();
        expect(result.isFailure, isTrue);
        final error = (result as Failure).error;
        expect(error, isA<AuthError>());
        expect((error as AuthError).message, contains('iCloud not available'));
      });
    });

    group('signOut', () {
      test(
        'always returns Success (OS-level sign-out, no app action)',
        () async {
          final result = await provider.signOut();
          expect(result.isSuccess, isTrue);
          verifyZeroInteractions(mockStorage);
        },
      );
    });

    // -----------------------------------------------------------------------
    // uploadEntity
    // -----------------------------------------------------------------------

    group('uploadEntity', () {
      test('calls upload with correct container and remote path', () async {
        when(
          mockStorage.upload(
            containerId: anyNamed('containerId'),
            filePath: anyNamed('filePath'),
            destinationRelativePath: anyNamed('destinationRelativePath'),
            onProgress: anyNamed('onProgress'),
          ),
        ).thenAnswer((_) async {});

        final result = await provider.uploadEntity(
          'supplements',
          'entity-123',
          'profile-1',
          'client-1',
          {'encryptedData': 'abc'},
          1,
        );

        expect(result.isSuccess, isTrue);
        final captured = verify(
          mockStorage.upload(
            containerId: 'iCloud.com.bluedomecolorado.shadow',
            filePath: captureAnyNamed('filePath'),
            destinationRelativePath: captureAnyNamed('destinationRelativePath'),
            onProgress: anyNamed('onProgress'),
          ),
        ).captured;
        // Remote path: shadow_app/data/supplements/entity-123.json
        expect(
          captured[1],
          equals('shadow_app/data/supplements/entity-123.json'),
        );
      });

      test('returns Failure on exception', () async {
        when(
          mockStorage.upload(
            containerId: anyNamed('containerId'),
            filePath: anyNamed('filePath'),
            destinationRelativePath: anyNamed('destinationRelativePath'),
            onProgress: anyNamed('onProgress'),
          ),
        ).thenThrow(Exception('upload failed'));

        final result = await provider.uploadEntity(
          'supplements',
          'entity-123',
          'profile-1',
          'client-1',
          {'encryptedData': 'abc'},
          1,
        );

        expect(result.isFailure, isTrue);
        expect((result as Failure).error, isA<SyncError>());
      });
    });

    // -----------------------------------------------------------------------
    // downloadEntity
    // -----------------------------------------------------------------------

    group('downloadEntity', () {
      test('returns Success(null) when file not found', () async {
        _setupDownloadNotFound(mockStorage);
        final result = await provider.downloadEntity('supplements', 'ent-1');
        expect(result.isSuccess, isTrue);
        expect((result as Success).value, isNull);
      });

      test('parses and returns JSON on success', () async {
        const envelope = {'entityId': 'ent-1', 'encryptedData': 'cipher'};
        _setupDownloadSuccess(mockStorage, jsonEncode(envelope));

        final result = await provider.downloadEntity('supplements', 'ent-1');

        expect(result.isSuccess, isTrue);
        final data = (result as Success<Map<String, dynamic>?, AppError>).value;
        expect(data, isNotNull);
        expect(data!['entityId'] as String, equals('ent-1'));
        expect(data['encryptedData'] as String, equals('cipher'));
      });

      test('returns Failure on generic exception', () async {
        _setupDownloadError(mockStorage);
        final result = await provider.downloadEntity('supplements', 'ent-1');
        expect(result.isFailure, isTrue);
        expect((result as Failure).error, isA<SyncError>());
      });
    });

    // -----------------------------------------------------------------------
    // deleteEntity
    // -----------------------------------------------------------------------

    group('deleteEntity', () {
      test('calls delete and returns Success', () async {
        when(
          mockStorage.delete(
            containerId: anyNamed('containerId'),
            relativePath: anyNamed('relativePath'),
          ),
        ).thenAnswer((_) async {});

        final result = await provider.deleteEntity('supplements', 'ent-1');

        expect(result.isSuccess, isTrue);
        verify(
          mockStorage.delete(
            containerId: 'iCloud.com.bluedomecolorado.shadow',
            relativePath: 'shadow_app/data/supplements/ent-1.json',
          ),
        );
      });

      test('returns Success when file is already gone (E_FNF)', () async {
        when(
          mockStorage.delete(
            containerId: anyNamed('containerId'),
            relativePath: anyNamed('relativePath'),
          ),
        ).thenThrow(
          PlatformException(code: PlatformExceptionCode.fileNotFound),
        );

        final result = await provider.deleteEntity('supplements', 'ent-1');
        expect(result.isSuccess, isTrue);
      });

      test('returns Failure on unexpected exception', () async {
        when(
          mockStorage.delete(
            containerId: anyNamed('containerId'),
            relativePath: anyNamed('relativePath'),
          ),
        ).thenThrow(Exception('network error'));

        final result = await provider.deleteEntity('supplements', 'ent-1');
        expect(result.isFailure, isTrue);
        expect((result as Failure).error, isA<SyncError>());
      });
    });

    // -----------------------------------------------------------------------
    // getChangesSince
    // -----------------------------------------------------------------------

    group('getChangesSince', () {
      test('returns Success([]) when no files match the timestamp', () async {
        // File with contentChangeDate before sinceTimestamp
        const oldFileSecs = 1000.0; // 1000000 ms
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenAnswer(
          (_) async => [
            ICloudFile.fromMap(
              _icloudFileMap(
                relativePath: 'shadow_app/data/supplements/ent-1.json',
                contentChangeDateSecs: oldFileSecs,
              ),
            ),
          ],
        );

        final result = await provider.getChangesSince(2000000); // 2000000 ms
        expect(result.isSuccess, isTrue);
        expect((result as Success).value, isEmpty);
      });

      test('downloads and returns changed envelopes', () async {
        // 3000000 ms = 3000.0 secs
        const newFileSecs = 3000.0;
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenAnswer(
          (_) async => [
            ICloudFile.fromMap(
              _icloudFileMap(
                relativePath: 'shadow_app/data/supplements/ent-1.json',
                contentChangeDateSecs: newFileSecs,
              ),
            ),
          ],
        );

        const envelope = {
          'entityId': 'ent-1',
          'entityType': 'supplements',
          'profileId': 'p1',
          'clientId': 'c1',
          'version': 2,
          'timestamp': 3000000,
          'isDeleted': false,
          'encryptedData': 'cipher',
        };
        _setupDownloadSuccess(mockStorage, jsonEncode(envelope));

        final result = await provider.getChangesSince(1000000);
        expect(result.isSuccess, isTrue);
        final changes = (result as Success<List<SyncChange>, AppError>).value;
        expect(changes, hasLength(1));
        expect(changes[0].entityType, equals('supplements'));
        expect(changes[0].entityId, equals('ent-1'));
      });

      test('skips files outside shadow_app/data/', () async {
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenAnswer(
          (_) async => [
            ICloudFile.fromMap(
              _icloudFileMap(
                relativePath: 'shadow_app/files/photo.jpg',
                contentChangeDateSecs: 9999999,
              ),
            ),
          ],
        );

        final result = await provider.getChangesSince(0);
        expect(result.isSuccess, isTrue);
        expect((result as Success).value, isEmpty);
      });

      test('returns Failure when gather throws', () async {
        when(
          mockStorage.gather(containerId: anyNamed('containerId')),
        ).thenThrow(Exception('iCloud error'));

        final result = await provider.getChangesSince(0);
        expect(result.isFailure, isTrue);
        expect((result as Failure).error, isA<SyncError>());
      });
    });

    // -----------------------------------------------------------------------
    // uploadFile / downloadFile
    // -----------------------------------------------------------------------

    group('uploadFile', () {
      test('uploads to shadow_app/files/ prefix', () async {
        when(
          mockStorage.upload(
            containerId: anyNamed('containerId'),
            filePath: anyNamed('filePath'),
            destinationRelativePath: anyNamed('destinationRelativePath'),
            onProgress: anyNamed('onProgress'),
          ),
        ).thenAnswer((_) async {});

        final result = await provider.uploadFile(
          '/local/photo.jpg',
          'photo.jpg',
        );
        expect(result.isSuccess, isTrue);
        verify(
          mockStorage.upload(
            containerId: 'iCloud.com.bluedomecolorado.shadow',
            filePath: '/local/photo.jpg',
            destinationRelativePath: 'shadow_app/files/photo.jpg',
            onProgress: anyNamed('onProgress'),
          ),
        );
      });
    });

    group('downloadFile', () {
      test('returns Success(localPath) on successful download', () async {
        _setupDownloadSuccess(mockStorage, 'binary-content');

        final destPath = '${tempDir.path}/photo.jpg';
        final result = await provider.downloadFile('photo.jpg', destPath);
        expect(result.isSuccess, isTrue);
        expect((result as Success).value, equals(destPath));
      });

      test('returns Failure when file not found', () async {
        _setupDownloadNotFound(mockStorage);

        final destPath = '${tempDir.path}/missing.jpg';
        final result = await provider.downloadFile('missing.jpg', destPath);
        expect(result.isFailure, isTrue);
        expect((result as Failure).error, isA<SyncError>());
      });
    });
  });
}
