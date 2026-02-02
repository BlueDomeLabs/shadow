# Shadow Code Review Checklist

**Version:** 1.0
**Last Updated:** January 30, 2026
**Purpose:** Standardized review criteria for all pull requests

---

## Overview

Every pull request MUST be reviewed against this checklist. Reviewers should copy this checklist into their review and check off each item. Any unchecked item blocks merge.

---

## 1. Quick Reference Checklist

Copy this into your PR review:

```markdown
## Code Review Checklist

### API Contracts
- [ ] Methods return `Result<T, AppError>` (not throwing)
- [ ] Error codes use defined constants (e.g., `DatabaseError.codeNotFound`)
- [ ] Use case checks authorization first
- [ ] Use case validates input before repository calls
- [ ] Repository interface matches 22_API_CONTRACTS.md

### ProfileId Filtering (MANDATORY)
- [ ] ALL repository methods returning lists include `profileId` parameter
- [ ] Data source WHERE clause includes `profile_id = ?`
- [ ] Data source WHERE clause includes `sync_deleted_at IS NULL`
- [ ] UseCase checks authorization: `authService.canRead(profileId)`
- [ ] SQL validates profile ownership (JOIN profiles WHERE owner_id = ?)
- [ ] No methods return data from all profiles without admin role

### Code Quality
- [ ] No `print()` statements (use logger)
- [ ] No hardcoded strings (use l10n)
- [ ] No hardcoded colors (use AppColors)
- [ ] No magic numbers (use named constants)
- [ ] No duplicate code (extract to shared utility)
- [ ] No unused imports or variables
- [ ] No TODO comments without ticket reference (format: `// TODO(SHADOW-123): description`)

### Specification Compliance
- [ ] Form fields match 38_UI_FIELD_SPECIFICATIONS.md
- [ ] Entity fields match 22_API_CONTRACTS.md
- [ ] Validation uses ValidationRules constants (never hardcoded values)
- [ ] All validators return user-friendly messages (ValidationMessages class)
- [ ] Entity includes clientId field for database merging
- [ ] SyncMetadata included in all syncable entities
- [ ] Default values match spec
- [ ] ProfileId filtering applied to ALL data queries (where applicable)
- [ ] Boundary tests exist for numeric validations

### Testing
- [ ] Unit tests for new/changed logic
- [ ] Contract tests for interface changes
- [ ] Widget tests for UI changes
- [ ] Edge cases covered (empty, null, error)
- [ ] Test names describe behavior, not implementation
- [ ] Security tests for auth/encryption (if applicable)

### Accessibility
- [ ] Semantic labels on interactive elements (see list below)
- [ ] Touch targets >= 48x48 dp
- [ ] Focus order is logical (FocusTraversalGroup)
- [ ] State changes announced (loading, error)
- [ ] No color-only information (icons + text)

**Elements REQUIRING semantic labels:**
- Buttons, IconButtons, FABs
- TextFields, Dropdowns, Switches, Checkboxes
- Tappable cards/list items (onTap)
- Custom GestureDetectors

**Elements NOT requiring labels (decorative):**
- Dividers, background images
- Icons inside labeled buttons

### Performance
- [ ] Lists use `ListView.builder` (not `ListView(children:)`)
- [ ] itemBuilder creates const widgets where possible
- [ ] No expensive computations in build()
- [ ] Images specify cacheWidth/cacheHeight
- [ ] Database queries use indexes on filtered columns
- [ ] No N+1 queries in loops
- [ ] Large result sets (50+ items) paginated
- [ ] Providers scoped appropriately (no unnecessary rebuilds)

### Security
- [ ] No PII in logs (use masking functions)
- [ ] Inputs validated/sanitized
- [ ] No hardcoded secrets or tokens
- [ ] Authorization checked before data access
- [ ] SQL includes profile ownership validation

### Documentation
- [ ] File header comment present (per Section 14.2)
- [ ] Public APIs have Dartdoc
- [ ] Complex logic has comments
- [ ] Breaking changes documented in PR

### Generated Code
- [ ] `build_runner` was run
- [ ] Generated files are committed
- [ ] Freezed entities have correct annotations
```

---

## 2. Detailed Review Criteria

### 2.1 API Contract Compliance

#### Result Type Usage

**CORRECT:**
```dart
// Method naming: getAll{Entity}s with required profileId
Future<Result<List<Supplement>, AppError>> getAllSupplements({
  required String profileId,
}) async {
  try {
    final data = await _datasource.query(profileId);
    return Success(data);
  } on DatabaseException catch (e, stack) {
    return Failure(DatabaseError.queryFailed(e.message, e, stack));
  }
}
```

**WRONG:**
```dart
// REJECT: Returns nullable instead of Result
Future<List<Supplement>?> getAllSupplements({required String profileId}) async {
  try {
    return await _datasource.query(profileId);
  } catch (e) {
    return null;  // Error information lost!
  }
}

