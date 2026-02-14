// lib/presentation/screens/home/tabs/conditions_tab.dart
// Conditions tab with flare-ups button and condition list with expansion tiles.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/condition.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/conditions/condition_inputs.dart';
import 'package:shadow_app/presentation/providers/conditions/condition_list_provider.dart';
import 'package:shadow_app/presentation/screens/conditions/condition_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Conditions tab showing conditions with expansion details.
class ConditionsTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const ConditionsTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conditionsAsync = ref.watch(conditionListProvider(profileId));
    final titlePrefix = profileName != null ? "$profileName's " : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Conditions'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to flare-up list (stub — uses condition list)
                  showAccessibleSnackBar(
                    context: context,
                    message: 'Flare-up list coming soon',
                  );
                },
                icon: const Icon(Icons.warning_amber),
                label: const Text('Flare-Ups'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: conditionsAsync.when(
              data: (conditions) {
                final active = conditions.where((c) => !c.isArchived).toList();
                if (active.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.health_and_safety_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No conditions tracked yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a condition to start tracking',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildConditionList(context, ref, active);
              },
              loading: () => const Center(
                child: ShadowStatus.loading(label: 'Loading conditions'),
              ),
              error: (error, _) =>
                  Center(child: Text('Error loading conditions: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'conditions_fab',
        backgroundColor: Colors.red,
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ConditionEditScreen(profileId: profileId),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildConditionList(
    BuildContext context,
    WidgetRef ref,
    List<Condition> conditions,
  ) => ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: conditions.length,
    itemBuilder: (context, index) {
      final condition = conditions[index];
      final statusText = condition.status == ConditionStatus.active
          ? 'active'
          : 'resolved';

      return Semantics(
        label: '${condition.name}, ${condition.category}, $statusText',
        hint: 'Double tap to expand for more details',
        child: Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ExpansionTile(
            leading: const ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.health_and_safety, color: Colors.white),
              ),
            ),
            title: ExcludeSemantics(
              child: Text(
                condition.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            subtitle: ExcludeSemantics(
              child: Text(
                '${condition.category} \u2022 ${condition.bodyLocations.join(", ")}',
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Options for ${condition.name}',
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => ConditionEditScreen(
                        profileId: profileId,
                        condition: condition,
                      ),
                    ),
                  );
                } else if (value == 'archive') {
                  _archiveCondition(context, ref, condition);
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
                    if (condition.description != null &&
                        condition.description!.isNotEmpty) ...[
                      const Text(
                        'Description:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(condition.description!),
                      const SizedBox(height: 12),
                    ],
                    const Text(
                      'Status:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(
                        condition.status == ConditionStatus.active
                            ? 'Active'
                            : 'Resolved',
                      ),
                      backgroundColor:
                          condition.status == ConditionStatus.active
                          ? Colors.red[100]
                          : Colors.green[100],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future<void> _archiveCondition(
    BuildContext context,
    WidgetRef ref,
    Condition condition,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Archive Condition?',
      contentText: 'This condition will be archived.',
      confirmButtonText: 'Archive',
    );
    if (confirmed ?? false) {
      try {
        await ref
            .read(conditionListProvider(profileId).notifier)
            .archive(
              ArchiveConditionInput(id: condition.id, profileId: profileId),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Condition archived',
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
