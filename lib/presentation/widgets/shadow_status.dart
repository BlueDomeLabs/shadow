/// Accessible status indicator components for Shadow app.
///
/// Provides [ShadowStatus] with configurable variants for all status displays,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated status indicator widget with accessible semantics.
///
/// [ShadowStatus] provides a unified interface for all status displays
/// in the Shadow app.
///
/// {@template shadow_status}
/// All status instances:
/// - Meet WCAG 2.1 accessibility requirements
/// - Use live regions for dynamic updates
/// - Don't convey information by color alone
/// {@endtemplate}
///
/// ## Basic Usage
///
/// ```dart
/// ShadowStatus(
///   variant: StatusVariant.loading,
///   label: 'Loading supplements',
/// )
/// ```
///
/// ## Variants
///
/// ```dart
/// // Loading spinner
/// ShadowStatus.loading(label: 'Loading')
///
/// // Progress bar
/// ShadowStatus.progress(label: '75% complete', value: 0.75)
///
/// // Status indicator
/// ShadowStatus.status(label: 'Synced', icon: Icons.cloud_done, color: Colors.green)
/// ```
class ShadowStatus extends StatelessWidget {
  /// The status variant determining display style.
  ///
  /// Defaults to [StatusVariant.loading].
  final StatusVariant variant;

  /// The semantic label for screen readers.
  final String label;

  /// Progress value for [StatusVariant.progress] (0.0 to 1.0).
  ///
  /// If null, shows indeterminate progress.
  final double? value;

  /// Icon for [StatusVariant.status] and [StatusVariant.sync].
  final IconData? icon;

  /// Color for the status indicator.
  final Color? color;

  /// Size of the indicator.
  final double? size;

  /// Stroke width for progress indicators.
  final double strokeWidth;

  /// Whether to show a text label alongside the indicator.
  final bool showLabel;

  /// Creates an accessible status indicator.
  const ShadowStatus({
    super.key,
    this.variant = StatusVariant.loading,
    required this.label,
    this.value,
    this.icon,
    this.color,
    this.size,
    this.strokeWidth = 4.0,
    this.showLabel = true,
  });

  /// Creates a loading indicator (convenience constructor).
  const ShadowStatus.loading({
    super.key,
    required this.label,
    this.size = 24.0,
    this.strokeWidth = 4.0,
    this.color,
    this.showLabel = true,
  }) : variant = StatusVariant.loading,
       value = null,
       icon = null;

  /// Creates a progress indicator (convenience constructor).
  const ShadowStatus.progress({
    super.key,
    required this.label,
    this.value,
    this.size,
    this.strokeWidth = 4.0,
    this.color,
    this.showLabel = true,
  }) : variant = StatusVariant.progress,
       icon = null;

  /// Creates a status indicator (convenience constructor).
  const ShadowStatus.status({
    super.key,
    required this.label,
    required this.icon,
    this.color,
    this.size = 24.0,
    this.showLabel = true,
  }) : variant = StatusVariant.status,
       value = null,
       strokeWidth = 4.0;

  /// Creates a sync status indicator (convenience constructor).
  const ShadowStatus.sync({
    super.key,
    required this.label,
    this.icon = Icons.cloud_done,
    this.color,
    this.size = 24.0,
    this.showLabel = true,
  }) : variant = StatusVariant.sync,
       value = null,
       strokeWidth = 4.0;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    liveRegion: true,
    child: _buildIndicator(context),
  );

  Widget _buildIndicator(BuildContext context) {
    switch (variant) {
      case StatusVariant.loading:
        return _buildLoadingIndicator(context);
      case StatusVariant.progress:
        return _buildProgressIndicator(context);
      case StatusVariant.status:
        return _buildStatusIndicator(context);
      case StatusVariant.sync:
        return _buildSyncIndicator(context);
    }
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final indicator = SizedBox(
      width: size ?? 24.0,
      height: size ?? 24.0,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
      ),
    );

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(width: 8),
          // Exclude from semantics to avoid duplication with outer Semantics wrapper
          ExcludeSemantics(child: Text(label)),
        ],
      );
    }

    return indicator;
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final indicator = SizedBox(
      width: size ?? 24.0,
      height: size ?? 24.0,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
      ),
    );

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(width: 8),
          // Exclude from semantics to avoid duplication with outer Semantics wrapper
          ExcludeSemantics(child: Text(label)),
        ],
      );
    }

    return indicator;
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final iconWidget = Icon(icon, size: size ?? 24.0, color: color);

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 8),
          // Exclude from semantics to avoid duplication with outer Semantics wrapper
          ExcludeSemantics(
            child: Text(label, style: TextStyle(color: color)),
          ),
        ],
      );
    }

    return iconWidget;
  }

  Widget _buildSyncIndicator(BuildContext context) =>
      _buildStatusIndicator(context);
}

/// Empty state widget for lists with no items.
///
/// ```dart
/// EmptyStateWidget(
///   icon: Icons.medication_outlined,
///   message: 'No supplements added',
///   submessage: 'Tap the + button to add your first supplement',
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The primary message.
  final String message;

  /// Optional secondary message.
  final String? submessage;

  /// Icon color.
  final Color? iconColor;

  /// Icon size.
  final double iconSize;

  /// Optional action widget (e.g., a button).
  final Widget? action;

  /// Creates an empty state widget.
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.message,
    this.submessage,
    this.iconColor,
    this.iconSize = 64.0,
    this.action,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (submessage != null) ...[
            const SizedBox(height: 8),
            Text(
              submessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    ),
  );
}
