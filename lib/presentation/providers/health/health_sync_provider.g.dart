// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthSyncSettingsNotifierHash() =>
    r'7f533fb06c598e902217317f523cb1c3636920d8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$HealthSyncSettingsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<HealthSyncSettings> {
  late final String profileId;

  FutureOr<HealthSyncSettings> build(String profileId);
}

/// See also [HealthSyncSettingsNotifier].
@ProviderFor(HealthSyncSettingsNotifier)
const healthSyncSettingsNotifierProvider = HealthSyncSettingsNotifierFamily();

/// See also [HealthSyncSettingsNotifier].
class HealthSyncSettingsNotifierFamily
    extends Family<AsyncValue<HealthSyncSettings>> {
  /// See also [HealthSyncSettingsNotifier].
  const HealthSyncSettingsNotifierFamily();

  /// See also [HealthSyncSettingsNotifier].
  HealthSyncSettingsNotifierProvider call(String profileId) {
    return HealthSyncSettingsNotifierProvider(profileId);
  }

  @override
  HealthSyncSettingsNotifierProvider getProviderOverride(
    covariant HealthSyncSettingsNotifierProvider provider,
  ) {
    return call(provider.profileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'healthSyncSettingsNotifierProvider';
}

/// See also [HealthSyncSettingsNotifier].
class HealthSyncSettingsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          HealthSyncSettingsNotifier,
          HealthSyncSettings
        > {
  /// See also [HealthSyncSettingsNotifier].
  HealthSyncSettingsNotifierProvider(String profileId)
    : this._internal(
        () => HealthSyncSettingsNotifier()..profileId = profileId,
        from: healthSyncSettingsNotifierProvider,
        name: r'healthSyncSettingsNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$healthSyncSettingsNotifierHash,
        dependencies: HealthSyncSettingsNotifierFamily._dependencies,
        allTransitiveDependencies:
            HealthSyncSettingsNotifierFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  HealthSyncSettingsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  FutureOr<HealthSyncSettings> runNotifierBuild(
    covariant HealthSyncSettingsNotifier notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(HealthSyncSettingsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: HealthSyncSettingsNotifierProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    HealthSyncSettingsNotifier,
    HealthSyncSettings
  >
  createElement() {
    return _HealthSyncSettingsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthSyncSettingsNotifierProvider &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HealthSyncSettingsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<HealthSyncSettings> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _HealthSyncSettingsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          HealthSyncSettingsNotifier,
          HealthSyncSettings
        >
    with HealthSyncSettingsNotifierRef {
  _HealthSyncSettingsNotifierProviderElement(super.provider);

  @override
  String get profileId =>
      (origin as HealthSyncSettingsNotifierProvider).profileId;
}

String _$healthSyncStatusListHash() =>
    r'a08626983b1928eda61245e3b774b5d6939a3543';

abstract class _$HealthSyncStatusList
    extends BuildlessAutoDisposeAsyncNotifier<List<HealthSyncStatus>> {
  late final String profileId;

  FutureOr<List<HealthSyncStatus>> build(String profileId);
}

/// See also [HealthSyncStatusList].
@ProviderFor(HealthSyncStatusList)
const healthSyncStatusListProvider = HealthSyncStatusListFamily();

/// See also [HealthSyncStatusList].
class HealthSyncStatusListFamily
    extends Family<AsyncValue<List<HealthSyncStatus>>> {
  /// See also [HealthSyncStatusList].
  const HealthSyncStatusListFamily();

  /// See also [HealthSyncStatusList].
  HealthSyncStatusListProvider call(String profileId) {
    return HealthSyncStatusListProvider(profileId);
  }

  @override
  HealthSyncStatusListProvider getProviderOverride(
    covariant HealthSyncStatusListProvider provider,
  ) {
    return call(provider.profileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'healthSyncStatusListProvider';
}

/// See also [HealthSyncStatusList].
class HealthSyncStatusListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          HealthSyncStatusList,
          List<HealthSyncStatus>
        > {
  /// See also [HealthSyncStatusList].
  HealthSyncStatusListProvider(String profileId)
    : this._internal(
        () => HealthSyncStatusList()..profileId = profileId,
        from: healthSyncStatusListProvider,
        name: r'healthSyncStatusListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$healthSyncStatusListHash,
        dependencies: HealthSyncStatusListFamily._dependencies,
        allTransitiveDependencies:
            HealthSyncStatusListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  HealthSyncStatusListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  FutureOr<List<HealthSyncStatus>> runNotifierBuild(
    covariant HealthSyncStatusList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(HealthSyncStatusList Function() create) {
    return ProviderOverride(
      origin: this,
      override: HealthSyncStatusListProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    HealthSyncStatusList,
    List<HealthSyncStatus>
  >
  createElement() {
    return _HealthSyncStatusListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HealthSyncStatusListProvider &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HealthSyncStatusListRef
    on AutoDisposeAsyncNotifierProviderRef<List<HealthSyncStatus>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _HealthSyncStatusListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          HealthSyncStatusList,
          List<HealthSyncStatus>
        >
    with HealthSyncStatusListRef {
  _HealthSyncStatusListProviderElement(super.provider);

  @override
  String get profileId => (origin as HealthSyncStatusListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
