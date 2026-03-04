// lib/presentation/providers/profile/profile_provider.dart
// Profile state management via domain use cases and Drift/SQLCipher.
// AUDIT-01-006: Profile data now goes through ProfileRepository, not SharedPreferences.
// currentProfileId (a UUID string) remains in SharedPreferences — device preference only.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/domain/entities/profile.dart';
import 'package:shadow_app/domain/usecases/profiles/create_profile_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/delete_profile_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/get_profiles_use_case.dart';
import 'package:shadow_app/domain/usecases/profiles/profile_inputs.dart';
import 'package:shadow_app/domain/usecases/profiles/update_profile_use_case.dart';
import 'package:shadow_app/presentation/providers/di/di_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _currentProfileIdKey = 'shadow_current_profile_id';

/// State holding all profiles and the current profile selection.
class ProfileState {
  final List<Profile> profiles;
  final String? currentProfileId;
  final bool isLoading;
  final AppError? error;

  const ProfileState({
    this.profiles = const [],
    this.currentProfileId,
    this.isLoading = false,
    this.error,
  });

  Profile? get currentProfile {
    if (currentProfileId == null) return null;
    final matches = profiles.where((p) => p.id == currentProfileId);
    return matches.isEmpty ? null : matches.first;
  }

  ProfileState copyWith({
    List<Profile>? profiles,
    String? currentProfileId,
    bool? isLoading,
    AppError? error,
    bool clearError = false,
    bool clearCurrentProfileId = false,
  }) => ProfileState(
    profiles: profiles ?? this.profiles,
    currentProfileId: clearCurrentProfileId
        ? null
        : currentProfileId ?? this.currentProfileId,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}

/// Notifier managing profile CRUD via domain use cases and Drift/SQLCipher.
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfilesUseCase _getProfiles;
  final CreateProfileUseCase _create;
  final UpdateProfileUseCase _update;
  final DeleteProfileUseCase _delete;

  ProfileNotifier({
    required GetProfilesUseCase getProfiles,
    required CreateProfileUseCase create,
    required UpdateProfileUseCase update,
    required DeleteProfileUseCase delete,
  }) : _getProfiles = getProfiles,
       _create = create,
       _update = update,
       _delete = delete,
       super(const ProfileState(isLoading: true)) {
    _load();
  }

  /// For use in widget tests only — creates a notifier with a preset state
  /// without triggering async loading or requiring real use cases.
  @visibleForTesting
  ProfileNotifier.forTesting(super.testState)
    : _getProfiles = _NoOpGetProfilesUseCase(),
      _create = _NoOpCreateProfileUseCase(),
      _update = _NoOpUpdateProfileUseCase(),
      _delete = _NoOpDeleteProfileUseCase();

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentId = prefs.getString(_currentProfileIdKey);

      final result = await _getProfiles();

      switch (result) {
        case Success(:final value):
          state = ProfileState(profiles: value, currentProfileId: currentId);
        case Failure(:final error):
          debugPrint('[Shadow Profile] _load FAILED: $error');
          state = ProfileState(currentProfileId: currentId, error: error);
      }
    } on Object catch (e, stack) {
      debugPrint('[Shadow Profile] _load FAILED — unexpected error: $e');
      debugPrint('[Shadow Profile] Stack trace: $stack');
      state = const ProfileState();
    }
  }

  Future<void> addProfile(CreateProfileInput input) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _create(input);
      switch (result) {
        case Success(:final value):
          final updated = [...state.profiles, value];
          final currentId = state.currentProfileId ?? value.id;
          state = ProfileState(profiles: updated, currentProfileId: currentId);
          await _saveCurrentId(currentId);
        case Failure(:final error):
          state = state.copyWith(isLoading: false, error: error);
      }
    } finally {
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> updateProfile(UpdateProfileInput input) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _update(input);
      switch (result) {
        case Success(:final value):
          final updated = state.profiles
              .map((p) => p.id == value.id ? value : p)
              .toList();
          state = state.copyWith(profiles: updated, isLoading: false);
        case Failure(:final error):
          state = state.copyWith(isLoading: false, error: error);
      }
    } finally {
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  Future<void> deleteProfile(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _delete(DeleteProfileInput(profileId: id));
      switch (result) {
        case Success():
          final updated = state.profiles.where((p) => p.id != id).toList();
          var currentId = state.currentProfileId;
          if (currentId == id) {
            currentId = updated.isNotEmpty ? updated.first.id : null;
            if (currentId != null) {
              await _saveCurrentId(currentId);
            } else {
              await _clearCurrentId();
            }
          }
          state = ProfileState(profiles: updated, currentProfileId: currentId);
        case Failure(:final error):
          state = state.copyWith(isLoading: false, error: error);
      }
    } finally {
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  void setCurrentProfile(String id) {
    state = state.copyWith(currentProfileId: id);
    _saveCurrentId(id);
  }

  Future<void> _saveCurrentId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentProfileIdKey, id);
  }

  Future<void> _clearCurrentId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentProfileIdKey);
  }
}

/// Provider for profile state management.
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    getProfiles: ref.read(getProfilesUseCaseProvider),
    create: ref.read(createProfileUseCaseProvider),
    update: ref.read(updateProfileUseCaseProvider),
    delete: ref.read(deleteProfileUseCaseProvider),
  ),
);

// =============================================================================
// No-op use case stubs — for ProfileNotifier.forTesting() ONLY
// =============================================================================

class _NoOpGetProfilesUseCase implements GetProfilesUseCase {
  @override
  Future<Result<List<Profile>, AppError>> call() async => const Success([]);
}

class _NoOpCreateProfileUseCase implements CreateProfileUseCase {
  @override
  Future<Result<Profile, AppError>> call(CreateProfileInput input) async =>
      throw UnimplementedError('_NoOpCreateProfileUseCase');
}

class _NoOpUpdateProfileUseCase implements UpdateProfileUseCase {
  @override
  Future<Result<Profile, AppError>> call(UpdateProfileInput input) async =>
      throw UnimplementedError('_NoOpUpdateProfileUseCase');
}

class _NoOpDeleteProfileUseCase implements DeleteProfileUseCase {
  @override
  Future<Result<void, AppError>> call(DeleteProfileInput input) async =>
      throw UnimplementedError('_NoOpDeleteProfileUseCase');
}

// =============================================================================
// Helpers
// =============================================================================

// Expose Uuid for use cases that need a clientId at the call site.
const _uuid = Uuid();

/// Helper: generate a new client ID for profile creation.
String generateProfileClientId() => _uuid.v4();
