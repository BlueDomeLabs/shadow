// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityListHash() => r'131851f9afb749d5472c15d03b105012904ade59';

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

abstract class _$ActivityList
    extends BuildlessAutoDisposeAsyncNotifier<List<Activity>> {
  late final String profileId;

  FutureOr<List<Activity>> build(String profileId);
}

/// Provider for managing activity list with profile scope.
///
/// Copied from [ActivityList].
@ProviderFor(ActivityList)
const activityListProvider = ActivityListFamily();

/// Provider for managing activity list with profile scope.
///
/// Copied from [ActivityList].
class ActivityListFamily extends Family<AsyncValue<List<Activity>>> {
  /// Provider for managing activity list with profile scope.
  ///
  /// Copied from [ActivityList].
  const ActivityListFamily();

  /// Provider for managing activity list with profile scope.
  ///
  /// Copied from [ActivityList].
  ActivityListProvider call(String profileId) {
    return ActivityListProvider(profileId);
  }

  @override
  ActivityListProvider getProviderOverride(
    covariant ActivityListProvider provider,
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
  String? get name => r'activityListProvider';
}

/// Provider for managing activity list with profile scope.
///
/// Copied from [ActivityList].
class ActivityListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ActivityList, List<Activity>> {
  /// Provider for managing activity list with profile scope.
  ///
  /// Copied from [ActivityList].
  ActivityListProvider(String profileId)
    : this._internal(
        () => ActivityList()..profileId = profileId,
        from: activityListProvider,
        name: r'activityListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activityListHash,
        dependencies: ActivityListFamily._dependencies,
        allTransitiveDependencies:
            ActivityListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  ActivityListProvider._internal(
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
  FutureOr<List<Activity>> runNotifierBuild(covariant ActivityList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(ActivityList Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ActivityList, List<Activity>>
  createElement() {
    return _ActivityListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityListProvider && other.profileId == profileId;
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
mixin ActivityListRef on AutoDisposeAsyncNotifierProviderRef<List<Activity>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ActivityListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ActivityList, List<Activity>>
    with ActivityListRef {
  _ActivityListProviderElement(super.provider);

  @override
  String get profileId => (origin as ActivityListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
