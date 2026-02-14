// lib/presentation/screens/home/tabs/fluids_tab.dart
// Fluids tab showing fluids entry log with expansion tiles.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/utils/date_formatters.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/usecases/fluids_entries/fluids_entry_inputs.dart';
import 'package:shadow_app/presentation/providers/fluids_entries/fluids_entry_list_provider.dart';
import 'package:shadow_app/presentation/screens/fluids_entries/fluids_entry_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Fluids tab for tracking water intake, bowel, urine, menstruation, BBT, and other fluids.
class FluidsTab extends ConsumerWidget {
  final String profileId;
  final String? profileName;

  const FluidsTab({super.key, required this.profileId, this.profileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titlePrefix = profileName != null ? "$profileName's " : '';

    // Default date range: last 30 days
    // Normalize to day boundaries so the provider key stays stable across rebuilds.
    // Without this, DateTime.now().millisecondsSinceEpoch changes every rebuild,
    // creating a new provider instance each time and causing an infinite poll loop.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today
        .subtract(const Duration(days: 30))
        .millisecondsSinceEpoch;
    final endDate = today.add(const Duration(days: 1)).millisecondsSinceEpoch;

    final entriesAsync = ref.watch(
      fluidsEntryListProvider(profileId, startDate, endDate),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${titlePrefix}Fluids'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wc_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No entries logged yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to log your first entry',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          return _buildEntryList(context, ref, entries);
        },
        loading: () =>
            const Center(child: ShadowStatus.loading(label: 'Loading entries')),
        error: (error, _) =>
            Center(child: Text('Error loading entries: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fluids_fab',
        backgroundColor: Colors.brown,
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => FluidsEntryScreen(profileId: profileId),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEntryList(
    BuildContext context,
    WidgetRef ref,
    List<FluidsEntry> entries,
  ) => ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: entries.length,
    itemBuilder: (context, index) {
      final entry = entries[index];
      final dateStr = DateFormatters.shortDate(
        DateTime.fromMillisecondsSinceEpoch(entry.entryDate),
      );
      final title = _getEntryTitle(entry);

      return Semantics(
        label: '$title on $dateStr',
        hint: 'Double tap to expand for more details',
        child: Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ExpansionTile(
            leading: const ExcludeSemantics(
              child: CircleAvatar(
                backgroundColor: Colors.brown,
                child: Icon(Icons.wc, color: Colors.white),
              ),
            ),
            title: ExcludeSemantics(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            subtitle: ExcludeSemantics(
              child: Text(
                dateStr,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Options for this entry',
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => FluidsEntryScreen(
                        profileId: profileId,
                        fluidsEntry: entry,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _deleteEntry(context, ref, entry);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.waterIntakeMl != null) ...[
                      _sectionHeader('Water Intake'),
                      _detailRow('Amount', '${entry.waterIntakeMl} ml'),
                      if (entry.waterIntakeNotes != null &&
                          entry.waterIntakeNotes!.isNotEmpty)
                        _detailRow('Notes', entry.waterIntakeNotes!),
                      const SizedBox(height: 8),
                    ],
                    if (entry.bowelCondition != null) ...[
                      _sectionHeader('Bowel Movement'),
                      _detailRow('Condition', entry.bowelCondition!.name),
                      if (entry.bowelSize != null)
                        _detailRow('Size', entry.bowelSize!.name),
                      const SizedBox(height: 8),
                    ],
                    if (entry.urineCondition != null) ...[
                      _sectionHeader('Urine'),
                      _detailRow('Condition', entry.urineCondition!.name),
                      if (entry.urineSize != null)
                        _detailRow('Size', entry.urineSize!.name),
                      const SizedBox(height: 8),
                    ],
                    if (entry.menstruationFlow != null) ...[
                      _sectionHeader('Menstruation'),
                      _detailRow('Flow', entry.menstruationFlow!.name),
                      const SizedBox(height: 8),
                    ],
                    if (entry.basalBodyTemperature != null) ...[
                      _sectionHeader('Basal Body Temperature'),
                      _detailRow(
                        'Temperature',
                        '${entry.basalBodyTemperature!.toStringAsFixed(1)}\u00B0F',
                      ),
                      if (entry.bbtRecordedTime != null)
                        _detailRow(
                          'Recorded',
                          DateFormatters.dateTime12h(
                            DateTime.fromMillisecondsSinceEpoch(
                              entry.bbtRecordedTime!,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                    if (entry.otherFluidName != null) ...[
                      _sectionHeader('Other Fluid'),
                      _detailRow('Name', entry.otherFluidName!),
                      if (entry.otherFluidAmount != null)
                        _detailRow('Amount', entry.otherFluidAmount!),
                      if (entry.otherFluidNotes != null &&
                          entry.otherFluidNotes!.isNotEmpty)
                        _detailRow('Notes', entry.otherFluidNotes!),
                      const SizedBox(height: 8),
                    ],
                    if (entry.notes.isNotEmpty) ...[
                      _sectionHeader('Notes'),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(entry.notes),
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

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
        Expanded(child: Text(value)),
      ],
    ),
  );

  String _getEntryTitle(FluidsEntry entry) {
    final parts = <String>[];
    if (entry.hasWaterData) parts.add('Water');
    if (entry.hasBowelData) parts.add('Bowel');
    if (entry.hasUrineData) parts.add('Urine');
    if (entry.hasMenstruationData) parts.add('Menstruation');
    if (entry.hasBBTData) parts.add('BBT');
    if (entry.hasOtherFluidData) parts.add(entry.otherFluidName!);
    if (parts.isEmpty) return 'Fluids Entry';
    return parts.join(' \u2022 ');
  }

  Future<void> _deleteEntry(
    BuildContext context,
    WidgetRef ref,
    FluidsEntry entry,
  ) async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Delete Entry?',
      contentText: 'Are you sure you want to delete this entry?',
    );
    if (confirmed ?? false) {
      try {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        await ref
            .read(
              fluidsEntryListProvider(
                profileId,
                today.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
                today.add(const Duration(days: 1)).millisecondsSinceEpoch,
              ).notifier,
            )
            .delete(DeleteFluidsEntryInput(id: entry.id, profileId: profileId));
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: 'Entry deleted');
        }
      } on Exception catch (e) {
        if (context.mounted) {
          showAccessibleSnackBar(context: context, message: 'Error: $e');
        }
      }
    }
  }
}
