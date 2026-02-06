// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplement_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supplementListHash() => r'd92870b37efddcfac232c1e2e32b762f3f3c99cd';

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

abstract class _$SupplementList
    extends BuildlessAutoDisposeAsyncNotifier<List<Supplement>> {
  late final String profileId;

  FutureOr<List<Supplement>> build(String profileId);
}

/// Provider for managing supplement list with profile scope.
///
/// Follows the UseCase delegation pattern:
/// - ALWAYS delegates to UseCases (never calls repository directly)
/// - Uses `result.when()` for Result handling
/// - Calls `ref.invalidateSelf()` after successful mutations
/// - Logs errors and throws for AsyncValue error state
/// - Checks write access before mutations (defense-in-depth)
///
/// Copied from [SupplementList].
@ProviderFor(SupplementList)
const supplementListProvider = SupplementListFamily();

/// Provider for managing supplement list with profile scope.
///
/// Follows the UseCase delegation pattern:
/// - ALWAYS delegates to UseCases (never calls repository directly)
/// - Uses `result.when()` for Result handling
/// - Calls `ref.invalidateSelf()` after successful mutations
/// - Logs errors and throws for AsyncValue error state
/// - Checks write access before mutations (defense-in-depth)
///
/// Copied from [SupplementList].
class SupplementListFamily extends Family<AsyncValue<List<Supplement>>> {
  /// Provider for managing supplement list with profile scope.
  ///
  /// Follows the UseCase delegation pattern:
  /// - ALWAYS delegates to UseCases (never calls repository directly)
  /// - Uses `result.when()` for Result handling
  /// - Calls `ref.invalidateSelf()` after successful mutations
  /// - Logs errors and throws for AsyncValue error state
  /// - Checks write access before mutations (defense-in-depth)
  ///
  /// Copied from [SupplementList].
  const SupplementListFamily();

  /// Provider for managing supplement list with profile scope.
  ///
  /// Follows the UseCase delegation pattern:
  /// - ALWAYS delegates to UseCases (never calls repository directly)
  /// - Uses `result.when()` for Result handling
  /// - Calls `ref.invalidateSelf()` after successful mutations
  /// - Logs errors and throws for AsyncValue error state
  /// - Checks write access before mutations (defense-in-depth)
  ///
  /// Copied from [SupplementList].
  SupplementListProvider call(String profileId) {
    return SupplementListProvider(profileId);
  }

  @override
  SupplementListProvider getProviderOverride(
    covariant SupplementListProvider provider,
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
  String? get name => r'supplementListProvider';
}

/// Provider for managing supplement list with profile scope.
///
/// Follows the UseCase delegation pattern:
/// - ALWAYS delegates to UseCases (never calls repository directly)
/// - Uses `result.when()` for Result handling
/// - Calls `ref.invalidateSelf()` after successful mutations
/// - Logs errors and throws for AsyncValue error state
/// - Checks write access before mutations (defense-in-depth)
///
/// Copied from [SupplementList].
class SupplementListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<SupplementList, List<Supplement>> {
  /// Provider for managing supplement list with profile scope.
  ///
  /// Follows the UseCase delegation pattern:
  /// - ALWAYS delegates to UseCases (never calls repository directly)
  /// - Uses `result.when()` for Result handling
  /// - Calls `ref.invalidateSelf()` after successful mutations
  /// - Logs errors and throws for AsyncValue error state
  /// - Checks write access before mutations (defense-in-depth)
  ///
  /// Copied from [SupplementList].
  SupplementListProvider(String profileId)
    : this._internal(
        () => SupplementList()..profileId = profileId,
        from: supplementListProvider,
        name: r'supplementListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$supplementListHash,
        dependencies: SupplementListFamily._dependencies,
        allTransitiveDependencies:
            SupplementListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  SupplementListProvider._internal(
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
  FutureOr<List<Supplement>> runNotifierBuild(
    covariant SupplementList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(SupplementList Function() create) {
    return ProviderOverride(
      origin: this,
      override: SupplementListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SupplementList, List<Supplement>>
  createElement() {
    return _SupplementListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SupplementListProvider && other.profileId == profileId;
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
mixin SupplementListRef
    on AutoDisposeAsyncNotifierProviderRef<List<Supplement>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SupplementListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SupplementList,
          List<Supplement>
        >
    with SupplementListRef {
  _SupplementListProviderElement(super.provider);

  @override
  String get profileId => (origin as SupplementListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
