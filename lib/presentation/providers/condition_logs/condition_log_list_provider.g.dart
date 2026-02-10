// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_log_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conditionLogListHash() => r'7772be3dcb6f32023b69585224b21564b44bfb9b';

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

abstract class _$ConditionLogList
    extends BuildlessAutoDisposeAsyncNotifier<List<ConditionLog>> {
  late final String profileId;
  late final String conditionId;

  FutureOr<List<ConditionLog>> build(String profileId, String conditionId);
}

/// Provider for managing condition log list with profile scope.
///
/// Copied from [ConditionLogList].
@ProviderFor(ConditionLogList)
const conditionLogListProvider = ConditionLogListFamily();

/// Provider for managing condition log list with profile scope.
///
/// Copied from [ConditionLogList].
class ConditionLogListFamily extends Family<AsyncValue<List<ConditionLog>>> {
  /// Provider for managing condition log list with profile scope.
  ///
  /// Copied from [ConditionLogList].
  const ConditionLogListFamily();

  /// Provider for managing condition log list with profile scope.
  ///
  /// Copied from [ConditionLogList].
  ConditionLogListProvider call(String profileId, String conditionId) {
    return ConditionLogListProvider(profileId, conditionId);
  }

  @override
  ConditionLogListProvider getProviderOverride(
    covariant ConditionLogListProvider provider,
  ) {
    return call(provider.profileId, provider.conditionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conditionLogListProvider';
}

/// Provider for managing condition log list with profile scope.
///
/// Copied from [ConditionLogList].
class ConditionLogListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ConditionLogList,
          List<ConditionLog>
        > {
  /// Provider for managing condition log list with profile scope.
  ///
  /// Copied from [ConditionLogList].
  ConditionLogListProvider(String profileId, String conditionId)
    : this._internal(
        () => ConditionLogList()
          ..profileId = profileId
          ..conditionId = conditionId,
        from: conditionLogListProvider,
        name: r'conditionLogListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conditionLogListHash,
        dependencies: ConditionLogListFamily._dependencies,
        allTransitiveDependencies:
            ConditionLogListFamily._allTransitiveDependencies,
        profileId: profileId,
        conditionId: conditionId,
      );

  ConditionLogListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
    required this.conditionId,
  }) : super.internal();

  final String profileId;
  final String conditionId;

  @override
  FutureOr<List<ConditionLog>> runNotifierBuild(
    covariant ConditionLogList notifier,
  ) {
    return notifier.build(profileId, conditionId);
  }

  @override
  Override overrideWith(ConditionLogList Function() create) {
    return ProviderOverride(
      origin: this,
      override: ConditionLogListProvider._internal(
        () => create()
          ..profileId = profileId
          ..conditionId = conditionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
        conditionId: conditionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ConditionLogList, List<ConditionLog>>
  createElement() {
    return _ConditionLogListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionLogListProvider &&
        other.profileId == profileId &&
        other.conditionId == conditionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, conditionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConditionLogListRef
    on AutoDisposeAsyncNotifierProviderRef<List<ConditionLog>> {
  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `conditionId` of this provider.
  String get conditionId;
}

class _ConditionLogListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ConditionLogList,
          List<ConditionLog>
        >
    with ConditionLogListRef {
  _ConditionLogListProviderElement(super.provider);

  @override
  String get profileId => (origin as ConditionLogListProvider).profileId;
  @override
  String get conditionId => (origin as ConditionLogListProvider).conditionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
