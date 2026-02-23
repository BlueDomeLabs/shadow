// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_invite_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$guestInviteListHash() => r'cdca99ddf79de0a198533c10e10d309ee9d4fcee';

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

abstract class _$GuestInviteList
    extends BuildlessAutoDisposeAsyncNotifier<List<GuestInvite>> {
  late final String profileId;

  FutureOr<List<GuestInvite>> build(String profileId);
}

/// Provider for managing guest invite list with profile scope.
///
/// Copied from [GuestInviteList].
@ProviderFor(GuestInviteList)
const guestInviteListProvider = GuestInviteListFamily();

/// Provider for managing guest invite list with profile scope.
///
/// Copied from [GuestInviteList].
class GuestInviteListFamily extends Family<AsyncValue<List<GuestInvite>>> {
  /// Provider for managing guest invite list with profile scope.
  ///
  /// Copied from [GuestInviteList].
  const GuestInviteListFamily();

  /// Provider for managing guest invite list with profile scope.
  ///
  /// Copied from [GuestInviteList].
  GuestInviteListProvider call(String profileId) {
    return GuestInviteListProvider(profileId);
  }

  @override
  GuestInviteListProvider getProviderOverride(
    covariant GuestInviteListProvider provider,
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
  String? get name => r'guestInviteListProvider';
}

/// Provider for managing guest invite list with profile scope.
///
/// Copied from [GuestInviteList].
class GuestInviteListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          GuestInviteList,
          List<GuestInvite>
        > {
  /// Provider for managing guest invite list with profile scope.
  ///
  /// Copied from [GuestInviteList].
  GuestInviteListProvider(String profileId)
    : this._internal(
        () => GuestInviteList()..profileId = profileId,
        from: guestInviteListProvider,
        name: r'guestInviteListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$guestInviteListHash,
        dependencies: GuestInviteListFamily._dependencies,
        allTransitiveDependencies:
            GuestInviteListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  GuestInviteListProvider._internal(
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
  FutureOr<List<GuestInvite>> runNotifierBuild(
    covariant GuestInviteList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(GuestInviteList Function() create) {
    return ProviderOverride(
      origin: this,
      override: GuestInviteListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<GuestInviteList, List<GuestInvite>>
  createElement() {
    return _GuestInviteListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GuestInviteListProvider && other.profileId == profileId;
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
mixin GuestInviteListRef
    on AutoDisposeAsyncNotifierProviderRef<List<GuestInvite>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _GuestInviteListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          GuestInviteList,
          List<GuestInvite>
        >
    with GuestInviteListRef {
  _GuestInviteListProviderElement(super.provider);

  @override
  String get profileId => (origin as GuestInviteListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
