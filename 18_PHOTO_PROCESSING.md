# Shadow Photo Processing Specification

**Version:** 1.0
**Last Updated:** January 31, 2026
**Purpose:** Complete specification for photo capture, compression, and storage

---

## 1. Overview

Shadow captures photos for health documentation (conditions, flare-ups, bowel tracking, etc.). All photos must be processed before storage to:
- Reduce file size for efficient sync
- Remove sensitive metadata (EXIF)
- Maintain sufficient quality for medical documentation
- Ensure consistent format across platforms

---

## 2. Photo Capture Sources

### 2.1 Supported Sources

| Source | Platform | Implementation |
|--------|----------|----------------|
| Camera (live capture) | iOS, Android, macOS | `image_picker` camera |
| Photo Library | iOS, Android, macOS | `image_picker` gallery |
| File System | macOS | Native file picker |
| Drag & Drop | macOS | Flutter drop target |

### 2.2 Capture Configuration

```dart
// lib/core/services/photo_capture_service.dart

class PhotoCaptureService {
  static const ImagePickerConfig _cameraConfig = ImagePickerConfig(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.rear,
    maxWidth: 2048,  // Capture at max 2048px width
    maxHeight: 2048, // Capture at max 2048px height
    imageQuality: 90, // Initial capture quality
  );

  static const ImagePickerConfig _galleryConfig = ImagePickerConfig(
    source: ImageSource.gallery,
    maxWidth: 2048,
    maxHeight: 2048,
    imageQuality: 90,
  );

  Future<ProcessedPhoto?> captureFromCamera() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: _cameraConfig.maxWidth,
      maxHeight: _cameraConfig.maxHeight,
      imageQuality: _cameraConfig.imageQuality,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image == null) return null;
    return await _processPhoto(image);
  }

  Future<ProcessedPhoto?> selectFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: _galleryConfig.maxWidth,
      maxHeight: _galleryConfig.maxHeight,
      imageQuality: _galleryConfig.imageQuality,
    );

    if (image == null) return null;
    return await _processPhoto(image);
  }
}
```

---

## 3. Photo Processing Pipeline

### 3.1 Processing Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PHOTO PROCESSING PIPELINE                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. CAPTURE/SELECT                                                  │
│     └── Raw image from camera or gallery                           │
│                    │                                                │
│                    ▼                                                │
│  2. FORMAT VALIDATION                                               │
│     ├── Check file type (JPEG, PNG, HEIC only)                     │
│     ├── Convert HEIC → JPEG (if needed)                            │
│     └── Reject unsupported formats                                 │
│                    │                                                │
│                    ▼                                                │
│  3. SIZE CHECK                                                      │
│     ├── If > 2048px on any dimension → resize                      │
│     └── Maintain aspect ratio                                      │
│                    │                                                │
│                    ▼                                                │
│  4. COMPRESSION                                                     │
│     ├── Target: ≤ 500 KB for standard photos                       │
│     ├── Target: ≤ 1 MB for high-detail (condition baseline)        │
│     ├── JPEG quality: Start at 85%, reduce if needed               │
│     └── Minimum quality: 60% (never go below)                      │
│                    │                                                │
│                    ▼                                                │
│  5. METADATA STRIPPING                                              │
│     ├── Remove ALL EXIF data                                       │
│     ├── Remove GPS coordinates                                     │
│     ├── Remove camera/device info                                  │
│     ├── Remove timestamps (we track separately)                    │
│     └── Keep only essential image data                             │
│                    │                                                │
│                    ▼                                                │
│  6. INTEGRITY HASH                                                  │
│     └── Calculate SHA-256 for sync verification                    │
│                    │                                                │
│                    ▼                                                │
│  7. ENCRYPTION                                                      │
│     └── AES-256-GCM encrypt before storage                         │
│                    │                                                │
│                    ▼                                                │
│  8. STORAGE                                                         │
│     ├── Save to app documents directory                            │
│     ├── Update database with file reference                        │
│     └── Queue for cloud sync (if enabled)                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.2 Processing Implementation

