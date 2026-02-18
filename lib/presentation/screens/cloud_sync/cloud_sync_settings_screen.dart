// lib/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart
// Cloud sync settings and management screen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart';

/// Cloud sync settings screen for managing sync configuration.
///
/// Displays current sync status, settings toggles, and device info.
/// Watches [cloudSyncAuthProvider] to reflect sign-in state.
class CloudSyncSettingsScreen extends ConsumerWidget {
  const CloudSyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(cloudSyncAuthProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cloud Sync')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sync status card
          _buildStatusCard(context, theme, authState),
          const SizedBox(height: 16),
          // Sync settings section
          _buildSettingsSection(context, theme),
          // Sync Now button (only shown when authenticated)
          if (authState.isAuthenticated) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showComingSoon(context),
                icon: const Icon(Icons.sync),
                label: const Text('Sync Now'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Set up / manage button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const CloudSyncSetupScreen(),
                  ),
                );
              },
              icon: Icon(
                authState.isAuthenticated ? Icons.settings : Icons.cloud_sync,
              ),
              label: Text(
                authState.isAuthenticated
                    ? 'Manage Cloud Sync'
                    : 'Set Up Cloud Sync',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Device info section
          _buildDeviceInfoSection(context, theme, authState),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    ThemeData theme,
    CloudSyncAuthState authState,
  ) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                authState.isAuthenticated ? Icons.cloud_done : Icons.cloud_off,
                color: authState.isAuthenticated
                    ? Colors.green
                    : Colors.grey[600],
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authState.isAuthenticated
                          ? 'Connected to Google Drive'
                          : 'Not configured',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: authState.isAuthenticated
                            ? Colors.green
                            : Colors.grey[600],
                      ),
                    ),
                    if (authState.isAuthenticated &&
                        authState.userEmail != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        authState.userEmail!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildSettingsSection(BuildContext context, ThemeData theme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sync Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingToggle(
            title: 'Auto Sync',
            subtitle: 'Automatically sync data in the background',
            value: false,
            onChanged: (_) => _showComingSoon(context),
          ),
          const Divider(),
          _buildSettingToggle(
            title: 'WiFi Only',
            subtitle: 'Only sync when connected to WiFi',
            value: true,
            onChanged: (_) => _showComingSoon(context),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sync Frequency'),
            subtitle: Text(
              'Every 30 minutes',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: () => _showComingSoon(context),
          ),
        ],
      ),
    ),
  );

  Widget _buildSettingToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    subtitle: Text(subtitle),
    value: value,
    onChanged: onChanged,
  );

  Widget _buildDeviceInfoSection(
    BuildContext context,
    ThemeData theme,
    CloudSyncAuthState authState,
  ) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Info',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Platform', Theme.of(context).platform.name),
          const SizedBox(height: 8),
          _buildInfoRow(
            'Sync Provider',
            authState.isAuthenticated ? 'Google Drive' : 'None',
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Last Sync', 'Never'),
        ],
      ),
    ),
  );

  Widget _buildInfoRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.grey[600])),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    ],
  );

  void _showComingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'Cloud sync settings will be available once a sync provider is configured.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
