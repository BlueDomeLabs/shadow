// lib/presentation/screens/home/tabs/home_tab.dart
// Home tab with profile selector and quick action buttons matching original app.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/cloud_sync/cloud_sync_settings_screen.dart';
import 'package:shadow_app/presentation/screens/conditions/condition_list_screen.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_screen.dart';
import 'package:shadow_app/presentation/screens/food_logs/food_log_screen.dart';
import 'package:shadow_app/presentation/screens/journal_entries/journal_entry_list_screen.dart';
import 'package:shadow_app/presentation/screens/photo_areas/photo_area_list_screen.dart';
import 'package:shadow_app/presentation/screens/profiles/profiles_screen.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_list_screen.dart';

/// Home tab displaying profile selector card, app branding, and quick action buttons.
class HomeTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const HomeTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final currentProfile = state.currentProfile;
    final guestMode = ref.watch(guestModeProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Selector Card (hidden in guest mode)
            if (guestMode.isGuestMode)
              _buildGuestHeader(context)
            else
              _buildProfileCard(context, ref, currentProfile),
            const SizedBox(height: 16),
            // App branding
            ExcludeSemantics(
              child: Column(
                children: [
                  const Icon(
                    Icons.health_and_safety,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Shadow',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Personal Health Tracking',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Action Buttons
            Semantics(
              label: 'Quick actions section',
              child: Column(
                children: [
                  _buildActionButton(
                    context: context,
                    label: 'Report a Flare-Up',
                    icon: Icons.warning_amber,
                    color: Colors.red,
                    onPressed: () => _navigateTo(
                      context,
                      ConditionListScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Report Supplements',
                    icon: Icons.medication,
                    color: Colors.green,
                    onPressed: () => _navigateTo(
                      context,
                      SupplementListScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Log Food',
                    icon: Icons.restaurant,
                    color: Colors.orange,
                    onPressed: () => _navigateTo(
                      context,
                      FoodLogScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Log Fluids',
                    icon: Icons.wc,
                    color: Colors.brown,
                    onPressed: () => _navigateTo(
                      context,
                      FluidsEntryScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Start Photo Round',
                    icon: Icons.camera_alt,
                    color: Colors.purple,
                    onPressed: () => _navigateTo(
                      context,
                      PhotoAreaListScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Going to Sleep',
                    icon: Icons.bedtime,
                    color: Colors.indigo[700]!,
                    onPressed: () => _navigateTo(
                      context,
                      SleepEntryEditScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Waking Up',
                    icon: Icons.wb_sunny,
                    color: Colors.amber[700]!,
                    onPressed: () => _navigateTo(
                      context,
                      SleepEntryEditScreen(profileId: profileId),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    label: 'Journal',
                    icon: Icons.book,
                    color: Colors.deepPurple,
                    onPressed: () => _navigateTo(
                      context,
                      JournalEntryListScreen(profileId: profileId),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestHeader(BuildContext context) => Card(
    elevation: 3,
    color: Colors.teal[50],
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 24,
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profileName ?? "Guest"} — Guest Access',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You have guest access to this profile',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    Profile? currentProfile,
  ) => Semantics(
    label: currentProfile != null
        ? 'Current profile: ${currentProfile.name}. Tap to switch profiles.'
        : 'No profile selected. Tap to create a profile.',
    hint: 'Double tap to manage profiles',
    button: true,
    child: Card(
      elevation: 3,
      color: Colors.indigo[50],
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateTo(context, const ProfilesScreen()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ExcludeSemantics(
                child: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  radius: 24,
                  child: currentProfile != null
                      ? Text(
                          currentProfile.name.isNotEmpty
                              ? currentProfile.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Icon(Icons.person_add, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentProfile?.name ?? 'No Profile Selected',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentProfile != null
                            ? 'Tap to switch profile'
                            : 'Tap to create a profile',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.cloud_sync, color: Colors.indigo),
                tooltip: 'Cloud Sync Settings',
                onPressed: () =>
                    _navigateTo(context, const CloudSyncSettingsScreen()),
              ),
              const Icon(Icons.settings, color: Colors.indigo),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
      ),
    ),
  );

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => screen));
  }
}
