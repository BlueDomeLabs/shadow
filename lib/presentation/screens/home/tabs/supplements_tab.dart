// lib/presentation/screens/home/tabs/supplements_tab.dart
// Supplements tab showing daily protocol grouped by timing slots.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/domain/entities/supplement.dart';
import 'package:shadow_app/domain/usecases/supplements/supplement_inputs.dart';
import 'package:shadow_app/presentation/providers/supplements/supplement_list_provider.dart';
import 'package:shadow_app/presentation/screens/supplements/supplement_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Supplements tab showing supplements grouped by timing slot.
class SupplementsTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const SupplementsTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementListProvider(profileId));
    final titlePrefix = profileName != null ? "$profileName's " : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Daily Protocol'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: const [],
      ),
      body: supplementsAsync.when(
        data: (supplements) {
          final active = supplements.where((s) => s.isActive).toList();
          if (active.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No supplements added yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first supplement',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          return _buildGroupedList(context, ref, active);
        },
        loading: () => const Center(
          child: ShadowStatus.loading(label: 'Loading supplements'),
        ),
        error: (error, _) =>
            Center(child: Text('Error loading supplements: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'supplements_fab',
        backgroundColor: Colors.green,
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => SupplementEditScreen(profileId: profileId),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGroupedList(
    BuildContext context,
    WidgetRef ref,
    List<Supplement> supplements,
  ) {
    final slots = _buildTimingSlots(supplements);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (final slot in slots)
          if (slot.supplements.isNotEmpty)
            _buildTimingSlotSection(context, ref, slot),
      ],
    );
  }

  List<_TimingSlot> _buildTimingSlots(List<Supplement> supplements) {
    final timingMap = <String, List<Supplement>>{};

    for (final supp in supplements) {
      if (supp.schedules.isEmpty) {
        timingMap.putIfAbsent('Unscheduled|other|0', () => []);
        if (!timingMap['Unscheduled|other|0']!.contains(supp)) {
          timingMap['Unscheduled|other|0']!.add(supp);
        }
        continue;
      }

      for (final schedule in supp.schedules) {
        final anchor = schedule.anchorEvent.name;
        final timing = schedule.timingType.name;
        final offset = schedule.offsetMinutes;

        final key = '$anchor|$timing|$offset';
        timingMap.putIfAbsent(key, () => []);
        if (!timingMap[key]!.contains(supp)) {
          timingMap[key]!.add(supp);
        }
      }
    }

    final slots = <_TimingSlot>[];
    for (final entry in timingMap.entries) {
      final parts = entry.key.split('|');
      final event = parts[0];
      final timing = parts[1];
      final offset = int.parse(parts[2]);
      final order = _getChronologicalOrder(event, timing, offset);
      final label = _getTimingLabel(event, timing, offset);
      slots.add(_TimingSlot(label, order, entry.value));
    }

    slots.sort((a, b) => a.order.compareTo(b.order));
    return slots;
  }

  int _getChronologicalOrder(String event, String timing, int offset) {
    int baseOrder;
    switch (event) {
      case 'wake':
        baseOrder = 100;
      case 'breakfast':
        baseOrder = 200;
      case 'lunch':
        baseOrder = 300;
      case 'dinner':
        baseOrder = 400;
      case 'bed':
        baseOrder = 500;
      default:
        baseOrder = 600;
    }
    if (timing == 'beforeEvent') return baseOrder - 1;
    if (timing == 'afterEvent') return baseOrder + 1;
    return baseOrder;
  }

  String _getTimingLabel(String event, String timing, int offset) {
    final displayEvent = _formatEventName(event);
    if (timing == 'beforeEvent') return '$offset min before $displayEvent';
    if (timing == 'afterEvent') return '$offset min after $displayEvent';
    return displayEvent;
  }

  String _formatEventName(String event) {
    switch (event) {
      case 'wake':
        return 'Wake Up';
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'bed':
        return 'Bedtime';
      default:
        return event;
    }
  }

  Widget _buildTimingSlotSection(
    BuildContext context,
    WidgetRef ref,
    _TimingSlot slot,
  ) {
    Color color;
    IconData icon;

    if (slot.order < 200) {
      color = const Color(0xFFFF9800);
      icon = Icons.wb_sunny;
    } else if (slot.order < 300) {
      color = const Color(0xFFFFB74D);
      icon = Icons.breakfast_dining;
    } else if (slot.order < 400) {
      color = const Color(0xFF4CAF50);
      icon = Icons.lunch_dining;
    } else if (slot.order < 500) {
      color = const Color(0xFF2196F3);
      icon = Icons.dinner_dining;
    } else if (slot.order < 600) {
      color = const Color(0xFF9C27B0);
      icon = Icons.bedtime;
    } else {
      color = const Color(0xFF607D8B);
      icon = Icons.schedule;
    }

    return Semantics(
      label: '${slot.label} section, ${slot.supplements.length} supplements',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: ExcludeSemantics(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      slot.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${slot.supplements.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...slot.supplements.map(
            (supp) => _buildSupplementCard(context, ref, supp, color),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSupplementCard(
    BuildContext context,
    WidgetRef ref,
    Supplement supp,
    Color categoryColor,
  ) {
    final dosageText = '${supp.dosageQuantity} ${supp.dosageUnit.name}';
    final formText =
        supp.form.name[0].toUpperCase() + supp.form.name.substring(1);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: categoryColor.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) =>
                SupplementEditScreen(profileId: profileId, supplement: supp),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      supp.brand.isNotEmpty ? supp.brand : supp.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dosageText,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: categoryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      formText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: categoryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    tooltip: 'Options for ${supp.name}',
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => SupplementEditScreen(
                              profileId: profileId,
                              supplement: supp,
                            ),
                          ),
                        );
                      } else if (value == 'archive') {
                        _archiveSupplement(context, ref, supp);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'archive', child: Text('Archive')),
                    ],
                  ),
                ],
              ),
              if (supp.ingredients.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    supp.ingredients
                        .map(
                          (i) =>
                              '${i.name}${i.quantity != null ? ' ${i.quantity}' : ''}${i.unit != null ? ' ${i.unit!.name}' : ''}',
                        )
                        .join(', '),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _archiveSupplement(
    BuildContext context,
    WidgetRef ref,
    Supplement supp,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Archive Supplement?',
      contentText: 'This supplement will be moved to the archived section.',
      confirmButtonText: 'Archive',
    );
    if (confirmed ?? false) {
      try {
        await ref
            .read(supplementListProvider(profileId).notifier)
            .archive(
              ArchiveSupplementInput(
                id: supp.id,
                profileId: profileId,
                archive: true,
              ),
            );
        if (context.mounted) {
          showAccessibleSnackBar(
            context: context,
            message: 'Supplement archived',
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

class _TimingSlot {
  final String label;
  final int order;
  final List<Supplement> supplements;

  _TimingSlot(this.label, this.order, this.supplements);
}
