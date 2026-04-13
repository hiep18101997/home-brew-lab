# Coffee Brewing Companion - Clean Architecture Refactor Design

**Date:** 2026-04-13  
**Author:** Claude Code  
**Status:** Draft

---

## 1. Project Overview

**Project:** Coffee Brewing Companion - Flutter app for home baristas  
**Goal:** Refactor from Riverpod + Layered Architecture → Feature-First Clean Architecture with BLoC + Drift  
**Scope:** Full architecture refactor with Layer-by-Layer approach

---

## 2. Architecture Decision

### 2.1 Feature-First Clean Architecture

**Structure:**

```
lib/
├── core/                           # Shared constants, theme, utils
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── beans/
│   │   ├── domain/                 # Entities, Repository interfaces, Use Cases
│   │   ├── data/                   # DTOs, Drift data source, Repository impl
│   │   └── presentation/           # BLoC, Screens, Widgets
│   ├── brew/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   └── profile/
│       ├── domain/
│       ├── data/
│       └── presentation/
├── injection.dart                  # get_it DI setup
└── app.dart                         # GoRouter, theming
```

### 2.2 Dependency Flow

```
presentation/presentation (BLoC) → domain/usecases → domain/repositories (interfaces)
                                    ↓
                              data/repositories (impl) → data/datasources (Drift)
                                    ↓
                              get_it (DI container)
```

**Dependency Rule:** Source code dependencies point inward. Inner layers know nothing about outer layers.

---

## 3. Tech Stack

### 3.1 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.0        # State management
  equatable: ^2.0.5           # For BLoC events/states
  drift: ^2.30.0              # SQLite database
  drift_flutter: ^0.2.8       # Flutter-specific Drift setup
  path_provider: ^2.1.5       # File paths
  get_it: ^8.0.0              # Dependency Injection
  go_router: ^14.0.0          # Routing (existing)
  uuid: ^4.2.1                # ID generation (existing)
  intl: ^0.18.1               # Date formatting (existing)
  google_fonts: ^6.1.0        # Typography (existing)

dev_dependencies:
  drift_dev: ^2.30.0          # Drift code generation
  build_runner: ^2.10.4      # Code generation runner
```

### 3.2 State Management: BLoC Pattern

- **BLoC (Business Logic Component)** from `flutter_bloc`
- Events → BLoC → States pattern
- Always emit Loading state before async operations
- Use Equatable for all Events and States

### 3.3 Database: Drift (SQLite)

- **Drift** - reactive persistence library built on SQLite
- Type-safe queries with code generation
- Auto-updating streams for reactive UI
- Cross-platform (mobile, web, desktop)

### 3.4 Dependency Injection: get_it

- **get_it** - Service locator pattern
- Lazy singletons for database and repositories
- Factories for use cases and BLoCs

---

## 4. Feature Breakdown

### 4.1 beans Feature

**Domain Layer:**
- `Bean` entity (existing, keep as-is)
- `BeanRepository` interface (existing, keep as-is)
- `GetBeans` use case
- `GetBeanById` use case
- `CreateBean` use case
- `UpdateBean` use case
- `DeleteBean` use case
- `UpdateBeanWeight` use case

**Data Layer:**
- `BeanDto` - data transfer object with Drift mapping
- `BeansDriftDataSource` - Drift table operations
- `BeanRepositoryImpl` - implements BeanRepository

**Presentation Layer:**
- `BeansBloc` - state management
- `BeansEvent` - user actions
- `BeansState` - UI states
- `BeanListScreen` - existing screen
- `AddBeanScreen` - existing screen
- `BeanDetailScreen` - existing screen

### 4.2 brew Feature

**Domain Layer:**
- `BrewLog` entity (existing, keep as-is)
- `BrewRepository` interface (existing, keep as-is)
- `GetBrewLogs` use case
- `GetBrewLogsByBeanId` use case
- `GetBrewLogsByMethod` use case
- `CreateBrewLog` use case
- `UpdateBrewLog` use case
- `DeleteBrewLog` use case

**Data Layer:**
- `BrewLogDto` - data transfer object with Drift mapping
- `BrewLogsDriftDataSource` - Drift table operations
- `BrewRepositoryImpl` - implements BrewRepository

**Presentation Layer:**
- `BrewBloc` - state management
- `BrewEvent` - user actions
- `BrewState` - UI states
- `NewBrewScreen` - existing screen
- `BrewTimerScreen` - existing screen
- `BrewHistoryScreen` - existing screen

### 4.3 timer Feature

Timer functionality will be integrated into the brew feature since they are closely related. The timer is primarily used during the brewing process.

### 4.4 profile Feature

**Domain Layer:**
- User entity (future - for authentication)
- Profile repository interface

**Data Layer:**
- User data source (future)

**Presentation Layer:**
- Profile screen (existing - currently placeholder)

---

## 5. Data Layer Details

### 5.1 Drift Database Schema

```dart
@DriftDatabase(tables: [Beans, BrewLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? driftDatabase(
    name: 'coffee_brewing_db',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  ));

  @override
  int get schemaVersion => 1;
}