```dart
// lib/core/services/photo_processing_service.dart

import 'package:image/image.dart' as img;

class PhotoProcessingService {
  // Size limits
  static const int maxDimension = 2048;
  static const int targetFileSizeStandard = 500 * 1024;   // 500 KB
  static const int targetFileSizeHighDetail = 1024 * 1024; // 1 MB
  static const int absoluteMaxFileSize = 2 * 1024 * 1024;  // 2 MB hard limit

  // Quality settings
  static const int initialQuality = 85;
  static const int minimumQuality = 60;
  static const int qualityStep = 5;

  final EncryptionService _encryptionService;

  Future<ProcessedPhoto> processPhoto(
    File inputFile, {
    PhotoQualityTier tier = PhotoQualityTier.standard,
  }) async {
    // 1. Read and decode image
    final bytes = await inputFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw PhotoProcessingException('Unable to decode image');
    }

    // 2. Convert HEIC if needed (handled by image package)
    // The image package automatically converts HEIC to standard format

    // 3. Resize if exceeds max dimensions
    if (image.width > maxDimension || image.height > maxDimension) {
      image = _resizeToFit(image, maxDimension);
    }

    // 4. Strip EXIF metadata
    image = _stripMetadata(image);

    // 5. Compress to target size
    final targetSize = tier == PhotoQualityTier.highDetail
        ? targetFileSizeHighDetail
        : targetFileSizeStandard;

    final compressedBytes = await _compressToTargetSize(image, targetSize);

    // 6. Calculate integrity hash
    final hash = sha256.convert(compressedBytes).toString();

    // 7. Encrypt
    final encryptedBytes = await _encryptionService.encryptBytes(
      Uint8List.fromList(compressedBytes),
    );

    // 8. Save to storage
    final outputPath = await _saveToStorage(encryptedBytes);

    return ProcessedPhoto(
      localPath: outputPath,
      originalWidth: image.width,
      originalHeight: image.height,
      fileSizeBytes: compressedBytes.length,
      encryptedSizeBytes: encryptedBytes.length,
      hash: hash,
      processedAt: DateTime.now(),
    );
  }

  img.Image _resizeToFit(img.Image image, int maxDim) {
    if (image.width > image.height) {
      // Landscape
      return img.copyResize(image, width: maxDim);
    } else {
      // Portrait or square
      return img.copyResize(image, height: maxDim);
    }
  }

  img.Image _stripMetadata(img.Image image) {
    // Create new image without EXIF data
    return img.Image.from(image)
      ..exif.clear();
  }

  Future<List<int>> _compressToTargetSize(
    img.Image image,
    int targetSizeBytes,
  ) async {
    int quality = initialQuality;
    List<int> compressed;

    do {
      compressed = img.encodeJpg(image, quality: quality);

      if (compressed.length <= targetSizeBytes) {
        break;
      }

      quality -= qualityStep;
    } while (quality >= minimumQuality);

    // If still too large at minimum quality, resize further
    if (compressed.length > absoluteMaxFileSize) {
      final smallerImage = _resizeToFit(image, maxDimension ~/ 2);
      compressed = img.encodeJpg(smallerImage, quality: minimumQuality);
    }

    return compressed;
  }

  Future<String> _saveToStorage(Uint8List encryptedBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${directory.path}/photos');
    await photosDir.create(recursive: true);

    final filename = '${const Uuid().v4()}.enc';
    final file = File('${photosDir.path}/$filename');
    await file.writeAsBytes(encryptedBytes);

    return file.path;
  }
}

enum PhotoQualityTier {
  standard,    // 500 KB target - daily logs, general photos
  highDetail,  // 1 MB target - condition baselines, medical documentation
}

// ===== FAILURE HANDLING =====

class PhotoProcessingException implements Exception {
  final String message;
  final PhotoProcessingError error;
  final String? details;

  PhotoProcessingException(this.message, this.error, [this.details]);
}

enum PhotoProcessingError {
  unsupportedFormat,     // File type not supported
  decodeFailure,         // Unable to decode image data
  fileTooLarge,          // Input exceeds 10MB limit
  compressionFailure,    // Unable to compress to target size
  encryptionFailure,     // Encryption failed
  storageFailure,        // Unable to write to storage
  insufficientStorage,   // Device storage full
}

/// Compression workflow with failure handling
class PhotoCompressionWorkflow {
  /// When compression happens:
  /// 1. ALWAYS after capture/selection (never store uncompressed)
  /// 2. Synchronously in the capture flow (user waits)
  /// 3. Before encryption (compress plaintext, then encrypt)

  static Future<Result<ProcessedPhoto, PhotoProcessingError>> process(
    File input,
    PhotoQualityTier tier,
  ) async {
    // Input validation: 10MB max raw input
    final inputSize = await input.length();
    if (inputSize > 10 * 1024 * 1024) {
      return Failure(PhotoProcessingError.fileTooLarge);
    }

    try {
      // Attempt processing...
      final result = await _processPhoto(input, tier);
      return Success(result);
    } on PhotoProcessingException catch (e) {
      return Failure(e.error);
    }
  }

  /// Failure recovery strategies
  static String getUserMessage(PhotoProcessingError error) => switch (error) {
    PhotoProcessingError.unsupportedFormat =>
      'This image format is not supported. Please use JPEG, PNG, or HEIC.',
    PhotoProcessingError.decodeFailure =>
      'Unable to read this image. The file may be corrupted.',
    PhotoProcessingError.fileTooLarge =>
      'This image is too large (max 10MB). Please choose a smaller image.',
    PhotoProcessingError.compressionFailure =>
      'Unable to process this image. Please try a different photo.',
    PhotoProcessingError.encryptionFailure =>
      'Security error. Please restart the app and try again.',
    PhotoProcessingError.storageFailure =>
      'Unable to save photo. Please check storage permissions.',
    PhotoProcessingError.insufficientStorage =>
      'Device storage is full. Please free up space and try again.',
  };
}

@freezed
class ProcessedPhoto with _$ProcessedPhoto {
  const factory ProcessedPhoto({
    required String localPath,
    required int originalWidth,
    required int originalHeight,
    required int fileSizeBytes,
    required int encryptedSizeBytes,
    required String hash,
    required DateTime processedAt,
  }) = _ProcessedPhoto;
}
```

