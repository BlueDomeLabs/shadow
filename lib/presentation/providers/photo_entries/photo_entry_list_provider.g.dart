// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_entry_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoEntryListHash() => r'f221a96713df378ec30035fefa2fbf8a2ac8b68a';

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

abstract class _$PhotoEntryList
    extends BuildlessAutoDisposeAsyncNotifier<List<PhotoEntry>> {
  late final String profileId;

  FutureOr<List<PhotoEntry>> build(String profileId);
}

/// Provider for managing photo entry list with profile scope.
///
/// Copied from [PhotoEntryList].
@ProviderFor(PhotoEntryList)
const photoEntryListProvider = PhotoEntryListFamily();

/// Provider for managing photo entry list with profile scope.
///
/// Copied from [PhotoEntryList].
class PhotoEntryListFamily extends Family<AsyncValue<List<PhotoEntry>>> {
  /// Provider for managing photo entry list with profile scope.
  ///
  /// Copied from [PhotoEntryList].
  const PhotoEntryListFamily();

  /// Provider for managing photo entry list with profile scope.
  ///
  /// Copied from [PhotoEntryList].
  PhotoEntryListProvider call(String profileId) {
    return PhotoEntryListProvider(profileId);
  }

  @override
  PhotoEntryListProvider getProviderOverride(
    covariant PhotoEntryListProvider provider,
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
  String? get name => r'photoEntryListProvider';
}

/// Provider for managing photo entry list with profile scope.
///
/// Copied from [PhotoEntryList].
class PhotoEntryListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<PhotoEntryList, List<PhotoEntry>> {
  /// Provider for managing photo entry list with profile scope.
  ///
  /// Copied from [PhotoEntryList].
  PhotoEntryListProvider(String profileId)
    : this._internal(
        () => PhotoEntryList()..profileId = profileId,
        from: photoEntryListProvider,
        name: r'photoEntryListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$photoEntryListHash,
        dependencies: PhotoEntryListFamily._dependencies,
        allTransitiveDependencies:
            PhotoEntryListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  PhotoEntryListProvider._internal(
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
  FutureOr<List<PhotoEntry>> runNotifierBuild(
    covariant PhotoEntryList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(PhotoEntryList Function() create) {
    return ProviderOverride(
      origin: this,
      override: PhotoEntryListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<PhotoEntryList, List<PhotoEntry>>
  createElement() {
    return _PhotoEntryListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoEntryListProvider && other.profileId == profileId;
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
mixin PhotoEntryListRef
    on AutoDisposeAsyncNotifierProviderRef<List<PhotoEntry>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _PhotoEntryListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PhotoEntryList,
          List<PhotoEntry>
        >
    with PhotoEntryListRef {
  _PhotoEntryListProviderElement(super.provider);

  @override
  String get profileId => (origin as PhotoEntryListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
