// lib/presentation/screens/home/tabs/sleep_tab.dart
// Sleep tab wrapping the existing SleepEntryListScreen.

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/screens/sleep_entries/sleep_entry_list_screen.dart';

/// Sleep tab that delegates to SleepEntryListScreen.
class SleepTab extends StatelessWidget {
  final String profileId;

  const SleepTab({super.key, required this.profileId});

  @override
  Widget build(BuildContext context) =>
      SleepEntryListScreen(profileId: profileId);
}
