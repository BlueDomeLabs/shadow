// lib/presentation/screens/settings/security_settings_screen.dart
// Per 58_SETTINGS_SCREENS.md Screen 3: Security Settings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/user_settings.dart';
import 'package:shadow_app/domain/enums/settings_enums.dart';
import 'package:shadow_app/presentation/providers/settings/security_provider.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';
import 'package:shadow_app/presentation/screens/settings/pin_entry_screen.dart';

/// Screen for configuring app lock, PIN, and biometric authentication.
///
/// All options are opt-in per 58_SETTINGS_SCREENS.md — the app works fully
/// without enabling any security features.
class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsNotifierProvider);
    final securityState = ref.watch(securityProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) =>
            _buildContent(context, ref, settings, securityState),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserSettings settings,
    SecurityState securityState,
  ) {
    void update(UserSettings updated) {
      ref.read(userSettingsNotifierProvider.notifier).save(updated);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Master toggle
          SwitchListTile(
            title: const Text('Enable App Lock'),
            subtitle: const Text('Require authentication to open Shadow'),
            value: settings.appLockEnabled,
            onChanged: (enabled) async {
              if (enabled && !securityState.isPinSet) {
                // Must set a PIN before enabling app lock.
                final pinSet = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) =>
                        const PinEntryScreen(mode: PinEntryMode.setup),
                  ),
                );
                if (pinSet ?? false) {
                  await ref.read(securityProvider.notifier).refresh();
                  update(settings.copyWith(appLockEnabled: true));
                }
              } else {
                update(settings.copyWith(appLockEnabled: enabled));
              }
            },
          ),
          if (settings.appLockEnabled) ...[
            const Divider(),
            const _SectionHeader('Authentication Method'),
            if (securityState.isBiometricAvailable)
              SwitchListTile(
                title: const Text('Biometric Authentication'),
                subtitle: const Text('Use Face ID or fingerprint'),
                value: settings.biometricEnabled,
                onChanged: (v) =>
                    update(settings.copyWith(biometricEnabled: v)),
              )
            else
              const ListTile(
                title: Text('Biometric Authentication'),
                subtitle: Text('Not available on this device'),
                enabled: false,
              ),
            if (securityState.isPinSet) ...[
              ListTile(
                title: const Text('Change PIN'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) =>
                          const PinEntryScreen(mode: PinEntryMode.change),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Remove PIN'),
                textColor: Colors.red,
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final removed = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) =>
                          const PinEntryScreen(mode: PinEntryMode.remove),
                    ),
                  );
                  if (removed ?? false) {
                    await ref.read(securityProvider.notifier).refresh();
                    // Disable app lock when PIN is removed.
                    update(
                      settings.copyWith(
                        appLockEnabled: false,
                        biometricEnabled: false,
                      ),
                    );
                  }
                },
              ),
            ] else
              ListTile(
                title: const Text('Set PIN'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final pinSet = await Navigator.of(context).push<bool>(
                    MaterialPageRoute<bool>(
                      builder: (_) =>
                          const PinEntryScreen(mode: PinEntryMode.setup),
                    ),
                  );
                  if (pinSet ?? false) {
                    await ref.read(securityProvider.notifier).refresh();
                  }
                },
              ),
            const Divider(),
            const _SectionHeader('Auto-Lock Timing'),
            RadioGroup<AutoLockDuration>(
              groupValue: settings.autoLockDuration,
              onChanged: (v) {
                if (v != null) update(settings.copyWith(autoLockDuration: v));
              },
              child: Column(
                children: AutoLockDuration.values
                    .map(
                      (d) => RadioListTile<AutoLockDuration>(
                        title: Text(d.label),
                        value: d,
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(),
            const _SectionHeader('Additional Options'),
            SwitchListTile(
              title: const Text('Hide in App Switcher'),
              subtitle: const Text(
                'Show a blank screen in the app switcher instead of app content',
              ),
              value: settings.hideInAppSwitcher,
              onChanged: (v) => update(settings.copyWith(hideInAppSwitcher: v)),
            ),
            if (settings.biometricEnabled && securityState.isPinSet)
              SwitchListTile(
                title: const Text('Allow Biometric to Bypass PIN'),
                subtitle: const Text(
                  'Use Face ID / fingerprint instead of entering your PIN',
                ),
                value: settings.allowBiometricBypassPin,
                onChanged: (v) =>
                    update(settings.copyWith(allowBiometricBypassPin: v)),
              ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    ),
  );
}
