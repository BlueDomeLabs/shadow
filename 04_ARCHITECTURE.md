# Shadow Technical Architecture

**Version:** 1.0
**Last Updated:** January 30, 2026

---

## Overview

Shadow implements Clean Architecture with a clear separation between Presentation, Domain, and Data layers. This document details the technical architecture, design patterns, and component organization.

---

## 1. Architecture Overview

### 1.1 Layer Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                      PRESENTATION LAYER                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                  │
│  │   Screens   │  │   Widgets   │  │  Providers  │                  │
│  │  (31+ UI)   │  │ (Reusable)  │  │   (State)   │                  │
│  └─────────────┘  └─────────────┘  └─────────────┘                  │
├─────────────────────────────────────────────────────────────────────┤
│                        DOMAIN LAYER                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                  │
│  │  Entities   │  │ Repository  │  │  Use Cases  │                  │
│  │    (23)     │  │ Interfaces  │  │    (18)     │                  │
│  └─────────────┘  └─────────────┘  └─────────────┘                  │
├─────────────────────────────────────────────────────────────────────┤
│                         DATA LAYER                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                  │
│  │ Repository  │  │   Models    │  │   Cloud     │                  │
│  │   Impls     │  │             │  │ Providers   │                  │
│  └─────────────┘  └─────────────┘  └─────────────┘                  │
│         │                                   │                        │
│  ┌─────────────┐                    ┌─────────────┐                  │
│  │   Local     │                    │   Remote    │                  │
│  │ DataSources │                    │ DataSources │                  │
│  └─────────────┘                    └─────────────┘                  │
│         │                                   │                        │
│  ┌─────────────┐                    ┌─────────────┐                  │
│  │   SQLite    │                    │Cloud APIs   │                  │
│  │  (SQLCipher)│                    │(GDrive/     │                  │
│  │             │                    │ iCloud)     │                  │
│  └─────────────┘                    └─────────────┘                  │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.2 Dependency Rules

```
Presentation ──depends on──► Domain
Domain ◄──implements── Data
```

- **Presentation Layer** depends only on Domain Layer interfaces
- **Domain Layer** has NO dependencies (pure business logic)
- **Data Layer** implements Domain interfaces

---

## 2. Project Structure

```
lib/
├── main.dart                    # App entry point
├── injection_container.dart     # Dependency injection setup
│
├── core/                        # Cross-cutting concerns
│   ├── config/                  # Configuration classes
│   │   ├── app_constants.dart
│   │   └── google_oauth_config.dart
│   ├── errors/                  # Exception definitions
│   │   └── exceptions.dart
│   ├── services/                # Shared services
│   │   ├── logger_service.dart
│   │   ├── encryption_service.dart
│   │   ├── device_info_service.dart
│   │   ├── audit_log_service.dart
│   │   ├── oauth_proxy_service.dart
│   │   └── diet_compliance_service.dart
│   ├── repositories/            # Base repository classes
│   │   └── base_repository.dart
│   ├── authorization/           # Access control
│   │   └── profile_authorization_service.dart
│   └── utils/                   # Utilities
│       ├── validators.dart
│       └── generators/          # Sample data generators
│
├── domain/                      # Business logic layer
│   ├── entities/                # Domain models (25 entities)
│   │   ├── profile.dart
│   │   ├── condition.dart
│   │   ├── supplement.dart
│   │   ├── diet.dart
│   │   ├── diet_rule.dart
│   │   ├── diet_violation.dart
│   │   └── ... (19 more)
│   ├── repositories/            # Repository interfaces (18)
│   │   ├── profile_repository.dart
│   │   ├── condition_repository.dart
│   │   └── ...
│   ├── sync/                    # Sync infrastructure
│   │   └── sync_metadata.dart
│   └── cloud/                   # Cloud interfaces
│       └── cloud_storage_provider.dart
│
├── data/                        # Data access layer
│   ├── repositories/            # Repository implementations
│   │   ├── profile_repository_impl.dart
│   │   └── ...
│   ├── datasources/
│   │   ├── local/               # SQLite datasources (19)
│   │   │   ├── database_helper.dart
│   │   │   ├── profile_local_datasource.dart
│   │   │   └── ...
│   │   └── remote/              # API datasources (future)
│   ├── models/                  # Data transfer objects
│   │   ├── profile_model.dart
│   │   └── ...
│   ├── cloud/                   # Cloud implementations
│   │   ├── google_drive_provider.dart
│   │   ├── icloud_provider.dart
│   │   ├── macos_google_oauth.dart
│   │   └── cloud_provider_factory.dart
│   ├── photo/                   # Photo processing
│   │   └── photo_processing_service.dart
│   └── services/                # Data services
│       └── sync_service.dart
│
├── presentation/                # UI layer
│   ├── screens/                 # Full-page screens (31+)
│   │   ├── home_screen.dart
│   │   ├── tabs/                # Tab screens
│   │   │   ├── home_tab.dart
│   │   │   ├── conditions_tab.dart
│   │   │   └── ...
│   │   └── ...
│   ├── widgets/                 # Reusable components
│   │   ├── accessible_widgets.dart
│   │   ├── common_dialogs.dart
│   │   └── ...
│   ├── providers/               # State management (13)
│   │   ├── profile_provider.dart
│   │   ├── condition_provider.dart
│   │   └── ...
│   └── theme/                   # Theme configuration
│       └── app_theme.dart
│
└── l10n/                        # Localization
    ├── app_en.arb
    ├── app_es.arb
    └── ...
```

