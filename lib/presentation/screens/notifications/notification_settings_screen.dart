// lib/presentation/screens/notifications/notification_settings_screen.dart
// Implements 58_SETTINGS_SCREENS.md Screen 1 — Notification Settings

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/anchor_event_time.dart';
import 'package:shadow_app/domain/entities/notification_category_settings.dart';
import 'package:shadow_app/domain/enums/notification_enums.dart';
import 'package:shadow_app/domain/usecases/notifications/notification_inputs.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/notifications/anchor_event_times_provider.dart';
import 'package:shadow_app/presentation/providers/notifications/notification_settings_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Notification Settings screen.
///
/// Three sections per 58_SETTINGS_SCREENS.md:
/// 1. Anchor Event Times — set clock times for Wake/Breakfast/Lunch/Dinner/Bedtime
/// 2. Notification Reminders — per-category enable/disable, mode, and config
/// 3. General — expiry duration and permission access
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anchorTimesAsync = ref.watch(anchorEventTimesProvider);
    final settingsAsync = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: Semantics(
        label: 'Notification settings',
        child: anchorTimesAsync.when(
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading settings'),
          ),
          error: (e, s) => Center(child: Text('Error: $e')),
          data: (anchorTimes) => settingsAsync.when(
            loading: () => const Center(
              child: ShadowStatus.loading(label: 'Loading settings'),
            ),
            error: (e, s) => Center(child: Text('Error: $e')),
            data: (settings) => _buildContent(context, anchorTimes, settings),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<AnchorEventTime> anchorTimes,
    List<NotificationCategorySettings> settings,
  ) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section 1: Anchor Event Times
        const _SectionHeader('Anchor Event Times'),
        ...anchorTimes.map((a) => _AnchorEventRow(anchorEvent: a)),

        const Divider(),

        // Section 2: Notification Reminders
        const _SectionHeader('Notification Reminders'),
        ...settings.map(
          (s) => _CategoryCard(settings: s, anchorTimes: anchorTimes),
        ),

        const Divider(),

        // Section 3: General
        const _SectionHeader('General'),
        _ExpiryRow(settings: settings),
        const _PermissionRow(),

        const SizedBox(height: 32),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Section 1: Anchor Event Row
// ---------------------------------------------------------------------------

class _AnchorEventRow extends ConsumerWidget {
  final AnchorEventTime anchorEvent;

  const _AnchorEventRow({required this.anchorEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    title: Text(anchorEvent.displayName),
    subtitle: Text(_formatTime(anchorEvent.timeOfDay)),
    trailing: Switch(
      value: anchorEvent.isEnabled,
      onChanged: (value) => ref
          .read(anchorEventTimesProvider.notifier)
          .updateAnchorEvent(
            UpdateAnchorEventTimeInput(id: anchorEvent.id, isEnabled: value),
          ),
    ),
    onTap: () => _pickTime(context, ref),
  );

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final parts = anchorEvent.timeOfDay.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (picked == null) return;
    final hhmm =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    await ref
        .read(anchorEventTimesProvider.notifier)
        .updateAnchorEvent(
          UpdateAnchorEventTimeInput(id: anchorEvent.id, timeOfDay: hhmm),
        );
  }
}

// ---------------------------------------------------------------------------
// Section 2: Category Card
// ---------------------------------------------------------------------------

class _CategoryCard extends ConsumerWidget {
  final NotificationCategorySettings settings;
  final List<AnchorEventTime> anchorTimes;

  const _CategoryCard({required this.settings, required this.anchorTimes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            secondary: Icon(_categoryIcon(settings.category)),
            title: Text(settings.category.displayName),
            value: settings.isEnabled,
            onChanged: (v) => notifier.updateSettings(
              UpdateNotificationCategorySettingsInput(
                id: settings.id,
                isEnabled: v,
              ),
            ),
          ),
          if (settings.isEnabled) ...[
            const Divider(height: 1),
            _buildModeSelector(notifier),
            _buildModeConfig(context, ref, notifier),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildModeSelector(NotificationSettings notifier) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: SegmentedButton<NotificationSchedulingMode>(
      segments: const [
        ButtonSegment(
          value: NotificationSchedulingMode.anchorEvents,
          label: Text('Anchor'),
        ),
        ButtonSegment(
          value: NotificationSchedulingMode.interval,
          label: Text('Interval'),
        ),
        ButtonSegment(
          value: NotificationSchedulingMode.specificTimes,
          label: Text('Specific'),
        ),
      ],
      selected: {settings.schedulingMode},
      onSelectionChanged: (selection) => notifier.updateSettings(
        UpdateNotificationCategorySettingsInput(
          id: settings.id,
          schedulingMode: selection.first,
        ),
      ),
    ),
  );

  Widget _buildModeConfig(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings notifier,
  ) => switch (settings.schedulingMode) {
    NotificationSchedulingMode.anchorEvents => _buildAnchorEventsConfig(
      notifier,
    ),
    NotificationSchedulingMode.interval => _buildIntervalConfig(
      context,
      ref,
      notifier,
    ),
    NotificationSchedulingMode.specificTimes => _buildSpecificTimesConfig(
      context,
      ref,
      notifier,
    ),
  };

  Widget _buildAnchorEventsConfig(NotificationSettings notifier) => Column(
    children: AnchorEventName.values.map((name) {
      final isChecked = settings.anchorEvents.contains(name);
      final matchingTime = anchorTimes
          .where((a) => a.name == name)
          .map((a) => a.timeOfDay)
          .firstOrNull;

      return CheckboxListTile(
        title: Text(name.displayName),
        subtitle: matchingTime != null ? Text(_formatTime(matchingTime)) : null,
        value: isChecked,
        onChanged: (v) {
          final current = List<int>.from(settings.anchorEventValues);
          if (v ?? false) {
            current.add(name.value);
          } else {
            current.remove(name.value);
          }
          notifier.updateSettings(
            UpdateNotificationCategorySettingsInput(
              id: settings.id,
              anchorEventValues: current,
            ),
          );
        },
      );
    }).toList(),
  );

  Widget _buildIntervalConfig(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings notifier,
  ) {
    final intervalHours = settings.intervalHours ?? 2;
    final startTime = settings.intervalStartTime ?? '08:00';
    final endTime = settings.intervalEndTime ?? '22:00';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Repeat interval: '),
              DropdownButton<int>(
                value: intervalHours,
                items: [1, 2, 3, 4, 6, 8, 12]
                    .map(
                      (h) => DropdownMenuItem(
                        value: h,
                        child: Text('Every $h ${h == 1 ? "hour" : "hours"}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  notifier.updateSettings(
                    UpdateNotificationCategorySettingsInput(
                      id: settings.id,
                      intervalHours: v,
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('Start time'),
            trailing: Text(_formatTime(startTime)),
            onTap: () =>
                _pickIntervalTime(context, ref, notifier, startTime, true),
          ),
          ListTile(
            title: const Text('End time'),
            trailing: Text(_formatTime(endTime)),
            onTap: () =>
                _pickIntervalTime(context, ref, notifier, endTime, false),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIntervalTime(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings notifier,
    String currentHHMM,
    bool isStart,
  ) async {
    final parts = currentHHMM.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (picked == null) return;
    final hhmm =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    await notifier.updateSettings(
      UpdateNotificationCategorySettingsInput(
        id: settings.id,
        intervalStartTime: isStart ? hhmm : null,
        intervalEndTime: isStart ? null : hhmm,
      ),
    );
  }

  Widget _buildSpecificTimesConfig(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings notifier,
  ) {
    final canAdd = settings.specificTimes.length < 12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          ...settings.specificTimes.map(
            (t) => ListTile(
              title: Text(_formatTime(t)),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: 'Remove time',
                onPressed: () {
                  final updated = List<String>.from(settings.specificTimes)
                    ..remove(t);
                  notifier.updateSettings(
                    UpdateNotificationCategorySettingsInput(
                      id: settings.id,
                      specificTimes: updated,
                    ),
                  );
                },
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add time'),
            enabled: canAdd,
            onTap: canAdd
                ? () => _addSpecificTime(context, ref, notifier)
                : null,
          ),
        ],
      ),
    );
  }

  Future<void> _addSpecificTime(
    BuildContext context,
    WidgetRef ref,
    NotificationSettings notifier,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked == null) return;
    final hhmm =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    await notifier.updateSettings(
      UpdateNotificationCategorySettingsInput(
        id: settings.id,
        specificTimes: [...settings.specificTimes, hhmm],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 3: Expiry Row
// ---------------------------------------------------------------------------

class _ExpiryRow extends ConsumerWidget {
  final List<NotificationCategorySettings> settings;

  const _ExpiryRow({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificationSettingsProvider.notifier);
    const options = [
      (30, '30 minutes'),
      (60, '60 minutes'),
      (120, '2 hours'),
      (0, 'Until dismissed'),
    ];
    final currentExpiry = settings.isEmpty
        ? 60
        : settings.first.expiresAfterMinutes;
    final validValue = options.any((o) => o.$1 == currentExpiry)
        ? currentExpiry
        : 60;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Notification Expiry: '),
          DropdownButton<int>(
            value: validValue,
            items: options
                .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                .toList(),
            onChanged: (v) {
              if (v != null) notifier.setAllExpiry(v);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 3: Permission Row
// ---------------------------------------------------------------------------

class _PermissionRow extends ConsumerWidget {
  const _PermissionRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    leading: const Icon(Icons.notifications),
    title: const Text('Notification Permission'),
    subtitle: const Text('Tap to request notification access'),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () async =>
        ref.read(notificationPermissionServiceProvider).requestPermission(),
  );
}

// ---------------------------------------------------------------------------
// Helpers (module-level)
// ---------------------------------------------------------------------------

/// Formats a "HH:mm" 24-hour string as "H:mm AM/PM".
String _formatTime(String hhmm) {
  final parts = hhmm.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  final h = hour % 12 == 0 ? 12 : hour % 12;
  final m = minute.toString().padLeft(2, '0');
  final period = hour < 12 ? 'AM' : 'PM';
  return '$h:$m $period';
}

/// Returns the icon for a given [NotificationCategory].
IconData _categoryIcon(NotificationCategory category) => switch (category) {
  NotificationCategory.supplements => Icons.medication,
  NotificationCategory.foodMeals => Icons.restaurant,
  NotificationCategory.fluids => Icons.local_drink,
  NotificationCategory.photos => Icons.photo_camera,
  NotificationCategory.journalEntries => Icons.book,
  NotificationCategory.activities => Icons.directions_run,
  NotificationCategory.conditionCheckIns => Icons.monitor_heart,
  NotificationCategory.bbtVitals => Icons.thermostat,
};
