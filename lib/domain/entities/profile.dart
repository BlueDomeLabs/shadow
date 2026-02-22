// lib/domain/entities/profile.dart - EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md Section 10.7

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/enums/health_enums.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// Profile is the root entity for user health data.
/// NOTE: Profile does not have a profileId field because it IS the profile.
/// Child entities reference this entity via their profileId foreign key.
/// The ownerId field links to user_accounts for multi-profile support.
@Freezed(toJson: true, fromJson: true)
class Profile with _$Profile implements Syncable {
  const Profile._();

  @JsonSerializable(explicitToJson: true)
  const factory Profile({
    required String id, // This IS the profileId for child entities
    required String clientId,
    required String name,
    int? birthDate, // Epoch milliseconds
    BiologicalSex? biologicalSex,

    /// Fully optional, self-reported, for the user's own records only.
    /// Never required, never used in logic or calculations.
    String? ethnicity,
    String? notes,
    String? ownerId, // FK to user_accounts
    /// Simple diet label for display purposes.
    /// For compliance tracking, create a Diet entity instead.
    @Default(ProfileDietType.none) ProfileDietType dietType,
    String? dietDescription, // Custom description when dietType=other
    required SyncMetadata syncMetadata,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  /// Profile IS the profile — its id serves as the profileId for Syncable.
  @override
  String get profileId => id;

  int? get ageYears {
    if (birthDate == null) return null;
    final birth = DateTime.fromMillisecondsSinceEpoch(birthDate!);
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }
}