---

## 3. Domain Layer Details

### 3.1 Entities (22 Total)

```
Core Entities:
├── UserAccount         # Authentication identity
├── Profile             # Health data container (includes dietType, dietDescription)
├── ProfileAccess       # Permission management
└── DeviceRegistration  # Multi-device tracking

Health Tracking Entities:
├── Condition           # Health condition
├── ConditionLog        # Condition log entry
├── FlareUp             # Acute health event
├── Supplement          # Supplement definition
├── SupplementIntakeLog # Dose tracking
├── FoodItem            # Food library entry
├── FoodLog             # Meal tracking
├── Activity            # Activity template
├── ActivityLog         # Activity session
├── SleepEntry          # Sleep record
├── FluidsEntry         # Comprehensive fluid tracking (water, bowel, urine, menstruation, BBT, custom "other")
├── PhotoArea           # Body region
├── PhotoEntry          # Photo record
├── JournalEntry        # Free-form notes
└── Document            # File attachment

Note: ALL health tracking entities include a `clientId` field for database merging support.
See 01_PRODUCT_SPECIFICATIONS.md Section 5.2 for clientId concept details.

Notification Entities:
└── NotificationSchedule # Reminder configurations

Diet Entities:
├── Diet                # Diet configuration (preset or custom)
├── DietRule            # Individual diet rules
└── DietViolation       # Logged violations for compliance

Intelligence Entities (Phase 3):
├── Pattern             # Detected health patterns (temporal, cyclical, sequential, cluster, dosage)
├── TriggerCorrelation  # Trigger-outcome relationships with statistical significance
├── HealthInsight       # Generated observations and recommendations
├── PredictiveAlert     # Flare/cycle predictions with probability scores
├── MLModel             # Machine learning model metadata
└── PredictionFeedback  # Outcome feedback for model improvement

See [42_INTELLIGENCE_SYSTEM.md](42_INTELLIGENCE_SYSTEM.md) for complete specification.

Sync Infrastructure:
├── SyncMetadata        # Entity sync state
└── FileSyncMetadata    # File sync state
```

### 3.2 Entity Relationships

