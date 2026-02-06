/// Accessible badge components for Shadow app.
///
/// Provides [ShadowBadge] with configurable badge types for status
/// and count display, following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [09_WIDGET_LIBRARY.md] Section 6.7 for badge specifications
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full accessibility requirements
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated badge widget with accessible semantics.
///
/// [ShadowBadge] provides a unified interface for status badges
/// in the Shadow app, ensuring consistent accessibility support.
///
/// {@template shadow_badge}
/// All badge instances:
/// - Include semantic labels for screen readers
/// - Use appropriate color contrast ratios
/// - Support multiple sizes
/// {@endtemplate}
///
/// ## Diet Badge
///
/// ```dart
/// ShadowBadge.diet(
///   dietType: DietPresetType.vegan,
///   showIcon: true,
///   size: BadgeSize.medium,
/// )
/// ```
///
/// ## Status Badge
///
/// ```dart
/// ShadowBadge.status(
///   status: 'Active',
///   color: Colors.green,
///   icon: Icons.check_circle,
/// )
/// ```
///
/// ## Count Badge
///
/// ```dart
/// ShadowBadge.count(
///   count: 5,
///   color: Colors.red,
///   maxCount: 99,
/// )
/// ```
///
/// See also:
///
/// * [BadgeType] for available badge types
/// * [BadgeSize] for size options
class ShadowBadge extends StatelessWidget {
  /// The type of badge.
  final BadgeType badgeType;

  /// The size of the badge.
  final BadgeSize size;

  /// The semantic label for screen readers.
  final String? semanticLabel;

  /// Whether to show an icon (for diet badges).
  final bool showIcon;

  /// Diet type (for [BadgeType.diet]).
  final DietPresetType? dietType;

  /// Status text (for [BadgeType.status]).
  final String? status;

  /// Status color (for [BadgeType.status] and [BadgeType.count]).
  final Color? color;

  /// Status icon (for [BadgeType.status]).
  final IconData? icon;

  /// Count value (for [BadgeType.count]).
  final int? count;

  /// Maximum count to display (for [BadgeType.count]).
  /// Values above this show as "maxCount+".
  final int maxCount;

  /// Creates a badge widget.
  const ShadowBadge({
    super.key,
    required this.badgeType,
    this.size = BadgeSize.medium,
    this.semanticLabel,
    this.showIcon = true,
    this.dietType,
    this.status,
    this.color,
    this.icon,
    this.count,
    this.maxCount = 99,
  });

  /// Creates a diet type badge.
  const ShadowBadge.diet({
    super.key,
    required this.dietType,
    this.showIcon = true,
    this.size = BadgeSize.medium,
    this.semanticLabel,
  }) : badgeType = BadgeType.diet,
       status = null,
       color = null,
       icon = null,
       count = null,
       maxCount = 99;

  /// Creates a status badge.
  const ShadowBadge.status({
    super.key,
    required this.status,
    this.color,
    this.icon,
    this.size = BadgeSize.medium,
    this.semanticLabel,
  }) : badgeType = BadgeType.status,
       showIcon = true,
       dietType = null,
       count = null,
       maxCount = 99;

  /// Creates a count badge.
  const ShadowBadge.count({
    super.key,
    required this.count,
    this.color,
    this.size = BadgeSize.medium,
    this.maxCount = 99,
    this.semanticLabel,
  }) : badgeType = BadgeType.count,
       showIcon = true,
       dietType = null,
       status = null,
       icon = null;

  @override
  Widget build(BuildContext context) {
    final label = semanticLabel ?? _getDefaultLabel();

    return Semantics(label: label, child: _buildBadge(context));
  }

  String _getDefaultLabel() {
    switch (badgeType) {
      case BadgeType.diet:
        return dietType != null ? _getDietLabel(dietType!) : 'Diet badge';
      case BadgeType.status:
        return status ?? 'Status badge';
      case BadgeType.count:
        if (count == null) return 'Count badge';
        if (count! > maxCount) return 'More than $maxCount';
        return '$count';
    }
  }

  Widget _buildBadge(BuildContext context) {
    switch (badgeType) {
      case BadgeType.diet:
        return _DietBadge(dietType: dietType!, showIcon: showIcon, size: size);
      case BadgeType.status:
        return _StatusBadge(
          status: status!,
          color: color,
          icon: icon,
          size: size,
        );
      case BadgeType.count:
        return _CountBadge(
          count: count!,
          color: color,
          size: size,
          maxCount: maxCount,
        );
    }
  }

