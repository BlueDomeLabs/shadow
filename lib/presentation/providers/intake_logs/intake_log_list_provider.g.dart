// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intake_log_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$intakeLogListHash() => r'646d08e368835be4caf3cb51054c6acbe381a0ad';

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

abstract class _$IntakeLogList
    extends BuildlessAutoDisposeAsyncNotifier<List<IntakeLog>> {
  late final String profileId;

  FutureOr<List<IntakeLog>> build(String profileId);
}

/// Provider for managing intake log list with profile scope.
///
/// Supports special actions: markTaken, markSkipped.
///
/// Copied from [IntakeLogList].
@ProviderFor(IntakeLogList)
const intakeLogListProvider = IntakeLogListFamily();

/// Provider for managing intake log list with profile scope.
///
/// Supports special actions: markTaken, markSkipped.
///
/// Copied from [IntakeLogList].
class IntakeLogListFamily extends Family<AsyncValue<List<IntakeLog>>> {
  /// Provider for managing intake log list with profile scope.
  ///
  /// Supports special actions: markTaken, markSkipped.
  ///
  /// Copied from [IntakeLogList].
  const IntakeLogListFamily();

  /// Provider for managing intake log list with profile scope.
  ///
  /// Supports special actions: markTaken, markSkipped.
  ///
  /// Copied from [IntakeLogList].
  IntakeLogListProvider call(String profileId) {
    return IntakeLogListProvider(profileId);
  }

  @override
  IntakeLogListProvider getProviderOverride(
    covariant IntakeLogListProvider provider,
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
  String? get name => r'intakeLogListProvider';
}

/// Provider for managing intake log list with profile scope.
///
/// Supports special actions: markTaken, markSkipped.
///
/// Copied from [IntakeLogList].
class IntakeLogListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<IntakeLogList, List<IntakeLog>> {
  /// Provider for managing intake log list with profile scope.
  ///
  /// Supports special actions: markTaken, markSkipped.
  ///
  /// Copied from [IntakeLogList].
  IntakeLogListProvider(String profileId)
    : this._internal(
        () => IntakeLogList()..profileId = profileId,
        from: intakeLogListProvider,
        name: r'intakeLogListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$intakeLogListHash,
        dependencies: IntakeLogListFamily._dependencies,
        allTransitiveDependencies:
            IntakeLogListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  IntakeLogListProvider._internal(
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
  FutureOr<List<IntakeLog>> runNotifierBuild(covariant IntakeLogList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(IntakeLogList Function() create) {
    return ProviderOverride(
      origin: this,
      override: IntakeLogListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<IntakeLogList, List<IntakeLog>>
  createElement() {
    return _IntakeLogListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IntakeLogListProvider && other.profileId == profileId;
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
mixin IntakeLogListRef on AutoDisposeAsyncNotifierProviderRef<List<IntakeLog>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _IntakeLogListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<IntakeLogList, List<IntakeLog>>
    with IntakeLogListRef {
  _IntakeLogListProviderElement(super.provider);

  @override
  String get profileId => (origin as IntakeLogListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
