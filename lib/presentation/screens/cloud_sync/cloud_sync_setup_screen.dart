// lib/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart
// First-time cloud sync setup wizard.

import 'dart:io';

import 'package:flutter/material.dart';

/// First-time cloud sync setup screen with onboarding wizard.
///
/// Displays benefits of cloud sync and provider selection buttons.
/// All providers currently show "Coming Soon" — backend not yet implemented.
class CloudSyncSetupScreen extends StatelessWidget {
  const CloudSyncSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Cloud sync setup screen',
      child: Scaffold(
        appBar: AppBar(title: const Text('Set Up Cloud Sync')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              // Cloud icon header
              Semantics(
                image: true,
                label: 'Cloud sync icon',
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cloud_sync,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Semantics(
                header: true,
                child: Text(
                  'Back Up and Sync Your Data',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Keep your health data safe and accessible across devices.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Benefits list
              _buildBenefitItem(
                context,
                icon: Icons.backup,
                title: 'Automatic Backup',
                description: 'Never lose your data — automatic cloud backup',
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                context,
                icon: Icons.sync,
                title: 'Multi-Device Sync',
                description: 'Access your data from any device',
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                context,
                icon: Icons.security,
                title: 'Secure & Private',
                description: 'End-to-end encrypted for your privacy',
              ),
              const SizedBox(height: 48),
              // Provider buttons
              _buildProviderButton(
                context,
                icon: Icons.cloud_circle,
                title: 'Google Drive',
                subtitle: 'Use your Google account for sync',
                onTap: () => _showComingSoon(context),
              ),
              const SizedBox(height: 12),
              if (Platform.isIOS || Platform.isMacOS) ...[
                _buildProviderButton(
                  context,
                  icon: Icons.cloud,
                  title: 'iCloud',
                  subtitle: 'Use your Apple account for sync',
                  onTap: () => _showComingSoon(context),
                ),
                const SizedBox(height: 12),
              ],
              _buildProviderButton(
                context,
                icon: Icons.smartphone,
                title: 'Local Only',
                subtitle: 'Store all data on this device only',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),
              // Skip button
              Semantics(
                button: true,
                label: 'Skip cloud sync setup',
                hint: 'Double tap to skip cloud sync',
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Maybe Later'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProviderButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: '$title. $subtitle',
      hint: 'Double tap to select $title for cloud sync',
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 32, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text(
          'Cloud sync is not yet available. '
          'Your data is safely stored on this device.',
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
