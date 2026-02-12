// lib/presentation/screens/sleep_entries/sleep_entry_edit_screen.dart
// Implements 38_UI_FIELD_SPECIFICATIONS.md Section 7.1 - Sleep Entry Edit

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/sleep_entry.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/sleep_entries/sleep_entries_usecases.dart';
import 'package:shadow_app/presentation/providers/sleep_entries/sleep_entry_list_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Screen for adding or editing a sleep entry.
///
/// Follows 38_UI_FIELD_SPECIFICATIONS.md Section 7.1 exactly.
/// Uses ConsumerStatefulWidget per coding standards.
class SleepEntryEditScreen extends ConsumerStatefulWidget {
  final String profileId;
  final SleepEntry? sleepEntry;

  const SleepEntryEditScreen({
    super.key,
    required this.profileId,
    this.sleepEntry,
  });

  @override
  ConsumerState<SleepEntryEditScreen> createState() =>
      _SleepEntryEditScreenState();
}

class _SleepEntryEditScreenState extends ConsumerState<SleepEntryEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _timesAwakenedController = TextEditingController();

  bool get _isEditing => widget.sleepEntry != null;

  // Time Section
  late DateTime _sleepDate;
  late TimeOfDay _bedTime;
  late TimeOfDay _wakeTime;

  // Sleep Quality Section
  String _timeToFallAsleep = 'Not set';
  int _timesAwakened = 0;
  String _timeAwakeDuringNight = 'None';

  // Waking Section
  WakingFeeling _wakingFeeling = WakingFeeling.neutral;
  DreamType _dreamType = DreamType.noDreams;

  bool _isSaving = false;

  // Dropdown options per spec
  static const _timeToFallAsleepOptions = [
    'Not set',
    'Immediately',
    '5 min',
    '15 min',
    '30 min',
    '1 hour',
    '1+ hours',
  ];

  static const _timeAwakeOptions = [
    'None',
    'A few min',
    '15 min',
    '30 min',
    '1 hour',
    '1+ hours',
  ];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (_isEditing) {
      final entry = widget.sleepEntry!;
      final bedDateTime = DateTime.fromMillisecondsSinceEpoch(entry.bedTime);
      _sleepDate = DateTime(
        bedDateTime.year,
        bedDateTime.month,
        bedDateTime.day,
      );
      _bedTime = TimeOfDay(hour: bedDateTime.hour, minute: bedDateTime.minute);

      if (entry.wakeTime != null) {
        final wakeDateTime = DateTime.fromMillisecondsSinceEpoch(
          entry.wakeTime!,
        );
        _wakeTime = TimeOfDay(
          hour: wakeDateTime.hour,
          minute: wakeDateTime.minute,
        );
      } else {
        _wakeTime = const TimeOfDay(hour: 6, minute: 30);
      }

      _wakingFeeling = entry.wakingFeeling;
      _dreamType = entry.dreamType;
      _notesController.text = entry.notes ?? '';
    } else {
      // Defaults per spec
      final now = DateTime.now();
      _sleepDate = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 1));
      _bedTime = const TimeOfDay(hour: 22, minute: 30); // 10:30 PM
      _wakeTime = const TimeOfDay(hour: 6, minute: 30); // 6:30 AM
    }
    _timesAwakenedController.text = _timesAwakened.toString();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _timesAwakenedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Sleep Entry' : 'Add Sleep Entry'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _onSave,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === Time Section ===
            _buildSectionHeader(context, 'Time'),
            const SizedBox(height: 12),
            _buildDatePicker(context, theme),
            const SizedBox(height: 16),
            _buildBedTimePicker(context, theme),
            const SizedBox(height: 16),
            _buildWakeTimePicker(context, theme),

            const SizedBox(height: 24),

            // === Sleep Quality Section ===
            _buildSectionHeader(context, 'Sleep Quality'),
            const SizedBox(height: 12),
            _buildTimeToFallAsleepDropdown(theme),
            const SizedBox(height: 16),
            _buildTimesAwakenedField(theme),
            const SizedBox(height: 16),
            _buildTimeAwakeDropdown(theme),

            const SizedBox(height: 24),

            // === Waking Section ===
            _buildSectionHeader(context, 'Waking'),
            const SizedBox(height: 12),
            _buildWakingFeelingSelector(theme),
            const SizedBox(height: 16),
            _buildDreamTypeDropdown(theme),
            const SizedBox(height: 16),
            _buildNotesField(theme),

            const SizedBox(height: 32),
          ],
        ),
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

  Widget _buildDatePicker(BuildContext context, ThemeData theme) => Semantics(
    label: 'Sleep date, ${_formatDate(_sleepDate)}, required',
    child: InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Sleep Date',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(_formatDate(_sleepDate), style: theme.textTheme.bodyLarge),
      ),
    ),
  );

  Widget _buildBedTimePicker(BuildContext context, ThemeData theme) =>
      Semantics(
        label: 'When you went to bed, ${_formatTimeOfDay(_bedTime)}, required',
        child: InkWell(
          onTap: () => _selectBedTime(context),
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Bed Time',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.bedtime),
            ),
            child: Text(
              _formatTimeOfDay(_bedTime),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      );

  Widget _buildWakeTimePicker(BuildContext context, ThemeData theme) =>
      Semantics(
        label: 'When you woke up, ${_formatTimeOfDay(_wakeTime)}, required',
        child: InkWell(
          onTap: () => _selectWakeTime(context),
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Wake Time',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.wb_sunny),
            ),
            child: Text(
              _formatTimeOfDay(_wakeTime),
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      );

  Widget _buildTimeToFallAsleepDropdown(ThemeData theme) => Semantics(
    label: 'Time to fall asleep, optional',
    child: DropdownButtonFormField<String>(
      initialValue: _timeToFallAsleep,
      decoration: const InputDecoration(
        labelText: 'Time to Fall Asleep',
        border: OutlineInputBorder(),
      ),
      items: _timeToFallAsleepOptions
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _timeToFallAsleep = value);
        }
      },
    ),
  );

  Widget _buildTimesAwakenedField(ThemeData theme) => Semantics(
    label: 'Number of wake-ups, optional',
    child: ShadowTextField.numeric(
      controller: _timesAwakenedController,
      label: 'Times Awakened',
      hintText: '0',
      helperText: '0-${ValidationRules.timesAwakenedMax}',
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _RangeTextInputFormatter(min: 0, max: ValidationRules.timesAwakenedMax),
      ],
      onChanged: (value) {
        final parsed = int.tryParse(value);
        if (parsed != null &&
            parsed >= 0 &&
            parsed <= ValidationRules.timesAwakenedMax) {
          setState(() => _timesAwakened = parsed);
        }
      },
    ),
  );

  Widget _buildTimeAwakeDropdown(ThemeData theme) => Semantics(
    label: 'Time awake during night, optional',
    child: DropdownButtonFormField<String>(
      initialValue: _timeAwakeDuringNight,
      decoration: const InputDecoration(
        labelText: 'Time Awake During Night',
        border: OutlineInputBorder(),
      ),
      items: _timeAwakeOptions
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _timeAwakeDuringNight = value);
        }
      },
    ),
  );

  Widget _buildWakingFeelingSelector(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Waking Feeling', style: theme.textTheme.titleSmall),
      const SizedBox(height: 8),
      Semantics(
        label: 'Waking feeling, ${_getWakingFeelingLabel(_wakingFeeling)}',
        child: SegmentedButton<WakingFeeling>(
          segments: const [
            ButtonSegment(
              value: WakingFeeling.unrested,
              label: Text('Groggy'),
              icon: Icon(Icons.sentiment_dissatisfied),
            ),
            ButtonSegment(
              value: WakingFeeling.neutral,
              label: Text('Neutral'),
              icon: Icon(Icons.sentiment_neutral),
            ),
            ButtonSegment(
              value: WakingFeeling.rested,
              label: Text('Rested'),
              icon: Icon(Icons.sentiment_satisfied),
            ),
          ],
          selected: {_wakingFeeling},
          onSelectionChanged: (selected) {
            if (selected.isNotEmpty) {
              setState(() => _wakingFeeling = selected.first);
            }
          },
        ),
      ),
    ],
  );

  Widget _buildDreamTypeDropdown(ThemeData theme) => Semantics(
    label: 'Dream type, optional',
    child: DropdownButtonFormField<DreamType>(
      initialValue: _dreamType,
      decoration: const InputDecoration(
        labelText: 'Dream Type',
        border: OutlineInputBorder(),
      ),
      items: DreamType.values
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(_getDreamTypeLabel(type)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _dreamType = value);
        }
      },
    ),
  );

  Widget _buildNotesField(ThemeData theme) => Semantics(
    label: 'Sleep notes, optional',
    child: ShadowTextField.text(
      controller: _notesController,
      label: 'Notes',
      hintText: 'Any notes about your sleep',
      maxLines: 4,
      maxLength: ValidationRules.notesMaxLength,
    ),
  );

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _sleepDate,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _sleepDate = picked);
    }
  }

  Future<void> _selectBedTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _bedTime,
    );
    if (picked != null) {
      setState(() => _bedTime = picked);
    }
  }

  Future<void> _selectWakeTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null) {
      setState(() => _wakeTime = picked);
    }
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    try {
      // Calculate epoch milliseconds for bed time and wake time
      final bedDateTime = DateTime(
        _sleepDate.year,
        _sleepDate.month,
        _sleepDate.day,
        _bedTime.hour,
        _bedTime.minute,
      );

      // Wake time is the next day if wake hour is less than bed hour
      var wakeDate = _sleepDate;
      if (_wakeTime.hour < _bedTime.hour ||
          (_wakeTime.hour == _bedTime.hour &&
              _wakeTime.minute <= _bedTime.minute)) {
        wakeDate = _sleepDate.add(const Duration(days: 1));
      }
      final wakeDateTime = DateTime(
        wakeDate.year,
        wakeDate.month,
        wakeDate.day,
        _wakeTime.hour,
        _wakeTime.minute,
      );

      final bedTimeEpoch = bedDateTime.millisecondsSinceEpoch;
      final wakeTimeEpoch = wakeDateTime.millisecondsSinceEpoch;
      final notes = _notesController.text.trim();

      if (_isEditing) {
        await ref
            .read(sleepEntryListProvider(widget.profileId).notifier)
            .updateEntry(
              UpdateSleepEntryInput(
                id: widget.sleepEntry!.id,
                profileId: widget.profileId,
                bedTime: bedTimeEpoch,
                wakeTime: wakeTimeEpoch,
                dreamType: _dreamType,
                wakingFeeling: _wakingFeeling,
                notes: notes.isEmpty ? null : notes,
              ),
            );
      } else {
        await ref
            .read(sleepEntryListProvider(widget.profileId).notifier)
            .log(
              LogSleepEntryInput(
                profileId: widget.profileId,
                clientId: const Uuid().v4(),
                bedTime: bedTimeEpoch,
                wakeTime: wakeTimeEpoch,
                dreamType: _dreamType,
                wakingFeeling: _wakingFeeling,
                notes: notes.isEmpty ? '' : notes,
              ),
            );
      }

      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: _isEditing ? 'Sleep entry updated' : 'Sleep entry logged',
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _getWakingFeelingLabel(WakingFeeling feeling) => switch (feeling) {
    WakingFeeling.unrested => 'Groggy',
    WakingFeeling.neutral => 'Neutral',
    WakingFeeling.rested => 'Rested',
  };

  String _getDreamTypeLabel(DreamType type) => switch (type) {
    DreamType.noDreams => 'No Dreams',
    DreamType.vague => 'Vague',
    DreamType.vivid => 'Vivid',
    DreamType.nightmares => 'Nightmares',
  };
}

/// Input formatter that restricts numeric input to a range.
class _RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final value = int.tryParse(newValue.text);
    if (value == null) return oldValue;
    if (value < min || value > max) return oldValue;
    return newValue;
  }
}