---

## 4. Format Specifications

### 4.1 Supported Input Formats

| Format | Extension | Support | Notes |
|--------|-----------|---------|-------|
| JPEG | .jpg, .jpeg | Full | Primary format |
| PNG | .png | Full | Converted to JPEG |
| HEIC | .heic, .heif | Convert | iOS format → JPEG |
| WebP | .webp | Convert | Android format → JPEG |
| GIF | .gif | Reject | Not suitable for medical photos |
| BMP | .bmp | Convert | Legacy format → JPEG |
| TIFF | .tiff, .tif | Reject | Too large, medical-specific |
| RAW | .raw, .cr2, .nef | Reject | Professional format, too large |

### 4.2 Output Format

**All photos stored as:**
- Format: JPEG
- Color space: sRGB
- Bit depth: 8-bit
- Extension: `.enc` (encrypted)

### 4.3 Dimension Limits

| Photo Type | Max Width | Max Height | Min Width | Min Height |
|------------|-----------|------------|-----------|------------|
| Standard | 2048 px | 2048 px | 100 px | 100 px |
| Thumbnail | 256 px | 256 px | - | - |
| Preview | 512 px | 512 px | - | - |

---

## 5. Metadata Stripping

### 5.1 Removed Metadata Fields

**ALL of the following are stripped:**

| Category | Fields Removed |
|----------|----------------|
| **GPS** | GPSLatitude, GPSLongitude, GPSAltitude, GPSTimeStamp, GPSDateStamp |
| **Camera** | Make, Model, Software, LensModel, SerialNumber |
| **Settings** | ExposureTime, FNumber, ISO, FocalLength, Flash |
| **Date/Time** | DateTimeOriginal, DateTimeDigitized, DateTime |
| **Author** | Artist, Copyright, ImageDescription |
| **Device** | HostComputer, DeviceSettingDescription |
| **Thumbnail** | Embedded thumbnail images |
| **Custom** | All XMP data, IPTC data, maker notes |

### 5.2 Implementation

```dart
img.Image _stripMetadata(img.Image image) {
  // Create a clean copy with no EXIF data
  final cleanImage = img.Image(
    width: image.width,
    height: image.height,
    format: image.format,
    numChannels: image.numChannels,
  );

  // Copy only pixel data
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      cleanImage.setPixel(x, y, image.getPixel(x, y));
    }
  }

  return cleanImage;
}
```

### 5.3 Verification

```dart
Future<bool> verifyMetadataStripped(File processedFile) async {
  final bytes = await processedFile.readAsBytes();
  final image = img.decodeImage(bytes);

  if (image == null) return false;

  // Check no EXIF data exists
  return image.exif.isEmpty;
}
```

---

## 6. Thumbnail Generation

### 6.1 Thumbnail Specifications

| Property | Value |
|----------|-------|
| Size | 256 x 256 px (fit within, maintain aspect) |
| Format | JPEG |
| Quality | 70% |
| Storage | Separate file, same encryption |
| Naming | `{photo_id}_thumb.enc` |

### 6.2 Implementation