  String _getDietLabel(DietPresetType type) => switch (type) {
    DietPresetType.vegan => 'Vegan',
    DietPresetType.vegetarian => 'Vegetarian',
    DietPresetType.pescatarian => 'Pescatarian',
    DietPresetType.paleo => 'Paleo',
    DietPresetType.keto => 'Keto',
    DietPresetType.ketoStrict => 'Strict Keto',
    DietPresetType.lowCarb => 'Low Carb',
    DietPresetType.mediterranean => 'Mediterranean',
    DietPresetType.whole30 => 'Whole30',
    DietPresetType.aip => 'AIP',
    DietPresetType.lowFodmap => 'Low FODMAP',
    DietPresetType.glutenFree => 'Gluten Free',
    DietPresetType.dairyFree => 'Dairy Free',
    DietPresetType.if168 => 'IF 16:8',
    DietPresetType.if186 => 'IF 18:6',
    DietPresetType.if204 => 'IF 20:4',
    DietPresetType.omad => 'OMAD',
    DietPresetType.fiveTwoDiet => '5:2 Diet',
    DietPresetType.zone => 'Zone Diet',
    DietPresetType.custom => 'Custom Diet',
  };
}

/// Internal diet badge implementation.
class _DietBadge extends StatelessWidget {
  final DietPresetType dietType;
  final bool showIcon;
  final BadgeSize size;

  const _DietBadge({
    required this.dietType,
    required this.showIcon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getDietColor(dietType);
    final dimensions = _getDimensions(size);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: color.withAlpha(128)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getDietIcon(dietType),
              size: dimensions.iconSize,
              color: color,
            ),
            SizedBox(width: dimensions.spacing),
          ],
          Text(
            _getDietLabel(dietType),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDietColor(DietPresetType type) => switch (type) {
    DietPresetType.vegan => Colors.green.shade700,
    DietPresetType.vegetarian => Colors.green.shade600,
    DietPresetType.pescatarian => Colors.blue.shade600,
    DietPresetType.paleo => Colors.brown.shade600,
    DietPresetType.keto => Colors.orange.shade700,
    DietPresetType.ketoStrict => Colors.orange.shade800,
    DietPresetType.lowCarb => Colors.amber.shade700,
    DietPresetType.mediterranean => Colors.teal.shade600,
    DietPresetType.whole30 => Colors.purple.shade600,
    DietPresetType.aip => Colors.indigo.shade600,
    DietPresetType.lowFodmap => Colors.cyan.shade700,
    DietPresetType.glutenFree => Colors.red.shade600,
    DietPresetType.dairyFree => Colors.lightBlue.shade700,
    DietPresetType.if168 => Colors.deepPurple.shade600,
    DietPresetType.if186 => Colors.deepPurple.shade700,
    DietPresetType.if204 => Colors.deepPurple.shade800,
    DietPresetType.omad => Colors.pink.shade700,
    DietPresetType.fiveTwoDiet => Colors.blueGrey.shade600,
    DietPresetType.zone => Colors.lime.shade800,
    DietPresetType.custom => Colors.grey.shade700,
  };

  IconData _getDietIcon(DietPresetType type) => switch (type) {
    DietPresetType.vegan => Icons.eco,
    DietPresetType.vegetarian => Icons.grass,
    DietPresetType.pescatarian => Icons.set_meal,
    DietPresetType.paleo => Icons.restaurant,
    DietPresetType.keto => Icons.egg,
    DietPresetType.ketoStrict => Icons.egg_alt,
    DietPresetType.lowCarb => Icons.no_food,
    DietPresetType.mediterranean => Icons.local_dining,
    DietPresetType.whole30 => Icons.calendar_month,
    DietPresetType.aip => Icons.healing,
    DietPresetType.lowFodmap => Icons.science,
    DietPresetType.glutenFree => Icons.do_not_disturb,
    DietPresetType.dairyFree => Icons.water_drop,
    DietPresetType.if168 => Icons.timer,
    DietPresetType.if186 => Icons.timer,
    DietPresetType.if204 => Icons.timer,
    DietPresetType.omad => Icons.dinner_dining,
    DietPresetType.fiveTwoDiet => Icons.calendar_today,
    DietPresetType.zone => Icons.balance,
    DietPresetType.custom => Icons.edit,
  };

  String _getDietLabel(DietPresetType type) => switch (type) {
    DietPresetType.vegan => 'Vegan',
    DietPresetType.vegetarian => 'Vegetarian',
    DietPresetType.pescatarian => 'Pescatarian',
    DietPresetType.paleo => 'Paleo',
    DietPresetType.keto => 'Keto',
    DietPresetType.ketoStrict => 'Strict Keto',
    DietPresetType.lowCarb => 'Low Carb',
    DietPresetType.mediterranean => 'Mediterranean',
    DietPresetType.whole30 => 'Whole30',
    DietPresetType.aip => 'AIP',
    DietPresetType.lowFodmap => 'Low FODMAP',
    DietPresetType.glutenFree => 'Gluten Free',
    DietPresetType.dairyFree => 'Dairy Free',
    DietPresetType.if168 => 'IF 16:8',
    DietPresetType.if186 => 'IF 18:6',
    DietPresetType.if204 => 'IF 20:4',
    DietPresetType.omad => 'OMAD',
    DietPresetType.fiveTwoDiet => '5:2 Diet',
    DietPresetType.zone => 'Zone Diet',
    DietPresetType.custom => 'Custom',
  };

  _BadgeDimensions _getDimensions(BadgeSize size) => switch (size) {
    BadgeSize.small => const _BadgeDimensions(
      horizontalPadding: 6,
      verticalPadding: 2,
      borderRadius: 4,
      iconSize: 12,
      fontSize: 10,
      spacing: 4,
    ),
    BadgeSize.medium => const _BadgeDimensions(
      horizontalPadding: 8,
      verticalPadding: 4,
      borderRadius: 6,
      iconSize: 14,
      fontSize: 12,
      spacing: 4,
    ),
    BadgeSize.large => const _BadgeDimensions(
      horizontalPadding: 12,
      verticalPadding: 6,
      borderRadius: 8,
      iconSize: 18,
      fontSize: 14,
      spacing: 6,
    ),
  };
}

/// Internal status badge implementation.
class _StatusBadge extends StatelessWidget {
  final String status;
  final Color? color;
  final IconData? icon;
  final BadgeSize size;

