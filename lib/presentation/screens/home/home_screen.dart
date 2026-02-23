// lib/presentation/screens/home/home_screen.dart
// Navigation shell with 9-tab bottom navigation matching original app.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/home/tabs/activities_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/conditions_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/fluids_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/food_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/home_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/photos_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/reports_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/sleep_tab.dart';
import 'package:shadow_app/presentation/screens/home/tabs/supplements_tab.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/activity_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/condition_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/fluids_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/food_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/journal_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/photo_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/supplement_quick_entry_sheet.dart';
import 'package:shadow_app/presentation/screens/notifications/quick_entry/vitals_quick_entry_sheet.dart';

/// Home screen with 9-tab bottom navigation matching original Shadow app.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  // Cached to allow cleanup in dispose() without calling ref.
  late final _tapHandler = ref.read(notificationTapHandlerProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tapHandler.onTap = _showQuickEntrySheet;
    });
  }

  @override
  void dispose() {
    _tapHandler.onTap = null;
    super.dispose();
  }

  void _showQuickEntrySheet(NotificationCategory category) {
    if (!mounted) return;
    final state = ref.read(profileProvider);
    final guestMode = ref.read(guestModeProvider);
    final profileId = guestMode.isGuestMode
        ? (guestMode.guestProfileId ?? 'test-profile-001')
        : (state.currentProfileId ?? 'test-profile-001');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _buildSheet(category, profileId),
    );
  }

  Widget _buildSheet(
    NotificationCategory category,
    String profileId,
  ) => switch (category) {
    NotificationCategory.supplements => SupplementQuickEntrySheet(
      profileId: profileId,
      pendingLogs: const [],
    ),
    NotificationCategory.foodMeals => FoodQuickEntrySheet(profileId: profileId),
    NotificationCategory.fluids => FluidsQuickEntrySheet(profileId: profileId),
    NotificationCategory.photos => PhotoQuickEntrySheet(profileId: profileId),
    NotificationCategory.journalEntries => JournalQuickEntrySheet(
      profileId: profileId,
    ),
    NotificationCategory.activities => ActivityQuickEntrySheet(
      profileId: profileId,
    ),
    NotificationCategory.conditionCheckIns => ConditionQuickEntrySheet(
      profileId: profileId,
    ),
    NotificationCategory.bbtVitals => VitalsQuickEntrySheet(
      profileId: profileId,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final guestMode = ref.watch(guestModeProvider);

    // In guest mode, use the guest's profile ID instead of the selected profile
    final profileId = guestMode.isGuestMode
        ? (guestMode.guestProfileId ?? 'test-profile-001')
        : (state.currentProfileId ?? 'test-profile-001');
    final profileName = state.currentProfile?.name;

    return Semantics(
      container: true,
      label: 'Main navigation',
      child: Scaffold(
        body: Semantics(
          container: true,
          label: _getScreenLabel(_currentIndex),
          child: IndexedStack(
            index: _currentIndex,
            children: [
              HomeTab(profileId: profileId, profileName: profileName),
              SupplementsTab(profileId: profileId, profileName: profileName),
              PhotosTab(profileId: profileId, profileName: profileName),
              FoodTab(profileId: profileId, profileName: profileName),
              ConditionsTab(profileId: profileId, profileName: profileName),
              FluidsTab(profileId: profileId, profileName: profileName),
              ActivitiesTab(profileId: profileId, profileName: profileName),
              SleepTab(profileId: profileId),
              ReportsTab(profileName: profileName),
            ],
          ),
        ),
        bottomNavigationBar: Semantics(
          label: 'Bottom navigation bar',
          hint: 'Swipe left or right to navigate between sections',
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.medication),
                label: 'Supplements',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_camera),
                label: 'Photos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                label: 'Food',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.health_and_safety),
                label: 'Conditions',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.wc), label: 'Fluids'),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_run),
                label: 'Activities',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bedtime),
                label: 'Sleep',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.picture_as_pdf),
                label: 'Reports',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getScreenLabel(int index) {
    const labels = [
      'Home screen',
      'Supplements screen',
      'Photos screen',
      'Food tracking screen',
      'Conditions screen',
      'Fluids tracking screen',
      'Activities screen',
      'Sleep tracking screen',
      'Reports screen',
    ];
    return labels[index];
  }
}
