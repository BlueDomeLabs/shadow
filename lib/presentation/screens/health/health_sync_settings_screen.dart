// lib/presentation/screens/health/health_sync_settings_screen.dart
// Phase 16c — Health Platform sync settings screen
// Per 61_HEALTH_PLATFORM_INTEGRATION.md Settings Screen Addition section

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/health_sync_status.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/health/health_types.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/health/health_sync_provider.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Human-readable label for each health data type.
String _dataTypeLabel(HealthDataType type) => switch (type) {
  HealthDataType.heartRate => 'Heart Rate',
  HealthDataType.restingHeartRate => 'Resting Heart Rate',
  HealthDataType.weight => 'Weight',
  HealthDataType.bpSystolic => 'Blood Pressure (Systolic)',
  HealthDataType.bpDiastolic => 'Blood Pressure (Diastolic)',
  HealthDataType.sleepDuration => 'Sleep Duration',
  HealthDataType.steps => 'Steps',
  HealthDataType.activeCalories => 'Active Calories',
  HealthDataType.bloodOxygen => 'Blood Oxygen',
};

/// Health Platform sync settings screen.
///
/// Sections per 61_HEALTH_PLATFORM_INTEGRATION.md:
/// 1. Platform status (Apple Health / Google Health Connect)
/// 2. Sync controls (Sync button, last synced timestamp, result summary)
/// 3. Date range selector (30 / 60 / 90 days)
/// 4. Per-data-type toggles (9 types)
class HealthSyncSettingsScreen extends ConsumerStatefulWidget {
  const HealthSyncSettingsScreen({super.key});

  @override
  ConsumerState<HealthSyncSettingsScreen> createState() =>
      _HealthSyncSettingsScreenState();
}

