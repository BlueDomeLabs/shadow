// lib/presentation/providers/profile/profile_provider.dart
// Lightweight profile management for UI layer.
// Uses SharedPreferences for persistence until full Profile domain entity exists.

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _profilesKey = 'shadow_profiles';
const _currentProfileIdKey = 'shadow_current_profile_id';
const _uuid = Uuid();

/// Lightweight profile model for UI layer.
class Profile {
  final String id;
  final String name;
  final DateTime? dateOfBirth;
  final String notes;
  final DateTime createdAt;

  const Profile({
    required this.id,
    required this.name,
    this.dateOfBirth,
    this.notes = '',
    required this.createdAt,
  });

  Profile copyWith({String? name, DateTime? dateOfBirth, String? notes}) =>
      Profile(
        id: id,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
    'notes': notes,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String,
    name: json['name'] as String,
    dateOfBirth: json['dateOfBirth'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['dateOfBirth'] as int)
        : null,
    notes: (json['notes'] as String?) ?? '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
  );
}

/// State holding all profiles and the current profile selection.
class ProfileState {
  final List<Profile> profiles;
  final String? currentProfileId;

  const ProfileState({this.profiles = const [], this.currentProfileId});

  Profile? get currentProfile {
    if (currentProfileId == null) return null;
    final matches = profiles.where((p) => p.id == currentProfileId);
    return matches.isEmpty ? null : matches.first;
  }
}

/// Notifier managing profile CRUD and persistence via SharedPreferences.
class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_profilesKey);
    final currentId = prefs.getString(_currentProfileIdKey);

    if (jsonStr != null) {
      final list = (jsonDecode(jsonStr) as List)
          .map((e) => Profile.fromJson(e as Map<String, dynamic>))
          .toList();
      state = ProfileState(profiles: list, currentProfileId: currentId);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.profiles.map((p) => p.toJson()).toList());
    await prefs.setString(_profilesKey, jsonStr);
    if (state.currentProfileId != null) {
      await prefs.setString(_currentProfileIdKey, state.currentProfileId!);
    } else {
      await prefs.remove(_currentProfileIdKey);
    }
  }

  Future<void> addProfile(Profile profile) async {
    final newProfile = Profile(
      id: _uuid.v4(),
      name: profile.name,
      dateOfBirth: profile.dateOfBirth,
      notes: profile.notes,
      createdAt: DateTime.now(),
    );
    final updated = [...state.profiles, newProfile];
    // Auto-select if first profile
    final currentId = state.currentProfileId ?? newProfile.id;
    state = ProfileState(profiles: updated, currentProfileId: currentId);
    await _save();
  }

  Future<void> updateProfile(Profile profile) async {
    final updated = state.profiles
        .map((p) => p.id == profile.id ? profile : p)
        .toList();
    state = ProfileState(
      profiles: updated,
      currentProfileId: state.currentProfileId,
    );
    await _save();
  }

  Future<void> deleteProfile(String id) async {
    final updated = state.profiles.where((p) => p.id != id).toList();
    var currentId = state.currentProfileId;
    if (currentId == id) {
      currentId = updated.isNotEmpty ? updated.first.id : null;
    }
    state = ProfileState(profiles: updated, currentProfileId: currentId);
    await _save();
  }

  void setCurrentProfile(String id) {
    state = ProfileState(profiles: state.profiles, currentProfileId: id);
    _save();
  }
}

/// Provider for profile state management.
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(),
);
