// lib/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart
// Cloud sync settings and management screen.

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart';

/// Cloud sync settings screen for managing sync configuration.
///
/// Displays current sync status, settings toggles, and device info.
/// All settings are currently disabled with "Coming Soon" — backend not yet implemented.
class CloudSyncSettingsScreen extends StatelessWidget {
  const CloudSyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cloud Sync')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sync status card
          _buildStatusCard(context, theme),
          const SizedBox(height: 16),
          // Sync settings section
          _buildSettingsSection(context, theme),
          const SizedBox(height: 16),
          // Set up button
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
              icon: const Icon(Icons.cloud_sync),
              label: const Text('Set Up Cloud Sync'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Device info section
          _buildDeviceInfoSection(context, theme),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, ThemeData theme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_off, color: Colors.grey[600], size: 28),
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
                      'Not configured',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
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

  Widget _buildDeviceInfoSection(BuildContext context, ThemeData theme) => Card(
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
          _buildInfoRow('Sync Provider', 'None'),
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
