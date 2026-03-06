// lib/presentation/screens/supplements/supplement_schedule_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';

/// Schedule configuration section extracted from SupplementEditScreen.
///
/// Stateless — all schedule state is owned by the parent. Each user action
/// fires a callback; the parent calls setState and rebuilds.
class SupplementScheduleSection extends StatelessWidget {
  final SupplementFrequencyType selectedFrequency;
  final List<int> selectedWeekdays;
  final SupplementAnchorEvent selectedAnchorEvent;
  final SupplementTimingType selectedTimingType;
  final int offsetMinutes;
  final int? specificTimeMinutes;
  final DateTime? startDate;
  final DateTime? endDate;
  final TextEditingController everyXDaysController;
  final String? everyXDaysError;
  final String? specificDaysError;
  final String? offsetMinutesError;
  final String? specificTimeError;
  final String? endDateError;

  final void Function(SupplementFrequencyType) onFrequencyChanged;
  final void Function(List<int>) onWeekdaysChanged;
  final void Function(SupplementAnchorEvent) onAnchorEventChanged;
  final void Function(SupplementTimingType) onTimingTypeChanged;
  final void Function(int) onOffsetMinutesChanged;
  final void Function(int?) onSpecificTimeChanged;
  final void Function(DateTime?) onStartDateChanged;
  final void Function(DateTime?) onEndDateChanged;

  /// Called when the everyXDays text field changes so the parent can validate.
  final VoidCallback onEveryXDaysChanged;

  const SupplementScheduleSection({
    super.key,
    required this.selectedFrequency,
    required this.selectedWeekdays,
    required this.selectedAnchorEvent,
    required this.selectedTimingType,
    required this.offsetMinutes,
    required this.specificTimeMinutes,
    required this.startDate,
    required this.endDate,
    required this.everyXDaysController,
    required this.everyXDaysError,
    required this.specificDaysError,
    required this.offsetMinutesError,
    required this.specificTimeError,
    required this.endDateError,
    required this.onFrequencyChanged,
    required this.onWeekdaysChanged,
    required this.onAnchorEventChanged,
    required this.onTimingTypeChanged,
    required this.onOffsetMinutesChanged,
    required this.onSpecificTimeChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onEveryXDaysChanged,
  });

  // ---- Label helpers ----

  String _frequencyLabel(SupplementFrequencyType freq) => switch (freq) {
    SupplementFrequencyType.daily => 'Daily',
    SupplementFrequencyType.everyXDays => 'Every X Days',
    SupplementFrequencyType.specificWeekdays => 'Specific Days',
  };

  String _anchorEventLabel(SupplementAnchorEvent event) => switch (event) {
    SupplementAnchorEvent.wake => 'Morning',
    SupplementAnchorEvent.breakfast => 'Breakfast',
    SupplementAnchorEvent.lunch => 'Lunch',
    SupplementAnchorEvent.dinner => 'Dinner',
    SupplementAnchorEvent.bed => 'Bedtime',
  };

  String _timingTypeLabel(SupplementTimingType type) => switch (type) {
    SupplementTimingType.withEvent => 'With',
    SupplementTimingType.beforeEvent => 'Before',
    SupplementTimingType.afterEvent => 'After',
    SupplementTimingType.specificTime => 'At Specific Time',
  };

