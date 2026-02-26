// lib/presentation/screens/conditions/flare_up_list_screen.dart
// Implements Phase 18b — FlareUpListScreen
// Shows all flare-ups for a profile, sorted newest first.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/providers/flare_ups/flare_up_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/report_flare_up_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying all flare-ups for a profile, sorted newest first.
///
/// Uses [FlareUpList] provider for data. Resolves condition names via
/// [ConditionList] — loaded once, not per row.
class FlareUpListScreen extends ConsumerWidget {
  final String profileId;

  const FlareUpListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flareUpsAsync = ref.watch(flareUpListProvider(profileId));
    final conditionsAsync = ref.watch(conditionListProvider(profileId));

    // Build a conditionId → name lookup map from loaded conditions.
    final conditionNames = conditionsAsync.maybeWhen(
      data: (conditions) =>
          Map.fromEntries(conditions.map((c) => MapEntry(c.id, c.name))),
      orElse: () => <String, String>{},
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Flare-Ups')),
      body: Semantics(
        label: 'Flare-up list',
        child: flareUpsAsync.when(
          data: (flareUps) =>
              _buildList(context, ref, flareUps, conditionNames),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading flare-ups'),
          ),
          error: (error, _) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Report flare-up',
        child: FloatingActionButton(
          onPressed: () => _openReportSheet(context),
          tooltip: 'Report Flare-Up',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<FlareUp> flareUps,
    Map<String, String> conditionNames,
  ) {
    if (flareUps.isEmpty) {
      return _buildEmptyState(context);
    }

    // Sort newest first.
    final sorted = [...flareUps]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(flareUpListProvider(profileId)),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sorted.length,
        itemBuilder: (context, index) =>
            _buildFlareUpCard(context, sorted[index], conditionNames),
      ),
    );
  }

  Widget _buildFlareUpCard(
    BuildContext context,
    FlareUp flareUp,
    Map<String, String> conditionNames,
  ) {
    final theme = Theme.of(context);
    final conditionName =
        conditionNames[flareUp.conditionId] ?? 'Unknown Condition';
    final dateStr = DateFormat(
      'MMM d, yyyy',
    ).format(DateTime.fromMillisecondsSinceEpoch(flareUp.startDate));
    final badgeColor = _severityColor(flareUp.severity);
    final badgeBg = _severityBackgroundColor(flareUp.severity);

    return Padding(
      key: ValueKey(flareUp.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _openEditSheet(context, flareUp),
        semanticLabel: '$conditionName, severity ${flareUp.severity}, $dateStr',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            // Severity badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${flareUp.severity}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conditionName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // ONGOING chip
            if (flareUp.isOngoing)
              Chip(
                label: const Text('ONGOING'),
                backgroundColor: theme.colorScheme.errorContainer,
                labelStyle: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No flare-ups recorded', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap + to report a flare-up',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Failed to load flare-ups', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error is AppError
                  ? error.userMessage
                  : 'Something went wrong. Please try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ShadowButton(
              onPressed: () => ref.invalidate(flareUpListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Color _severityColor(int severity) {
    if (severity <= 3) return Colors.green.shade700;
    if (severity <= 6) return Colors.amber.shade800;
    return Colors.red.shade700;
  }

  Color _severityBackgroundColor(int severity) {
    if (severity <= 3) return Colors.green.shade50;
    if (severity <= 6) return Colors.amber.shade50;
    return Colors.red.shade50;
  }

  void _openReportSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ReportFlareUpScreen(profileId: profileId),
    );
  }

  void _openEditSheet(BuildContext context, FlareUp flareUp) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          ReportFlareUpScreen(profileId: profileId, editingFlareUp: flareUp),
    );
  }
}
