// lib/domain/usecases/journal_entries/create_journal_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/entities/sync_metadata.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';
import 'package:uuid/uuid.dart';

/// Use case to create a new journal entry.
class CreateJournalEntryUseCase
    implements UseCase<CreateJournalEntryInput, JournalEntry> {
  final JournalEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  CreateJournalEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<JournalEntry, AppError>> call(
    CreateJournalEntryInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Validation
    final validationResult = _validate(input);
    if (validationResult != null) {
      return Failure(validationResult);
    }

    // 3. Create entity
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    final entry = JournalEntry(
      id: id,
      clientId: input.clientId,
      profileId: input.profileId,
      timestamp: input.timestamp,
      content: input.content,
      title: input.title,
      mood: input.mood,
      tags: input.tags.isEmpty ? null : input.tags,
      audioUrl: input.audioUrl,
      syncMetadata: SyncMetadata(
        syncCreatedAt: now,
        syncUpdatedAt: now,
        syncDeviceId: '', // Will be populated by repository
      ),
    );

    // 4. Persist
    return _repository.create(entry);
  }

  ValidationError? _validate(CreateJournalEntryInput input) {
    final errors = <String, List<String>>{};

    // Content validation
    final contentError = ValidationRules.journalContent(input.content);
    if (contentError != null) errors['content'] = [contentError];

    // Title validation if provided
    if (input.title != null &&
        (input.title!.isEmpty ||
            input.title!.length > ValidationRules.titleMaxLength)) {
      errors['title'] = [
        'Title must be 1-${ValidationRules.titleMaxLength} characters',
      ];
    }

    // Mood validation if provided
    if (input.mood != null &&
        (input.mood! < ValidationRules.moodMin ||
            input.mood! > ValidationRules.moodMax)) {
      errors['mood'] = [
        'Mood must be between ${ValidationRules.moodMin} and ${ValidationRules.moodMax}',
      ];
    }

    // Timestamp validation (not more than 1 hour in future)
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneHourFromNow = now + ValidationRules.maxFutureTimestampToleranceMs;
    if (input.timestamp > oneHourFromNow) {
      errors['timestamp'] = [
        'Timestamp cannot be more than 1 hour in the future',
      ];
    }

    // Tags validation
    for (final tag in input.tags) {
      if (tag.isEmpty || tag.length > ValidationRules.tagMaxLength) {
        errors['tags'] = [
          'Each tag must be 1-${ValidationRules.tagMaxLength} characters',
        ];
        break;
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
