// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flare_up_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$flareUpListHash() => r'6c1adeefec618d4dde738497388605b016e174fb';

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

abstract class _$FlareUpList
    extends BuildlessAutoDisposeAsyncNotifier<List<FlareUp>> {
  late final String profileId;

  FutureOr<List<FlareUp>> build(String profileId);
}

/// Provider for managing flare up list with profile scope.
///
/// Copied from [FlareUpList].
@ProviderFor(FlareUpList)
const flareUpListProvider = FlareUpListFamily();

/// Provider for managing flare up list with profile scope.
///
/// Copied from [FlareUpList].
class FlareUpListFamily extends Family<AsyncValue<List<FlareUp>>> {
  /// Provider for managing flare up list with profile scope.
  ///
  /// Copied from [FlareUpList].
  const FlareUpListFamily();

  /// Provider for managing flare up list with profile scope.
  ///
  /// Copied from [FlareUpList].
  FlareUpListProvider call(String profileId) {
    return FlareUpListProvider(profileId);
  }

  @override
  FlareUpListProvider getProviderOverride(
    covariant FlareUpListProvider provider,
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
  String? get name => r'flareUpListProvider';
}

/// Provider for managing flare up list with profile scope.
///
/// Copied from [FlareUpList].
class FlareUpListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FlareUpList, List<FlareUp>> {
  /// Provider for managing flare up list with profile scope.
  ///
  /// Copied from [FlareUpList].
  FlareUpListProvider(String profileId)
    : this._internal(
        () => FlareUpList()..profileId = profileId,
        from: flareUpListProvider,
        name: r'flareUpListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$flareUpListHash,
        dependencies: FlareUpListFamily._dependencies,
        allTransitiveDependencies: FlareUpListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  FlareUpListProvider._internal(
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
  FutureOr<List<FlareUp>> runNotifierBuild(covariant FlareUpList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(FlareUpList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FlareUpListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FlareUpList, List<FlareUp>>
  createElement() {
    return _FlareUpListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FlareUpListProvider && other.profileId == profileId;
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
mixin FlareUpListRef on AutoDisposeAsyncNotifierProviderRef<List<FlareUp>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _FlareUpListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FlareUpList, List<FlareUp>>
    with FlareUpListRef {
  _FlareUpListProviderElement(super.provider);

  @override
  String get profileId => (origin as FlareUpListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
