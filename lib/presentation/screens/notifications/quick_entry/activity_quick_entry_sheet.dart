// lib/presentation/screens/notifications/quick_entry/activity_quick_entry_sheet.dart
// Per 57_NOTIFICATION_SYSTEM.md — Activities quick-entry sheet

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_log_inputs.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/providers/activity_logs/activity_log_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Quick-entry sheet for Activities notification category.
///
/// Opened when the user taps an Activities notification.
/// Shows a list of defined activities (most recent first), duration input,
/// intensity selector, and a "Log Activity" button.
/// Per 57_NOTIFICATION_SYSTEM.md section: Activities.
class ActivityQuickEntrySheet extends ConsumerStatefulWidget {
  final String profileId;

  const ActivityQuickEntrySheet({super.key, required this.profileId});

  /// Shows the sheet as a modal bottom sheet.
  static Future<void> show(BuildContext context, {required String profileId}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => ActivityQuickEntrySheet(profileId: profileId),
      );

  @override
  ConsumerState<ActivityQuickEntrySheet> createState() =>
      _ActivityQuickEntrySheetState();
}

class _ActivityQuickEntrySheetState
    extends ConsumerState<ActivityQuickEntrySheet> {
  final _durationController = TextEditingController();
  Activity? _selectedActivity;
  ActivityIntensity _selectedIntensity = ActivityIntensity.moderate;
  bool _isSaving = false;
  String? _durationError;

  static const _intensityLabels = {
    ActivityIntensity.light: 'Light',
    ActivityIntensity.moderate: 'Moderate',
    ActivityIntensity.vigorous: 'Vigorous',
  };

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  bool _validateDuration() {
    final text = _durationController.text.trim();
    if (text.isEmpty) {
      setState(() => _durationError = 'Duration is required');
      return false;
    }
    final value = int.tryParse(text);
    if (value == null || value <= 0) {
      setState(() => _durationError = 'Enter a positive number of minutes');
      return false;
    }
    setState(() => _durationError = null);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(activityListProvider(widget.profileId));

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Semantics(
        label: 'Activity log quick-entry sheet',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text('Log Activity', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 16),
            // Activity selector
            activitiesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
              data: (activities) {
                final active = activities.where((a) => a.isActive).toList();
                if (active.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No activities defined yet.',
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                }
                return Semantics(
                  label: 'Activity type, optional',
                  child: ExcludeSemantics(
                    child: DropdownButtonFormField<Activity?>(
                      initialValue: _selectedActivity,
                      decoration: const InputDecoration(
                        labelText: 'Activity Type',
                        hintText: 'Select or leave blank for ad-hoc',
                      ),
                      items: [
                        const DropdownMenuItem<Activity?>(
                          child: Text('Ad-hoc (no type)'),
                        ),
                        ...active.map(
                          (a) => DropdownMenuItem<Activity?>(
                            value: a,
                            child: Text(a.name),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedActivity = value),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            // Duration input
            Semantics(
              label: 'Duration in minutes, required',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _durationController,
                  label: 'Duration (minutes)',
                  hintText: 'e.g. 30',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  errorText: _durationError,
                  onChanged: (_) {
                    if (_durationError != null) _validateDuration();
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Intensity selector
            Semantics(
              label: 'Activity intensity',
              child: ExcludeSemantics(
                child: SegmentedButton<ActivityIntensity>(
                  segments: ActivityIntensity.values
                      .map(
                        (i) => ButtonSegment<ActivityIntensity>(
                          value: i,
                          label: Text(_intensityLabels[i]!),
                        ),
                      )
                      .toList(),
                  selected: {_selectedIntensity},
                  onSelectionChanged: (selected) =>
                      setState(() => _selectedIntensity = selected.first),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ShadowButton.elevated(
              onPressed: _isSaving ? null : _handleSave,
              label: 'Log activity',
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Log Activity'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_validateDuration()) return;

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(
        activityLogListProvider(widget.profileId).notifier,
      );

      await notifier.log(
        LogActivityInput(
          profileId: widget.profileId,
          clientId: const Uuid().v4(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
          activityIds: _selectedActivity != null ? [_selectedActivity!.id] : [],
          duration: int.parse(_durationController.text.trim()),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop();
        showAccessibleSnackBar(context: context, message: 'Activity logged');
      }
    } on AppError catch (e) {
      if (mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'An unexpected error occurred',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
