// lib/presentation/screens/settings/settings_screen.dart
// Per 58_SETTINGS_SCREENS.md

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart';
import 'package:shadow_app/presentation/screens/notifications/notification_settings_screen.dart';
import 'package:shadow_app/presentation/screens/settings/security_settings_screen.dart';
import 'package:shadow_app/presentation/screens/settings/units_settings_screen.dart';

/// Hub screen linking all settings sections.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      children: [
        _SettingsTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Configure reminders and anchor times',
          onTap: () => _navigateTo(context, const NotificationSettingsScreen()),
        ),
        _SettingsTile(
          icon: Icons.straighten_outlined,
          title: 'Units',
          subtitle: 'Weight, volume, temperature, and energy',
          onTap: () => _navigateTo(context, const UnitsSettingsScreen()),
        ),
        _SettingsTile(
          icon: Icons.lock_outline,
          title: 'Security',
          subtitle: 'App lock, PIN, and biometric authentication',
          onTap: () => _navigateTo(context, const SecuritySettingsScreen()),
        ),
        _SettingsTile(
          icon: Icons.cloud_outlined,
          title: 'Cloud Sync',
          subtitle: 'Google Drive backup and sync status',
          onTap: () => _navigateTo(context, const CloudSyncSettingsScreen()),
        ),
      ],
    ),
  );

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
