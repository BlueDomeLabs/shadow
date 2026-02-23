/// Guest mode state management provider.
///
/// Tracks whether the app is running in guest mode (single profile,
/// restricted navigation) or host mode (full access).
/// Uses StateNotifier pattern matching profile_provider.dart.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasSeenDisclaimerKey = 'shadow_guest_has_seen_disclaimer';

/// State representing guest mode status.
class GuestModeState {
  final bool isGuestMode;
  final String? guestProfileId;
  final String? guestToken;
  final bool hasSeenDisclaimer;

  const GuestModeState({
    this.isGuestMode = false,
    this.guestProfileId,
    this.guestToken,
    this.hasSeenDisclaimer = false,
  });

  GuestModeState copyWith({
    bool? isGuestMode,
    String? guestProfileId,
    String? guestToken,
    bool? hasSeenDisclaimer,
  }) => GuestModeState(
    isGuestMode: isGuestMode ?? this.isGuestMode,
    guestProfileId: guestProfileId ?? this.guestProfileId,
    guestToken: guestToken ?? this.guestToken,
    hasSeenDisclaimer: hasSeenDisclaimer ?? this.hasSeenDisclaimer,
  );
}

/// Notifier managing guest mode activation/deactivation.
class GuestModeNotifier extends StateNotifier<GuestModeState> {
  GuestModeNotifier() : super(const GuestModeState()) {
    _loadDisclaimerState();
  }

  Future<void> _loadDisclaimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(_hasSeenDisclaimerKey) ?? false;
    state = state.copyWith(hasSeenDisclaimer: hasSeen);
  }

  /// Activates guest mode for a specific profile.
  void activateGuestMode({required String profileId, required String token}) {
    state = state.copyWith(
      isGuestMode: true,
      guestProfileId: profileId,
      guestToken: token,
    );
  }

  /// Deactivates guest mode, returning to host mode.
  void deactivateGuestMode() {
    state = const GuestModeState();
    _loadDisclaimerState();
  }

  /// Marks the disclaimer as seen and persists it.
  Future<void> markDisclaimerSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenDisclaimerKey, true);
    state = state.copyWith(hasSeenDisclaimer: true);
  }
}

/// Provider for guest mode state management.
final guestModeProvider =
    StateNotifierProvider<GuestModeNotifier, GuestModeState>(
      (ref) => GuestModeNotifier(),
    );
