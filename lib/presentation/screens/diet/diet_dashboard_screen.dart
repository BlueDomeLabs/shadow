// lib/presentation/screens/diet/diet_dashboard_screen.dart
// Diet compliance dashboard screen — Phase 15b-3
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.3 + 59_DIET_TRACKING.md

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/diet.dart';
import 'package:shadow_app/domain/usecases/diet/diets_usecases.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/diet/diet_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Diet compliance dashboard screen.
///
/// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.3:
/// - Overall compliance score gauge
/// - Daily, weekly, monthly scores
/// - Current streak badge
/// - Recent violations list
/// - Daily trend
class DietDashboardScreen extends ConsumerWidget {
  final String profileId;

  const DietDashboardScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietListAsync = ref.watch(dietListProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Diet Dashboard')),
      body: Semantics(
        label: 'Diet compliance dashboard',
        child: dietListAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => EmptyStateWidget(
            icon: Icons.error_outline,
            message: 'Could not load diet data',
            submessage: error is AppError
                ? error.userMessage
                : error.toString(),
            action: ShadowButton.outlined(
              onPressed: () => ref.invalidate(dietListProvider(profileId)),
              label: 'Retry loading diet data',
              child: const Text('Retry'),
            ),
          ),
          data: (diets) {
            final activeDiet = diets.where((d) => d.isActive).firstOrNull;

            if (activeDiet == null) {
              return const EmptyStateWidget(
                icon: Icons.no_meals,
                message: 'No Active Diet',
                submessage: 'Select a diet to start tracking compliance',
              );
            }

            return _DashboardContent(
              profileId: profileId,
              activeDiet: activeDiet,
            );
          },
        ),
      ),
    );
  }
}

/// The dashboard content once an active diet is confirmed.
class _DashboardContent extends ConsumerWidget {
  final String profileId;
  final Diet activeDiet;

  const _DashboardContent({required this.profileId, required this.activeDiet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Date range: last 30 days, truncated to day boundary so the provider key
    // is stable across rebuilds within the same day (prevents a new provider
    // instance on every build due to millisecond-level DateTime.now() drift).
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));
    final endOfToday = today.add(const Duration(days: 1));

    final statsAsync = ref.watch(
      _complianceStatsProvider((
        profileId: profileId,
        dietId: activeDiet.id,
        startEpoch: thirtyDaysAgo.millisecondsSinceEpoch,
        endEpoch: endOfToday.millisecondsSinceEpoch,
      )),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(dietListProvider(profileId))
          ..invalidate(
            _complianceStatsProvider((
              profileId: profileId,
              dietId: activeDiet.id,
              startEpoch: thirtyDaysAgo.millisecondsSinceEpoch,
              endEpoch: endOfToday.millisecondsSinceEpoch,
            )),
          );
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active diet name
          ShadowCard.listItem(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(activeDiet.name),
              subtitle: const Text('Active diet'),
            ),
          ),
          const SizedBox(height: 16),

          statsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, s) => const EmptyStateWidget(
              icon: Icons.analytics_outlined,
              message: 'No compliance data yet',
              submessage: 'Log food to start tracking compliance',
            ),
            data: (stats) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score overview
                const _SectionHeader(title: 'Compliance Scores'),
                const SizedBox(height: 8),
                _ScoreRow(
                  daily: stats.dailyScore,
                  weekly: stats.weeklyScore,
                  monthly: stats.monthlyScore,
                ),
                const SizedBox(height: 16),

                // Streak
                const _SectionHeader(title: 'Streak'),
                const SizedBox(height: 8),
                ShadowCard.listItem(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: stats.currentStreak > 0
                              ? Colors.orange
                              : theme.colorScheme.onSurfaceVariant,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stats.currentStreak} day streak',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Best: ${stats.longestStreak} days',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Violation summary
                const _SectionHeader(title: 'This Month'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Violations',
                        value: stats.totalViolations.toString(),
                        icon: Icons.close,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatCard(
                        label: 'Added Anyway',
                        value: stats.totalWarnings.toString(),
                        icon: Icons.warning_amber,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Recent violations
                if (stats.recentViolations.isNotEmpty) ...[
                  const _SectionHeader(title: 'Recent Violations'),
                  const SizedBox(height: 8),
                  ...stats.recentViolations
                      .take(5)
                      .map(
                        (violation) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ShadowCard.listItem(
                            child: ListTile(
                              leading: Icon(
                                violation.wasOverridden
                                    ? Icons.warning_amber
                                    : Icons.close,
                                color: violation.wasOverridden
                                    ? Colors.orange
                                    : theme.colorScheme.error,
                              ),
                              title: Text(violation.foodName),
                              subtitle: Text(violation.ruleDescription),
                              trailing: Text(
                                violation.wasOverridden
                                    ? 'Added anyway'
                                    : 'Cancelled',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: violation.wasOverridden
                                      ? Colors.orange
                                      : theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Score display row (daily / weekly / monthly).
class _ScoreRow extends StatelessWidget {
  final double daily;
  final double weekly;
  final double monthly;

  const _ScoreRow({
    required this.daily,
    required this.weekly,
    required this.monthly,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _ScoreCard(label: 'Today', score: daily),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _ScoreCard(label: '7 Days', score: weekly),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _ScoreCard(label: '30 Days', score: monthly),
      ),
    ],
  );
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreCard({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = score >= 80
        ? Colors.green
        : score >= 50
        ? Colors.orange
        : theme.colorScheme.error;

    return ShadowCard.listItem(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              '${score.toStringAsFixed(0)}%',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ShadowCard.listItem(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}

// ---------------------------------------------------------------------------
// Internal provider for compliance stats (scoped to diet + date range)
// ---------------------------------------------------------------------------

typedef _StatsKey = ({
  String profileId,
  String dietId,
  int startEpoch,
  int endEpoch,
});

final _complianceStatsProvider =
    FutureProvider.family<ComplianceStats, _StatsKey>((ref, key) async {
      final useCase = ref.read(getComplianceStatsUseCaseProvider);
      final result = await useCase(
        GetComplianceStatsInput(
          profileId: key.profileId,
          dietId: key.dietId,
          startDateEpoch: key.startEpoch,
          endDateEpoch: key.endEpoch,
        ),
      );

      return result.when(
        success: (stats) => stats,
        failure: (error) => throw error,
      );
    });