// REJECT: Throws instead of returning Failure
Future<Result<Supplement?, AppError>> getById(String id) async {
  final data = await _datasource.find(id);
  if (data == null) {
    throw NotFoundException(id);  // Should return Failure(NotFound)
  }
  return Success(data);
}
```

#### Error Code Constants

**CORRECT:**
```dart
return Failure(DatabaseError._(
  code: DatabaseError.codeNotFound,  // Uses constant
  message: 'Supplement $id not found',
  userMessage: 'The supplement could not be found.',
));
```

**WRONG:**
```dart
return Failure(DatabaseError._(
  code: 'NOT_FOUND',  // REJECT: Hardcoded string
  message: 'Supplement $id not found',
  userMessage: 'The supplement could not be found.',
));
```

#### Use Case Authorization

**CORRECT:**
```dart
@override
Future<Result<List<Supplement>, AppError>> call(GetSupplementsInput input) async {
  // Authorization FIRST
  if (!await _authService.canRead(input.profileId)) {
    return Failure(AuthError.profileAccessDenied(input.profileId));
  }

  // Then business logic
  return _repository.getByProfile(input.profileId);
}
```

**WRONG:**
```dart
@override
Future<Result<List<Supplement>, AppError>> call(GetSupplementsInput input) async {
  // REJECT: No authorization check!
  return _repository.getByProfile(input.profileId);
}
```

#### ProfileId Filtering (MANDATORY)

Every data access method MUST filter by profileId and validate ownership.

**CORRECT - Repository:**
```dart
Future<Result<List<Supplement>, AppError>> getAllSupplements({
  required String profileId,  // REQUIRED parameter
}) async {
  try {
    final data = await _datasource.getAllSupplements(profileId: profileId);
    return Success(data);
  } catch (e, stack) {
    return Failure(DatabaseError.queryFailed(e.toString(), stack));
  }
}
```

**WRONG - Repository:**
```dart
// REJECT: profileId is optional
Future<Result<List<Supplement>, AppError>> getAllSupplements({
  String? profileId,  // Should be required!
}) async { ... }

// REJECT: No profileId parameter at all
Future<Result<List<Supplement>, AppError>> getAllSupplements() async { ... }
```

**CORRECT - Data Source SQL:**
```dart
Future<List<Supplement>> getAllSupplements({
  required String profileId,
  required String userId,  // Current authenticated user
}) async {
  final result = await db.rawQuery('''
    SELECT s.* FROM supplements s
    INNER JOIN profiles p ON s.profile_id = p.id
    WHERE s.profile_id = ?
      AND s.sync_deleted_at IS NULL      -- Filter soft deletes
      AND (p.owner_id = ?                 -- User owns profile
           OR EXISTS (                    -- OR has authorization
             SELECT 1 FROM hipaa_authorizations h
             WHERE h.profile_id = p.id
               AND h.granted_to_user_id = ?
               AND h.revoked_at IS NULL
           ))
    ORDER BY s.sync_created_at DESC
  ''', [profileId, userId, userId]);

  return result.map((map) => SupplementModel.fromMap(map).toEntity()).toList();
}
```

**WRONG - Data Source SQL:**
```dart
// REJECT: No profile ownership validation
Future<List<Supplement>> getAllSupplements({
  required String profileId,
}) async {
  final result = await db.query(
    'supplements',
    where: 'profile_id = ?',  // Missing ownership check!
    whereArgs: [profileId],
  );
  return result.map((map) => SupplementModel.fromMap(map).toEntity()).toList();
}
```

**Methods that MUST filter by profileId:**
- `getAll{Entity}s()`
- `search{Entity}s()`
- `get{Entity}sForDate()`
- `get{Entity}sInRange()`
- Any method returning `List<T>`

#### Specification Compliance

Every form and entity implementation MUST match the specification documents.

**UI Field Compliance (38_UI_FIELD_SPECIFICATIONS.md):**
```dart
// CORRECT: All fields from spec present with correct validation
class AddSupplementScreen extends ConsumerWidget {
  // Check these match spec:
  // - Field names and labels
  // - Required vs optional
  // - Validation rules and messages
  // - Default values
  // - Max lengths
  // - Semantic labels
}
```

**Entity Compliance (22_API_CONTRACTS.md):**
```dart
// CORRECT: Entity matches contract exactly
@freezed
class Supplement with _$Supplement {
  const factory Supplement({
    required String id,
    required String clientId,      // Must match contract
    required String profileId,
    required String name,          // Required in contract
    String? brand,                 // Optional in contract
    @Default([]) List<SupplementIngredient> ingredients,
    required SyncMetadata syncMetadata,
  }) = _Supplement;
}
```

**Review Checklist for Spec Compliance:**
- [ ] All required fields from spec are present in form
- [ ] Field labels exactly match spec (for localization consistency)
- [ ] Validation rules match spec (min length, max length, format)
- [ ] Default values match spec
- [ ] Error messages match spec validation messages
- [ ] Entity fields match 22_API_CONTRACTS.md exactly
- [ ] Semantic labels match 38_UI_FIELD_SPECIFICATIONS.md Section 16

---

### 2.2 Code Quality

#### Logging

**CORRECT:**
```dart
class SupplementProvider extends _$SupplementProvider {
  static final _log = logger.scope('SupplementProvider');

