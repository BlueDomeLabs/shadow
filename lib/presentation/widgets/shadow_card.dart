/// Accessible card components for Shadow app.
///
/// Provides [ShadowCard] with configurable variants for containers,
/// following WCAG 2.1 Level AA accessibility standards.
///
/// See also:
/// * [12_ACCESSIBILITY_GUIDELINES.md] for full requirements
/// * [ShadowButton] for interactive buttons
library;

import 'package:flutter/material.dart';
import 'package:shadow_app/presentation/widgets/widget_enums.dart';

/// A consolidated card widget with accessible semantics.
///
/// [ShadowCard] provides a unified interface for card containers
/// in the Shadow app, with optional tap interaction.
///
/// {@template shadow_card}
/// All card instances:
/// - Meet WCAG 2.1 accessibility requirements
/// - Include semantic labels when tappable
/// - Support proper focus indicators
/// {@endtemplate}
///
/// ## Basic Usage
///
/// ```dart
/// ShadowCard(
///   child: Text('Card content'),
/// )
/// ```
///
/// ## Tappable Card
///
/// ```dart
/// ShadowCard(
///   onTap: () => viewDetails(),
///   semanticLabel: 'Vitamin D supplement card',
///   semanticHint: 'Double tap to view details',
///   child: SupplementContent(),
/// )
/// ```
class ShadowCard extends StatelessWidget {
  /// The visual variant of the card.
  ///
  /// Defaults to [CardVariant.standard].
  final CardVariant variant;

  /// Called when the card is tapped.
  ///
  /// If null, the card is not interactive.
  final VoidCallback? onTap;

  /// The semantic label for screen readers.
  ///
  /// Required when [onTap] is non-null.
  final String? semanticLabel;

  /// Optional hint providing additional context for screen readers.
  final String? semanticHint;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Card elevation (shadow depth).
  final double? elevation;

  /// Card border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Card background color.
  final Color? color;

  /// Card border.
  final BoxBorder? border;

  /// The card content.
  final Widget child;

  /// Creates an accessible card.
  const ShadowCard({
    super.key,
    this.variant = CardVariant.standard,
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
    this.margin,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.color,
    this.border,
    required this.child,
  });

  /// Creates a standard card (convenience constructor).
  const ShadowCard.standard({
    super.key,
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
    this.margin,
    this.padding,
    this.elevation,
    this.borderRadius,
    this.color,
    this.border,
    required this.child,
  }) : variant = CardVariant.standard;

  /// Creates a list item card (convenience constructor).
  const ShadowCard.listItem({
    super.key,
    this.onTap,
    this.semanticLabel,
    this.semanticHint,
    this.margin,
    this.padding,
    this.elevation = 0,
    this.borderRadius,
    this.color,
    this.border,
    required this.child,
  }) : variant = CardVariant.listItem;

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      margin: margin ?? _defaultMargin,
      elevation: elevation ?? _defaultElevation,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius!)
          : null,
      color: color,
      child: Padding(padding: padding ?? _defaultPadding, child: child),
    );

    if (onTap != null) {
      return Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              borderRadius as BorderRadius? ??
              const BorderRadius.all(Radius.circular(12)),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }

  EdgeInsetsGeometry get _defaultMargin {
    switch (variant) {
      case CardVariant.standard:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case CardVariant.listItem:
        return const EdgeInsets.symmetric(vertical: 1);
    }
  }

  EdgeInsetsGeometry get _defaultPadding {
    switch (variant) {
      case CardVariant.standard:
        return const EdgeInsets.all(16);
      case CardVariant.listItem:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    }
  }

  double get _defaultElevation {
    switch (variant) {
      case CardVariant.standard:
        return 2;
      case CardVariant.listItem:
        return 0;
    }
  }
}
