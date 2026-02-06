// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_area_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoAreaListHash() => r'28d53ee3f68c56c846b7e486cd83019272e2edc0';

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

abstract class _$PhotoAreaList
    extends BuildlessAutoDisposeAsyncNotifier<List<PhotoArea>> {
  late final String profileId;

  FutureOr<List<PhotoArea>> build(String profileId);
}

/// Provider for managing photo area list with profile scope.
///
/// Copied from [PhotoAreaList].
@ProviderFor(PhotoAreaList)
const photoAreaListProvider = PhotoAreaListFamily();

/// Provider for managing photo area list with profile scope.
///
/// Copied from [PhotoAreaList].
class PhotoAreaListFamily extends Family<AsyncValue<List<PhotoArea>>> {
  /// Provider for managing photo area list with profile scope.
  ///
  /// Copied from [PhotoAreaList].
  const PhotoAreaListFamily();

  /// Provider for managing photo area list with profile scope.
  ///
  /// Copied from [PhotoAreaList].
  PhotoAreaListProvider call(String profileId) {
    return PhotoAreaListProvider(profileId);
  }

  @override
  PhotoAreaListProvider getProviderOverride(
    covariant PhotoAreaListProvider provider,
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
  String? get name => r'photoAreaListProvider';
}

/// Provider for managing photo area list with profile scope.
///
/// Copied from [PhotoAreaList].
class PhotoAreaListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<PhotoAreaList, List<PhotoArea>> {
  /// Provider for managing photo area list with profile scope.
  ///
  /// Copied from [PhotoAreaList].
  PhotoAreaListProvider(String profileId)
    : this._internal(
        () => PhotoAreaList()..profileId = profileId,
        from: photoAreaListProvider,
        name: r'photoAreaListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$photoAreaListHash,
        dependencies: PhotoAreaListFamily._dependencies,
        allTransitiveDependencies:
            PhotoAreaListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  PhotoAreaListProvider._internal(
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
  FutureOr<List<PhotoArea>> runNotifierBuild(covariant PhotoAreaList notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(PhotoAreaList Function() create) {
    return ProviderOverride(
      origin: this,
      override: PhotoAreaListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PhotoAreaList, List<PhotoArea>>
  createElement() {
    return _PhotoAreaListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoAreaListProvider && other.profileId == profileId;
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
mixin PhotoAreaListRef on AutoDisposeAsyncNotifierProviderRef<List<PhotoArea>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _PhotoAreaListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<PhotoAreaList, List<PhotoArea>>
    with PhotoAreaListRef {
  _PhotoAreaListProviderElement(super.provider);

  @override
  String get profileId => (origin as PhotoAreaListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
