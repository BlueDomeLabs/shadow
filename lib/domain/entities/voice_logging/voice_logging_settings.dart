// lib/domain/entities/voice_logging/voice_logging_settings.dart
// Per VOICE_LOGGING_SPEC.md Section 2.1

import 'package:shadow_app/domain/enums/health_enums.dart';

/// Per-profile voice logging preferences.
///
/// id == profileId — one row per profile in the database.
/// categoryPriorityOrder: null = use default priority; non-null = user-defined
/// order of NotificationCategory integer values.
class VoiceLoggingSettings {
  final String id;
  final String profileId;
  final ClosingStyle closingStyle;
  final String? fixedFarewell;
  final List<int>? categoryPriorityOrder;
  final int createdAt;
  final int? updatedAt;

  const VoiceLoggingSettings({
    required this.id,
    required this.profileId,
    required this.closingStyle,
    this.fixedFarewell,
    this.categoryPriorityOrder,
    required this.createdAt,
    this.updatedAt,
  });

  VoiceLoggingSettings copyWith({
    String? id,
    String? profileId,
    ClosingStyle? closingStyle,
    String? fixedFarewell,
    List<int>? categoryPriorityOrder,
    int? createdAt,
    int? updatedAt,
  }) => VoiceLoggingSettings(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    closingStyle: closingStyle ?? this.closingStyle,
    fixedFarewell: fixedFarewell ?? this.fixedFarewell,
    categoryPriorityOrder: categoryPriorityOrder ?? this.categoryPriorityOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
