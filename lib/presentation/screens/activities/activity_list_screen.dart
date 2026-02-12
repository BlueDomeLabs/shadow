// lib/presentation/screens/activities/activity_list_screen.dart
// Activity list screen following ConditionListScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/usecases/activities/activities_usecases.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/screens/activities/activity_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Screen displaying the list of activities for a profile.
///
/// Follows the same pattern as [ConditionListScreen] with
/// active/archived sections and archive/unarchive behavior.
class ActivityListScreen extends ConsumerWidget {
  final String profileId;

  const ActivityListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: Semantics(
        label: 'Activity list',
        child: activitiesAsync.when(
          data: (activities) => _buildActivityList(context, ref, activities),
          loading: () => const Center(
            child: ShadowStatus.loading(label: 'Loading activities'),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Add new activity',
        child: FloatingActionButton(
          onPressed: () => _navigateToAddActivity(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildActivityList(
    BuildContext context,
    WidgetRef ref,
    List<Activity> activities,
  ) {
    if (activities.isEmpty) {
      return _buildEmptyState(context);
    }

    final activeActivities = activities.where((a) => a.isActive).toList();
    final archivedActivities = activities.where((a) => a.isArchived).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(activityListProvider(profileId));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeActivities.isNotEmpty) ...[
            _buildSectionHeader(context, 'Active Activities'),
            const SizedBox(height: 8),
            ...activeActivities.map(
              (activity) => _buildActivityCard(context, ref, activity),
            ),
          ],
          if (archivedActivities.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Archived Activities'),
            const SizedBox(height: 8),
            ...archivedActivities.map(
              (activity) => _buildActivityCard(context, ref, activity),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) {
    final theme = Theme.of(context);

    return Padding(
      key: ValueKey(activity.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEditActivity(context, activity),
        semanticLabel: '${activity.name}, ${activity.durationMinutes} minutes',
        semanticHint: 'Double tap to edit',
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.fitness_center,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: activity.isArchived
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${activity.durationMinutes} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (activity.location != null &&
                      activity.location!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      activity.location!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: 'More options',
              onSelected: (value) =>
                  _handleActivityAction(context, ref, activity, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: activity.isArchived ? 'unarchive' : 'archive',
                  child: ListTile(
                    leading: Icon(
                      activity.isArchived ? Icons.unarchive : Icons.archive,
                    ),
                    title: Text(activity.isArchived ? 'Unarchive' : 'Archive'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
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
              Icons.fitness_center_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No activities yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first activity',
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
            Text(
              'Failed to load activities',
              style: theme.textTheme.titleLarge,
            ),
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
              onPressed: () => ref.invalidate(activityListProvider(profileId)),
              label: 'Retry',
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddActivity(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ActivityEditScreen(profileId: profileId),
      ),
    );
  }

  void _navigateToEditActivity(BuildContext context, Activity activity) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) =>
            ActivityEditScreen(profileId: profileId, activity: activity),
      ),
    );
  }

  Future<void> _handleActivityAction(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        _navigateToEditActivity(context, activity);
      case 'archive':
      case 'unarchive':
        await _toggleArchive(context, ref, activity);
    }
  }

  Future<void> _toggleArchive(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: activity.isArchived ? 'Unarchive Activity?' : 'Archive Activity?',
      contentText: activity.isArchived
          ? 'This activity will appear in your active list again.'
          : 'This activity will be moved to the archived section.',
      confirmButtonText: activity.isArchived ? 'Unarchive' : 'Archive',
    );

    if (confirmed ?? false) {
      try {
        await ref
            .read(activityListProvider(profileId).notifier)
            .archive(
              ArchiveActivityInput(
                id: activity.id,
                profileId: profileId,
                archive: !activity.isArchived,
              ),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: activity.isArchived
                ? 'Activity unarchived'
                : 'Activity archived',
          );
        }
      } on AppError catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: e.userMessage);
        }
      } on Exception {
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'An unexpected error occurred',
          );
        }
      }
    }
  }
}
