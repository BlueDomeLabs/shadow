// lib/presentation/providers/settings/security_provider.dart
// Tracks app lock state and responds to AppLifecycleState changes.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';

/// Represents the current lock/security state of the app.
class SecurityState {
  final bool isLocked;
  final bool isPinSet;
  final bool isBiometricAvailable;

  const SecurityState({
    this.isLocked = false,
    this.isPinSet = false,
    this.isBiometricAvailable = false,
  });

  SecurityState copyWith({
    bool? isLocked,
    bool? isPinSet,
    bool? isBiometricAvailable,
  }) => SecurityState(
    isLocked: isLocked ?? this.isLocked,
    isPinSet: isPinSet ?? this.isPinSet,
    isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
  );
}

/// Notifier managing app lock state.
///
/// Listens to [AppLifecycleState] changes to auto-lock based on the user's
/// configured [AutoLockDuration]. Registers/deregisters itself as a
/// [WidgetsBindingObserver] automatically.
class SecurityNotifier extends StateNotifier<SecurityState>
    with WidgetsBindingObserver {
  final Ref _ref;
  DateTime? _backgroundedAt;

  SecurityNotifier(this._ref) : super(const SecurityState()) {
    WidgetsBinding.instance.addObserver(this);
    _refreshPinAndBiometric();
  }

  /// Checks the current PIN and biometric availability and updates state.
  Future<void> _refreshPinAndBiometric() async {
    final service = _ref.read(securityServiceProvider);
    final pinSet = await service.isPinSet();
    final biometricAvailable = await service.isBiometricAvailable();
    state = state.copyWith(
      isPinSet: pinSet,
      isBiometricAvailable: biometricAvailable,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final settings = _ref.read(userSettingsNotifierProvider).valueOrNull;
    if (settings == null || !settings.appLockEnabled) return;

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _backgroundedAt = DateTime.now();
      // Immediately lock if configured to do so.
      if (settings.autoLockDuration.value == 0) {
        this.state = this.state.copyWith(isLocked: true);
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_backgroundedAt != null) {
        final elapsed = DateTime.now().difference(_backgroundedAt!);
        final thresholdMinutes = settings.autoLockDuration.value;
        if (thresholdMinutes == 0 || elapsed.inMinutes >= thresholdMinutes) {
          this.state = this.state.copyWith(isLocked: true);
        }
        _backgroundedAt = null;
      }
    }
  }

  /// Locks the app immediately.
  void lock() => state = state.copyWith(isLocked: true);

  /// Unlocks the app after successful authentication.
  void unlock() => state = state.copyWith(isLocked: false);

  /// Refreshes PIN and biometric availability (call after PIN is set/removed).
  Future<void> refresh() => _refreshPinAndBiometric();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Provider for app security lock state.
final securityProvider = StateNotifierProvider<SecurityNotifier, SecurityState>(
  SecurityNotifier.new,
);
