// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_entry_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sleepEntryListHash() => r'711470f333d692ad8dce1ebd5fd494eda39012ce';

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

abstract class _$SleepEntryList
    extends BuildlessAutoDisposeAsyncNotifier<List<SleepEntry>> {
  late final String profileId;

  FutureOr<List<SleepEntry>> build(String profileId);
}

/// Provider for managing sleep entry list with profile scope.
///
/// Copied from [SleepEntryList].
@ProviderFor(SleepEntryList)
const sleepEntryListProvider = SleepEntryListFamily();

/// Provider for managing sleep entry list with profile scope.
///
/// Copied from [SleepEntryList].
class SleepEntryListFamily extends Family<AsyncValue<List<SleepEntry>>> {
  /// Provider for managing sleep entry list with profile scope.
  ///
  /// Copied from [SleepEntryList].
  const SleepEntryListFamily();

  /// Provider for managing sleep entry list with profile scope.
  ///
  /// Copied from [SleepEntryList].
  SleepEntryListProvider call(String profileId) {
    return SleepEntryListProvider(profileId);
  }

  @override
  SleepEntryListProvider getProviderOverride(
    covariant SleepEntryListProvider provider,
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
  String? get name => r'sleepEntryListProvider';
}

/// Provider for managing sleep entry list with profile scope.
///
/// Copied from [SleepEntryList].
class SleepEntryListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<SleepEntryList, List<SleepEntry>> {
  /// Provider for managing sleep entry list with profile scope.
  ///
  /// Copied from [SleepEntryList].
  SleepEntryListProvider(String profileId)
    : this._internal(
        () => SleepEntryList()..profileId = profileId,
        from: sleepEntryListProvider,
        name: r'sleepEntryListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepEntryListHash,
        dependencies: SleepEntryListFamily._dependencies,
        allTransitiveDependencies:
            SleepEntryListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  SleepEntryListProvider._internal(
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
  FutureOr<List<SleepEntry>> runNotifierBuild(
    covariant SleepEntryList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(SleepEntryList Function() create) {
    return ProviderOverride(
      origin: this,
      override: SleepEntryListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SleepEntryList, List<SleepEntry>>
  createElement() {
    return _SleepEntryListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepEntryListProvider && other.profileId == profileId;
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
mixin SleepEntryListRef
    on AutoDisposeAsyncNotifierProviderRef<List<SleepEntry>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _SleepEntryListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SleepEntryList,
          List<SleepEntry>
        >
    with SleepEntryListRef {
  _SleepEntryListProviderElement(super.provider);

  @override
  String get profileId => (origin as SleepEntryListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
