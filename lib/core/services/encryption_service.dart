// lib/core/services/encryption_service.dart - SHADOW-009 Implementation
// Implements AES-256-GCM encryption per 11_SECURITY_GUIDELINES.md Section 2.2

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

/// Exception thrown when decryption fails due to invalid format or tampering.
class DecryptionException implements Exception {
  final String message;
  DecryptionException(this.message);

  @override
  String toString() => 'DecryptionException: $message';
}

/// AES-256-GCM encryption service for field-level encryption.
///
/// Provides authenticated encryption with associated data (AEAD) using
/// AES-256-GCM mode. GCM provides both confidentiality and integrity.
///
/// Usage:
/// ```dart
/// final service = EncryptionService(FlutterSecureStorage());
/// await service.initialize();
///
/// final encrypted = await service.encrypt('sensitive data');
/// final decrypted = await service.decrypt(encrypted);
/// ```
///
/// IMPORTANT: Never log plaintext or encryption keys.
/// See 11_SECURITY_GUIDELINES.md for security requirements.
class EncryptionService {
  static const String _keyStorageKey = 'shadow_encryption_key_v1';
  static const int _keyLengthBytes = 32; // 256 bits
  static const int _nonceLengthBytes = 12; // 96 bits for GCM
  static const int _tagLengthBits = 128; // 128-bit authentication tag

  final FlutterSecureStorage _secureStorage;
  Uint8List? _secretKey;

  /// Creates an EncryptionService with the given secure storage.
  EncryptionService(this._secureStorage);

  /// Initializes the service by loading or generating the encryption key.
  ///
  /// Must be called before encrypt() or decrypt().
  Future<void> initialize() async {
    final storedKey = await _secureStorage.read(key: _keyStorageKey);
    if (storedKey != null) {
      _secretKey = base64Decode(storedKey);
    } else {
      _secretKey = generateKey();
      await _secureStorage.write(
        key: _keyStorageKey,
        value: base64Encode(_secretKey!),
      );
    }
  }

  /// Generates a new 256-bit cryptographically secure random key.
  ///
  /// Returns the key as raw bytes. For storage, use base64 encoding.
  Uint8List generateKey() {
    final secureRandom = Random.secure();
    return Uint8List.fromList(
      List.generate(_keyLengthBytes, (_) => secureRandom.nextInt(256)),
    );
  }

  /// Encrypts plaintext using AES-256-GCM.
  ///
  /// Returns a string in format: `nonce:ciphertext:tag` (all base64 encoded).
  /// The nonce is unique per operation, ensuring security even with repeated
  /// plaintext values.
  ///
  /// Throws [StateError] if the service has not been initialized.
  Future<String> encrypt(String plaintext) async {
    if (_secretKey == null) {
      throw StateError(
        'EncryptionService not initialized. Call initialize() first.',
      );
    }

    // Generate unique nonce for this operation
    final nonce = _generateNonce();

    // Create GCM cipher
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true, // forEncryption
        AEADParameters(
          KeyParameter(_secretKey!),
          _tagLengthBits,
          nonce,
          Uint8List(0), // No additional authenticated data
        ),
      );

    // Encrypt the plaintext
    final plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
    final ciphertextWithTag = Uint8List(
      cipher.getOutputSize(plaintextBytes.length),
    );

    var offset = cipher.processBytes(
      plaintextBytes,
      0,
      plaintextBytes.length,
      ciphertextWithTag,
      0,
    );
    offset += cipher.doFinal(ciphertextWithTag, offset);

    // GCM appends the tag to the ciphertext, split them
    const tagLength = _tagLengthBits ~/ 8;
    final ciphertext = ciphertextWithTag.sublist(0, offset - tagLength);
    final tag = ciphertextWithTag.sublist(offset - tagLength, offset);

    // Return format: nonce:ciphertext:tag (all base64)
    return '${base64Encode(nonce)}:${base64Encode(ciphertext)}:${base64Encode(tag)}';
  }

  /// Decrypts ciphertext that was encrypted with [encrypt].
  ///
  /// Input must be in format: `nonce:ciphertext:tag` (all base64 encoded).
  ///
  /// Throws [DecryptionException] if the format is invalid or authentication fails.
  /// Throws [StateError] if the service has not been initialized.
  Future<String> decrypt(String encrypted) async {
    if (_secretKey == null) {
      throw StateError(
        'EncryptionService not initialized. Call initialize() first.',
      );
    }

    // Parse the encrypted format
    final parts = encrypted.split(':');
    if (parts.length != 3) {
      throw DecryptionException(
        'Invalid format: expected nonce:ciphertext:tag',
      );
    }

    final Uint8List nonce;
    final Uint8List ciphertext;
    final Uint8List tag;

    try {
      nonce = Uint8List.fromList(base64Decode(parts[0]));
      ciphertext = Uint8List.fromList(base64Decode(parts[1]));
      tag = Uint8List.fromList(base64Decode(parts[2]));
    } on FormatException {
      throw DecryptionException('Invalid base64 encoding');
    }

    // Validate lengths
    if (nonce.length != _nonceLengthBytes) {
      throw DecryptionException('Invalid nonce length');
    }
    if (tag.length != _tagLengthBits ~/ 8) {
      throw DecryptionException('Invalid tag length');
    }

    // Create GCM cipher for decryption
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false, // forDecryption
        AEADParameters(
          KeyParameter(_secretKey!),
          _tagLengthBits,
          nonce,
          Uint8List(0), // No additional authenticated data
        ),
      );

    // Combine ciphertext and tag for GCM processing
    final ciphertextWithTag = Uint8List(ciphertext.length + tag.length)
      ..setRange(0, ciphertext.length, ciphertext)
      ..setRange(ciphertext.length, ciphertext.length + tag.length, tag);

    // Decrypt and verify authentication
    try {
      final plaintext = Uint8List(
        cipher.getOutputSize(ciphertextWithTag.length),
      );
      var offset = cipher.processBytes(
        ciphertextWithTag,
        0,
        ciphertextWithTag.length,
        plaintext,
        0,
      );
      offset += cipher.doFinal(plaintext, offset);

      return utf8.decode(plaintext.sublist(0, offset));
    } on InvalidCipherTextException {
      throw DecryptionException('Authentication failed: data may be tampered');
    }
  }

  /// Generates a cryptographically secure random nonce.
  Uint8List _generateNonce() {
    final secureRandom = Random.secure();
    return Uint8List.fromList(
      List.generate(_nonceLengthBytes, (_) => secureRandom.nextInt(256)),
    );
  }

  /// Returns whether the service has been initialized.
  bool get isInitialized => _secretKey != null;
}
