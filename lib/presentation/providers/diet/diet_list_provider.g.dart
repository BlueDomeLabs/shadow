// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dietListHash() => r'8514b526b2037bdaef8dded94a4f89ff1b911f62';

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

abstract class _$DietList
    extends BuildlessAutoDisposeAsyncNotifier<List<Diet>> {
  late final String profileId;

  FutureOr<List<Diet>> build(String profileId);
}

/// Provider for managing diet list with profile scope.
///
/// Follows the UseCase delegation pattern — never calls repository directly.
///
/// Copied from [DietList].
@ProviderFor(DietList)
const dietListProvider = DietListFamily();

/// Provider for managing diet list with profile scope.
///
/// Follows the UseCase delegation pattern — never calls repository directly.
///
/// Copied from [DietList].
class DietListFamily extends Family<AsyncValue<List<Diet>>> {
  /// Provider for managing diet list with profile scope.
  ///
  /// Follows the UseCase delegation pattern — never calls repository directly.
  ///
  /// Copied from [DietList].
  const DietListFamily();

  /// Provider for managing diet list with profile scope.
  ///
  /// Follows the UseCase delegation pattern — never calls repository directly.
  ///
  /// Copied from [DietList].
  DietListProvider call(String profileId) {
    return DietListProvider(profileId);
  }

  @override
  DietListProvider getProviderOverride(covariant DietListProvider provider) {
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
  String? get name => r'dietListProvider';
}

/// Provider for managing diet list with profile scope.
///
/// Follows the UseCase delegation pattern — never calls repository directly.
///
/// Copied from [DietList].
class DietListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DietList, List<Diet>> {
  /// Provider for managing diet list with profile scope.
  ///
  /// Follows the UseCase delegation pattern — never calls repository directly.
  ///
  /// Copied from [DietList].
  DietListProvider(String profileId)
    : this._internal(
        () => DietList()..profileId = profileId,
        from: dietListProvider,
        name: r'dietListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dietListHash,
        dependencies: DietListFamily._dependencies,
        allTransitiveDependencies: DietListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  DietListProvider._internal(
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
  FutureOr<List<Diet>> runNotifierBuild(covariant DietList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(DietList Function() create) {
    return ProviderOverride(
      origin: this,
      override: DietListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<DietList, List<Diet>>
  createElement() {
    return _DietListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DietListProvider && other.profileId == profileId;
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
mixin DietListRef on AutoDisposeAsyncNotifierProviderRef<List<Diet>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _DietListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DietList, List<Diet>>
    with DietListRef {
  _DietListProviderElement(super.provider);

  @override
  String get profileId => (origin as DietListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
