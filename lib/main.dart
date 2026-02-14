// lib/main.dart - Shadow App Entry Point

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/bootstrap.dart';
import 'package:shadow_app/presentation/providers/profile/profile_provider.dart';
import 'package:shadow_app/presentation/screens/home/home_screen.dart';
import 'package:shadow_app/presentation/screens/profiles/welcome_screen.dart';

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

    return MaterialApp(
      title: 'Shadow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: state.profiles.isEmpty ? const WelcomeScreen() : const HomeScreen(),
    );
  }
}
