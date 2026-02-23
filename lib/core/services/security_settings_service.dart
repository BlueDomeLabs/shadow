// lib/core/services/security_settings_service.dart
// Concrete SecurityService implementation using flutter_secure_storage,
// bcrypt (on background isolate), and local_auth.

import 'dart:isolate';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shadow_app/domain/services/security_service.dart';

const _pinHashKey = 'shadow_app_pin_hash';

/// Concrete implementation of [SecurityService].
///
/// PIN hashes are stored in [FlutterSecureStorage] as bcrypt hashes.
/// Hashing and verification run on a background isolate to avoid UI blocking.
/// Biometric authentication delegates to [LocalAuthentication].
class SecuritySettingsService implements SecurityService {
  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  SecuritySettingsService({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  }) : _storage =
           storage ??
           const FlutterSecureStorage(
             aOptions: AndroidOptions(encryptedSharedPreferences: true),
             iOptions: IOSOptions(
               accessibility: KeychainAccessibility.first_unlock,
             ),
             mOptions: MacOsOptions(
               accessibility: KeychainAccessibility.first_unlock,
               useDataProtectionKeyChain: false,
             ),
           ),
       _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<bool> isPinSet() async {
    final hash = await _storage.read(key: _pinHashKey);
    return hash != null;
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final hash = await _storage.read(key: _pinHashKey);
    if (hash == null) return false;
    // Run bcrypt check on a background isolate to avoid UI jank.
    return Isolate.run(() => BCrypt.checkpw(pin, hash));
  }

  @override
  Future<void> setPin(String pin) async {
    // bcrypt is intentionally slow — run on a background isolate.
    final hash = await Isolate.run(() => BCrypt.hashpw(pin, BCrypt.gensalt()));
    await _storage.write(key: _pinHashKey, value: hash);
  }

  @override
  Future<bool> removePin(String currentPin) async {
    final valid = await verifyPin(currentPin);
    if (!valid) return false;
    await _storage.delete(key: _pinHashKey);
    return true;
  }

  @override
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Shadow',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on Exception catch (_) {
      return false;
    }
  }
}
