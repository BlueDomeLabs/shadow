// lib/presentation/screens/settings/lock_screen.dart
// Per 58_SETTINGS_SCREENS.md — Lock Screen Behavior

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/settings/security_provider.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';
import 'package:shadow_app/presentation/screens/settings/pin_entry_screen.dart';

/// Full-screen overlay shown when the app is locked.
///
/// Attempts biometric authentication automatically on first render if
/// biometric is enabled. Falls back to PIN entry.
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  Future<void> _tryBiometric() async {
    final settings = ref.read(userSettingsNotifierProvider).valueOrNull;
    if (settings == null ||
        !settings.appLockEnabled ||
        !settings.biometricEnabled) {
      return;
    }

    final securityState = ref.read(securityProvider);
    if (!securityState.isBiometricAvailable) return;

    final service = ref.read(securityServiceProvider);
    final authenticated = await service.authenticateWithBiometrics();
    if (authenticated && mounted) {
      ref.read(securityProvider.notifier).unlock();
    }
  }

  Future<void> _showPinEntry() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const PinEntryScreen(mode: PinEntryMode.unlock),
      ),
    );
    if ((result ?? false) && mounted) {
      ref.read(securityProvider.notifier).unlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(userSettingsNotifierProvider).valueOrNull;
    final securityState = ref.watch(securityProvider);
    final showBiometric =
        settings != null &&
        settings.biometricEnabled &&
        securityState.isBiometricAvailable;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Shadow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'App is locked',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: _showPinEntry,
              icon: const Icon(Icons.lock_open),
              label: const Text('Enter PIN'),
            ),
            if (showBiometric) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _tryBiometric,
                icon: const Icon(Icons.fingerprint, color: Colors.white),
                label: const Text(
                  'Use Face ID / Fingerprint',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