```
UserAccount (1) ─────owns────► (N) Profile
UserAccount (1) ─────has─────► (N) DeviceRegistration
UserAccount (1) ────access───► (N) ProfileAccess ◄───grants───(1) Profile

Profile (1) ──contains──► (N) Condition
Condition (1) ──has──────► (N) ConditionLog
Condition (1) ──has──────► (N) FlareUp

Profile (1) ──contains──► (N) Supplement
Supplement (1) ──has────► (N) SupplementIntakeLog

Profile (1) ──contains──► (N) FoodItem
Profile (1) ──contains──► (N) FoodLog
FoodLog (N) ──references─► (N) FoodItem

Profile (1) ──contains──► (N) Activity
Profile (1) ──contains──► (N) ActivityLog
ActivityLog (N) ──refs───► (N) Activity

Profile (1) ──contains──► (N) PhotoArea
PhotoArea (1) ──has─────► (N) PhotoEntry

Profile (1) ──contains──► (N) SleepEntry
Profile (1) ──contains──► (N) FluidsEntry
Profile (1) ──contains──► (N) JournalEntry
Profile (1) ──contains──► (N) Document
```

### 3.3 Repository Interfaces

Each entity type has a corresponding repository interface:

```dart
abstract class SupplementRepository implements EntityRepository<Supplement, String> {
  Future<Result<List<Supplement>, AppError>> getAll({String? profileId, int? limit, int? offset});

  /// Get entity by ID. Returns Failure(DatabaseError.notFound) if not found.
  /// Use when the entity MUST exist (caller knows it should be there).
  Future<Result<Supplement, AppError>> getById(String id);

  Future<Result<Supplement, AppError>> create(Supplement supplement);
  Future<Result<Supplement, AppError>> update(Supplement supplement, {bool markDirty = true});
  Future<Result<void, AppError>> delete(String id);
}

// NOTE: Use getById() which returns Failure if not found.
// Callers should handle the not-found case in the Result type.
// There is no separate "findById" that returns null - use getById().valueOrNull instead.
```

### 3.4 Use Case Layer

Use Cases encapsulate single business operations and sit between Providers and Repositories. They enforce business rules, orchestrate multiple repository calls, and return typed `Result<T, E>` values.

#### Use Case Pattern

```dart
// lib/domain/usecases/supplements/get_supplements_use_case.dart

class GetSupplementsUseCase {
  final SupplementRepository _repository;
  final ProfileAuthorizationService _authService;

  GetSupplementsUseCase(this._repository, this._authService);

  Future<Result<List<Supplement>, AppError>> call({
    required String profileId,
    int? limit,
    int? offset,
  }) async {
    // 1. Check authorization
    if (!_authService.canReadProfile(profileId)) {
      return Failure(AuthError.unauthorized('Cannot access this profile'));
    }

    // 2. Execute repository operation
    final result = await _repository.getAll(
      profileId: profileId,
      limit: limit,
      offset: offset,
    );
    return result; // Result<List<Supplement>, AppError> passes through
  }
}
```

#### Use Case Inventory

| Domain | Use Cases |
|--------|-----------|
| **Profile** | GetProfiles, CreateProfile, UpdateProfile, DeleteProfile |
| **Condition** | GetConditions, CreateCondition, LogConditionEntry, ReportFlareUp |
| **Supplement** | GetSupplements, CreateSupplement, LogIntake, GetIntakeHistory |
| **Food** | GetFoodItems, LogMeal, GetFoodLogs |
| **Fluids** | LogFluidsEntry, GetFluidsEntries, GetBBTChartData |
| **Sleep** | LogSleepEntry, GetSleepEntries |
| **Notification** | GetSchedules, CreateSchedule, UpdateSchedule, DeleteSchedule |
| **Diet** | GetDiets, CreateDiet, UpdateDiet, CheckCompliance, LogViolation, GetComplianceStats |
| **Sync** | PerformSync, ResolveConflict, GetSyncStatus |

#### Provider Integration (Riverpod)

Providers delegate to Use Cases instead of directly calling repositories. **All providers use Riverpod with code generation:**

```dart
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,  // AsyncValue handles error state
    );
  }

  Future<void> createSupplement(CreateSupplementInput input) async {
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);

    result.when(
      success: (_) => ref.invalidateSelf(),  // Refresh list
      failure: (error) => throw error,
    );
  }
}

// Consumer widget usage:
class SupplementListScreen extends ConsumerWidget {
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementListProvider(profileId));

    return supplementsAsync.when(
      data: (supplements) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error.toString()),
    );
  }
}
```

