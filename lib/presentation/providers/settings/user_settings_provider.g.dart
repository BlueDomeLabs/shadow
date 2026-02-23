// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userSettingsNotifierHash() =>
    r'56c5ef56291ae43aac6c2b252a3f61bba8dc4258';

/// Provider for app-wide user settings (units, security configuration).
///
/// Loads from [GetUserSettingsUseCase] on first access (creates defaults if
/// none exist). Updates are written back through [UpdateUserSettingsUseCase].
///
/// Copied from [UserSettingsNotifier].
@ProviderFor(UserSettingsNotifier)
final userSettingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      UserSettingsNotifier,
      UserSettings
    >.internal(
      UserSettingsNotifier.new,
      name: r'userSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserSettingsNotifier = AutoDisposeAsyncNotifier<UserSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
