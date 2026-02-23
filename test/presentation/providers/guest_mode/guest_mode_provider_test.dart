// test/presentation/providers/guest_mode/guest_mode_provider_test.dart
// Tests for GuestModeNotifier state management.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GuestModeNotifier', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is not guest mode', () {
      final state = container.read(guestModeProvider);

      expect(state.isGuestMode, isFalse);
      expect(state.guestProfileId, isNull);
      expect(state.guestToken, isNull);
    });

    test('activateGuestMode sets isGuestMode, guestProfileId, guestToken', () {
      container
          .read(guestModeProvider.notifier)
          .activateGuestMode(profileId: 'profile-123', token: 'token-abc');

      final state = container.read(guestModeProvider);
      expect(state.isGuestMode, isTrue);
      expect(state.guestProfileId, 'profile-123');
      expect(state.guestToken, 'token-abc');
    });

    test('deactivateGuestMode resets state', () {
      // First activate
      container
          .read(guestModeProvider.notifier)
          .activateGuestMode(profileId: 'profile-123', token: 'token-abc');
      expect(container.read(guestModeProvider).isGuestMode, isTrue);

      // Then deactivate
      container.read(guestModeProvider.notifier).deactivateGuestMode();

      final state = container.read(guestModeProvider);
      expect(state.isGuestMode, isFalse);
      expect(state.guestProfileId, isNull);
      expect(state.guestToken, isNull);
    });

    test('markDisclaimerSeen persists to SharedPreferences', () async {
      final notifier = container.read(guestModeProvider.notifier);

      expect(container.read(guestModeProvider).hasSeenDisclaimer, isFalse);

      await notifier.markDisclaimerSeen();

      expect(container.read(guestModeProvider).hasSeenDisclaimer, isTrue);

      // Verify persisted to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('shadow_guest_has_seen_disclaimer'), isTrue);
    });

    test('loads hasSeenDisclaimer from SharedPreferences on init', () async {
      SharedPreferences.setMockInitialValues({
        'shadow_guest_has_seen_disclaimer': true,
      });

      final container2 = ProviderContainer();
      addTearDown(container2.dispose);

      // Force the notifier to initialize, then wait for async load
      container2.read(guestModeProvider.notifier);
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final state = container2.read(guestModeProvider);
      expect(state.hasSeenDisclaimer, isTrue);
    });
  });

  group('GuestModeState', () {
    test('copyWith creates new state with updated values', () {
      const state = GuestModeState();

      final updated = state.copyWith(
        isGuestMode: true,
        guestProfileId: 'p1',
        guestToken: 't1',
        hasSeenDisclaimer: true,
      );

      expect(updated.isGuestMode, isTrue);
      expect(updated.guestProfileId, 'p1');
      expect(updated.guestToken, 't1');
      expect(updated.hasSeenDisclaimer, isTrue);
    });

    test('copyWith preserves unchanged values', () {
      const state = GuestModeState(
        isGuestMode: true,
        guestProfileId: 'p1',
        guestToken: 't1',
      );

      final updated = state.copyWith(hasSeenDisclaimer: true);

      expect(updated.isGuestMode, isTrue);
      expect(updated.guestProfileId, 'p1');
      expect(updated.guestToken, 't1');
      expect(updated.hasSeenDisclaimer, isTrue);
    });
  });
}
