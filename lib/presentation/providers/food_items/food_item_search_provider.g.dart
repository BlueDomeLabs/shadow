// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodItemSearchHash() => r'8d9bfcbfee7e7dcbc4267b3739e12bfe79798245';

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

abstract class _$FoodItemSearch
    extends BuildlessAutoDisposeAsyncNotifier<List<FoodItem>> {
  late final String profileId;
  late final String query;

  FutureOr<List<FoodItem>> build(String profileId, String query);
}

/// Provider for searching food items with profile scope.
///
/// Takes both profileId and query as build parameters.
///
/// Copied from [FoodItemSearch].
@ProviderFor(FoodItemSearch)
const foodItemSearchProvider = FoodItemSearchFamily();

/// Provider for searching food items with profile scope.
///
/// Takes both profileId and query as build parameters.
///
/// Copied from [FoodItemSearch].
class FoodItemSearchFamily extends Family<AsyncValue<List<FoodItem>>> {
  /// Provider for searching food items with profile scope.
  ///
  /// Takes both profileId and query as build parameters.
  ///
  /// Copied from [FoodItemSearch].
  const FoodItemSearchFamily();

  /// Provider for searching food items with profile scope.
  ///
  /// Takes both profileId and query as build parameters.
  ///
  /// Copied from [FoodItemSearch].
  FoodItemSearchProvider call(String profileId, String query) {
    return FoodItemSearchProvider(profileId, query);
  }

  @override
  FoodItemSearchProvider getProviderOverride(
    covariant FoodItemSearchProvider provider,
  ) {
    return call(provider.profileId, provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'foodItemSearchProvider';
}

/// Provider for searching food items with profile scope.
///
/// Takes both profileId and query as build parameters.
///
/// Copied from [FoodItemSearch].
class FoodItemSearchProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<FoodItemSearch, List<FoodItem>> {
  /// Provider for searching food items with profile scope.
  ///
  /// Takes both profileId and query as build parameters.
  ///
  /// Copied from [FoodItemSearch].
  FoodItemSearchProvider(String profileId, String query)
    : this._internal(
        () => FoodItemSearch()
          ..profileId = profileId
          ..query = query,
        from: foodItemSearchProvider,
        name: r'foodItemSearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$foodItemSearchHash,
        dependencies: FoodItemSearchFamily._dependencies,
        allTransitiveDependencies:
            FoodItemSearchFamily._allTransitiveDependencies,
        profileId: profileId,
        query: query,
      );

  FoodItemSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
    required this.query,
  }) : super.internal();

  final String profileId;
  final String query;

  @override
  FutureOr<List<FoodItem>> runNotifierBuild(covariant FoodItemSearch notifier) {
    return notifier.build(profileId, query);
  }

  @override
  Override overrideWith(FoodItemSearch Function() create) {
    return ProviderOverride(
      origin: this,
      override: FoodItemSearchProvider._internal(
        () => create()
          ..profileId = profileId
          ..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FoodItemSearch, List<FoodItem>>
  createElement() {
    return _FoodItemSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodItemSearchProvider &&
        other.profileId == profileId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FoodItemSearchRef on AutoDisposeAsyncNotifierProviderRef<List<FoodItem>> {
  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `query` of this provider.
  String get query;
}

class _FoodItemSearchProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<FoodItemSearch, List<FoodItem>>
    with FoodItemSearchRef {
  _FoodItemSearchProviderElement(super.provider);

  @override
  String get profileId => (origin as FoodItemSearchProvider).profileId;
  @override
  String get query => (origin as FoodItemSearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
