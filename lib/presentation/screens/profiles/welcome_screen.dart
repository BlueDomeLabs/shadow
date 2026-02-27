// lib/presentation/screens/profiles/welcome_screen.dart
// Welcome screen shown on first launch when no profiles exist.

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_scan_screen.dart';
import 'package:shadow_app/presentation/screens/profiles/add_edit_profile_screen.dart';

/// Welcome screen shown on first launch when no profiles exist.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Semantics(
        label: 'Welcome screen',
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Shadow app logo',
                  image: true,
                  child: Icon(
                    Icons.health_and_safety,
                    size: 120,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Semantics(
                  header: true,
                  child: Text(
                    'Welcome to Shadow',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your personal health tracking companion',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildFeature(
                  context,
                  icon: Icons.medication,
                  title: 'Track Supplements',
                  description: 'Monitor your daily supplement intake',
                ),
                const SizedBox(height: 20),
                _buildFeature(
                  context,
                  icon: Icons.restaurant,
                  title: 'Log Food & Reactions',
                  description: 'Track what you eat and how you feel',
                ),
                const SizedBox(height: 20),
                _buildFeature(
                  context,
                  icon: Icons.health_and_safety,
                  title: 'Monitor Conditions',
                  description: 'Track symptoms and health conditions',
                ),
                const SizedBox(height: 20),
                _buildFeature(
                  context,
                  icon: Icons.photo_camera,
                  title: 'Photo Tracking',
                  description: 'Document progress with photos',
                ),
                const SizedBox(height: 20),
                _buildFeature(
                  context,
                  icon: Icons.cloud_sync,
                  title: 'Cloud Sync',
                  description: 'Sync your data across devices (optional)',
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const AddEditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add, size: 24),
                    label: const Text(
                      'Create New Account',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 32,
                      ),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const GuestInviteScanScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 24),
                    label: const Text(
                      'Join Existing Account',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your data stays on your device. '
                  'Cloud sync is optional.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(
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
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
}
