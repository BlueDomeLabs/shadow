// lib/main.dart - Shadow App Entry Point

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: ShadowApp()));
}

/// Root application widget.
class ShadowApp extends StatelessWidget {
  const ShadowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Shadow - Phase 1 Foundation')),
      ),
    );
  }
}
