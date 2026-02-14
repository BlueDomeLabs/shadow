// lib/presentation/screens/home/tabs/activities_tab.dart
// Activities tab with expansion tiles for activity details.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/usecases/activities/activity_inputs.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/screens/activities/activity_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Activities tab showing activity definitions with expanded details.
class ActivitiesTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const ActivitiesTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListProvider(profileId));
    final titlePrefix = profileName != null ? "$profileName's " : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Activities'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: activitiesAsync.when(
        data: (activities) {
          final active = activities.where((a) => a.isActive).toList();
          if (active.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_run_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activities logged yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first activity',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          return _buildActivityList(context, ref, active);
        },
        loading: () => const Center(
          child: ShadowStatus.loading(label: 'Loading activities'),
        ),
        error: (error, _) =>
            Center(child: Text('Error loading activities: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'activities_fab',
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ActivityEditScreen(profileId: profileId),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildActivityList(
    BuildContext context,
    WidgetRef ref,
    List<Activity> activities,
  ) => ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: activities.length,
    itemBuilder: (context, index) {
      final activity = activities[index];
      final durationText = _formatDuration(activity.durationMinutes);

      return Semantics(
        label:
            '${activity.name}, $durationText${activity.location != null ? " at ${activity.location}" : ""}',
        hint: 'Double tap to expand for more details',
        child: Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ExpansionTile(
            leading: const ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.directions_run, color: Colors.white),
              ),
            ),
            title: ExcludeSemantics(
              child: Text(
                activity.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            subtitle: ExcludeSemantics(
              child: Row(
                children: [
                  Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    durationText,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                  if (activity.location != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        activity.location!,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Options for ${activity.name}',
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => ActivityEditScreen(
                        profileId: profileId,
                        activity: activity,
                      ),
                    ),
                  );
                } else if (value == 'archive') {
                  _archiveActivity(context, ref, activity);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'archive', child: Text('Archive')),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (activity.description != null) ...[
                      const Text(
                        'Description:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(activity.description!),
                      const SizedBox(height: 12),
                    ],
                    if (activity.triggers != null &&
                        activity.triggers!.isNotEmpty) ...[
                      const Text(
                        'Potential Triggers:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: activity.triggers!
                            .split(',')
                            .map((t) => t.trim())
                            .where((t) => t.isNotEmpty)
                            .map(
                              (trigger) => Chip(
                                label: Text(
                                  trigger,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.orange[100],
                                padding: const EdgeInsets.all(4),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  String _formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours hr';
    return '$hours hr $mins min';
  }

  Future<void> _archiveActivity(
    BuildContext context,
    WidgetRef ref,
    Activity activity,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Archive Activity?',
      contentText: 'This activity will be archived.',
      confirmButtonText: 'Archive',
    );
    if (confirmed ?? false) {
      try {
        await ref
            .read(activityListProvider(profileId).notifier)
            .archive(
              ArchiveActivityInput(id: activity.id, profileId: profileId),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Activity archived',
          );
        }
      } on Exception catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: 'Error: $e');
        }
      }
    }
  }
}
