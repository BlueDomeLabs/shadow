// lib/domain/entities/journal_entry.dart
// JournalEntry entity per 22_API_CONTRACTS.md Section 10.16

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

/// JournalEntry entity for user journal notes.
///
/// Per 22_API_CONTRACTS.md Section 10.16:
/// - timestamp: Epoch milliseconds
/// - mood: Optional 1-10 rating
/// - tags: Optional list of tags
/// - audioUrl: Optional audio attachment URL
@Freezed(toJson: true, fromJson: true)
class JournalEntry with _$JournalEntry implements Syncable {
  const JournalEntry._();

  @JsonSerializable(explicitToJson: true)
  const factory JournalEntry({
    required String id,
    required String clientId,
    required String profileId,
    required int timestamp, // Epoch milliseconds
    required String content,
    String? title,
    int? mood, // Mood rating 1-10, optional
    List<String>? tags,
    String? audioUrl,
    required SyncMetadata syncMetadata,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  /// Whether the entry has a mood rating.
  bool get hasMood => mood != null;

  /// Whether the entry has audio attached.
  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  /// Whether the entry has any tags.
  bool get hasTags => tags != null && tags!.isNotEmpty;
}