#### Benefits of Use Case Layer

1. **Single Responsibility**: Each use case handles one operation
2. **Testability**: Business logic tested independently of UI and data layers
3. **Reusability**: Same use case can be called from multiple providers
4. **Type Safety**: Result type forces error handling at call site
5. **Authorization**: Centralized permission checks before data access

---

## 4. Data Layer Details

### 4.1 Repository Implementations

All repositories extend `BaseRepository` for sync metadata management:

```dart
class SupplementRepositoryImpl extends BaseRepository<Supplement>
    implements SupplementRepository {

  final SupplementLocalDataSource localDataSource;

  SupplementRepositoryImpl(
    this.localDataSource,
    Uuid uuid,
    DeviceInfoService deviceInfoService,
  ) : super(uuid, deviceInfoService);

  @override
  Future<Result<Supplement, AppError>> create(Supplement supplement) async {
    try {
      final withSync = await prepareForCreate(
        supplement,
        (id, syncMetadata) => supplement.copyWith(
          id: id,
          syncMetadata: syncMetadata,
        ),
      );
      await localDataSource.insertSupplement(
        SupplementModel.fromEntity(withSync)
      );
      return Success(withSync);
    } on DatabaseException catch (e) {
      return Failure(DatabaseError.insertFailed(e.message));
    }
  }
}
```

### 4.2 Data Source Pattern

```dart
// Interface
abstract class SupplementLocalDataSource {
  Future<List<Supplement>> getAllSupplements({String? profileId});
  Future<void> insertSupplement(SupplementModel model);
  Future<void> updateSupplement(SupplementModel model);
}

// Implementation
class SupplementLocalDataSourceImpl implements SupplementLocalDataSource {
  final DatabaseHelper databaseHelper;

  @override
  Future<List<Supplement>> getAllSupplements({String? profileId}) async {
    final db = await databaseHelper.database;

    String where = 'sync_deleted_at IS NULL';
    List<dynamic> args = [];

    if (profileId != null) {
      where += ' AND profile_id = ?';
      args.add(profileId);
    }

    final result = await db.query(
      'supplements',
      where: where,
      whereArgs: args.isEmpty ? null : args,
    );

    return result.map((m) => SupplementModel.fromMap(m).toEntity()).toList();
  }
}
```

### 4.3 Model Layer

Models handle serialization between entities and database/JSON:

```dart
class SupplementModel {
  final String id;
  final String profileId;
  // ... fields

  // Database serialization
  factory SupplementModel.fromMap(Map<String, dynamic> map) { ... }
  Map<String, dynamic> toMap() { ... }

  // JSON serialization (for cloud sync)
  factory SupplementModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }

  // Entity conversion
  factory SupplementModel.fromEntity(Supplement entity) { ... }
  Supplement toEntity() { ... }
}
```

---

## 5. Presentation Layer Details

### 5.1 State Management with Riverpod

**Shadow uses Riverpod with code generation for all state management.** Providers delegate to Use Cases, never directly to repositories.

```dart
// Profile-scoped provider using family pattern
@riverpod
class SupplementList extends _$SupplementList {
  @override
  Future<List<Supplement>> build(String profileId) async {
    // Delegate to use case (not repository)
    final useCase = ref.read(getSupplementsUseCaseProvider);
    final result = await useCase(GetSupplementsInput(profileId: profileId));

    return result.when(
      success: (supplements) => supplements,
      failure: (error) => throw error,  // AsyncValue handles error state
    );
  }

  // Write operations with authorization check
  Future<Result<Supplement, AppError>> addSupplement(
    CreateSupplementInput input,
  ) async {
    // Authorization checked in use case
    final useCase = ref.read(createSupplementUseCaseProvider);
    final result = await useCase(input);

    if (result.isSuccess) {
      ref.invalidateSelf();  // Trigger refresh
    }

    return result;
  }
}

// Consumer widget pattern
class SupplementListScreen extends ConsumerWidget {
  final String profileId;

  const SupplementListScreen({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplementsAsync = ref.watch(supplementListProvider(profileId));

    return supplementsAsync.when(
      data: (supplements) => ListView.builder(
        itemCount: supplements.length,
        itemBuilder: (context, index) => SupplementTile(supplements[index]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorDisplay(
        message: error is AppError ? error.userMessage : 'An error occurred',
        onRetry: () => ref.invalidate(supplementListProvider(profileId)),
      ),
    );
  }
}
```

