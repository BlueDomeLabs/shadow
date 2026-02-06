// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityLogListHash() => r'33030326fa91d13900e215835478db748d67376e';

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

abstract class _$ActivityLogList
    extends BuildlessAutoDisposeAsyncNotifier<List<ActivityLog>> {
  late final String profileId;

  FutureOr<List<ActivityLog>> build(String profileId);
}

/// Provider for managing activity log list with profile scope.
///
/// Copied from [ActivityLogList].
@ProviderFor(ActivityLogList)
const activityLogListProvider = ActivityLogListFamily();

/// Provider for managing activity log list with profile scope.
///
/// Copied from [ActivityLogList].
class ActivityLogListFamily extends Family<AsyncValue<List<ActivityLog>>> {
  /// Provider for managing activity log list with profile scope.
  ///
  /// Copied from [ActivityLogList].
  const ActivityLogListFamily();

  /// Provider for managing activity log list with profile scope.
  ///
  /// Copied from [ActivityLogList].
  ActivityLogListProvider call(String profileId) {
    return ActivityLogListProvider(profileId);
  }

  @override
  ActivityLogListProvider getProviderOverride(
    covariant ActivityLogListProvider provider,
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
  String? get name => r'activityLogListProvider';
}

/// Provider for managing activity log list with profile scope.
///
/// Copied from [ActivityLogList].
class ActivityLogListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ActivityLogList,
          List<ActivityLog>
        > {
  /// Provider for managing activity log list with profile scope.
  ///
  /// Copied from [ActivityLogList].
  ActivityLogListProvider(String profileId)
    : this._internal(
        () => ActivityLogList()..profileId = profileId,
        from: activityLogListProvider,
        name: r'activityLogListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activityLogListHash,
        dependencies: ActivityLogListFamily._dependencies,
        allTransitiveDependencies:
            ActivityLogListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  ActivityLogListProvider._internal(
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
  FutureOr<List<ActivityLog>> runNotifierBuild(
    covariant ActivityLogList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(ActivityLogList Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityLogListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ActivityLogList, List<ActivityLog>>
  createElement() {
    return _ActivityLogListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityLogListProvider && other.profileId == profileId;
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
mixin ActivityLogListRef
    on AutoDisposeAsyncNotifierProviderRef<List<ActivityLog>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ActivityLogListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ActivityLogList,
          List<ActivityLog>
        >
    with ActivityLogListRef {
  _ActivityLogListProviderElement(super.provider);

  @override
  String get profileId => (origin as ActivityLogListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
