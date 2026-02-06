// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalEntrySearchHash() =>
    r'3224b2ba535fad12e39d557645bb655d3a33277e';

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

abstract class _$JournalEntrySearch
    extends BuildlessAutoDisposeAsyncNotifier<List<JournalEntry>> {
  late final String profileId;
  late final String query;

  FutureOr<List<JournalEntry>> build(String profileId, String query);
}

/// Provider for searching journal entries with profile scope.
///
/// Takes both profileId and query as build parameters.
///
/// Copied from [JournalEntrySearch].
@ProviderFor(JournalEntrySearch)
const journalEntrySearchProvider = JournalEntrySearchFamily();

/// Provider for searching journal entries with profile scope.
///
/// Takes both profileId and query as build parameters.
///
/// Copied from [JournalEntrySearch].
class JournalEntrySearchFamily extends Family<AsyncValue<List<JournalEntry>>> {
  /// Provider for searching journal entries with profile scope.
  ///
  /// Takes both profileId and query as build parameters.
  ///
  /// Copied from [JournalEntrySearch].
  const JournalEntrySearchFamily();

  /// Provider for searching journal entries with profile scope.
  ///
  /// Takes both profileId and query as build parameters.
  ///
  /// Copied from [JournalEntrySearch].
  JournalEntrySearchProvider call(String profileId, String query) {
    return JournalEntrySearchProvider(profileId, query);
  }

  @override
  JournalEntrySearchProvider getProviderOverride(
    covariant JournalEntrySearchProvider provider,
  ) {
    return call(provider.profileId, provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'journalEntrySearchProvider';
}

/// Provider for searching journal entries with profile scope.
///
/// Takes both profileId and query as build parameters.
///
/// Copied from [JournalEntrySearch].
class JournalEntrySearchProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          JournalEntrySearch,
          List<JournalEntry>
        > {
  /// Provider for searching journal entries with profile scope.
  ///
  /// Takes both profileId and query as build parameters.
  ///
  /// Copied from [JournalEntrySearch].
  JournalEntrySearchProvider(String profileId, String query)
    : this._internal(
        () => JournalEntrySearch()
          ..profileId = profileId
          ..query = query,
        from: journalEntrySearchProvider,
        name: r'journalEntrySearchProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journalEntrySearchHash,
        dependencies: JournalEntrySearchFamily._dependencies,
        allTransitiveDependencies:
            JournalEntrySearchFamily._allTransitiveDependencies,
        profileId: profileId,
        query: query,
      );

  JournalEntrySearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
    required this.query,
  }) : super.internal();

  final String profileId;
  final String query;

  @override
  FutureOr<List<JournalEntry>> runNotifierBuild(
    covariant JournalEntrySearch notifier,
  ) {
    return notifier.build(profileId, query);
  }

  @override
  Override overrideWith(JournalEntrySearch Function() create) {
    return ProviderOverride(
      origin: this,
      override: JournalEntrySearchProvider._internal(
        () => create()
          ..profileId = profileId
          ..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    JournalEntrySearch,
    List<JournalEntry>
  >
  createElement() {
    return _JournalEntrySearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntrySearchProvider &&
        other.profileId == profileId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JournalEntrySearchRef
    on AutoDisposeAsyncNotifierProviderRef<List<JournalEntry>> {
  /// The parameter `profileId` of this provider.
  String get profileId;

  /// The parameter `query` of this provider.
  String get query;
}

class _JournalEntrySearchProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          JournalEntrySearch,
          List<JournalEntry>
        >
    with JournalEntrySearchRef {
  _JournalEntrySearchProviderElement(super.provider);

  @override
  String get profileId => (origin as JournalEntrySearchProvider).profileId;
  @override
  String get query => (origin as JournalEntrySearchProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