  const _StatusBadge({
    required this.status,
    required this.color,
    required this.icon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final dimensions = _getDimensions(size);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: effectiveColor.withAlpha(51),
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: effectiveColor.withAlpha(128)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dimensions.iconSize, color: effectiveColor),
            SizedBox(width: dimensions.spacing),
          ],
          Text(
            status,
            style: theme.textTheme.labelSmall?.copyWith(
              color: effectiveColor,
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeDimensions _getDimensions(BadgeSize size) => switch (size) {
    BadgeSize.small => const _BadgeDimensions(
      horizontalPadding: 6,
      verticalPadding: 2,
      borderRadius: 4,
      iconSize: 12,
      fontSize: 10,
      spacing: 4,
    ),
    BadgeSize.medium => const _BadgeDimensions(
      horizontalPadding: 8,
      verticalPadding: 4,
      borderRadius: 6,
      iconSize: 14,
      fontSize: 12,
      spacing: 4,
    ),
    BadgeSize.large => const _BadgeDimensions(
      horizontalPadding: 12,
      verticalPadding: 6,
      borderRadius: 8,
      iconSize: 18,
      fontSize: 14,
      spacing: 6,
    ),
  };
}

/// Internal count badge implementation.
class _CountBadge extends StatelessWidget {
  final int count;
  final Color? color;
  final BadgeSize size;
  final int maxCount;

  const _CountBadge({
    required this.count,
    required this.color,
    required this.size,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.error;
    final dimensions = _getDimensions(size);
    final displayText = count > maxCount ? '$maxCount+' : '$count';

    return Container(
      constraints: BoxConstraints(
        minWidth: dimensions.minSize,
        minHeight: dimensions.minSize,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.horizontalPadding,
        vertical: dimensions.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(dimensions.minSize / 2),
      ),
      child: Center(
        child: Text(
          displayText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontSize: dimensions.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _CountBadgeDimensions _getDimensions(BadgeSize size) => switch (size) {
    BadgeSize.small => const _CountBadgeDimensions(
      horizontalPadding: 4,
      verticalPadding: 2,
      minSize: 16,
      fontSize: 10,
    ),
    BadgeSize.medium => const _CountBadgeDimensions(
      horizontalPadding: 6,
      verticalPadding: 2,
      minSize: 20,
      fontSize: 12,
    ),
    BadgeSize.large => const _CountBadgeDimensions(
      horizontalPadding: 8,
      verticalPadding: 4,
      minSize: 24,
      fontSize: 14,
    ),
  };
}

/// Dimensions for diet and status badges.
class _BadgeDimensions {
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final double spacing;

  const _BadgeDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
  });
}

/// Dimensions for count badges.
class _CountBadgeDimensions {
  final double horizontalPadding;
  final double verticalPadding;
  final double minSize;
  final double fontSize;

  const _CountBadgeDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.minSize,
    required this.fontSize,
  });
}
