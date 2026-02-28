// lib/presentation/screens/reports/correlation_view_screen.dart
// Correlation View — photos with ±48-hour event window — Phase 29

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/utils/date_formatters.dart';
import 'package:shadow_app/domain/entities/condition_log.dart';
import 'package:shadow_app/domain/entities/flare_up.dart';
import 'package:shadow_app/domain/entities/fluids_entry.dart';
import 'package:shadow_app/domain/entities/food_log.dart';
import 'package:shadow_app/domain/entities/intake_log.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/photo_area.dart';
import 'package:shadow_app/domain/entities/photo_entry.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shadow_app/presentation/providers/photo_areas/photo_area_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

// ════════════════════════════════════════════════════════════════════════════
// Enum: correlation event categories
// ════════════════════════════════════════════════════════════════════════════

/// Health event categories shown in the correlation window.
enum CorrelationCategory {
  food,
  supplements,
  fluids,
  sleep,
  conditions,
  flareUps,
  journal;

  String get label => switch (this) {
    CorrelationCategory.food => 'Food',
    CorrelationCategory.supplements => 'Supplements',
    CorrelationCategory.fluids => 'Fluids',
    CorrelationCategory.sleep => 'Sleep',
    CorrelationCategory.conditions => 'Conditions',
    CorrelationCategory.flareUps => 'Flare-Ups',
    CorrelationCategory.journal => 'Journal',
  };

  IconData get icon => switch (this) {
    CorrelationCategory.food => Icons.restaurant,
    CorrelationCategory.supplements => Icons.medication,
    CorrelationCategory.fluids => Icons.water_drop,
    CorrelationCategory.sleep => Icons.bedtime,
    CorrelationCategory.conditions => Icons.monitor_heart,
    CorrelationCategory.flareUps => Icons.warning_amber,
    CorrelationCategory.journal => Icons.book,
  };
}

// ════════════════════════════════════════════════════════════════════════════
// Data classes
// ════════════════════════════════════════════════════════════════════════════

/// All health event data loaded for the correlation view in a given date range.
class CorrelationData {
  final List<PhotoEntry> photos;
  final List<FoodLog> foodLogs;
  final List<IntakeLog> intakeLogs;
  final List<FluidsEntry> fluidsEntries;
  final List<SleepEntry> sleepEntries;
  final List<ConditionLog> conditionLogs;
  final List<FlareUp> flareUps;
  final List<JournalEntry> journalEntries;

  const CorrelationData({
    required this.photos,
    required this.foodLogs,
    required this.intakeLogs,
    required this.fluidsEntries,
    required this.sleepEntries,
    required this.conditionLogs,
    required this.flareUps,
    required this.journalEntries,
  });
}

/// A single event displayed in a photo's correlation window.
class _CorrelationEvent {
  final int timestamp; // epoch ms — used to derive before/after/same
  final CorrelationCategory category;
  final String description;

