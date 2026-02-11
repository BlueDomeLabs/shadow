// lib/presentation/screens/activity_logs/activity_log_screen.dart
// Activity log screen following FoodLogScreen pattern.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/activity.dart';
import 'package:shadow_app/domain/entities/activity_log.dart';
import 'package:shadow_app/domain/usecases/activity_logs/activity_logs_usecases.dart';
import 'package:shadow_app/presentation/providers/activities/activity_list_provider.dart';
import 'package:shadow_app/presentation/providers/activity_logs/activity_log_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for creating or editing an activity log entry.
///
/// Fields from [LogActivityInput]:
/// - timestamp (date/time picker, required)
/// - activityIds (multi-select from activity list)
/// - adHocActivities (text chips)
/// - duration (optional)
/// - notes (optional)
class ActivityLogScreen extends ConsumerStatefulWidget {
  final String profileId;
  final ActivityLog? activityLog;

  const ActivityLogScreen({
    super.key,
    required this.profileId,
    this.activityLog,
  });

  @override
  ConsumerState<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends ConsumerState<ActivityLogScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _notesController;
  late final TextEditingController _adHocItemController;
  late final TextEditingController _durationController;

  late DateTime _selectedDateTime;
  late List<String> _selectedActivityIds;
  late List<String> _adHocActivities;

  bool _isDirty = false;
  bool _isSaving = false;

  String? _dateTimeError;
  String? _adHocItemError;
  String? _notesError;

  bool get _isEditing => widget.activityLog != null;

