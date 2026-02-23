// lib/presentation/screens/settings/pin_entry_screen.dart
// Per 58_SETTINGS_SCREENS.md — PIN entry, setup, change, and removal.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';

/// The mode in which [PinEntryScreen] operates.
enum PinEntryMode {
  /// Enter + confirm a new 6-digit PIN (first time).
  setup,

  /// Verify current PIN, then enter + confirm new PIN.
  change,

  /// Verify current PIN, then delete it.
  remove,

  /// Verify PIN to unlock the app.
  unlock,
}

/// Full-screen 6-digit PIN entry flow.
///
/// Returns [true] on success, [false] if verification failed, or [null] on
/// cancel (back button).
class PinEntryScreen extends ConsumerStatefulWidget {
  final PinEntryMode mode;

  const PinEntryScreen({super.key, required this.mode});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  String _pin = '';
  String? _firstPin;
  String? _errorMessage;
  bool _loading = false;
  late String _phase;

  @override
  void initState() {
    super.initState();
    _phase = switch (widget.mode) {
      PinEntryMode.setup => 'enter',
      PinEntryMode.change => 'verify',
      PinEntryMode.remove => 'verify',
      PinEntryMode.unlock => 'enter',
    };
  }

  String get _title => switch (widget.mode) {
    PinEntryMode.setup => 'Set PIN',
    PinEntryMode.change => 'Change PIN',
    PinEntryMode.remove => 'Remove PIN',
    PinEntryMode.unlock => 'Enter PIN',
  };

  String get _prompt => switch ((widget.mode, _phase)) {
    (PinEntryMode.setup, 'enter') => 'Enter a 6-digit PIN',
    (PinEntryMode.setup, _) => 'Confirm your PIN',
    (PinEntryMode.change, 'verify') => 'Enter your current PIN',
    (PinEntryMode.change, 'enter') => 'Enter your new PIN',
    (PinEntryMode.change, _) => 'Confirm your new PIN',
    (PinEntryMode.remove, _) => 'Enter your current PIN to remove it',
    (PinEntryMode.unlock, _) => 'Enter your PIN',
  };

  void _onDigit(String digit) {
    if (_pin.length >= 6 || _loading) return;
    setState(() {
      _pin += digit;
      _errorMessage = null;
    });
    if (_pin.length == 6) _onPinComplete();
  }

  void _onDelete() {
    if (_pin.isEmpty || _loading) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _onPinComplete() async {
    final service = ref.read(securityServiceProvider);
    setState(() => _loading = true);
    try {
      switch ((widget.mode, _phase)) {
        case (PinEntryMode.setup, 'enter'):
          _firstPin = _pin;
          setState(() {
            _pin = '';
            _phase = 'confirm';
          });
        case (PinEntryMode.setup, _):
          if (_pin == _firstPin) {
            await service.setPin(_pin);
            if (mounted) Navigator.of(context).pop(true);
          } else {
            setState(() {
              _pin = '';
              _firstPin = null;
              _phase = 'enter';
              _errorMessage = 'PINs did not match. Try again.';
            });
          }
        case (PinEntryMode.change, 'verify'):
          final valid = await service.verifyPin(_pin);
          if (valid) {
            setState(() {
              _pin = '';
              _phase = 'enter';
            });
          } else {
            setState(() {
              _pin = '';
              _errorMessage = 'Incorrect PIN';
            });
          }
        case (PinEntryMode.change, 'enter'):
          _firstPin = _pin;
          setState(() {
            _pin = '';
            _phase = 'confirm';
          });
        case (PinEntryMode.change, _):
          if (_pin == _firstPin) {
            await service.setPin(_pin);
            if (mounted) Navigator.of(context).pop(true);
          } else {
            setState(() {
              _pin = '';
              _firstPin = null;
              _phase = 'enter';
              _errorMessage = 'PINs did not match. Try again.';
            });
          }
        case (PinEntryMode.remove, _):
          final removed = await service.removePin(_pin);
          if (mounted) Navigator.of(context).pop(removed);
        case (PinEntryMode.unlock, _):
          final valid = await service.verifyPin(_pin);
          if (valid) {
            if (mounted) Navigator.of(context).pop(true);
          } else {
            setState(() {
              _pin = '';
              _errorMessage = 'Incorrect PIN';
            });
          }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(_title)),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_prompt, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 24),
        // PIN dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            6,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _pin.length
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ],
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: CircularProgressIndicator(),
          ),
        const SizedBox(height: 32),
        _buildNumpad(),
      ],
    ),
  );

  Widget _buildNumpad() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      children: [
        for (final row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', 'del'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row
                .map(
                  (key) => SizedBox(
                    width: 80,
                    height: 60,
                    child: key.isEmpty
                        ? const SizedBox()
                        : key == 'del'
                        ? IconButton(
                            icon: const Icon(Icons.backspace_outlined),
                            onPressed: _onDelete,
                          )
                        : TextButton(
                            onPressed: () => _onDigit(key),
                            child: Text(
                              key,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                  ),
                )
                .toList(),
          ),
      ],
    ),
  );
}
