// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_entries_by_area_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoEntriesByAreaHash() =>
    r'87f915a8d4a24d35afad9e26071b7e5c76c81100';

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

abstract class _$PhotoEntriesByArea
    extends BuildlessAutoDisposeAsyncNotifier<List<PhotoEntry>> {
  late final String profileId;
  late final String photoAreaId;

  FutureOr<List<PhotoEntry>> build(String profileId, String photoAreaId);
}

/// Provider for fetching photo entries filtered by area with profile scope.
///
/// Takes both profileId and areaId as build parameters.
///
/// Copied from [PhotoEntriesByArea].
@ProviderFor(PhotoEntriesByArea)
const photoEntriesByAreaProvider = PhotoEntriesByAreaFamily();

/// Provider for fetching photo entries filtered by area with profile scope.
///
/// Takes both profileId and areaId as build parameters.
///
/// Copied from [PhotoEntriesByArea].
class PhotoEntriesByAreaFamily extends Family<AsyncValue<List<PhotoEntry>>> {
  /// Provider for fetching photo entries filtered by area with profile scope.
  ///
  /// Takes both profileId and areaId as build parameters.
  ///
  /// Copied from [PhotoEntriesByArea].
  const PhotoEntriesByAreaFamily();

  /// Provider for fetching photo entries filtered by area with profile scope.
  ///
  /// Takes both profileId and areaId as build parameters.
  ///
  /// Copied from [PhotoEntriesByArea].
  PhotoEntriesByAreaProvider call(String profileId, String photoAreaId) {
    return PhotoEntriesByAreaProvider(profileId, photoAreaId);
  }

  @override
  PhotoEntriesByAreaProvider getProviderOverride(
    covariant PhotoEntriesByAreaProvider provider,
  ) {
    return call(provider.profileId, provider.photoAreaId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'photoEntriesByAreaProvider';
}

/// Provider for fetching photo entries filtered by area with profile scope.
///
/// Takes both profileId and areaId as build parameters.
///
/// Copied from [PhotoEntriesByArea].
class PhotoEntriesByAreaProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PhotoEntriesByArea,
          List<PhotoEntry>
        > {
  /// Provider for fetching photo entries filtered by area with profile scope.
  ///
  /// Takes both profileId and areaId as build parameters.
  ///
  /// Copied from [PhotoEntriesByArea].
  PhotoEntriesByAreaProvider(String profileId, String photoAreaId)
    : this._internal(
        () => PhotoEntriesByArea()
          ..profileId = profileId
          ..photoAreaId = photoAreaId,
        from: photoEntriesByAreaProvider,
        name: r'photoEntriesByAreaProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$photoEntriesByAreaHash,
        dependencies: PhotoEntriesByAreaFamily._dependencies,
        allTransitiveDependencies:
            PhotoEntriesByAreaFamily._allTransitiveDependencies,
        profileId: profileId,
        photoAreaId: photoAreaId,
      );

  PhotoEntriesByAreaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
    required this.photoAreaId,
  }) : super.internal();

  final String profileId;
  final String photoAreaId;

  @override
  FutureOr<List<PhotoEntry>> runNotifierBuild(
    covariant PhotoEntriesByArea notifier,
  ) {
    return notifier.build(profileId, photoAreaId);
  }

  @override
  Override overrideWith(PhotoEntriesByArea Function() create) {
    return ProviderOverride(
      origin: this,
      override: PhotoEntriesByAreaProvider._internal(
        () => create()
          ..profileId = profileId
          ..photoAreaId = photoAreaId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
        photoAreaId: photoAreaId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PhotoEntriesByArea, List<PhotoEntry>>
  createElement() {
    return _PhotoEntriesByAreaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoEntriesByAreaProvider &&
        other.profileId == profileId &&
        other.photoAreaId == photoAreaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, photoAreaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PhotoEntriesByAreaRef
    on AutoDisposeAsyncNotifierProviderRef<List<PhotoEntry>> {
  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `photoAreaId` of this provider.
  String get photoAreaId;
}

class _PhotoEntriesByAreaProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PhotoEntriesByArea,
          List<PhotoEntry>
        >
    with PhotoEntriesByAreaRef {
  _PhotoEntriesByAreaProviderElement(super.provider);

  @override
  String get profileId => (origin as PhotoEntriesByAreaProvider).profileId;
  @override
  String get photoAreaId => (origin as PhotoEntriesByAreaProvider).photoAreaId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