  const _CorrelationEvent({
    required this.timestamp,
    required this.category,
    required this.description,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// Provider
// ════════════════════════════════════════════════════════════════════════════

typedef _CorrelationKey = ({String profileId, int startMs, int endMs});

/// Loads all event data for the correlation view within a date range.
///
/// Photo failures are propagated. Non-critical failures (event categories)
/// degrade gracefully to empty lists.
final correlationDataProvider =
    FutureProvider.family<CorrelationData, _CorrelationKey>((ref, key) async {
      // Start all fetches in parallel.
      final photoFuture = ref
          .read(photoEntryRepositoryProvider)
          .getByProfile(
            key.profileId,
            startDate: key.startMs,
            endDate: key.endMs,
          );
      final foodFuture = ref
          .read(foodLogRepositoryProvider)
          .getByDateRange(key.profileId, key.startMs, key.endMs);
      final intakeFuture = ref
          .read(intakeLogRepositoryProvider)
          .getByProfile(
            key.profileId,
            startDate: key.startMs,
            endDate: key.endMs,
          );
      final fluidsFuture = ref
          .read(fluidsEntryRepositoryProvider)
          .getByDateRange(key.profileId, key.startMs, key.endMs);
      final sleepFuture = ref
          .read(sleepEntryRepositoryProvider)
          .getByProfile(
            key.profileId,
            startDate: key.startMs,
            endDate: key.endMs,
          );
      final condLogFuture = ref
          .read(conditionLogRepositoryProvider)
          .getByDateRange(key.profileId, key.startMs, key.endMs);
      final flareFuture = ref
          .read(flareUpRepositoryProvider)
          .getByProfile(
            key.profileId,
            startDate: key.startMs,
            endDate: key.endMs,
          );
      final journalFuture = ref
          .read(journalEntryRepositoryProvider)
          .getByProfile(
            key.profileId,
            startDate: key.startMs,
            endDate: key.endMs,
          );

      // Await all.
      final photoR = await photoFuture;
      final foodR = await foodFuture;
      final intakeR = await intakeFuture;
      final fluidsR = await fluidsFuture;
      final sleepR = await sleepFuture;
      final condLogR = await condLogFuture;
      final flareR = await flareFuture;
      final journalR = await journalFuture;

      // Photos are critical — propagate failure.
      final photos = photoR.when(success: (v) => v, failure: (e) => throw e);

      // Non-critical — degrade gracefully to empty lists.
      return CorrelationData(
        photos: photos,
        foodLogs: foodR.when(success: (v) => v, failure: (_) => []),
        intakeLogs: intakeR.when(success: (v) => v, failure: (_) => []),
        fluidsEntries: fluidsR.when(success: (v) => v, failure: (_) => []),
        sleepEntries: sleepR.when(success: (v) => v, failure: (_) => []),
        conditionLogs: condLogR.when(success: (v) => v, failure: (_) => []),
        flareUps: flareR.when(success: (v) => v, failure: (_) => []),
        journalEntries: journalR.when(success: (v) => v, failure: (_) => []),
      );
    });

// ════════════════════════════════════════════════════════════════════════════
// Event filtering helpers (extracted for unit testability)
// ════════════════════════════════════════════════════════════════════════════

/// Returns all events within ±[windowHours] of [photo.timestamp],
/// filtered to [categories], sorted chronologically.
List<_CorrelationEvent> _eventsForPhoto(
  PhotoEntry photo,
  CorrelationData data,
  Set<CorrelationCategory> categories,
  int windowHours,
) {
  final windowMs = Duration(hours: windowHours).inMilliseconds;
  final windowStart = photo.timestamp - windowMs;
  final windowEnd = photo.timestamp + windowMs;

  final events = <_CorrelationEvent>[];

  if (categories.contains(CorrelationCategory.food)) {
    for (final log in data.foodLogs) {
      if (log.timestamp >= windowStart && log.timestamp <= windowEnd) {
        final mealLabel = log.mealType?.name ?? 'meal';
        events.add(
          _CorrelationEvent(
            timestamp: log.timestamp,
            category: CorrelationCategory.food,
            description: '$mealLabel: ${log.totalItems} item(s)',
          ),
        );
      }
    }
  }

  if (categories.contains(CorrelationCategory.supplements)) {
    for (final log in data.intakeLogs) {
      if (log.scheduledTime >= windowStart && log.scheduledTime <= windowEnd) {
        events.add(
          _CorrelationEvent(
            timestamp: log.scheduledTime,
            category: CorrelationCategory.supplements,
            description: 'Supplement — ${log.status.name}',
          ),
        );
      }
    }
  }

  if (categories.contains(CorrelationCategory.fluids)) {
    for (final entry in data.fluidsEntries) {
      if (entry.entryDate >= windowStart && entry.entryDate <= windowEnd) {
        final parts = <String>[];
        if (entry.waterIntakeMl != null) {
          parts.add('Water: ${entry.waterIntakeMl}ml');
        }
        if (entry.bowelCondition != null) {
          parts.add('Bowel: ${entry.bowelCondition!.name}');
        }
        if (entry.basalBodyTemperature != null) {
          parts.add('BBT: ${entry.basalBodyTemperature}°F');
        }
        if (entry.menstruationFlow != null) {
          parts.add('Menstruation: ${entry.menstruationFlow!.name}');
        }
        if (entry.urineCondition != null) {
          parts.add('Urine: ${entry.urineCondition!.name}');
        }
        events.add(
          _CorrelationEvent(
            timestamp: entry.entryDate,
            category: CorrelationCategory.fluids,
            description: parts.isEmpty ? 'Fluids entry' : parts.join(', '),
          ),
        );
      }
    }
  }

  if (categories.contains(CorrelationCategory.sleep)) {
    for (final entry in data.sleepEntries) {
      if (entry.bedTime >= windowStart && entry.bedTime <= windowEnd) {
        final minutes = entry.totalSleepMinutes;
        final durationStr = minutes != null
            ? '${(minutes / 60).toStringAsFixed(1)}h'
            : 'in progress';
        events.add(
          _CorrelationEvent(
            timestamp: entry.bedTime,
            category: CorrelationCategory.sleep,
            description: 'Sleep: $durationStr',
          ),
        );
      }
    }
  }

  if (categories.contains(CorrelationCategory.conditions)) {
    for (final log in data.conditionLogs) {
      if (log.timestamp >= windowStart && log.timestamp <= windowEnd) {
        events.add(
          _CorrelationEvent(
            timestamp: log.timestamp,
            category: CorrelationCategory.conditions,
            description: 'Condition — severity ${log.severity}/10',
          ),
        );
      }
    }
  }

  if (categories.contains(CorrelationCategory.flareUps)) {
    for (final flare in data.flareUps) {
      if (flare.startDate >= windowStart && flare.startDate <= windowEnd) {
        events.add(
          _CorrelationEvent(
            timestamp: flare.startDate,
            category: CorrelationCategory.flareUps,
            description: 'Flare-up — severity ${flare.severity}/10',
          ),
        );
      }
    }
  }

  if (categories.contains(CorrelationCategory.journal)) {
    for (final entry in data.journalEntries) {
      if (entry.timestamp >= windowStart && entry.timestamp <= windowEnd) {
        events.add(
          _CorrelationEvent(
            timestamp: entry.timestamp,
            category: CorrelationCategory.journal,
            description: 'Journal entry',
          ),
        );
      }
    }
  }

  events.sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return events;
}

/// Formats the time difference between an event and its photo.
///
/// Returns 'at same time' (< 30 min), 'Xh before', or 'Xh after'.
String _relativeTime(int eventMs, int photoMs) {
  final diffMs = photoMs - eventMs;
  final absMs = diffMs.abs();
  if (absMs < 1800000) return 'at same time'; // < 30 min
  final h = (absMs / 3600000).round();
  return diffMs > 0 ? '${h}h before' : '${h}h after';
}

// ════════════════════════════════════════════════════════════════════════════
// Screen
// ════════════════════════════════════════════════════════════════════════════

enum _DatePreset { last30, last90, allTime }

/// Correlation View — photos with ±48-hour surrounding health event window.
///
/// Shows photos newest-first with health events before and after each photo
/// to help users identify triggers and patterns.
class CorrelationViewScreen extends ConsumerStatefulWidget {
  final String profileId;

  const CorrelationViewScreen({super.key, required this.profileId});

  @override
  ConsumerState<CorrelationViewScreen> createState() =>
      _CorrelationViewScreenState();
}

class _CorrelationViewScreenState extends ConsumerState<CorrelationViewScreen> {
  static const _windowHours = 48;

  var _preset = _DatePreset.last90;
  Set<CorrelationCategory> _selectedCategories = {
    ...CorrelationCategory.values,
  };
  Set<String> _selectedPhotoAreaIds = {};

  /// Stable key for the correlation data provider.
  ///
  /// Computed ONCE in [initState] and only updated when the user changes
  /// the date preset in the filter sheet. Must NOT be computed in [build]
  /// because [DateTime.now()] would produce a different key on every frame,
  /// causing the provider to reload continuously.
  late _CorrelationKey _key;

  @override
  void initState() {
    super.initState();
    _key = _computeKey(_preset);
  }

  _CorrelationKey _computeKey(_DatePreset preset) {
    final now = DateTime.now();
    final (start, end) = switch (preset) {
      _DatePreset.last30 => (now.subtract(const Duration(days: 30)), now),
      _DatePreset.last90 => (now.subtract(const Duration(days: 90)), now),
      _DatePreset.allTime => (DateTime(2000), now),
    };
    return (
      profileId: widget.profileId,
      startMs: start.millisecondsSinceEpoch,
      endMs: end.millisecondsSinceEpoch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(correlationDataProvider(_key));
    final areasAsync = ref.watch(photoAreaListProvider(widget.profileId));
    final areas = areasAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Correlation View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Filter',
            onPressed: () => _showFilterSheet(context, areas),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(
          child: ShadowStatus.loading(label: 'Loading correlation data'),
        ),
        error: (error, _) => _buildError(context, error),
        data: (data) => _buildBody(context, data, areas),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CorrelationData data,
    List<PhotoArea> areas,
  ) {
    // Apply photo area filter client-side.
    final photos =
        (_selectedPhotoAreaIds.isEmpty
              ? List<PhotoEntry>.of(data.photos)
              : data.photos
                    .where((p) => _selectedPhotoAreaIds.contains(p.photoAreaId))
                    .toList())
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (photos.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.photo_library_outlined,
        message: 'No photos in this date range',
        submessage: 'Add photos in the Tracking tab to see correlations.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return _CorrelationPhotoCard(
          photo: photo,
          data: data,
          areas: areas,
          selectedCategories: _selectedCategories,
          windowHours: _windowHours,
        );
      },
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Failed to load data', style: theme.textTheme.titleLarge),
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
            FilledButton(
              onPressed: () => ref.invalidate(correlationDataProvider(_key)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFilterSheet(
    BuildContext context,
    List<PhotoArea> areas,
  ) async {
    final result = await showModalBottomSheet<_FilterResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FilterSheet(
        initialPreset: _preset,
        initialCategories: Set.of(_selectedCategories),
        initialAreaIds: Set.of(_selectedPhotoAreaIds),
        areas: areas,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedCategories = result.categories;
        _selectedPhotoAreaIds = result.areaIds;
        if (result.preset != _preset) {
          _preset = result.preset;
          _key = _computeKey(_preset);
        }
      });
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Filter sheet
// ════════════════════════════════════════════════════════════════════════════

class _FilterResult {
  final _DatePreset preset;
  final Set<CorrelationCategory> categories;
  final Set<String> areaIds;

  const _FilterResult({
    required this.preset,
    required this.categories,
    required this.areaIds,
  });
}

class _FilterSheet extends StatefulWidget {
  final _DatePreset initialPreset;
  final Set<CorrelationCategory> initialCategories;
  final Set<String> initialAreaIds;
  final List<PhotoArea> areas;

  const _FilterSheet({
    required this.initialPreset,
    required this.initialCategories,
    required this.initialAreaIds,
    required this.areas,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _DatePreset _preset;
  late Set<CorrelationCategory> _categories;
  late Set<String> _areaIds;

  @override
  void initState() {
    super.initState();
    _preset = widget.initialPreset;
    _categories = Set.of(widget.initialCategories);
    _areaIds = Set.of(widget.initialAreaIds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Filter',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Scrollable sections
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1 — Date Range
                    Text(
                      'Date Range',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        ChoiceChip(
                          label: const Text('Last 30 days'),
                          selected: _preset == _DatePreset.last30,
                          onSelected: (_) =>
                              setState(() => _preset = _DatePreset.last30),
                        ),
                        ChoiceChip(
                          label: const Text('Last 90 days'),
                          selected: _preset == _DatePreset.last90,
                          onSelected: (_) =>
                              setState(() => _preset = _DatePreset.last90),
                        ),
                        ChoiceChip(
                          label: const Text('All time'),
                          selected: _preset == _DatePreset.allTime,
                          onSelected: (_) =>
                              setState(() => _preset = _DatePreset.allTime),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 2 — Photo Areas (only if multiple areas)
                    if (widget.areas.length > 1) ...[
                      Text(
                        'Photo Areas',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final area in widget.areas)
                            FilterChip(
                              label: Text(area.name),
                              // Empty _areaIds set = all areas selected.
                              selected:
                                  _areaIds.isEmpty ||
                                  _areaIds.contains(area.id),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    if (_areaIds.isNotEmpty) {
                                      _areaIds.add(area.id);
                                      // Reset to 'all' if every area is now selected.
                                      if (_areaIds.length ==
                                          widget.areas.length) {
                                        _areaIds = {};
                                      }
                                    }
                                    // Already all-selected (empty) — nothing to do.
                                  } else {
                                    // Deselecting: if currently all-selected (empty set),
                                    // switch to explicit set minus this area.
                                    if (_areaIds.isEmpty) {
                                      _areaIds = widget.areas
                                          .map((a) => a.id)
                                          .where((id) => id != area.id)
                                          .toSet();
                                    } else {
                                      _areaIds.remove(area.id);
                                    }
                                  }
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Section 3 — Event Categories
                    Text(
                      'Event Categories',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final cat in CorrelationCategory.values)
                          FilterChip(
                            avatar: Icon(cat.icon, size: 16),
                            label: Text(cat.label),
                            selected: _categories.contains(cat),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _categories.add(cat);
                                } else {
                                  _categories.remove(cat);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Apply button — pinned outside scroll area
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(
                    context,
                    _FilterResult(
                      preset: _preset,
                      categories: _categories,
                      areaIds: _areaIds,
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Photo card
// ════════════════════════════════════════════════════════════════════════════

/// Displays one photo with its surrounding ±windowHours health events.
class _CorrelationPhotoCard extends StatelessWidget {
  final PhotoEntry photo;
  final CorrelationData data;
  final List<PhotoArea> areas;
  final Set<CorrelationCategory> selectedCategories;
  final int windowHours;

  const _CorrelationPhotoCard({
    required this.photo,
    required this.data,
    required this.areas,
    required this.selectedCategories,
    required this.windowHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.fromMillisecondsSinceEpoch(photo.timestamp);
    final dateStr =
        '${DateFormatters.shortDate(date)} • ${DateFormatters.dateTime12h(date)}';
    final areaName = areas
        .where((a) => a.id == photo.photoAreaId)
        .map((a) => a.name)
        .firstOrNull;
    final events = _eventsForPhoto(
      photo,
      data,
      selectedCategories,
      windowHours,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Photo thumbnail
        ShadowImage.file(
          filePath: photo.filePath,
          width: double.infinity,
          height: 220,
          isDecorative: true,
        ),

        // 2. Photo metadata
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateStr, style: theme.textTheme.titleSmall),
              if (areaName != null) ...[
                const SizedBox(height: 2),
                Text(
                  areaName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (photo.notes != null && photo.notes!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  photo.notes!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),

        // 3. Event window header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
          child: Text(
            '±${windowHours}h window',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // 4. Event list (or empty message)
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              'No selected events in ±$windowHours hour window',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final event in events) _buildEventRow(context, event, theme),

        // 5. Divider
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEventRow(
    BuildContext context,
    _CorrelationEvent event,
    ThemeData theme,
  ) {
    final diffMs = photo.timestamp - event.timestamp;
    final isBefore = diffMs > 1800000; // > 30 min before
    final isAfter = diffMs < -1800000; // > 30 min after
    final color = isBefore
        ? Colors.blueGrey
        : isAfter
        ? Colors.amber.shade700
        : theme.colorScheme.primary;
    final relTime = _relativeTime(event.timestamp, photo.timestamp);

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(event.category.icon, size: 16, color: color),
      title: Text(
        event.description,
        style: theme.textTheme.bodySmall?.copyWith(color: color),
      ),
      subtitle: Text(
        relTime,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
