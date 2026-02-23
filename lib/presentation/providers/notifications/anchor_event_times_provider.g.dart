// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anchor_event_times_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$anchorEventTimesHash() => r'75a46fef11f53cb04124f237e4b76663f3772cfb';

/// Provider for the 5 anchor event times (global — not profile-scoped).
///
/// Anchor events (Wake, Breakfast, Lunch, Dinner, Bedtime) are shared across
/// all profiles. Follows the UseCase delegation pattern:
/// - ALWAYS delegates to UseCases (never calls repository directly)
/// - Calls ref.invalidateSelf() after successful mutations
///
/// Copied from [AnchorEventTimes].
@ProviderFor(AnchorEventTimes)
final anchorEventTimesProvider =
    AutoDisposeAsyncNotifierProvider<
      AnchorEventTimes,
      List<AnchorEventTime>
    >.internal(
      AnchorEventTimes.new,
      name: r'anchorEventTimesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$anchorEventTimesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AnchorEventTimes = AutoDisposeAsyncNotifier<List<AnchorEventTime>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