class Beans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get roaster => text().withLength(min: 1, max: 100)();
  TextColumn get origin => text().nullable()();
  TextColumn get variety => text().nullable()();
  TextColumn get process => text().nullable()();
  TextColumn get roastLevel => text().nullable()();
  DateTimeColumn get roastDate => dateTime().nullable()();
  RealColumn get weightRemaining => real()();
  RealColumn get weightInitial => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class BrewLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get beanId => integer().nullable().references(Beans, #id)();
  TextColumn get method => text()();
  RealColumn get dose => real()();
  RealColumn get yield => real()();
  IntColumn get grindSize => integer()();
  IntColumn get waterTemperature => integer()();
  IntColumn get brewTimeSeconds => integer()();
  IntColumn get rating => integer().nullable()();
  TextColumn get flavorTags => text().nullable()(); // JSON array
  TextColumn get notes => text().nullable()();
  RealColumn get tds => real().nullable()();
  RealColumn get extractionYield => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### 5.2 Repository Implementation Pattern

```dart
class BeanRepositoryImpl implements BeanRepository {
  final BeansDriftDataSource _dataSource;

  BeanRepositoryImpl(this._dataSource);

  @override
  Future<List<Bean>> getAllBeans() async {
    final dtos = await _dataSource.getAllBeans();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Bean?> getBeanById(String id) async {
    final dto = await _dataSource.getBeanById(id);
    return dto?.toEntity();
  }
  // ... other methods
}
```

---

## 6. BLoC Pattern

### 6.1 Event Structure

```dart
abstract class BeansEvent extends Equatable {
  const BeansEvent();
  @override
  List<Object?> get props => [];
}

class BeansRequested extends BeansEvent {}

class BeanCreated extends BeansEvent {
  final Bean bean;
  const BeanCreated(this.bean);
  @override
  List<Object> get props => [bean];
}

class BeanDeleted extends BeansEvent {
  final String id;
  const BeanDeleted(this.id);
  @override
  List<Object> get props => [id];
}
```

### 6.2 State Structure

```dart
abstract class BeansState extends Equatable {
  const BeansState();
  @override
  List<Object?> get props => [];
}

class BeansInitial extends BeansState {}

class BeansLoading extends BeansState {}

class BeansSuccess extends BeansState {
  final List<Bean> beans;
  const BeansSuccess(this.beans);
  @override
  List<Object> get props => [beans];
}

class BeansError extends BeansState {
  final String message;
  const BeansError(this.message);
  @override
  List<Object> get props => [message];
}
```

### 6.3 BLoC Implementation

```dart
class BeansBloc extends Bloc<BeansEvent, BeansState> {
  final GetBeans getBeans;
  final CreateBean createBean;
  final DeleteBean deleteBean;

  BeansBloc({
    required this.getBeans,
    required this.createBean,
    required this.deleteBean,
  }) : super(BeansInitial()) {
    on<BeansRequested>(_onBeansRequested);
    on<BeanCreated>(_onBeanCreated);
    on<BeanDeleted>(_onBeanDeleted);
  }

  Future<void> _onBeansRequested(
    BeansRequested event,
    Emitter<BeansState> emit,
  ) async {
    emit(BeansLoading());
    try {
      final beans = await getBeans();
      emit(BeansSuccess(beans));
    } catch (e) {
      emit(BeansError(e.toString()));
    }
  }
}
```

---

## 7. Dependency Injection Setup

```dart
// injection.dart
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Data Sources
  getIt.registerLazySingleton<BeansDriftDataSource>(
    () => BeansDriftDataSource(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<BrewLogsDriftDataSource>(
    () => BrewLogsDriftDataSource(getIt<AppDatabase>()),
  );

  // Repositories
  getIt.registerLazySingleton<BeanRepository>(
    () => BeanRepositoryImpl(getIt<BeansDriftDataSource>()),
  );
  getIt.registerLazySingleton<BrewRepository>(
    () => BrewRepositoryImpl(getIt<BrewLogsDriftDataSource>()),
  );

  // Use Cases - Beans
  getIt.registerFactory(() => GetBeans(getIt<BeanRepository>()));
  getIt.registerFactory(() => GetBeanById(getIt<BeanRepository>()));
  getIt.registerFactory(() => CreateBean(getIt<BeanRepository>()));
  getIt.registerFactory(() => UpdateBean(getIt<BeanRepository>()));
  getIt.registerFactory(() => DeleteBean(getIt<BeanRepository>()));
  getIt.registerFactory(() => UpdateBeanWeight(getIt<BeanRepository>()));

  // Use Cases - Brew
  getIt.registerFactory(() => GetBrewLogs(getIt<BrewRepository>()));
  getIt.registerFactory(() => GetBrewLogsByBeanId(getIt<BrewRepository>()));
  getIt.registerFactory(() => CreateBrewLog(getIt<BrewRepository>()));
  getIt.registerFactory(() => DeleteBrewLog(getIt<BrewRepository>()));

  // BLoCs
  getIt.registerFactory(() => BeansBloc(
    getBeans: getIt<GetBeans>(),
    createBean: getIt<CreateBean>(),
    deleteBean: getIt<DeleteBean>(),
  ));
  getIt.registerFactory(() => BrewBloc(
    getBrewLogs: getIt<GetBrewLogs>(),
    createBrewLog: getIt<CreateBrewLog>(),
    deleteBrewLog: getIt<DeleteBrewLog>(),
  ));
}
```

---

## 8. Implementation Order (Layer-by-Layer)

### Phase 1: Core & Infrastructure
1. Update `pubspec.yaml` with new dependencies
2. Create Drift database with tables
3. Set up get_it injection
4. Create design system constants (if needed)

### Phase 2: Domain Layer (Existing)
5. Create Use Cases for beans feature
6. Create Use Cases for brew feature

### Phase 3: Data Layer
7. Create DTOs with Drift mapping
8. Create Drift data sources
9. Create repository implementations

### Phase 4: Presentation Layer
10. Create BLoCs for beans feature
11. Create BLoCs for brew feature
12. Update screens to use BLoCs
13. Remove Riverpod providers

### Phase 5: Cleanup
14. Remove old Riverpod code
15. Clean up unused files
16. Test and verify

---

## 9. Key Rules

1. **No business logic in UI** - all logic in BLoC or Use Cases
2. **No SDK calls outside datasources** - Drift calls only in data sources
3. **Zero hardcoded values** - use theme constants
4. **Loading state required** - emit before async operations
5. **Equatable for all events/states** - for proper equality checking
6. **Feature-specific code stays in feature folder**
7. **Shared code goes in core/ or shared/**

---

## 10. References

- flutter-bloc-development skill: `~/.agents/skills/flutter-bloc-development/`
- flutter-drift skill: `~/.agents/skills/flutter-drift/`