### 5.2 Screen Structure

```dart
class AddEditSupplementScreen extends StatefulWidget {
  final Supplement? editingSupplement;

  const AddEditSupplementScreen({super.key, this.editingSupplement});

  @override
  State<AddEditSupplementScreen> createState() => _AddEditSupplementScreenState();
}

class _AddEditSupplementScreenState extends State<AddEditSupplementScreen> {
  static final _log = logger.scope('AddEditSupplementScreen');
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameController;

  bool get _isEditing => widget.editingSupplement != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.editingSupplement?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editSupplement : l10n.addSupplement),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Form fields...
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Cloud Sync Architecture

### 6.1 Sync Components

```
┌─────────────────────────────────────────────────┐
│                  SyncProvider                    │
│  (Orchestrates sync, manages UI state)          │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│                  SyncService                     │
│  (Core sync logic, conflict resolution)         │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│            CloudStorageProvider                  │
│  (Interface for cloud backends)                 │
└────────────────────┬────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
┌────────▼────────┐    ┌────────▼────────┐
│ GoogleDrive     │    │ iCloud          │
│ Provider        │    │ Provider        │
└─────────────────┘    └─────────────────┘
```

### 6.1.1 Cloud Provider Selection

Users choose their cloud provider during initial sync setup:
- **Google Drive**: Available on all platforms (iOS, Android, macOS)
- **Apple iCloud**: Available on Apple platforms only (iOS, macOS)
- Users can switch providers later (requires re-sync)

See `15_APPLE_INTEGRATION.md` for iCloud/CloudKit implementation details.

### 6.2 Sync Workflow

```
1. Check Connectivity
        │
2. Authenticate (refresh token if needed)
        │
3. Upload Dirty Local Entities
   └── For each entity type with isDirty=true
        │
4. Download Remote Changes
   └── Compare lastSyncedAt timestamps
        │
5. Resolve Conflicts
   └── Default: Last-Write-Wins
        │
6. Upload Files (photos, documents)
        │
7. Download Files from Cloud
        │
8. Update Sync Metadata
   └── Mark as synced, update timestamps
```

### 6.3 Conflict Resolution

```dart
/// CANONICAL: See 22_API_CONTRACTS.md
enum ConflictResolution {
  keepLocal,   // Use local version, overwrite remote
  keepRemote,  // Use remote version, overwrite local
  merge,       // Merge both versions (for compatible changes)
}

class ConflictResolver {
  SyncMetadata resolve(SyncMetadata local, SyncMetadata remote) {
    // Default: Last-Write-Wins
    if (local.updatedAt.isAfter(remote.updatedAt)) {
      return local;
    } else {
      return remote;
    }
  }
}
```

---

## 7. Notification Service Architecture

### 7.1 Notification Components

```
┌─────────────────────────────────────────────────┐
│              NotificationProvider                │
│  (UI state, schedule management)                │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│              NotificationService                 │
│  (Core scheduling, permission handling)         │
└────────────────────┬────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
┌────────▼────────┐    ┌────────▼────────┐
│ flutter_local   │    │    timezone     │
│ _notifications  │    │    package      │
└─────────────────┘    └─────────────────┘
```

### 7.2 NotificationSchedule Entity

```dart
/// NotificationType enum - 25 values with explicit integer codes
/// CANONICAL DEFINITION: See 22_API_CONTRACTS.md Section 3.2
///
/// Values: supplementIndividual(0), supplementGrouped(1), mealBreakfast(2),
/// mealLunch(3), mealDinner(4), mealSnacks(5), waterInterval(6), waterFixed(7),
/// waterSmart(8), bbtMorning(9), menstruationTracking(10), sleepBedtime(11),
/// sleepWakeup(12), conditionCheckIn(13), photoReminder(14), journalPrompt(15),
/// syncReminder(16), fastingWindowOpen(17), fastingWindowClose(18),
/// fastingWindowClosed(19), dietStreak(20), dietWeeklySummary(21),
/// fluidsGeneral(22), fluidsBowel(23), inactivity(24)

