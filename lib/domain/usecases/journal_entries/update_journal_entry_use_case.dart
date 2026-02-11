// lib/domain/usecases/journal_entries/update_journal_entry_use_case.dart
// EXACT IMPLEMENTATION FROM 22_API_CONTRACTS.md

import 'package:shadow_app/core/errors/app_error.dart';
import 'package:shadow_app/core/types/result.dart';
import 'package:shadow_app/core/validation/validation_rules.dart';
import 'package:shadow_app/domain/entities/journal_entry.dart';
import 'package:shadow_app/domain/repositories/journal_entry_repository.dart';
import 'package:shadow_app/domain/services/profile_authorization_service.dart';
import 'package:shadow_app/domain/usecases/base_use_case.dart';
import 'package:shadow_app/domain/usecases/journal_entries/journal_entry_inputs.dart';

/// Use case to update an existing journal entry.
class UpdateJournalEntryUseCase
    implements UseCase<UpdateJournalEntryInput, JournalEntry> {
  final JournalEntryRepository _repository;
  final ProfileAuthorizationService _authService;

  UpdateJournalEntryUseCase(this._repository, this._authService);

  @override
  Future<Result<JournalEntry, AppError>> call(
    UpdateJournalEntryInput input,
  ) async {
    // 1. Authorization
    if (!await _authService.canWrite(input.profileId)) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 2. Fetch existing entity
    final existingResult = await _repository.getById(input.id);
    if (existingResult.isFailure) {
      return Failure(existingResult.errorOrNull!);
    }

    final existing = existingResult.valueOrNull!;

    // Verify the entry belongs to the profile
    if (existing.profileId != input.profileId) {
      return Failure(AuthError.profileAccessDenied(input.profileId));
    }

    // 3. Apply updates
    final updated = existing.copyWith(
      content: input.content ?? existing.content,
      title: input.title ?? existing.title,
      mood: input.mood ?? existing.mood,
      tags: input.tags ?? existing.tags,
      audioUrl: input.audioUrl ?? existing.audioUrl,
    );

    // 4. Validation
    final validationError = _validate(updated);
    if (validationError != null) {
      return Failure(validationError);
    }

    // 5. Persist
    return _repository.update(updated);
  }

  ValidationError? _validate(JournalEntry entry) {
    final errors = <String, List<String>>{};

    // Content validation
    if (entry.content.length < ValidationRules.journalContentMinLength ||
        entry.content.length > ValidationRules.journalContentMaxLength) {
      errors['content'] = [
        'Content must be ${ValidationRules.journalContentMinLength}-${ValidationRules.journalContentMaxLength} characters',
      ];
    }

    // Title validation if provided
    if (entry.title != null &&
        (entry.title!.isEmpty ||
            entry.title!.length > ValidationRules.titleMaxLength)) {
      errors['title'] = [
        'Title must be 1-${ValidationRules.titleMaxLength} characters',
      ];
    }

    // Mood validation if provided
    if (entry.mood != null &&
        (entry.mood! < ValidationRules.moodMin ||
            entry.mood! > ValidationRules.moodMax)) {
      errors['mood'] = [
        'Mood must be between ${ValidationRules.moodMin} and ${ValidationRules.moodMax}',
      ];
    }

    // Tags validation
    if (entry.tags != null) {
      for (final tag in entry.tags!) {
        if (tag.isEmpty || tag.length > ValidationRules.tagMaxLength) {
          errors['tags'] = [
            'Each tag must be 1-${ValidationRules.tagMaxLength} characters',
          ];
          break;
        }
      }
    }

    if (errors.isNotEmpty) {
      return ValidationError.fromFieldErrors(errors);
    }
    return null;
  }
}
