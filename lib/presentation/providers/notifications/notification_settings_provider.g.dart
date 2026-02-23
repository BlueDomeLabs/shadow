// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationSettingsHash() =>
    r'05bfe99b6a8b9aba47451714ca5c203d60723f44';

/// Provider for per-category notification settings (global — not profile-scoped).
///
/// One record exists per NotificationCategory (8 total). Follows the UseCase
/// delegation pattern from 02_CODING_STANDARDS.md.
///
/// Copied from [NotificationSettings].
@ProviderFor(NotificationSettings)
final notificationSettingsProvider =
    AutoDisposeAsyncNotifierProvider<
      NotificationSettings,
      List<NotificationCategorySettings>
    >.internal(
      NotificationSettings.new,
      name: r'notificationSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationSettings =
    AutoDisposeAsyncNotifier<List<NotificationCategorySettings>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