// See 22_API_CONTRACTS.md and 37_NOTIFICATIONS.md for complete notification specification

/// NotificationSchedule entity - uses @freezed per 02_CODING_STANDARDS.md Section 5
@freezed
class NotificationSchedule with _$NotificationSchedule {
  const factory NotificationSchedule({
    required String id,
    required String clientId,
    String? profileId,
    required NotificationType type,
    String? entityId,           // e.g., supplement_id for supplement notifications
    required List<int> timesMinutesFromMidnight,  // [480, 720] = 8am, 12pm
    required List<int> weekdays,         // [0,1,2,3,4,5,6] = all days
    required bool isEnabled,
    String? customMessage,
    required SyncMetadata syncMetadata,
  }) = _NotificationSchedule;

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleFromJson(json);
}
```

### 7.3 NotificationService Implementation

```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationScheduleRepository _repository;

  // Initialize with platform-specific settings
  Future<void> initialize() async;

  // Request notification permissions
  Future<bool> requestPermissions() async;

  // Schedule all notifications for a profile
  Future<void> scheduleAllNotifications(String profileId) async;

  // Cancel all notifications for a profile
  Future<void> cancelAllNotifications(String profileId) async;

  // Handle notification tap (deep linking)
  Future<void> handleNotificationTap(NotificationResponse response) async;

  // Reschedule after boot or app update
  Future<void> rescheduleAllNotifications() async;
}
```

### 7.3.1 Permission Denial Handling

When the user denies notification permissions:

```dart
class NotificationPermissionHandler {
  /// Called when user denies notification permissions
  Future<void> handlePermissionDenied() async {
    // 1. Store denial state (don't repeatedly ask)
    await _preferences.setBool('notificationPermissionDenied', true);

    // 2. Disable all notification schedules in database (keeps configuration)
    await _notificationScheduleRepository.disableAll();

    // 3. Show non-intrusive in-app banner (not blocking dialog)
    // Banner shown once per session, dismissible
  }

  /// Check if we should show permission rationale
  bool shouldShowRationale() {
    // iOS: Always show rationale before first request
    // Android: Show only if permission was previously denied
    return Platform.isIOS || _wasPreviouslyDenied;
  }

