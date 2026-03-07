// lib/presentation/screens/bodily_output/bodily_output_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shadow_app/domain/entities/bodily_output_enums.dart';
import 'package:shadow_app/domain/entities/bodily_output_log.dart';
import 'package:shadow_app/presentation/providers/bodily_output_providers.dart';
import 'package:shadow_app/presentation/screens/bodily_output/bodily_output_edit_screen.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Displays the list of bodily output events for a profile, grouped by day.
class BodilyOutputListScreen extends ConsumerWidget {
  final String profileId;

  const BodilyOutputListScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _BodilyOutputListBody(profileId: profileId);
}

class _BodilyOutputListBody extends ConsumerStatefulWidget {
  final String profileId;

  const _BodilyOutputListBody({required this.profileId});

  @override
  ConsumerState<_BodilyOutputListBody> createState() =>
      _BodilyOutputListBodyState();
}

class _BodilyOutputListBodyState extends ConsumerState<_BodilyOutputListBody> {
  late Future<List<BodilyOutputLog>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    final useCase = ref.read(getBodilyOutputsUseCaseProvider);
    _logsFuture = useCase
        .execute(widget.profileId)
        .then(
          (result) =>
              result.when(success: (logs) => logs, failure: (e) => throw e),
        );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bodily Functions')),
    body: FutureBuilder<List<BodilyOutputLog>>(
      future: _logsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: ShadowStatus.loading(label: 'Loading events'),
          );
        }
        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error);
        }
        final logs = snapshot.data ?? [];
        if (logs.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildLogList(context, logs);
      },
    ),
    floatingActionButton: Semantics(
      label: 'Log new bodily output event',
      child: FloatingActionButton(
        onPressed: () => _navigateToAdd(context),
        child: const Icon(Icons.add),
      ),
    ),
  );

  Widget _buildErrorState(BuildContext context, Object? error) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          const Text('Failed to load events'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => setState(_loadLogs),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );

  Widget _buildEmptyState(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wc, size: 64),
          SizedBox(height: 16),
          Text('No events logged yet', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('Tap + to log a new event', textAlign: TextAlign.center),
        ],
      ),
    ),
  );

  Widget _buildLogList(BuildContext context, List<BodilyOutputLog> logs) {
    final grouped = <String, List<BodilyOutputLog>>{};
    for (final log in logs) {
      final day = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.fromMillisecondsSinceEpoch(log.occurredAt));
      grouped.putIfAbsent(day, () => []).add(log);
    }
    final sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return RefreshIndicator(
      onRefresh: () async => setState(_loadLogs),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedDays.length,
        itemBuilder: (context, i) {
          final day = sortedDays[i];
          final dayLogs = grouped[day]!;
          final date = DateFormat('yyyy-MM-dd').parse(day);
          final dayLabel = DateFormat.yMMMMd().format(date);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i > 0) const SizedBox(height: 16),
              _buildDayHeader(context, dayLabel),
              const SizedBox(height: 8),
              ...dayLogs.map((log) => _buildLogCard(context, log)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      child: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLogCard(BuildContext context, BodilyOutputLog log) {
    final theme = Theme.of(context);
    final time = DateFormat.jm().format(
      DateTime.fromMillisecondsSinceEpoch(log.occurredAt),
    );
    final typeLabel = _typeLabel(log.outputType);

    return Padding(
      key: ValueKey(log.id),
      padding: const EdgeInsets.only(bottom: 8),
      child: ShadowCard.listItem(
        onTap: () => _navigateToEdit(context, log),
        semanticLabel: '$typeLabel at $time',
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
                _typeIcon(log.outputType),
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (log.notes != null && log.notes!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      log.notes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(BodyOutputType type) => switch (type) {
    BodyOutputType.urine => 'Urine',
    BodyOutputType.bowel => 'Bowel movement',
    BodyOutputType.gas => 'Gas',
    BodyOutputType.menstruation => 'Menstruation',
    BodyOutputType.bbt => 'Basal body temperature',
    BodyOutputType.custom => 'Custom',
  };

  IconData _typeIcon(BodyOutputType type) => switch (type) {
    BodyOutputType.urine => Icons.water_drop,
    BodyOutputType.bowel => Icons.emoji_nature,
    BodyOutputType.gas => Icons.air,
    BodyOutputType.menstruation => Icons.favorite,
    BodyOutputType.bbt => Icons.thermostat,
    BodyOutputType.custom => Icons.category,
  };

  void _navigateToAdd(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => BodilyOutputEditScreen(
          profileId: widget.profileId,
          existingLog: null,
        ),
      ),
    ).then((_) => setState(_loadLogs));
  }

  void _navigateToEdit(BuildContext context, BodilyOutputLog log) {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => BodilyOutputEditScreen(
          profileId: widget.profileId,
          existingLog: log,
        ),
      ),
    ).then((_) => setState(_loadLogs));
  }
}
