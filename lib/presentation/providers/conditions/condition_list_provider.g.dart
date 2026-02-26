// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conditionListHash() => r'69a170f1dd55dc022df34d87b35f2b55d7c912bb';

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

abstract class _$ConditionList
    extends BuildlessAutoDisposeAsyncNotifier<List<Condition>> {
  late final String profileId;

  FutureOr<List<Condition>> build(String profileId);
}

/// Provider for managing condition list with profile scope.
///
/// Copied from [ConditionList].
@ProviderFor(ConditionList)
const conditionListProvider = ConditionListFamily();

/// Provider for managing condition list with profile scope.
///
/// Copied from [ConditionList].
class ConditionListFamily extends Family<AsyncValue<List<Condition>>> {
  /// Provider for managing condition list with profile scope.
  ///
  /// Copied from [ConditionList].
  const ConditionListFamily();

  /// Provider for managing condition list with profile scope.
  ///
  /// Copied from [ConditionList].
  ConditionListProvider call(String profileId) {
    return ConditionListProvider(profileId);
  }

  @override
  ConditionListProvider getProviderOverride(
    covariant ConditionListProvider provider,
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
  String? get name => r'conditionListProvider';
}

/// Provider for managing condition list with profile scope.
///
/// Copied from [ConditionList].
class ConditionListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ConditionList, List<Condition>> {
  /// Provider for managing condition list with profile scope.
  ///
  /// Copied from [ConditionList].
  ConditionListProvider(String profileId)
    : this._internal(
        () => ConditionList()..profileId = profileId,
        from: conditionListProvider,
        name: r'conditionListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conditionListHash,
        dependencies: ConditionListFamily._dependencies,
        allTransitiveDependencies:
            ConditionListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  ConditionListProvider._internal(
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
  FutureOr<List<Condition>> runNotifierBuild(covariant ConditionList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(ConditionList Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConditionListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ConditionList, List<Condition>>
  createElement() {
    return _ConditionListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionListProvider && other.profileId == profileId;
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
mixin ConditionListRef on AutoDisposeAsyncNotifierProviderRef<List<Condition>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ConditionListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ConditionList, List<Condition>>
    with ConditionListRef {
  _ConditionListProviderElement(super.provider);

  @override
  String get profileId => (origin as ConditionListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
