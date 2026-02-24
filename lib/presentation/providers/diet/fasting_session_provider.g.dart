// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fastingSessionNotifierHash() =>
    r'bb0605f7179f63047a45619c17c12c6d1d9aa32e';

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

abstract class _$FastingSessionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<FastingSession?> {
  late final String profileId;

  FutureOr<FastingSession?> build(String profileId);
}

/// Provider for managing the active fasting session for a profile.
///
/// Returns the current active FastingSession, or null if no fast is in progress.
/// Follows the UseCase delegation pattern — never calls repository directly.
///
/// Copied from [FastingSessionNotifier].
@ProviderFor(FastingSessionNotifier)
const fastingSessionNotifierProvider = FastingSessionNotifierFamily();

/// Provider for managing the active fasting session for a profile.
///
/// Returns the current active FastingSession, or null if no fast is in progress.
/// Follows the UseCase delegation pattern — never calls repository directly.
///
/// Copied from [FastingSessionNotifier].
class FastingSessionNotifierFamily extends Family<AsyncValue<FastingSession?>> {
  /// Provider for managing the active fasting session for a profile.
  ///
  /// Returns the current active FastingSession, or null if no fast is in progress.
  /// Follows the UseCase delegation pattern — never calls repository directly.
  ///
  /// Copied from [FastingSessionNotifier].
  const FastingSessionNotifierFamily();

  /// Provider for managing the active fasting session for a profile.
  ///
  /// Returns the current active FastingSession, or null if no fast is in progress.
  /// Follows the UseCase delegation pattern — never calls repository directly.
  ///
  /// Copied from [FastingSessionNotifier].
  FastingSessionNotifierProvider call(String profileId) {
    return FastingSessionNotifierProvider(profileId);
  }

  @override
  FastingSessionNotifierProvider getProviderOverride(
    covariant FastingSessionNotifierProvider provider,
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
  String? get name => r'fastingSessionNotifierProvider';
}

/// Provider for managing the active fasting session for a profile.
///
/// Returns the current active FastingSession, or null if no fast is in progress.
/// Follows the UseCase delegation pattern — never calls repository directly.
///
/// Copied from [FastingSessionNotifier].
class FastingSessionNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          FastingSessionNotifier,
          FastingSession?
        > {
  /// Provider for managing the active fasting session for a profile.
  ///
  /// Returns the current active FastingSession, or null if no fast is in progress.
  /// Follows the UseCase delegation pattern — never calls repository directly.
  ///
  /// Copied from [FastingSessionNotifier].
  FastingSessionNotifierProvider(String profileId)
    : this._internal(
        () => FastingSessionNotifier()..profileId = profileId,
        from: fastingSessionNotifierProvider,
        name: r'fastingSessionNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$fastingSessionNotifierHash,
        dependencies: FastingSessionNotifierFamily._dependencies,
        allTransitiveDependencies:
            FastingSessionNotifierFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  FastingSessionNotifierProvider._internal(
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
  FutureOr<FastingSession?> runNotifierBuild(
    covariant FastingSessionNotifier notifier,
  ) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(FastingSessionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FastingSessionNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    FastingSessionNotifier,
    FastingSession?
  >
  createElement() {
    return _FastingSessionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FastingSessionNotifierProvider &&
        other.profileId == profileId;
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
mixin FastingSessionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<FastingSession?> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _FastingSessionNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          FastingSessionNotifier,
          FastingSession?
        >
    with FastingSessionNotifierRef {
  _FastingSessionNotifierProviderElement(super.provider);

  @override
  String get profileId => (origin as FastingSessionNotifierProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
