// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodItemListHash() => r'1c516609af292b0303ecc028a0c38bda183142f0';

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

abstract class _$FoodItemList
    extends BuildlessAutoDisposeAsyncNotifier<List<FoodItem>> {
  late final String profileId;

  FutureOr<List<FoodItem>> build(String profileId);
}

/// Provider for managing food item list with profile scope.
///
/// Copied from [FoodItemList].
@ProviderFor(FoodItemList)
const foodItemListProvider = FoodItemListFamily();

/// Provider for managing food item list with profile scope.
///
/// Copied from [FoodItemList].
class FoodItemListFamily extends Family<AsyncValue<List<FoodItem>>> {
  /// Provider for managing food item list with profile scope.
  ///
  /// Copied from [FoodItemList].
  const FoodItemListFamily();

  /// Provider for managing food item list with profile scope.
  ///
  /// Copied from [FoodItemList].
  FoodItemListProvider call(String profileId) {
    return FoodItemListProvider(profileId);
  }

  @override
  FoodItemListProvider getProviderOverride(
    covariant FoodItemListProvider provider,
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
  String? get name => r'foodItemListProvider';
}

/// Provider for managing food item list with profile scope.
///
/// Copied from [FoodItemList].
class FoodItemListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FoodItemList, List<FoodItem>> {
  /// Provider for managing food item list with profile scope.
  ///
  /// Copied from [FoodItemList].
  FoodItemListProvider(String profileId)
    : this._internal(
        () => FoodItemList()..profileId = profileId,
        from: foodItemListProvider,
        name: r'foodItemListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$foodItemListHash,
        dependencies: FoodItemListFamily._dependencies,
        allTransitiveDependencies:
            FoodItemListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  FoodItemListProvider._internal(
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
  FutureOr<List<FoodItem>> runNotifierBuild(covariant FoodItemList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(FoodItemList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FoodItemListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<FoodItemList, List<FoodItem>>
  createElement() {
    return _FoodItemListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FoodItemListProvider && other.profileId == profileId;
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
mixin FoodItemListRef on AutoDisposeAsyncNotifierProviderRef<List<FoodItem>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _FoodItemListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<FoodItemList, List<FoodItem>>
    with FoodItemListRef {
  _FoodItemListProviderElement(super.provider);

  @override
  String get profileId => (origin as FoodItemListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
