// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodLogListHash() => r'bfd0e0e7dd552d316121ecf124b0a02c4039dfa9';

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

abstract class _$FoodLogList
    extends BuildlessAutoDisposeAsyncNotifier<List<FoodLog>> {
  late final String profileId;

  FutureOr<List<FoodLog>> build(String profileId);
}

/// Provider for managing food log list with profile scope.
///
/// Copied from [FoodLogList].
@ProviderFor(FoodLogList)
const foodLogListProvider = FoodLogListFamily();

/// Provider for managing food log list with profile scope.
///
/// Copied from [FoodLogList].
class FoodLogListFamily extends Family<AsyncValue<List<FoodLog>>> {
  /// Provider for managing food log list with profile scope.
  ///
  /// Copied from [FoodLogList].
  const FoodLogListFamily();

  /// Provider for managing food log list with profile scope.
  ///
  /// Copied from [FoodLogList].
  FoodLogListProvider call(String profileId) {
    return FoodLogListProvider(profileId);
  }

  @override
  FoodLogListProvider getProviderOverride(
    covariant FoodLogListProvider provider,
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
  String? get name => r'foodLogListProvider';
}

/// Provider for managing food log list with profile scope.
///
/// Copied from [FoodLogList].
class FoodLogListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FoodLogList, List<FoodLog>> {
  /// Provider for managing food log list with profile scope.
  ///
  /// Copied from [FoodLogList].
  FoodLogListProvider(String profileId)
    : this._internal(
        () => FoodLogList()..profileId = profileId,
        from: foodLogListProvider,
        name: r'foodLogListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$foodLogListHash,
        dependencies: FoodLogListFamily._dependencies,
        allTransitiveDependencies: FoodLogListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  FoodLogListProvider._internal(
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
  FutureOr<List<FoodLog>> runNotifierBuild(covariant FoodLogList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(FoodLogList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FoodLogListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FoodLogList, List<FoodLog>>
  createElement() {
    return _FoodLogListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodLogListProvider && other.profileId == profileId;
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
mixin FoodLogListRef on AutoDisposeAsyncNotifierProviderRef<List<FoodLog>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _FoodLogListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FoodLogList, List<FoodLog>>
    with FoodLogListRef {
  _FoodLogListProviderElement(super.provider);

  @override
  String get profileId => (origin as FoodLogListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