  Future<void> addSupplement(Supplement supplement) async {
    _log.info('Adding supplement: ${supplement.name}');
    // ...
    _log.error('Failed to add supplement', error, stackTrace);
  }
}
```

**WRONG:**
```dart
Future<void> addSupplement(Supplement supplement) async {
  print('Adding supplement: ${supplement.name}');  // REJECT: Use logger
  // ...
  print('Error: $error');  // REJECT: No structured logging
}
```

#### Localization

**CORRECT:**
```dart
Text(l10n.supplementName)  // Uses localization

// With interpolation
Text(l10n.itemCount(supplements.length))
```

**WRONG:**
```dart
Text('Supplement Name')  // REJECT: Hardcoded string
Text('${supplements.length} items')  // REJECT: Not localized
```

#### Colors

**CORRECT:**
```dart
Container(
  color: AppColors.supplements,  // Uses theme color
)
```

**WRONG:**
```dart
Container(
  color: Color(0xFF6B705C),  // REJECT: Hardcoded color
  // or
  color: Colors.green,  // REJECT: Not using AppColors
)
```

#### Magic Numbers

**CORRECT:**
```dart
if (temperature < ValidationRules.bbtMinFahrenheit ||
    temperature > ValidationRules.bbtMaxFahrenheit) {
  // ...
}
```

**WRONG:**
```dart
if (temperature < 95.0 || temperature > 105.0) {  // REJECT: Magic numbers
  // ...
}
```

---

### 2.3 Testing

#### Unit Test Structure

**CORRECT:**
```dart
group('LogFluidsEntryUseCase', () {
  group('when user is not authorized', () {
    test('returns AuthError.profileAccessDenied', () async {
      // Arrange
      when(authService.canWrite(any)).thenAnswer((_) async => false);

      // Act
      final result = await useCase(input);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<AuthError>());
      expect((result.errorOrNull as AuthError).code,
          equals(AuthError.codeProfileAccessDenied));
    });
  });

  group('when BBT is out of range', () {
    test('returns ValidationError with field error', () async {
      // Arrange
      when(authService.canWrite(any)).thenAnswer((_) async => true);
      final invalidInput = input.copyWith(basalBodyTemperature: 110.0);

      // Act
      final result = await useCase(invalidInput);

      // Assert
      expect(result.isFailure, isTrue);
      expect(result.errorOrNull, isA<ValidationError>());
      expect((result.errorOrNull as ValidationError).fieldErrors,
          containsPair('basalBodyTemperature', isNotEmpty));
    });
  });
});
```

**WRONG:**
```dart
test('test1', () async {  // REJECT: Non-descriptive name
  final result = await useCase(input);
  expect(result.isSuccess, isTrue);  // REJECT: No arrange, minimal assert
});
```

#### Edge Cases Required

| Scenario | Must Test |
|----------|-----------|
| Empty input | Empty list returns `Success([])`, not null or error |
| Not found | Returns `Failure(DatabaseError.notFound)` |
| Unauthorized | Returns `Failure(AuthError.profileAccessDenied)` |
| Validation failure | Returns `Failure(ValidationError)` with field details |
| Database error | Returns `Failure(DatabaseError)` with context |

---

### 2.4 Accessibility

#### Semantic Labels

**CORRECT:**
```dart
ShadowButton(
  variant: ButtonVariant.icon,
  icon: Icons.delete,
  label: 'Delete ${supplement.name}',  // Specific, descriptive
  hint: 'Removes this supplement from your list',
  onPressed: () => delete(supplement),
)
```

**WRONG:**
```dart
IconButton(
  icon: Icon(Icons.delete),  // REJECT: No semantic label
  onPressed: () => delete(supplement),
)

