// lib/domain/services/security_service.dart
// Abstract interface for PIN and biometric authentication per 58_SETTINGS_SCREENS.md

/// Abstract security service for PIN management and biometric authentication.
///
/// PIN is stored as a bcrypt hash in flutter_secure_storage — never as plain
/// text. Biometric authentication delegates to the platform via local_auth.
///
/// Tests implement this interface with fakes rather than touching real storage.
abstract class SecurityService {
  /// Returns true if a PIN has been set.
  Future<bool> isPinSet();

  /// Verifies [pin] against the stored bcrypt hash.
  ///
  /// Returns false if no PIN is set or the PIN does not match.
  Future<bool> verifyPin(String pin);

  /// Stores a bcrypt hash of [pin] in secure storage.
  ///
  /// Replaces any existing PIN hash. The hash is computed on a background
  /// isolate to avoid blocking the UI thread.
  Future<void> setPin(String pin);

  /// Removes the stored PIN hash from secure storage.
  ///
  /// Requires the correct [currentPin] for confirmation.
  /// Returns false if [currentPin] is wrong.
  Future<bool> removePin(String currentPin);

  /// Returns true if the device supports biometric authentication.
  Future<bool> isBiometricAvailable();

  /// Prompts the user for biometric authentication.
  ///
  /// Returns true if authentication succeeded, false if cancelled or failed.
  Future<bool> authenticateWithBiometrics();
}