  /// Re-request permission (user-initiated from settings)
  Future<bool> requestPermissionAgain() async {
    // 1. If denied at OS level, open system settings
    if (await _permission.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    // 2. Otherwise, request permission again
    final granted = await _notificationService.requestPermissions();
    if (granted) {
      await _notificationScheduleRepository.enableAll();
    }
    return granted;
  }
}
```

**User Experience:**
- First launch: Show rationale explaining benefits before requesting
- If denied: Banner in notification settings screen with "Enable" button
- Never show blocking modals or repeated permission requests
- Keep schedule configurations (don't delete) so enabling is one tap
- Log permission denial for analytics (not as error)

### 7.4 Deep Linking

Notification taps route to relevant screens:

| Notification Type | Target Screen |
|-------------------|---------------|
| supplement | Supplement intake log screen for that supplement |
| supplementGroup | Supplement list screen |
| foodMeal | Log food screen (with meal type pre-selected) |
| foodGeneral | Log food screen |
| water | Fluids tab (water section focused) |
| fluidsBowel | Add fluids entry screen |
| fluidsGeneral | Fluids tab |
| bbt | Add fluids entry screen (BBT section focused) |
| menstruation | Add fluids entry screen (menstruation section) |
| sleepBedtime | Add sleep entry screen |
| sleepWakeup | Add sleep entry screen |
| condition | Log condition screen for that condition |
| photo | Photo capture for specified area |
| journal | Add journal entry screen |
| sync | Sync settings screen |
| inactivity | Home screen |

```dart
// Deep link payload structure
{
  "type": "supplement",
  "profileId": "uuid",
  "entityId": "supplement-uuid"  // optional
}
```

### 7.5 Platform Configuration

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
          android:exported="false">
  <intent-filter>
    <action android:name="android.intent.action.BOOT_COMPLETED"/>
    <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
  </intent-filter>
</receiver>
```

**iOS (Info.plist):**
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

### 7.6 Notification Repository Stack

```
NotificationScheduleRepository (interface)
        │
        ▼
NotificationScheduleRepositoryImpl (implementation)
        │
        ▼
NotificationScheduleLocalDataSource (database operations)
        │
        ▼
NotificationScheduleModel (serialization)
```

---

## 8. Security Architecture

### 8.1 Encryption Layers

```
┌─────────────────────────────────────────────────┐
│              Application Layer                   │
│  All PHI processed in memory only               │
├─────────────────────────────────────────────────┤
│              Encryption Layer                    │
│  AES-256-GCM for cloud data                     │
├─────────────────────────────────────────────────┤
│              Storage Layer                       │
│  SQLCipher (AES-256) for local database         │
├─────────────────────────────────────────────────┤
│              Platform Secure Storage             │
│  iOS Keychain / Android Keystore / macOS Keychain│
│  (Encryption keys, OAuth tokens)                │
└─────────────────────────────────────────────────┘
```

### 8.2 Token Storage

```dart
class SecureStorageKeys {
  // Separate keys for reduced blast radius
  static const googleDriveAccessToken = 'google_drive_access_token';
  static const googleDriveRefreshToken = 'google_drive_refresh_token';
  static const googleDriveTokenExpiry = 'google_drive_token_expiry';
  static const databaseEncryptionKey = 'database_encryption_key';
}
```

---

## 9. Dependency Injection

### 9.1 Service Registration

```dart
// lib/injection_container.dart

final sl = GetIt.instance;

Future<void> init() async {
  // Core Services
  sl.registerLazySingleton(() => const Uuid());
  sl.registerLazySingleton(() => LoggerService());
  sl.registerLazySingleton(() => EncryptionService());
  sl.registerLazySingleton(() => DeviceInfoService(DeviceInfoPlugin()));

  // Database
  sl.registerLazySingleton(() => DatabaseHelper());

  // Data Sources
  sl.registerLazySingleton<SupplementLocalDataSource>(
    () => SupplementLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<SupplementRepository>(
    () => SupplementRepositoryImpl(sl(), sl(), sl()),
  );

  // Providers
  sl.registerFactory(() => SupplementProvider(sl(), sl()));

  // Cloud Services
  sl.registerLazySingleton<CloudStorageProvider>(
    () => GoogleDriveProvider(),
  );
  sl.registerLazySingleton(() => SyncService(sl(), sl()));

  // Notification Services
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton<NotificationScheduleLocalDataSource>(
    () => NotificationScheduleLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NotificationScheduleRepository>(
    () => NotificationScheduleRepositoryImpl(sl(), sl(), sl()),
  );
  sl.registerLazySingleton(() => NotificationService(sl(), sl()));
  sl.registerFactory(() => NotificationProvider(sl(), sl()));
}
```

---

## 10. Design Patterns Used

| Pattern | Usage |
|---------|-------|
| Clean Architecture | Layer separation (Presentation, Domain, Data) |
| Repository Pattern | Abstract data access |
| Factory Pattern | CloudProviderFactory, model factories |
| Singleton Pattern | Services (Logger, Encryption, Database, NotificationService) |
| Riverpod Pattern | State management with code generation (@riverpod) |
| Adapter Pattern | Models convert between formats |
| AsyncNotifier Pattern | Riverpod async state management |
| Strategy Pattern | Conflict resolution strategies |
| Command Pattern | Deep link handling for notifications |

---

## Document Control

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-30 | Initial release |
| 1.1 | 2026-01-30 | Added notification service architecture, deep linking, renamed BowelUrineEntry to FluidsEntry |
