// lib/presentation/screens/profiles/profiles_screen.dart
// Profile management screen with list, debug menu, and sample data.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/utils/sample_data_generator.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_list_screen.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_invite_qr_screen.dart';
import 'package:shadow_app/presentation/screens/profiles/add_edit_profile_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen for managing profiles.
class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (kDebugMode)
            PopupMenuButton<String>(
              icon: const Icon(Icons.bug_report),
              tooltip: 'Debug menu',
              onSelected: (value) {
                if (value == 'generate_sample_data') {
                  _generateSampleData(context, ref);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'generate_sample_data',
                  child: Row(
                    children: [
                      Icon(Icons.data_object, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text('Generate Sample Data'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: state.profiles.isEmpty
                ? _buildEmptyState(context, ref)
                : _buildProfileList(context, ref, state),
          ),
          // Footer
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _showPrivacyPolicy(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ExcludeSemantics(
                  child: Text(
                    '\u2022',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Shadow v1.0.0',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'profiles_fab',
        backgroundColor: Colors.indigo,
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => const AddEditProfileScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person_outline, size: 100, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(
          'No profiles yet',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          'Tap + to add your first profile',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
        if (kDebugMode) ...[
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _generateSampleDataWithProfile(context, ref),
            icon: const Icon(Icons.data_object),
            label: const Text('Generate Sample Data'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Creates a sample profile with test data',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ],
    ),
  );

  Widget _buildProfileList(
    BuildContext context,
    WidgetRef ref,
    ProfileState state,
  ) => ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: state.profiles.length,
    itemBuilder: (context, index) {
      final profile = state.profiles[index];
      final isSelected = state.currentProfileId == profile.id;

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: isSelected ? 4 : 2,
        color: isSelected ? Colors.indigo[50] : null,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isSelected ? Colors.indigo : Colors.grey,
            child: Text(
              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  profile.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (isSelected)
                const Chip(
                  label: Text(
                    'Active',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          subtitle: profile.dateOfBirth != null
              ? Text(
                  'Born ${profile.dateOfBirth!.month}/${profile.dateOfBirth!.day}/${profile.dateOfBirth!.year}',
                )
              : null,
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Options for ${profile.name}',
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => AddEditProfileScreen(profile: profile),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context, ref, profile);
              } else if (value == 'select') {
                ref
                    .read(profileProvider.notifier)
                    .setCurrentProfile(profile.id);
              } else if (value == 'invite_device') {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => GuestInviteQrScreen(
                      profileId: profile.id,
                      profileName: profile.name,
                    ),
                  ),
                );
              } else if (value == 'manage_invites') {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => GuestInviteListScreen(
                      profileId: profile.id,
                      profileName: profile.name,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (_) => [
              if (!isSelected)
                const PopupMenuItem(
                  value: 'select',
                  child: Text('Set as Active'),
                ),
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(
                value: 'invite_device',
                child: Text('Invite Device'),
              ),
              const PopupMenuItem(
                value: 'manage_invites',
                child: Text('Manage Invites'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
          onTap: () {
            ref.read(profileProvider.notifier).setCurrentProfile(profile.id);
          },
        ),
      );
    },
  );

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Profile profile,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text(
          'Are you sure you want to delete "${profile.name}"? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(profileProvider.notifier)
                  .deleteProfile(profile.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateSampleData(BuildContext context, WidgetRef ref) async {
    final state = ref.read(profileProvider);
    if (state.currentProfile == null) {
      showAccessibleSnackBar(
        context: context,
        message: 'Please select a profile first',
      );
      return;
    }
    showAccessibleSnackBar(
      context: context,
      message: 'Generating sample data...',
    );
    try {
      final generator = SampleDataGenerator(
        ref: ref,
        profileId: state.currentProfile!.id,
      );
      final summary = await generator.generateAll();
      if (context.mounted) {
        showAccessibleSnackBar(context: context, message: summary);
      }
    } on Exception catch (e) {
      if (context.mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Error generating sample data: $e',
        );
      }
    }
  }

  Future<void> _generateSampleDataWithProfile(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(profileProvider.notifier);
    await notifier.addProfile(
      Profile(
        id: '',
        name: 'Sample User',
        dateOfBirth: DateTime(1990),
        createdAt: DateTime.now(),
      ),
    );
    if (context.mounted) {
      showAccessibleSnackBar(
        context: context,
        message: 'Sample profile created',
      );
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shadow Health Tracking App',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Data Collection',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'All health data is stored locally on your device using encrypted storage. '
                'No data is sent to external servers unless you explicitly enable cloud sync.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Your Rights',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You own all your data. You can export, delete, or modify it at any time. '
                'Deleting the app removes all local data permanently.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Medical Disclaimer',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This app is not a medical device and should not be used for diagnosis. '
                'Always consult with a healthcare professional.',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
