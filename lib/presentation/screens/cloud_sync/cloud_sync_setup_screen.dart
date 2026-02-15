// lib/presentation/screens/cloud_sync/cloud_sync_setup_screen.dart
// First-time cloud sync setup wizard.
// Phase 1c: Wired to real GoogleDriveProvider sign-in.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/cloud_sync/cloud_sync_auth_provider.dart';

/// First-time cloud sync setup screen with onboarding wizard.
///
/// Displays benefits of cloud sync and provider selection buttons.
/// Google Drive button triggers real OAuth sign-in flow.
/// After successful sign-in, shows signed-in state with user email.
class CloudSyncSetupScreen extends ConsumerWidget {
  const CloudSyncSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(cloudSyncAuthProvider);
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
                label: authState.isAuthenticated
                    ? 'Cloud sync connected'
                    : 'Cloud sync icon',
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: authState.isAuthenticated
                        ? Colors.green.withValues(alpha: 0.15)
                        : theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    authState.isAuthenticated
                        ? Icons.cloud_done
                        : Icons.cloud_sync,
                    size: 80,
                    color: authState.isAuthenticated
                        ? Colors.green
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title changes based on auth state
              Semantics(
                header: true,
                child: Text(
                  authState.isAuthenticated
                      ? 'Cloud Sync Connected'
                      : 'Back Up and Sync Your Data',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                authState.isAuthenticated
                    ? 'Signed in as ${authState.userEmail ?? "unknown"}'
                    : 'Keep your health data safe and accessible across devices.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Show error if present
              if (authState.errorMessage != null) ...[
                _buildErrorBanner(context, ref, authState.errorMessage!),
                const SizedBox(height: 24),
              ],
              // Show signed-in state or provider selection
              if (authState.isAuthenticated)
                _buildSignedInSection(context, ref, authState)
              else ...[
                // Benefits list (only shown before sign-in)
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
                _buildGoogleDriveButton(context, ref, authState),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleDriveButton(
    BuildContext context,
    WidgetRef ref,
    CloudSyncAuthState authState,
  ) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: authState.isLoading
          ? 'Signing in to Google Drive'
          : 'Google Drive. Use your Google account for sync',
      hint: authState.isLoading
          ? 'Sign-in in progress'
          : 'Double tap to select Google Drive for cloud sync',
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: authState.isLoading
              ? null
              : () =>
                    ref.read(cloudSyncAuthProvider.notifier).signInWithGoogle(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (authState.isLoading)
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                else
                  Icon(
                    Icons.cloud_circle,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.isLoading ? 'Signing in...' : 'Google Drive',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authState.isLoading
                            ? 'Complete sign-in in your browser'
                            : 'Use your Google account for sync',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!authState.isLoading)
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignedInSection(
    BuildContext context,
    WidgetRef ref,
    CloudSyncAuthState authState,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Signed-in info card
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 32, color: Colors.green),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Google Drive',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authState.userEmail ?? 'Connected',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Done button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Done'),
          ),
        ),
        const SizedBox(height: 12),
        // Sign out button
        Semantics(
          button: true,
          label: 'Sign out from Google Drive',
          child: TextButton(
            onPressed: authState.isLoading
                ? null
                : () => ref.read(cloudSyncAuthProvider.notifier).signOut(),
            child: Text('Sign Out', style: TextStyle(color: Colors.grey[600])),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(
    BuildContext context,
    WidgetRef ref,
    String errorMessage,
  ) => Semantics(
    liveRegion: true,
    label: 'Error: $errorMessage',
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () =>
                ref.read(cloudSyncAuthProvider.notifier).clearError(),
            color: Colors.red,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Dismiss error',
          ),
        ],
      ),
    ),
  );

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