class _HealthSyncSettingsScreenState
    extends ConsumerState<HealthSyncSettingsScreen> {
  bool _syncing = false;
  String? _lastSyncResult;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.currentProfile;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Health Data')),
        body: const Center(child: Text('No profile selected')),
      );
    }

    final settingsAsync = ref.watch(
      healthSyncSettingsNotifierProvider(profile.id),
    );
    final statusAsync = ref.watch(healthSyncStatusListProvider(profile.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Health Data')),
      body: settingsAsync.when(
        loading: () => const Center(
          child: ShadowStatus.loading(label: 'Loading settings'),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section 1: Platform status
              const _SectionHeader('Health Data'),
              _PlatformStatusRow(),

              const Divider(),

              // Section 2: Sync controls
              _SyncControlsSection(
                syncing: _syncing,
                lastSyncResult: _lastSyncResult,
                statusAsync: statusAsync,
                onSync: () => _runSync(profile.id),
              ),

              const Divider(),

              // Section 3: Date range
              _DateRangeSection(
                current: settings.dateRangeDays,
                profileId: profile.id,
              ),

              const Divider(),

              // Section 4: Per-data-type toggles
              const _SectionHeader('Import Data Types'),
              ...HealthDataType.values.map(
                (dataType) => _DataTypeToggle(
                  dataType: dataType,
                  enabled: settings.enabledDataTypes.contains(dataType),
                  profileId: profile.id,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _runSync(String profileId) async {
    setState(() {
      _syncing = true;
      _lastSyncResult = null;
    });

    try {
      final useCase = ref.read(syncFromHealthPlatformUseCaseProvider);
      final result = await useCase(
        SyncFromHealthPlatformInput(profileId: profileId),
      );

      result.when(
        success: (syncResult) {
          if (syncResult.platformUnavailable) {
            setState(() => _lastSyncResult = 'Health platform not available');
          } else if (syncResult.totalImported == 0 &&
              syncResult.deniedTypes.isEmpty) {
            setState(() => _lastSyncResult = 'No new records found');
          } else {
            setState(() => _lastSyncResult = _buildSummary(syncResult));
          }
          // Refresh status row
          ref.invalidate(healthSyncStatusListProvider(profileId));
        },
        failure: (error) =>
            setState(() => _lastSyncResult = 'Sync failed: ${error.message}'),
      );
    } finally {
      setState(() => _syncing = false);
    }
  }

  String _buildSummary(SyncFromHealthPlatformResult result) {
    final parts = result.importedCountByType.entries
        .where((e) => e.value > 0)
        .map((e) => '${e.value} ${_dataTypeLabel(e.key).toLowerCase()}')
        .toList();
    final total = result.totalImported;
    if (parts.isEmpty) return 'No new records imported';
    return 'Imported $total records — ${parts.join(', ')}';
  }
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
// Section 1: Platform status
// ---------------------------------------------------------------------------

class _PlatformStatusRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(healthPlatformServiceProvider);
    final platformName = service.currentPlatform.displayName;

    return FutureBuilder<bool>(
      future: service.isAvailable(),
      builder: (context, snapshot) {
        final available = snapshot.data ?? false;
        return ListTile(
          leading: Icon(
            Icons.favorite_outline,
            color: available
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).disabledColor,
          ),
          title: Text(platformName),
          subtitle: Text(
            available ? 'Connected' : 'Not available on this device',
          ),
          trailing: available
              ? Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                )
              : const Icon(Icons.cancel_outlined),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Section 2: Sync controls
// ---------------------------------------------------------------------------

class _SyncControlsSection extends StatelessWidget {
  final bool syncing;
  final String? lastSyncResult;
  final AsyncValue<List<HealthSyncStatus>> statusAsync;
  final VoidCallback onSync;

  const _SyncControlsSection({
    required this.syncing,
    required this.lastSyncResult,
    required this.statusAsync,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    // Find the most recent sync timestamp across all data types.
    final lastSynced = statusAsync.maybeWhen(
      data: (statuses) {
        final times = statuses
            .map((s) => s.lastSyncedAt)
            .whereType<int>()
            .toList();
        if (times.isEmpty) return null;
        return times.reduce((a, b) => a > b ? a : b);
      },
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: syncing ? null : onSync,
            icon: syncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: Text(syncing ? 'Syncing…' : 'Sync from Health'),
          ),
        ),
        if (lastSyncResult != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              lastSyncResult!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Last synced'),
          subtitle: Text(
            lastSynced != null ? _formatTimestamp(lastSynced) : 'Never',
          ),
        ),
        _ManagePermissionsRow(),
      ],
    );
  }

  String _formatTimestamp(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today at ${_pad(dt.hour)}:${_pad(dt.minute)}';
    }
    return '${dt.month}/${dt.day}/${dt.year} at ${_pad(dt.hour)}:${_pad(dt.minute)}';
  }

  String _pad(int v) => v.toString().padLeft(2, '0');
}

// ---------------------------------------------------------------------------
// Manage Permissions row
// ---------------------------------------------------------------------------

class _ManagePermissionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.settings_outlined),
    title: const Text('Manage Permissions'),
    subtitle: const Text('Open platform health settings'),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      // Opens the platform's health permission settings.
      // Platform URL launch integration is planned for a future phase.
    },
  );
}

// ---------------------------------------------------------------------------
// Section 3: Date range selector
// ---------------------------------------------------------------------------

class _DateRangeSection extends ConsumerWidget {
  final int current;
  final String profileId;

  const _DateRangeSection({required this.current, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const options = [30, 60, 90];
    // Clamp to a valid option in case of an unexpected stored value.
    final safeValue = options.contains(current) ? current : 30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Import last', style: TextStyle(fontSize: 15)),
          SegmentedButton<int>(
            segments: options
                .map(
                  (d) => ButtonSegment<int>(value: d, label: Text('$d days')),
                )
                .toList(),
            selected: {safeValue},
            onSelectionChanged: (selection) {
              ref
                  .read(healthSyncSettingsNotifierProvider(profileId).notifier)
                  .setDateRange(selection.first);
            },
            style: const ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section 4: Per-data-type toggle
// ---------------------------------------------------------------------------

class _DataTypeToggle extends ConsumerWidget {
  final HealthDataType dataType;
  final bool enabled;
  final String profileId;

  const _DataTypeToggle({
    required this.dataType,
    required this.enabled,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SwitchListTile(
    title: Text(_dataTypeLabel(dataType)),
    subtitle: Text(dataType.canonicalUnit),
    value: enabled,
    onChanged: (value) {
      ref
          .read(healthSyncSettingsNotifierProvider(profileId).notifier)
          .toggleDataType(dataType, enabled: value);
    },
  );
}
