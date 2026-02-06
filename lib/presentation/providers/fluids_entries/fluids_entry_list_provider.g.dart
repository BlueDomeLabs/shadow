// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fluids_entry_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fluidsEntryListHash() => r'2f109dea8e6c24b6de55701be5e6e94bce4b6a7b';

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

abstract class _$FluidsEntryList
    extends BuildlessAutoDisposeAsyncNotifier<List<FluidsEntry>> {
  late final String profileId;
  late final int startDate;
  late final int endDate;

  FutureOr<List<FluidsEntry>> build(
    String profileId,
    int startDate,
    int endDate,
  );
}

/// Provider for managing fluids entry list with profile scope and date range.
///
/// Copied from [FluidsEntryList].
@ProviderFor(FluidsEntryList)
const fluidsEntryListProvider = FluidsEntryListFamily();

/// Provider for managing fluids entry list with profile scope and date range.
///
/// Copied from [FluidsEntryList].
class FluidsEntryListFamily extends Family<AsyncValue<List<FluidsEntry>>> {
  /// Provider for managing fluids entry list with profile scope and date range.
  ///
  /// Copied from [FluidsEntryList].
  const FluidsEntryListFamily();

  /// Provider for managing fluids entry list with profile scope and date range.
  ///
  /// Copied from [FluidsEntryList].
  FluidsEntryListProvider call(String profileId, int startDate, int endDate) {
    return FluidsEntryListProvider(profileId, startDate, endDate);
  }

  @override
  FluidsEntryListProvider getProviderOverride(
    covariant FluidsEntryListProvider provider,
  ) {
    return call(provider.profileId, provider.startDate, provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fluidsEntryListProvider';
}

/// Provider for managing fluids entry list with profile scope and date range.
///
/// Copied from [FluidsEntryList].
class FluidsEntryListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          FluidsEntryList,
          List<FluidsEntry>
        > {
  /// Provider for managing fluids entry list with profile scope and date range.
  ///
  /// Copied from [FluidsEntryList].
  FluidsEntryListProvider(String profileId, int startDate, int endDate)
    : this._internal(
        () => FluidsEntryList()
          ..profileId = profileId
          ..startDate = startDate
          ..endDate = endDate,
        from: fluidsEntryListProvider,
        name: r'fluidsEntryListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$fluidsEntryListHash,
        dependencies: FluidsEntryListFamily._dependencies,
        allTransitiveDependencies:
            FluidsEntryListFamily._allTransitiveDependencies,
        profileId: profileId,
        startDate: startDate,
        endDate: endDate,
      );

  FluidsEntryListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String profileId;
  final int startDate;
  final int endDate;

  @override
  FutureOr<List<FluidsEntry>> runNotifierBuild(
    covariant FluidsEntryList notifier,
  ) {
    return notifier.build(profileId, startDate, endDate);
  }

  @override
  Override overrideWith(FluidsEntryList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FluidsEntryListProvider._internal(
        () => create()
          ..profileId = profileId
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FluidsEntryList, List<FluidsEntry>>
  createElement() {
    return _FluidsEntryListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FluidsEntryListProvider &&
        other.profileId == profileId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FluidsEntryListRef
    on AutoDisposeAsyncNotifierProviderRef<List<FluidsEntry>> {
  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `startDate` of this provider.
  int get startDate;

  /// The parameter `endDate` of this provider.
  int get endDate;
}

class _FluidsEntryListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          FluidsEntryList,
          List<FluidsEntry>
        >
    with FluidsEntryListRef {
  _FluidsEntryListProviderElement(super.provider);

  @override
  String get profileId => (origin as FluidsEntryListProvider).profileId;
  @override
  int get startDate => (origin as FluidsEntryListProvider).startDate;
  @override
  int get endDate => (origin as FluidsEntryListProvider).endDate;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