  @override
  void initState() {
    super.initState();
    final log = widget.activityLog;

    _notesController = TextEditingController(text: log?.notes ?? '');
    _adHocItemController = TextEditingController();
    _durationController = TextEditingController(
      text: log?.duration != null ? log!.duration.toString() : '',
    );

    _selectedDateTime = log != null
        ? DateTime.fromMillisecondsSinceEpoch(log.timestamp)
        : DateTime.now();

    _selectedActivityIds = log != null
        ? List<String>.from(log.activityIds)
        : [];

    _adHocActivities = log != null
        ? List<String>.from(log.adHocActivities)
        : [];

    _notesController.addListener(_markDirty);
    _durationController.addListener(_markDirty);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _adHocItemController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_isDirty) {
      setState(() {
        _isDirty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(activityListProvider(widget.profileId));

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldLeave = await _confirmDiscard();
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Activity Log' : 'Log Activity'),
          actions: [
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
        body: Semantics(
          label: _isEditing ? 'Edit activity log form' : 'Log activity form',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader(theme, 'Date & Time'),
                const SizedBox(height: 16),
                _buildDateTimePicker(theme),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Activities'),
                const SizedBox(height: 16),
                _buildActivitySelector(theme, activitiesAsync),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Ad-hoc Activities'),
                const SizedBox(height: 16),
                _buildAdHocActivitiesSection(theme),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Duration'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Actual duration in minutes, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _durationController,
                      label: 'Duration (minutes)',
                      hintText: 'Override planned duration',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(theme, 'Notes'),
                const SizedBox(height: 16),
                Semantics(
                  label: 'Activity notes, optional',
                  textField: true,
                  child: ExcludeSemantics(
                    child: ShadowTextField(
                      controller: _notesController,
                      label: 'Notes',
                      hintText: 'Any notes about this session',
                      errorText: _notesError,
                      maxLength: ValidationRules.notesMaxLength,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) => _validateNotes(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ShadowButton.outlined(
                        onPressed: _isSaving ? null : _handleCancel,
                        label: 'Cancel',
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShadowButton.elevated(
                        onPressed: _isSaving ? null : _handleSave,
                        label: _isEditing
                            ? 'Save activity log changes'
                            : 'Save new activity log',
                        child: Text(_isEditing ? 'Save Changes' : 'Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) => Semantics(
    header: true,
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  Widget _buildDateTimePicker(ThemeData theme) {
    final dateStr =
        '${_selectedDateTime.month}/${_selectedDateTime.day}/${_selectedDateTime.year}';
    final hour = _selectedDateTime.hour % 12 == 0
        ? 12
        : _selectedDateTime.hour % 12;
    final minute = _selectedDateTime.minute.toString().padLeft(2, '0');
    final period = _selectedDateTime.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';

    return Semantics(
      label: 'When performed, required',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dateTimeError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _dateTimeError!,
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateStr),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(timeStr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        _isDirty = true;
        _validateDateTime();
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
        _isDirty = true;
        _validateDateTime();
      });
    }
  }

  Widget _buildActivitySelector(
    ThemeData theme,
    AsyncValue<List<Activity>> activitiesAsync,
  ) => activitiesAsync.when(
    data: (activities) {
      final activeActivities = activities.where((a) => a.isActive).toList();
      if (activeActivities.isEmpty) {
        return Text(
          'No activities defined. Create activities first.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      }
      return Wrap(
        spacing: 8,
        runSpacing: 4,
        children: activeActivities.map((activity) {
          final isSelected = _selectedActivityIds.contains(activity.id);
          return FilterChip(
            label: Text(activity.name),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedActivityIds.add(activity.id);
                } else {
                  _selectedActivityIds.remove(activity.id);
                }
                _isDirty = true;
              });
            },
          );
        }).toList(),
      );
    },
    loading: () => const ShadowStatus.loading(label: 'Loading activities'),
    error: (error, _) => Text(
      'Failed to load activities',
      style: TextStyle(color: theme.colorScheme.error),
    ),
  );

  Widget _buildAdHocActivitiesSection(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              label: 'Ad-hoc activity name',
              textField: true,
              child: ExcludeSemantics(
                child: ShadowTextField(
                  controller: _adHocItemController,
                  label: 'Ad-hoc Activity',
                  hintText: 'Add unlisted activity...',
                  errorText: _adHocItemError,
                  maxLength: ValidationRules.nameMaxLength,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addAdHocActivity(),
                  onChanged: (_) {
                    if (_adHocItemError != null) {
                      setState(() => _adHocItemError = null);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ShadowButton.icon(
            icon: Icons.add,
            label: 'Add ad-hoc activity',
            onPressed: _addAdHocActivity,
          ),
        ],
      ),
      if (_adHocActivities.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _adHocActivities.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Chip(
              label: Text(item),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _removeAdHocActivity(index),
            );
          }).toList(),
        ),
      ],
    ],
  );

  void _addAdHocActivity() {
    final text = _adHocItemController.text.trim();
    if (text.isEmpty) return;

    if (text.length < ValidationRules.nameMinLength) {
      setState(
        () => _adHocItemError =
            'Activity name must be at least ${ValidationRules.nameMinLength} characters',
      );
      return;
    }
    if (text.length > ValidationRules.nameMaxLength) {
      setState(
        () => _adHocItemError =
            'Activity name must not exceed ${ValidationRules.nameMaxLength} characters',
      );
      return;
    }

    setState(() {
      _adHocActivities.add(text);
      _adHocItemController.clear();
      _adHocItemError = null;
      _isDirty = true;
    });
  }

  void _removeAdHocActivity(int index) {
    setState(() {
      _adHocActivities.removeAt(index);
      _isDirty = true;
    });
  }

  bool _validateDateTime() {
    final now = DateTime.now();
    String? error;
    if (_selectedDateTime.isAfter(now)) {
      error = 'Date and time cannot be in the future';
    }
    setState(() => _dateTimeError = error);
    return error == null;
  }

  bool _validateNotes() {
    final notes = _notesController.text.trim();
    String? error;
    if (notes.length > ValidationRules.notesMaxLength) {
      error =
          'Notes must not exceed ${ValidationRules.notesMaxLength} characters';
    }
    setState(() => _notesError = error);
    return error == null;
  }

  bool _validateAll() {
    final dateTimeValid = _validateDateTime();
    final notesValid = _validateNotes();
    return dateTimeValid && notesValid;
  }

  Future<void> _handleCancel() async {
    if (_isDirty) {
      final shouldLeave = await _confirmDiscard();
      if (!shouldLeave || !mounted) return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _confirmDiscard() async {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      title: 'Discard Changes?',
      contentText:
          'You have unsaved changes. Are you sure you want to discard them?',
      confirmButtonText: 'Discard',
      cancelButtonText: 'Keep Editing',
    );
    return confirmed ?? false;
  }

  Future<void> _handleSave() async {
    if (!_validateAll()) return;

    setState(() => _isSaving = true);

    try {
      final timestamp = _selectedDateTime.millisecondsSinceEpoch;
      final durationText = _durationController.text.trim();
      final duration = durationText.isNotEmpty
          ? int.tryParse(durationText)
          : null;

      if (_isEditing) {
        await ref
            .read(activityLogListProvider(widget.profileId).notifier)
            .updateLog(
              UpdateActivityLogInput(
                id: widget.activityLog!.id,
                profileId: widget.profileId,
                activityIds: _selectedActivityIds,
                adHocActivities: _adHocActivities,
                duration: duration,
                notes: _notesController.text.trim(),
              ),
            );
      } else {
        await ref
            .read(activityLogListProvider(widget.profileId).notifier)
            .log(
              LogActivityInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                timestamp: timestamp,
                activityIds: _selectedActivityIds,
                adHocActivities: _adHocActivities,
                duration: duration,
                notes: _notesController.text.trim(),
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing
              ? 'Activity log updated successfully'
              : 'Activity log created successfully',
        );
        Navigator.of(context).pop();
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
