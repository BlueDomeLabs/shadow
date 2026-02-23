// lib/main.dart - Shadow App Entry Point

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/bootstrap.dart';
import 'package:shadow_app/domain/services/guest_token_service.dart';
import 'package:shadow_app/presentation/providers/guest_mode/guest_mode_provider.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/providers/settings/security_provider.dart';
import 'package:shadow_app/presentation/providers/settings/user_settings_provider.dart';
import 'package:shadow_app/presentation/screens/guest_invites/access_revoked_screen.dart';
import 'package:shadow_app/presentation/screens/guest_invites/guest_disclaimer_dialog.dart';
import 'package:shadow_app/presentation/screens/home/home_screen.dart';
import 'package:shadow_app/presentation/screens/profiles/welcome_screen.dart';
import 'package:shadow_app/presentation/screens/settings/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await bootstrap();
  runApp(ProviderScope(overrides: overrides, child: const ShadowApp()));
}

/// Root application widget.
class ShadowApp extends ConsumerWidget {
  const ShadowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final guestMode = ref.watch(guestModeProvider);

    // If guest mode and token is invalid, show access revoked
    if (guestMode.isGuestMode && guestMode.guestToken == null) {
      return MaterialApp(
        title: 'Shadow',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const AccessRevokedScreen(reason: TokenRejectionReason.revoked),
      );
    }

    return MaterialApp(
      title: 'Shadow',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: state.profiles.isEmpty && !guestMode.isGuestMode
          ? const WelcomeScreen()
          : const HomeScreen(),
      builder: (context, child) =>
          _LockScreenGuard(child: _GuestDisclaimerGuard(child: child!)),
    );
  }

  ThemeData _buildTheme() => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );
}

/// Widget that shows the lock screen when the app is locked.
class _LockScreenGuard extends ConsumerWidget {
  final Widget child;

  const _LockScreenGuard({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final security = ref.watch(securityProvider);
    final settings = ref.watch(userSettingsNotifierProvider).valueOrNull;
    if (settings != null && settings.appLockEnabled && security.isLocked) {
      return const LockScreen();
    }
    return child;
  }
}

/// Widget that shows the guest disclaimer dialog when needed.
class _GuestDisclaimerGuard extends ConsumerStatefulWidget {
  final Widget child;

  const _GuestDisclaimerGuard({required this.child});

  @override
  ConsumerState<_GuestDisclaimerGuard> createState() =>
      _GuestDisclaimerGuardState();
}

class _GuestDisclaimerGuardState extends ConsumerState<_GuestDisclaimerGuard> {
  bool _hasShownDisclaimer = false;

  @override
  Widget build(BuildContext context) {
    final guestMode = ref.watch(guestModeProvider);

    // Show disclaimer on first guest launch if not seen
    if (guestMode.isGuestMode &&
        !guestMode.hasSeenDisclaimer &&
        !_hasShownDisclaimer) {
      _hasShownDisclaimer = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        final accepted = await showGuestDisclaimerDialog(context);
        if (accepted && context.mounted) {
          await ref.read(guestModeProvider.notifier).markDisclaimerSeen();
        }
      });
    }

    return widget.child;
  }
}
