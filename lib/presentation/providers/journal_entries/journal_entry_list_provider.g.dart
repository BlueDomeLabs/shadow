// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalEntryListHash() => r'ac5b2ccfcd81c98f2f7a2ce6b5475493a7ef8f1c';

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

abstract class _$JournalEntryList
    extends BuildlessAutoDisposeAsyncNotifier<List<JournalEntry>> {
  late final String profileId;

  FutureOr<List<JournalEntry>> build(String profileId);
}

/// Provider for managing journal entry list with profile scope.
///
/// Copied from [JournalEntryList].
@ProviderFor(JournalEntryList)
const journalEntryListProvider = JournalEntryListFamily();

/// Provider for managing journal entry list with profile scope.
///
/// Copied from [JournalEntryList].
class JournalEntryListFamily extends Family<AsyncValue<List<JournalEntry>>> {
  /// Provider for managing journal entry list with profile scope.
  ///
  /// Copied from [JournalEntryList].
  const JournalEntryListFamily();

  /// Provider for managing journal entry list with profile scope.
  ///
  /// Copied from [JournalEntryList].
  JournalEntryListProvider call(String profileId) {
    return JournalEntryListProvider(profileId);
  }

  @override
  JournalEntryListProvider getProviderOverride(
    covariant JournalEntryListProvider provider,
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
  String? get name => r'journalEntryListProvider';
}

/// Provider for managing journal entry list with profile scope.
///
/// Copied from [JournalEntryList].
class JournalEntryListProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          JournalEntryList,
          List<JournalEntry>
        > {
  /// Provider for managing journal entry list with profile scope.
  ///
  /// Copied from [JournalEntryList].
  JournalEntryListProvider(String profileId)
    : this._internal(
        () => JournalEntryList()..profileId = profileId,
        from: journalEntryListProvider,
        name: r'journalEntryListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journalEntryListHash,
        dependencies: JournalEntryListFamily._dependencies,
        allTransitiveDependencies:
            JournalEntryListFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  JournalEntryListProvider._internal(
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
  FutureOr<List<JournalEntry>> runNotifierBuild(
    covariant JournalEntryList notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(JournalEntryList Function() create) {
    return ProviderOverride(
      origin: this,
      override: JournalEntryListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<JournalEntryList, List<JournalEntry>>
  createElement() {
    return _JournalEntryListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntryListProvider && other.profileId == profileId;
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
mixin JournalEntryListRef
    on AutoDisposeAsyncNotifierProviderRef<List<JournalEntry>> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _JournalEntryListProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          JournalEntryList,
          List<JournalEntry>
        >
    with JournalEntryListRef {
  _JournalEntryListProviderElement(super.provider);

  @override
  String get profileId => (origin as JournalEntryListProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
