// lib/presentation/screens/diet/fasting_timer_screen.dart
// Intermittent fasting timer screen — Phase 15b-3
// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.4 + 59_DIET_TRACKING.md

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/domain/entities/fasting_session.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/domain/usecases/fasting/fasting_usecases.dart';
import 'package:shadow_app/presentation/providers/diet/fasting_session_provider.dart';
import 'package:shadow_app/presentation/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

/// Intermittent fasting timer screen.
///
/// Per 38_UI_FIELD_SPECIFICATIONS.md Section 17.4:
/// - Status label (Fasting / Eating window)
/// - Large timer display HH:MM:SS
/// - Progress bar showing progress toward target
/// - Start / End Fast button
/// - Protocol selector when no fast is active
class FastingTimerScreen extends ConsumerStatefulWidget {
  final String profileId;

  const FastingTimerScreen({super.key, required this.profileId});

  @override
  ConsumerState<FastingTimerScreen> createState() => _FastingTimerScreenState();
}

class _FastingTimerScreenState extends ConsumerState<FastingTimerScreen> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  // Protocol selection when starting a new fast
  DietPresetType _selectedProtocol = DietPresetType.if168;

  bool _isLoading = false;

  static const Map<DietPresetType, double> _protocolHours = {
    DietPresetType.if168: 16.0,
    DietPresetType.if186: 18.0,
    DietPresetType.if204: 20.0,
    DietPresetType.omad: 23.0,
    DietPresetType.fiveTwoDiet: 36.0,
  };

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionAsync = ref.watch(
      fastingSessionNotifierProvider(widget.profileId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Fasting Timer')),
      body: Semantics(
        label: 'Fasting timer screen',
        child: sessionAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => EmptyStateWidget(
            icon: Icons.error_outline,
            message: 'Could not load fasting status',
            submessage: error is AppError
                ? error.userMessage
                : error.toString(),
            action: ShadowButton.outlined(
              onPressed: () => ref.invalidate(
                fastingSessionNotifierProvider(widget.profileId),
              ),
              label: 'Retry loading fasting status',
              child: const Text('Retry'),
            ),
          ),
          data: (session) {
            if (session != null && session.isActive) {
              return _buildActiveTimer(theme, session);
            } else {
              return _buildStartFastPrompt(theme, session);
            }
          },
        ),
      ),
    );
  }

  /// Shows the live timer when a fast is in progress.
  Widget _buildActiveTimer(ThemeData theme, FastingSession session) {
    final startedAt = DateTime.fromMillisecondsSinceEpoch(session.startedAt);
    final elapsed = _now.difference(startedAt);
    final targetMs = session.targetHours * 3600 * 1000;
    final progress = (elapsed.inMilliseconds / targetMs).clamp(0.0, 1.0);
    final isComplete = progress >= 1.0;

    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    final seconds = elapsed.inSeconds.remainder(60);
    final timerStr =
        '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

    final remaining = Duration(
      milliseconds: (targetMs - elapsed.inMilliseconds).toInt().clamp(
        0,
        targetMs.toInt(),
      ),
    );
    final remH = remaining.inHours;
    final remM = remaining.inMinutes.remainder(60);
    final remStr = remH > 0
        ? '$remH hr $remM min remaining'
        : '$remM min remaining';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status label
            Semantics(
              label: isComplete ? 'Fast complete' : 'Currently fasting',
              child: Text(
                isComplete ? 'Fast Complete!' : 'Fasting',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isComplete ? Colors.green : theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _protocolLabel(session.protocol),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Large timer
            Semantics(
              label: 'Elapsed fasting time: $timerStr',
              child: Text(
                timerStr,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Progress bar
            Semantics(
              label:
                  'Progress toward ${session.targetHours.toStringAsFixed(0)}-hour goal',
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isComplete ? Colors.green : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isComplete ? 'Goal reached!' : remStr,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Target: ${session.targetHours.toStringAsFixed(0)} hours',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),

            // End fast button
            ShadowButton.elevated(
              onPressed: _isLoading ? null : () => _endFast(session),
              label: 'End fast',
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('End Fast'),
            ),
            const SizedBox(height: 8),
            Text(
              'Started ${_formatStartTime(startedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the protocol selector when no fast is active.
  Widget _buildStartFastPrompt(
    ThemeData theme,
    FastingSession? completedSession,
  ) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            completedSession != null ? 'Fast Ended' : 'No active fast',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (completedSession != null) ...[
            const SizedBox(height: 8),
            Text(
              'Fasted for ${completedSession.actualHours?.toStringAsFixed(1) ?? "?"} hours',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 32),
          Text(
            'Select protocol:',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Protocol selector
          RadioGroup<DietPresetType>(
            groupValue: _selectedProtocol,
            onChanged: (value) {
              if (value != null) setState(() => _selectedProtocol = value);
            },
            child: Column(
              children: _protocolHours.entries
                  .map(
                    (entry) => RadioListTile<DietPresetType>(
                      title: Text(_protocolLabel(entry.key)),
                      subtitle: Text(
                        '${entry.value.toStringAsFixed(0)}-hour fast',
                      ),
                      value: entry.key,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),

          ShadowButton.elevated(
            onPressed: _isLoading ? null : _startFast,
            label: 'Start fast',
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Start Fast'),
          ),
        ],
      ),
    ),
  );

  Future<void> _startFast() async {
    setState(() => _isLoading = true);
    try {
      final targetHours = _protocolHours[_selectedProtocol] ?? 16.0;
      await ref
          .read(fastingSessionNotifierProvider(widget.profileId).notifier)
          .startFast(
            StartFastInput(
              profileId: widget.profileId,
              clientId: const Uuid().v4(),
              protocol: _selectedProtocol,
              startedAt: DateTime.now().millisecondsSinceEpoch,
              targetHours: targetHours,
            ),
          );

      if (mounted) {
        showAccessibleSnackBar(context: context, message: 'Fast started');
      }
    } on AppError catch (e) {
      if (mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(
          context: context,
          message: 'Could not start fast',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _endFast(FastingSession session) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(fastingSessionNotifierProvider(widget.profileId).notifier)
          .endFast(
            EndFastInput(
              profileId: widget.profileId,
              sessionId: session.id,
              endedAt: DateTime.now().millisecondsSinceEpoch,
              isManualEnd: true,
            ),
          );

      if (mounted) {
        showAccessibleSnackBar(context: context, message: 'Fast ended');
      }
    } on AppError catch (e) {
      if (mounted) {
        showAccessibleSnackBar(context: context, message: e.userMessage);
      }
    } on Exception {
      if (mounted) {
        showAccessibleSnackBar(context: context, message: 'Could not end fast');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _protocolLabel(DietPresetType type) {
    switch (type) {
      case DietPresetType.if168:
        return '16:8 Fasting';
      case DietPresetType.if186:
        return '18:6 Fasting';
      case DietPresetType.if204:
        return '20:4 Fasting';
      case DietPresetType.omad:
        return 'OMAD (One Meal A Day)';
      case DietPresetType.fiveTwoDiet:
        return '5:2 Extended Fast';
      default:
        return type.name;
    }
  }

  String _formatStartTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