ShadowButton(
  label: 'Delete',  // REJECT: Not specific enough for screen reader
  onPressed: () => delete(supplement),
)
```

#### Touch Targets

**CORRECT:**
```dart
GestureDetector(
  child: Container(
    width: 48,  // Minimum 48x48
    height: 48,
    child: Icon(Icons.close, size: 24),  // Icon can be smaller
  ),
  onTap: () => close(),
)
```

**WRONG:**
```dart
GestureDetector(
  child: Icon(Icons.close, size: 24),  // REJECT: Touch target only 24x24
  onTap: () => close(),
)
```

---

### 2.5 Performance

#### Database Queries

**CORRECT:**
```dart
// Single query with join
Future<Result<List<SupplementWithIntakes>, AppError>> getSupplementsWithIntakes(
  String profileId,
  DateTime date,
) async {
  final results = await db.customSelect('''
    SELECT s.*, i.* FROM supplements s
    LEFT JOIN intake_logs i ON s.id = i.supplement_id
    WHERE s.profile_id = ? AND i.logged_at >= ? AND i.logged_at < ?
  ''', variables: [profileId, date, date.add(Duration(days: 1))]).get();

  return Success(_mapToSupplementsWithIntakes(results));
}
```

**WRONG:**
```dart
// REJECT: N+1 queries
Future<Result<List<SupplementWithIntakes>, AppError>> getSupplementsWithIntakes(
  String profileId,
  DateTime date,
) async {
  final supplements = await _supplementRepo.getAllSupplements(profileId: profileId);

  for (final supplement in supplements.valueOrNull ?? []) {
    // REJECT: Query per supplement!
    final intakes = await _intakeRepo.getForSupplement(supplement.id, date);
    // ...
  }
}
```

#### Build Method

**CORRECT:**
```dart
class _MyWidgetState extends State<MyWidget> {
  late final List<Supplement> _sortedSupplements;

  @override
  void initState() {
    super.initState();
    _sortedSupplements = _sortSupplements(widget.supplements);  // Computed once
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _sortedSupplements.length,
      itemBuilder: (context, index) => SupplementTile(_sortedSupplements[index]),
    );
  }
}
```

**WRONG:**
```dart
@override
Widget build(BuildContext context) {
  // REJECT: Sorting on every rebuild!
  final sorted = widget.supplements.toList()..sort((a, b) => a.name.compareTo(b.name));

  return ListView.builder(
    itemCount: sorted.length,
    itemBuilder: (context, index) => SupplementTile(sorted[index]),
  );
}
```

---

### 2.6 Security

#### No PII in Logs

**CORRECT:**
```dart
_log.info('User logged in', {'userId': user.id.hashCode});  // Hashed ID
_log.info('Profile accessed', {'profileId': profileId});    // Non-PII identifier
```

**WRONG:**
```dart
_log.info('User logged in: ${user.email}');  // REJECT: PII in logs
_log.info('BBT recorded: ${entry.temperature}');  // REJECT: Health data in logs
```

#### Input Validation

**CORRECT:**
```dart
Future<Result<FluidsEntry, AppError>> call(LogFluidsEntryInput input) async {
  // Validate ALL inputs before any processing
  final validationError = _validate(input);
  if (validationError != null) {
    return Failure(validationError);
  }

  // Sanitize text inputs
  final sanitizedNotes = _sanitize(input.notes);

  // ...
}

String _sanitize(String? input) {
  if (input == null) return '';
  // Remove potential script injections, trim whitespace
  return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}
```

**WRONG:**
```dart
Future<Result<FluidsEntry, AppError>> call(LogFluidsEntryInput input) async {
  // REJECT: No validation, raw input used directly
  final entry = FluidsEntry(
    notes: input.notes,  // Could contain malicious content
    // ...
  );
  return _repository.create(entry);
}
```

---

## 3. Review Process

### 3.1 Review Steps

```
1. Check PR description
   └── Does it explain what and why?

2. Check linked ticket
   └── Does implementation match requirements?

3. Run tests locally
   └── flutter test

4. Check generated files
   └── Are freezed/drift files up to date?

5. Review code against checklist
   └── Go through each section

6. Test on device (if UI change)
   └── Verify accessibility, performance

7. Leave actionable feedback
   └── Specific, with examples

8. Approve only when ALL criteria met
```

### 3.2 Review Comments

**GOOD comment:**
```markdown
This repository method throws an exception instead of returning a Failure.

Per 22_API_CONTRACTS.md section 3.1, all repository methods must return
`Future<Result<T, AppError>>`.

Suggested fix:
```dart
} on DatabaseException catch (e, stack) {
  return Failure(DatabaseError.queryFailed(e.message, e, stack));
}
```
```

**BAD comment:**
```markdown
This is wrong.  // No explanation, not actionable
```

### 3.3 Blocking vs Non-blocking

| Blocking (Must Fix) | Non-blocking (Suggestion) |
|---------------------|---------------------------|
| API contract violation | Alternative implementation |
| Missing tests for new code | Additional test suggestions |
| Security issue | Performance optimization |
| Accessibility failure | Code style preference |
| Hardcoded strings/colors | Documentation improvement |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
