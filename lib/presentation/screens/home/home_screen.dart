// lib/presentation/screens/home/home_screen.dart
// Navigation shell for the Shadow app.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/screens/activities/activity_list_screen.dart';
import 'package:shadow_app/presentation/screens/activity_logs/activity_log_screen.dart';
import 'package:shadow_app/presentation/screens/conditions/condition_list_screen.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_screen.dart';
import 'package:shadow_app/presentation/screens/food_items/food_item_list_screen.dart';
import 'package:shadow_app/presentation/screens/food_logs/food_log_screen.dart';
import 'package:shadow_app/presentation/screens/journal_entries/journal_entry_list_screen.dart';
import 'package:shadow_app/presentation/screens/photo_areas/photo_area_list_screen.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_list_screen.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_list_screen.dart';

/// Hardcoded test profile ID for manual testing (no auth UI yet).
const testProfileId = 'test-profile-001';

/// Home screen with bottom navigation providing access to all app sections.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(
      index: _selectedIndex,
      children: const [
        _DashboardTab(),
        _TrackingTab(),
        _FoodTab(),
        _JournalTab(),
        _PhotosTab(),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.track_changes_outlined),
          selectedIcon: Icon(Icons.track_changes),
          label: 'Tracking',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon: Icon(Icons.restaurant),
          label: 'Food',
        ),
        NavigationDestination(
          icon: Icon(Icons.book_outlined),
          selectedIcon: Icon(Icons.book),
          label: 'Journal',
        ),
        NavigationDestination(
          icon: Icon(Icons.photo_library_outlined),
          selectedIcon: Icon(Icons.photo_library),
          label: 'Photos',
        ),
      ],
    ),
  );
}

/// Dashboard tab showing a grid of category cards linking to entity screens.
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Shadow')),
      body: Semantics(
        label: 'Dashboard',
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Health Tracking',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _CategoryCard(
                  icon: Icons.medication,
                  label: 'Supplements',
                  color: Colors.green,
                  onTap: () => _navigateTo(
                    context,
                    const SupplementListScreen(profileId: testProfileId),
                  ),
                ),
                _CategoryCard(
                  icon: Icons.medical_services,
                  label: 'Conditions',
                  color: Colors.red,
                  onTap: () => _navigateTo(
                    context,
                    const ConditionListScreen(profileId: testProfileId),
                  ),
                ),
                _CategoryCard(
                  icon: Icons.bedtime,
                  label: 'Sleep',
                  color: Colors.indigo,
                  onTap: () => _navigateTo(
                    context,
                    const SleepEntryListScreen(profileId: testProfileId),
                  ),
                ),
                _CategoryCard(
                  icon: Icons.fitness_center,
                  label: 'Activities',
                  color: Colors.orange,
                  onTap: () => _navigateTo(
                    context,
                    const ActivityListScreen(profileId: testProfileId),
                  ),
                ),
                _CategoryCard(
                  icon: Icons.restaurant,
                  label: 'Food Items',
                  color: Colors.teal,
                  onTap: () => _navigateTo(
                    context,
                    const FoodItemListScreen(profileId: testProfileId),
                  ),
                ),
                _CategoryCard(
                  icon: Icons.photo_camera,
                  label: 'Photo Areas',
                  color: Colors.purple,
                  onTap: () => _navigateTo(
                    context,
                    const PhotoAreaListScreen(profileId: testProfileId),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (context) => screen));
  }
}

/// Tracking tab: quick access to Supplements, Conditions, Sleep, Activities.
class _TrackingTab extends StatelessWidget {
  const _TrackingTab();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tracking')),
    body: Semantics(
      label: 'Tracking',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TrackingTile(
            icon: Icons.medication,
            title: 'Supplements',
            subtitle: 'Track your supplement intake',
            onTap: () => _navigateTo(
              context,
              const SupplementListScreen(profileId: testProfileId),
            ),
          ),
          _TrackingTile(
            icon: Icons.medical_services,
            title: 'Conditions',
            subtitle: 'Monitor your health conditions',
            onTap: () => _navigateTo(
              context,
              const ConditionListScreen(profileId: testProfileId),
            ),
          ),
          _TrackingTile(
            icon: Icons.bedtime,
            title: 'Sleep',
            subtitle: 'Track your sleep patterns',
            onTap: () => _navigateTo(
              context,
              const SleepEntryListScreen(profileId: testProfileId),
            ),
          ),
          _TrackingTile(
            icon: Icons.fitness_center,
            title: 'Activities',
            subtitle: 'Manage your activities',
            onTap: () => _navigateTo(
              context,
              const ActivityListScreen(profileId: testProfileId),
            ),
          ),
          _TrackingTile(
            icon: Icons.directions_run,
            title: 'Activity Logs',
            subtitle: 'Log activity sessions',
            onTap: () => _navigateTo(
              context,
              const ActivityLogScreen(profileId: testProfileId),
            ),
          ),
        ],
      ),
    ),
  );

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (context) => screen));
  }
}

/// Food tab: Food Items, Food Logs, Fluids.
class _FoodTab extends StatelessWidget {
  const _FoodTab();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Food')),
    body: Semantics(
      label: 'Food',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TrackingTile(
            icon: Icons.restaurant_menu,
            title: 'Food Items',
            subtitle: 'Manage your food library',
            onTap: () => _navigateTo(
              context,
              const FoodItemListScreen(profileId: testProfileId),
            ),
          ),
          _TrackingTile(
            icon: Icons.fastfood,
            title: 'Food Logs',
            subtitle: 'Log meals and snacks',
            onTap: () => _navigateTo(
              context,
              const FoodLogScreen(profileId: testProfileId),
            ),
          ),
          _TrackingTile(
            icon: Icons.local_drink,
            title: 'Fluids',
            subtitle: 'Track fluid intake',
            onTap: () => _navigateTo(
              context,
              const FluidsEntryScreen(profileId: testProfileId),
            ),
          ),
        ],
      ),
    ),
  );

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (context) => screen));
  }
}

/// Journal tab: Journal entry list.
class _JournalTab extends StatelessWidget {
  const _JournalTab();

  @override
  Widget build(BuildContext context) =>
      const JournalEntryListScreen(profileId: testProfileId);
}

/// Photos tab: Photo areas list.
class _PhotosTab extends StatelessWidget {
  const _PhotosTab();

  @override
  Widget build(BuildContext context) =>
      const PhotoAreaListScreen(profileId: testProfileId);
}

/// A card widget for the dashboard grid.
class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: label,
      button: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: theme.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A list tile for tracking and food tabs.
class _TrackingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TrackingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
