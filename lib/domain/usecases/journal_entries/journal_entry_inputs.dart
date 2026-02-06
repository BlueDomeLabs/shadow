// lib/domain/usecases/journal_entries/journal_entry_inputs.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'journal_entry_inputs.freezed.dart';

@freezed
class CreateJournalEntryInput with _$CreateJournalEntryInput {
  const factory CreateJournalEntryInput({
    required String profileId,
    required String clientId,
    required int timestamp, // Epoch milliseconds
    required String content,
    String? title,
    int? mood, // 1-10 rating
    @Default([]) List<String> tags,
    String? audioUrl,
  }) = _CreateJournalEntryInput;
}

@freezed
class GetJournalEntriesInput with _$GetJournalEntriesInput {
  const factory GetJournalEntriesInput({
    required String profileId,
    int? startDate, // Epoch milliseconds
    int? endDate, // Epoch milliseconds
    List<String>? tags,
    int? mood,
    int? limit,
    int? offset,
  }) = _GetJournalEntriesInput;
}

@freezed
class SearchJournalEntriesInput with _$SearchJournalEntriesInput {
  const factory SearchJournalEntriesInput({
    required String profileId,
    required String query,
  }) = _SearchJournalEntriesInput;
}

@freezed
class UpdateJournalEntryInput with _$UpdateJournalEntryInput {
  const factory UpdateJournalEntryInput({
    required String id,
    required String profileId,
    String? content,
    String? title,
    int? mood,
    List<String>? tags,
    String? audioUrl,
  }) = _UpdateJournalEntryInput;
}

@freezed
class DeleteJournalEntryInput with _$DeleteJournalEntryInput {
  const factory DeleteJournalEntryInput({
    required String id,
    required String profileId,
  }) = _DeleteJournalEntryInput;
}
