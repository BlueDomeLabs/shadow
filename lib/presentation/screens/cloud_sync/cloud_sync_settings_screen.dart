// lib/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart
// Cloud sync settings and management screen.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart';

/// Cloud sync settings screen for managing sync configuration.
///
/// Displays current sync status, settings toggles, and device info.
/// Watches [cloudSyncAuthProvider] to reflect sign-in state.
class CloudSyncSettingsScreen extends ConsumerStatefulWidget {
  const CloudSyncSettingsScreen({super.key});

  @override
  ConsumerState<CloudSyncSettingsScreen> createState() =>
      _CloudSyncSettingsScreenState();
}

class _CloudSyncSettingsScreenState
    extends ConsumerState<CloudSyncSettingsScreen> {
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
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
                onPressed: _isSyncing ? null : () => _syncNow(context),
                icon: _isSyncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
                label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
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

  Future<void> _syncNow(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final profileId = ref.read(profileProvider).currentProfileId;

    if (profileId == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No profile selected')),
      );
      return;
    }

    setState(() => _isSyncing = true);

    try {
      final syncSvc = ref.read(syncServiceProvider);
      var uploaded = 0;
      var downloaded = 0;
      var conflicts = 0;

      // 1. Pull remote changes first (get latest from cloud)
      final pullResult = await syncSvc.pullChanges(profileId);
      if (pullResult.isSuccess) {
        final pulled = pullResult.valueOrNull!;
        if (pulled.isNotEmpty) {
          final applyResult = await syncSvc.applyChanges(profileId, pulled);
          if (applyResult.isSuccess) {
            final r = applyResult.valueOrNull!;
            downloaded = r.appliedCount;
            conflicts = r.conflictCount;
          }
        }
      }

      // 2. Push local changes
      final pendingResult = await syncSvc.getPendingChanges(profileId);
      if (pendingResult.isSuccess) {
        final changes = pendingResult.valueOrNull!;
        if (changes.isNotEmpty) {
          final pushResult = await syncSvc.pushChanges(changes);
          if (pushResult.isSuccess) {
            uploaded = pushResult.valueOrNull!.pushedCount;
          }
        }
      }

      // 3. Show summary
      final parts = <String>[];
      if (uploaded > 0) parts.add('$uploaded uploaded');
      if (downloaded > 0) parts.add('$downloaded downloaded');
      if (conflicts > 0) parts.add('$conflicts conflicts');

      final message = parts.isEmpty
          ? 'Sync complete - all up to date'
          : 'Sync complete: ${parts.join(', ')}';

      debugPrint('[SyncNow] $message');
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Sync error: $e')));
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

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