```dart
Future<ProcessedPhoto> generateThumbnail(ProcessedPhoto original) async {
  // Decrypt and decode original
  final decryptedBytes = await _encryptionService.decryptFile(original.localPath);
  final image = img.decodeImage(decryptedBytes);

  if (image == null) {
    throw PhotoProcessingException('Cannot decode original for thumbnail');
  }

  // Resize to thumbnail
  final thumbnail = img.copyResize(
    image,
    width: 256,
    height: 256,
    interpolation: img.Interpolation.average,
  );

  // Compress
  final compressed = img.encodeJpg(thumbnail, quality: 70);

  // Encrypt and save
  final encrypted = await _encryptionService.encryptBytes(
    Uint8List.fromList(compressed),
  );

  final thumbPath = original.localPath.replaceAll('.enc', '_thumb.enc');
  await File(thumbPath).writeAsBytes(encrypted);

  return ProcessedPhoto(
    localPath: thumbPath,
    originalWidth: thumbnail.width,
    originalHeight: thumbnail.height,
    fileSizeBytes: compressed.length,
    encryptedSizeBytes: encrypted.length,
    hash: sha256.convert(compressed).toString(),
    processedAt: DateTime.now(),
  );
}
```

---

## 7. Photo Comparison Feature

### 7.1 Comparison View Requirements

For tracking condition progress, users compare photos over time:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PHOTO COMPARISON VIEW                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  [Jan 15, 2026]              [Jan 30, 2026]                        │
│  ┌─────────────────┐         ┌─────────────────┐                   │
│  │                 │         │                 │                   │
│  │   [Photo 1]     │  <--->  │   [Photo 2]     │                   │
│  │                 │         │                 │                   │
│  └─────────────────┘         └─────────────────┘                   │
│                                                                     │
│  [<< Prev]   Swipe to compare   [Next >>]                          │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Timeline: [o--o-----o--------o----o]                        │   │
│  │           Jan 1    Jan 10    Jan 20   Jan 30   Today        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.2 Comparison Requirements

- Same photo area required for meaningful comparison
- Side-by-side view with synchronized zoom
- Overlay/slider mode for precise comparison
- Timeline scrubber for date selection
- Notes visible for each photo

---

## 8. Storage Management

### 8.1 Storage Locations

```
Documents/
├── photos/
│   ├── {uuid}.enc           # Full-size encrypted photos
│   └── {uuid}_thumb.enc     # Thumbnail versions
├── temp/
│   └── processing/          # Temporary during processing
└── cache/
    └── photos/              # Decrypted cache (cleared on app close)
```

### 8.2 Cache Management

```dart
class PhotoCacheService {
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const int maxCacheItems = 50;

  final LruCache<String, Uint8List> _memoryCache;
  final Directory _diskCache;

  Future<Uint8List> getDecrypted(String photoId) async {
    // Check memory cache
    if (_memoryCache.containsKey(photoId)) {
      return _memoryCache[photoId]!;
    }

    // Check disk cache
    final diskFile = File('${_diskCache.path}/$photoId.jpg');
    if (await diskFile.exists()) {
      final bytes = await diskFile.readAsBytes();
      _memoryCache[photoId] = bytes;
      return bytes;
    }

    // Decrypt from storage
    final encrypted = await File(_getEncryptedPath(photoId)).readAsBytes();
    final decrypted = await _encryptionService.decryptBytes(encrypted);

    // Cache it
    await diskFile.writeAsBytes(decrypted);
    _memoryCache[photoId] = decrypted;

    // Enforce cache limits
    await _enforceCache Limits();

    return decrypted;
  }

  Future<void> clearCache() async {
    _memoryCache.clear();
    await _diskCache.delete(recursive: true);
    await _diskCache.create();
  }
}
```

### 8.3 Cleanup on Delete

When a photo is deleted:
1. Mark database record as deleted (soft delete)
2. Delete encrypted file from disk
3. Delete thumbnail file
4. Clear from cache
5. Queue deletion from cloud (if synced)

---

## 9. Error Handling

| Error | Cause | User Message | Recovery |
|-------|-------|--------------|----------|
| `UnsupportedFormat` | GIF, TIFF, RAW file | "This image format is not supported. Please use JPEG, PNG, or HEIC." | Show format list |
| `FileTooLarge` | > 50 MB input file | "This image is too large. Maximum size is 50 MB." | Suggest resize |
| `ProcessingFailed` | Decode error | "Unable to process this image. Please try a different photo." | Retry or different image |
| `StorageFull` | Disk full | "Not enough storage space. Free up space to save photos." | Show storage settings |
| `EncryptionFailed` | Key unavailable | "Unable to secure this photo. Please restart the app." | Force key refresh |

---

## 10. Performance Targets

| Operation | Target | Maximum |
|-----------|--------|---------|
| Capture to save | < 2 seconds | 5 seconds |
| Gallery import | < 3 seconds | 8 seconds |
| Thumbnail generation | < 500 ms | 1 second |
| Photo display (cached) | < 100 ms | 200 ms |
| Photo display (decrypt) | < 500 ms | 1 second |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-31 | Initial release - complete photo processing specification |