  String _formatMinutesAsTime(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _pickSpecificTime(BuildContext context) async {
    final initialTime = specificTimeMinutes != null
        ? TimeOfDay(
            hour: specificTimeMinutes! ~/ 60,
            minute: specificTimeMinutes! % 60,
          )
        : const TimeOfDay(hour: 8, minute: 0);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      onSpecificTimeChanged(picked.hour * 60 + picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSpecificTime =
        selectedTimingType == SupplementTimingType.specificTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frequency
        Semantics(
          label: 'How often to take, required',
          child: ExcludeSemantics(
            child: DropdownButtonFormField<SupplementFrequencyType>(
              initialValue: selectedFrequency,
              decoration: const InputDecoration(labelText: 'Frequency'),
              items: SupplementFrequencyType.values
                  .map(
                    (freq) => DropdownMenuItem<SupplementFrequencyType>(
                      value: freq,
                      child: Text(_frequencyLabel(freq)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onFrequencyChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Every X Days (conditional)
        if (selectedFrequency == SupplementFrequencyType.everyXDays) ...[
          Semantics(
            label: 'Every how many days, required, 2 to 365',
            textField: true,
            child: ExcludeSemantics(
              child: ShadowTextField.numeric(
                controller: everyXDaysController,
                label: 'Every X Days',
                hintText: '2',
                errorText: everyXDaysError,
                maxLength: 3,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => onEveryXDaysChanged(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Specific Days (conditional)
        if (selectedFrequency == SupplementFrequencyType.specificWeekdays) ...[
          ShadowPicker.weekday(
            label: 'Which days to take',
            selectedDays: selectedWeekdays,
            onDaysChanged: onWeekdaysChanged,
          ),
          if (specificDaysError != null) ...[
            const SizedBox(height: 4),
            Text(
              specificDaysError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],

        // Anchor Event
        Semantics(
          label: 'When to take supplement, required',
          child: ExcludeSemantics(
            child: DropdownButtonFormField<String>(
              initialValue: isSpecificTime
                  ? 'specificTime'
                  : selectedAnchorEvent.name,
              decoration: const InputDecoration(labelText: 'Anchor Event'),
              items: [
                ...SupplementAnchorEvent.values.map(
                  (event) => DropdownMenuItem<String>(
                    value: event.name,
                    child: Text(_anchorEventLabel(event)),
                  ),
                ),
                const DropdownMenuItem<String>(
                  value: 'specificTime',
                  child: Text('Specific Time'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                if (value == 'specificTime') {
                  onTimingTypeChanged(SupplementTimingType.specificTime);
                } else {
                  final event = SupplementAnchorEvent.values.firstWhere(
                    (e) => e.name == value,
                  );
                  onAnchorEventChanged(event);
                  if (selectedTimingType == SupplementTimingType.specificTime) {
                    onTimingTypeChanged(SupplementTimingType.withEvent);
                  }
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Timing (With/Before/After) — hidden when Specific Time
        if (!isSpecificTime) ...[
          Semantics(
            label: 'Timing relative to anchor event, required',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<SupplementTimingType>(
                initialValue: selectedTimingType,
                decoration: const InputDecoration(labelText: 'Timing'),
                items:
                    [
                          SupplementTimingType.withEvent,
                          SupplementTimingType.beforeEvent,
                          SupplementTimingType.afterEvent,
                        ]
                        .map(
                          (type) => DropdownMenuItem<SupplementTimingType>(
                            value: type,
                            child: Text(_timingTypeLabel(type)),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onTimingTypeChanged(value);
                    if (value == SupplementTimingType.withEvent) {
                      onOffsetMinutesChanged(0);
                    } else if (offsetMinutes == 0) {
                      onOffsetMinutesChanged(30);
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Offset Minutes (conditional: Before or After)
        if (selectedTimingType == SupplementTimingType.beforeEvent ||
            selectedTimingType == SupplementTimingType.afterEvent) ...[
          Semantics(
            label: 'Minutes before or after, required, 5 to 120',
            child: ExcludeSemantics(
              child: DropdownButtonFormField<int>(
                initialValue: offsetMinutes,
                decoration: const InputDecoration(labelText: 'Offset Minutes'),
                items: List.generate(24, (i) => (i + 1) * 5)
                    .map(
                      (minutes) => DropdownMenuItem<int>(
                        value: minutes,
                        child: Text('$minutes min'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) onOffsetMinutesChanged(value);
                },
              ),
            ),
          ),
          if (offsetMinutesError != null) ...[
            const SizedBox(height: 4),
            Text(
              offsetMinutesError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],

        // Specific Time picker (conditional)
        if (isSpecificTime) ...[
          Semantics(
            label:
                'Specific time to take supplement, required, ${specificTimeMinutes != null ? _formatMinutesAsTime(specificTimeMinutes!) : "not set"}',
            child: ExcludeSemantics(
              child: InkWell(
                onTap: () => _pickSpecificTime(context),
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Specific Time',
                    errorText: specificTimeError,
                    suffixIcon: const Icon(Icons.access_time),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    specificTimeMinutes != null
                        ? _formatMinutesAsTime(specificTimeMinutes!)
                        : 'Select time',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: specificTimeMinutes != null
                          ? null
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Start Date
        ShadowPicker.date(
          label: 'Start Date',
          hint: 'When to start taking this supplement',
          dateValue: startDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: onStartDateChanged,
        ),
        const SizedBox(height: 16),

        // End Date
        ShadowPicker.date(
          label: 'End Date',
          hint: 'When to stop taking this supplement (optional)',
          dateValue: endDate,
          firstDate: startDate ?? DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: onEndDateChanged,
        ),
        if (endDateError != null) ...[
          const SizedBox(height: 4),
          Text(
            endDateError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
