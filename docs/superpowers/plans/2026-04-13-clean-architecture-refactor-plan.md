# Clean Architecture Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor Coffee Brewing Companion from Riverpod + Layered Architecture to Feature-First Clean Architecture with BLoC + Drift

**Architecture:** Feature-First Clean Architecture with Layer-by-Layer approach. Dependencies point inward: presentation → domain ← data. Each feature is self-contained with its own domain, data, and presentation layers.

**Tech Stack:** flutter_bloc, equatable, drift, drift_flutter, get_it, go_router

---

## File Structure Overview

```
lib/
├── core/                          # Keep as-is
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── beans/
│   │   ├── domain/                # Bean entity (existing), Use Cases (NEW)
│   │   ├── data/                  # DTO, DriftDataSource, RepositoryImpl (NEW)
│   │   └── presentation/          # BLoC (NEW), Screens (UPDATE)
│   ├── brew/
│   │   ├── domain/                # BrewLog entity (existing), Use Cases (NEW)
│   │   ├── data/                  # DTO, DriftDataSource, RepositoryImpl (NEW)
│   │   └── presentation/         # BLoC (NEW), Screens (UPDATE)
│   └── profile/                   # Minimal change (placeholder)
├── injection.dart                 # get_it setup (NEW)
├── database.dart                  # Drift database (NEW)
└── app.dart                       # Update routing
```

---

## Phase 1: Infrastructure Setup

### Task 1: Update pubspec.yaml with dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Update pubspec.yaml**

```yaml
dependencies:
  flutter_bloc: ^8.1.0
  equatable: ^2.0.5
  drift: ^2.30.0
  drift_flutter: ^0.2.8
  path_provider: ^2.1.5
  get_it: ^8.0.0

dev_dependencies:
  drift_dev: ^2.30.0
  build_runner: ^2.10.4
```

- [ ] **Step 2: Run flutter pub get**

```bash
flutter pub get
```

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock && git commit -m "chore: add BLoC, Drift, get_it dependencies"
```

---

### Task 2: Create Drift Database

**Files:**
- Create: `lib/database.dart`
- Create: `lib/features/beans/data/datasources/beans_table.dart`
- Create: `lib/features/brew/data/datasources/brew_logs_table.dart`

- [ ] **Step 1: Create beans table definition**

```dart
// lib/features/beans/data/datasources/beans_table.dart
import 'package:drift/drift.dart';

class BeansTable extends Table {
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
```

- [ ] **Step 2: Create brew_logs table definition**

```dart
// lib/features/brew/data/datasources/brew_logs_table.dart
import 'package:drift/drift.dart';

class BrewLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get beanId => integer().nullable()();
  TextColumn get method => text()();
  RealColumn get dose => real()();
  RealColumn get yieldColumn => real()();
  IntColumn get grindSize => integer()();
  IntColumn get waterTemperature => integer()();
  IntColumn get brewTimeSeconds => integer()();
  IntColumn get rating => integer().nullable()();
  TextColumn get flavorTags => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get tds => real().nullable()();
  RealColumn get extractionYield => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

- [ ] **Step 3: Create main database file**

```dart
// lib/database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'features/beans/data/datasources/beans_table.dart';
import 'features/brew/data/datasources/brew_logs_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [BeansTable, BrewLogsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(
    name: 'coffee_brewing_db',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  ));

  @override
  int get schemaVersion => 1;
}
```

- [ ] **Step 4: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 5: Commit**

```bash
git add lib/database.dart lib/features/beans/data/datasources/ lib/features/brew/data/datasources/ && git commit -m "feat: add Drift database with beans and brew_logs tables"
```

---

### Task 3: Create Dependency Injection with get_it

**Files:**
- Create: `lib/injection.dart`

- [ ] **Step 1: Create injection.dart**

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'database.dart';
import 'features/beans/data/datasources/beans_drift_datasource.dart';
import 'features/beans/data/repositories/bean_repository_impl.dart';
import 'features/beans/domain/repositories/bean_repository.dart';
import 'features/beans/domain/usecases/get_beans.dart';
import 'features/beans/domain/usecases/create_bean.dart';
import 'features/beans/domain/usecases/delete_bean.dart';
import 'features/beans/presentation/bloc/beans_bloc.dart';
import 'features/brew/data/datasources/brew_logs_drift_datasource.dart';
import 'features/brew/data/repositories/brew_repository_impl.dart';
import 'features/brew/domain/repositories/brew_repository.dart';
import 'features/brew/domain/usecases/get_brew_logs.dart';
import 'features/brew/domain/usecases/create_brew_log.dart';
import 'features/brew/domain/usecases/delete_brew_log.dart';
import 'features/brew/presentation/bloc/brew_bloc.dart';

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
  getIt.registerFactory(() => CreateBean(getIt<BeanRepository>()));
  getIt.registerFactory(() => DeleteBean(getIt<BeanRepository>()));

  // Use Cases - Brew
  getIt.registerFactory(() => GetBrewLogs(getIt<BrewRepository>()));
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

- [ ] **Step 2: Commit**

```bash
git add lib/injection.dart && git commit -m "feat: setup get_it dependency injection"
```

---

## Phase 2: Domain Layer - Use Cases

### Task 4: Create Beans Use Cases

**Files:**
- Create: `lib/features/beans/domain/usecases/get_beans.dart`
- Create: `lib/features/beans/domain/usecases/create_bean.dart`
- Create: `lib/features/beans/domain/usecases/delete_bean.dart`
- Create: `lib/features/beans/domain/usecases/usecases.dart`

- [ ] **Step 1: Create GetBeans use case**

```dart
// lib/features/beans/domain/usecases/get_beans.dart
import '../repositories/bean_repository.dart';
import '../../domain/entities/bean.dart';

class GetBeans {
  final BeanRepository repository;

  GetBeans(this.repository);

  Future<List<Bean>> call() async {
    return await repository.getAllBeans();
  }
}
```

- [ ] **Step 2: Create CreateBean use case**

```dart
// lib/features/beans/domain/usecases/create_bean.dart
import '../repositories/bean_repository.dart';
import '../../domain/entities/bean.dart';

class CreateBean {
  final BeanRepository repository;

  CreateBean(this.repository);

  Future<Bean> call(Bean bean) async {
    return await repository.createBean(bean);
  }
}
```

- [ ] **Step 3: Create DeleteBean use case**

```dart
// lib/features/beans/domain/usecases/delete_bean.dart
import '../repositories/bean_repository.dart';

class DeleteBean {
  final BeanRepository repository;

  DeleteBean(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteBean(id);
  }
}
```

- [ ] **Step 4: Create barrel file**

```dart
// lib/features/beans/domain/usecases/usecases.dart
export 'get_beans.dart';
export 'create_bean.dart';
export 'delete_bean.dart';
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/beans/domain/usecases/ && git commit -m "feat(beans): add use cases"
```

---

### Task 5: Create Brew Use Cases

**Files:**
- Create: `lib/features/brew/domain/usecases/get_brew_logs.dart`
- Create: `lib/features/brew/domain/usecases/create_brew_log.dart`
- Create: `lib/features/brew/domain/usecases/delete_brew_log.dart`
- Create: `lib/features/brew/domain/usecases/usecases.dart`

- [ ] **Step 1-4: Create use cases (same pattern as beans)**

- [ ] **Step 5: Commit**

```bash
git add lib/features/brew/domain/usecases/ && git commit -m "feat(brew): add use cases"
```

---

## Phase 3: Data Layer

### Task 6: Create Beans Data Layer

**Files:**
- Create: `lib/features/beans/data/models/bean_dto.dart`
- Create: `lib/features/beans/data/datasources/beans_drift_datasource.dart`
- Create: `lib/features/beans/data/repositories/bean_repository_impl.dart`
- Create: `lib/features/beans/data/data.dart`

- [ ] **Step 1: Create BeanDto**

```dart
// lib/features/beans/data/models/bean_dto.dart
import 'package:drift/drift.dart';
import '../../domain/entities/bean.dart';
import '../datasources/beans_table.dart';

class BeanDto {
  final int id;
  final String name;
  final String roaster;
  final String? origin;
  final String? variety;
  final String? process;
  final String? roastLevel;
  final DateTime? roastDate;
  final double weightRemaining;
  final double? weightInitial;
  final String? notes;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BeanDto({
    required this.id,
    required this.name,
    required this.roaster,
    this.origin,
    this.variety,
    this.process,
    this.roastLevel,
    this.roastDate,
    required this.weightRemaining,
    this.weightInitial,
    this.notes,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BeanDto.fromDrift(BeansTableCompanion row) {
    return BeanDto(
      id: row.id.value,
      name: row.name.value,
      roaster: row.roaster.value,
      origin: row.origin.value,
      variety: row.variety.value,
      process: row.process.value,
      roastLevel: row.roastLevel.value,
      roastDate: row.roastDate.value,
      weightRemaining: row.weightRemaining.value,
      weightInitial: row.weightInitial.value,
      notes: row.notes.value,
      imageUrl: row.imageUrl.value,
      createdAt: row.createdAt.value,
      updatedAt: row.updatedAt.value,
    );
  }

  Bean toEntity() {
    return Bean(
      id: id.toString(),
      name: name,
      roaster: roaster,
      origin: origin,
      variety: variety,
      process: process,
      roastLevel: roastLevel,
      roastDate: roastDate,
      weightRemaining: weightRemaining,
      weightInitial: weightInitial,
      notes: notes,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static BeansTableCompanion fromEntity(Bean entity) {
    return BeansTableCompanion.insert(
      name: entity.name,
      roaster: entity.roaster,
      origin: Value(entity.origin),
      variety: Value(entity.variety),
      process: Value(entity.process),
      roastLevel: Value(entity.roastLevel),
      roastDate: Value(entity.roastDate),
      weightRemaining: entity.weightRemaining,
      weightInitial: Value(entity.weightInitial),
      notes: Value(entity.notes),
      imageUrl: Value(entity.imageUrl),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
```

- [ ] **Step 2: Create BeansDriftDataSource**

```dart
// lib/features/beans/data/datasources/beans_drift_datasource.dart
import 'package:drift/drift.dart';
import '../../../../database.dart';
import '../models/bean_dto.dart';

class BeansDriftDataSource {
  final AppDatabase _db;

  BeansDriftDataSource(this._db);

  Future<List<BeanDto>> getAllBeans() async {
    final rows = await _db.select(_db.beansTable).get();
    return rows.map((row) => BeanDto.fromDrift(row)).toList();
  }

  Future<BeanDto?> getBeanById(int id) async {
    final row = await (_db.select(_db.beansTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? BeanDto.fromDrift(row) : null;
  }

  Future<BeanDto> insertBean(BeansTableCompanion bean) async {
    final id = await _db.into(_db.beansTable).insert(bean);
    return getBeanById(id) ?? throw Exception('Failed to insert bean');
  }

  Future<void> updateBean(BeansTableCompanion bean) async {
    await (_db.update(_db.beansTable)..where((t) => t.id.equals(bean.id.value)))
        .write(bean);
  }

  Future<void> deleteBean(int id) async {
    await (_db.delete(_db.beansTable)..where((t) => t.id.equals(id))).go();
  }
}
```

Note: Need to add getter for beansTable in database.g.dart - will be generated by Drift.

- [ ] **Step 3: Create BeanRepositoryImpl**

```dart
// lib/features/beans/data/repositories/bean_repository_impl.dart
import '../../domain/entities/bean.dart';
import '../../domain/repositories/bean_repository.dart';
import '../datasources/beans_drift_datasource.dart';
import '../models/bean_dto.dart';

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
    final dto = await _dataSource.getBeanById(int.parse(id));
    return dto?.toEntity();
  }

  @override
  Future<Bean> createBean(Bean bean) async {
    final companion = BeanDto.fromEntity(bean);
    final inserted = await _dataSource.insertBean(companion);
    return inserted.toEntity();
  }

  @override
  Future<Bean> updateBean(Bean bean) async {
    final companion = BeanDto.fromEntity(bean);
    await _dataSource.updateBean(companion);
    return bean;
  }

  @override
  Future<void> deleteBean(String id) async {
    await _dataSource.deleteBean(int.parse(id));
  }

  @override
  Future<void> updateWeight(String id, double newWeight) async {
    final bean = await getBeanById(id);
    if (bean != null) {
      await updateBean(bean.copyWith(weightRemaining: newWeight));
    }
  }
}
```

- [ ] **Step 4: Create barrel file**

```dart
// lib/features/beans/data/data.dart
export 'models/bean_dto.dart';
export 'datasources/beans_drift_datasource.dart';
export 'repositories/bean_repository_impl.dart';
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/beans/data/ && git commit -m "feat(beans): add data layer with Drift"
```

---

### Task 7: Create Brew Data Layer

**Files:**
- Create: `lib/features/brew/data/models/brew_log_dto.dart`
- Create: `lib/features/brew/data/datasources/brew_logs_drift_datasource.dart`
- Create: `lib/features/brew/data/repositories/brew_repository_impl.dart`
- Create: `lib/features/brew/data/data.dart`

- [ ] **Step 1-4: Create similar to beans data layer**

- [ ] **Step 5: Commit**

```bash
git add lib/features/brew/data/ && git commit -m "feat(brew): add data layer with Drift"
```

---

## Phase 4: Presentation Layer - BLoCs

### Task 8: Create Beans BLoC

**Files:**
- Create: `lib/features/beans/presentation/bloc/beans_event.dart`
- Create: `lib/features/beans/presentation/bloc/beans_state.dart`
- Create: `lib/features/beans/presentation/bloc/beans_bloc.dart`
- Create: `lib/features/beans/presentation/bloc/bloc.dart`

- [ ] **Step 1: Create BeansEvent**

```dart
// lib/features/beans/presentation/bloc/beans_event.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/bean.dart';

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
  List<Object?> get props => [bean];
}

class BeanDeleted extends BeansEvent {
  final String id;
  const BeanDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class BeanUpdated extends BeansEvent {
  final Bean bean;
  const BeanUpdated(this.bean);

  @override
  List<Object?> get props => [bean];
}
```

- [ ] **Step 2: Create BeansState**

```dart
// lib/features/beans/presentation/bloc/beans_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/bean.dart';

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
  List<Object?> get props => [beans];
}

class BeansError extends BeansState {
  final String message;
  const BeansError(this.message);

  @override
  List<Object?> get props => [message];
}
```

- [ ] **Step 3: Create BeansBloc**

```dart
// lib/features/beans/presentation/bloc/beans_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_beans.dart';
import '../../../domain/usecases/create_bean.dart';
import '../../../domain/usecases/delete_bean.dart';
import 'beans_event.dart';
import 'beans_state.dart';

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

  Future<void> _onBeanCreated(
    BeanCreated event,
    Emitter<BeansState> emit,
  ) async {
    emit(BeansLoading());
    try {
      await createBean(event.bean);
      final beans = await getBeans();
      emit(BeansSuccess(beans));
    } catch (e) {
      emit(BeansError(e.toString()));
    }
  }

  Future<void> _onBeanDeleted(
    BeanDeleted event,
    Emitter<BeansState> emit,
  ) async {
    emit(BeansLoading());
    try {
      await deleteBean(event.id);
      final beans = await getBeans();
      emit(BeansSuccess(beans));
    } catch (e) {
      emit(BeansError(e.toString()));
    }
  }
}
```

- [ ] **Step 4: Create barrel file**

```dart
// lib/features/beans/presentation/bloc/bloc.dart
export 'beans_bloc.dart';
export 'beans_event.dart';
export 'beans_state.dart';
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/beans/presentation/bloc/ && git commit -m "feat(beans): add BLoC for state management"
```

---

### Task 9: Create Brew BLoC

**Files:**
- Create: `lib/features/brew/presentation/bloc/brew_event.dart`
- Create: `lib/features/brew/presentation/bloc/brew_state.dart`
- Create: `lib/features/brew/presentation/bloc/brew_bloc.dart`
- Create: `lib/features/brew/presentation/bloc/bloc.dart`

- [ ] **Step 1-4: Create similar to beans BLoC**

- [ ] **Step 5: Commit**

```bash
git add lib/features/brew/presentation/bloc/ && git commit -m "feat(brew): add BLoC for state management"
```

---

## Phase 5: Update Screens & Main

### Task 10: Update main.dart and app.dart

**Files:**
- Modify: `lib/main.dart`
- Modify: `lib/app.dart`

- [ ] **Step 1: Update main.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart';
import 'features/beans/presentation/bloc/beans_bloc.dart';
import 'features/brew/presentation/bloc/brew_bloc.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BeansBloc>(create: (_) => getIt<BeansBloc>()),
        BlocProvider<BrewBloc>(create: (_) => getIt<BrewBloc>()),
      ],
      child: const CoffeeBrewingApp(),
    ),
  );
}
```

- [ ] **Step 2: Update app.dart (minimal change - routing stays same)**

- [ ] **Step 3: Commit**

```bash
git add lib/main.dart lib/app.dart && git commit -m "chore: update main.dart for BLoC providers"
```

---

### Task 11: Update Bean Screens to use BLoC

**Files:**
- Modify: `lib/presentation/screens/beans/bean_list_screen.dart`
- Modify: `lib/presentation/screens/beans/add_bean_screen.dart`
- Modify: `lib/presentation/screens/beans/bean_detail_screen.dart`

- [ ] **Step 1: Update BeanListScreen to use BlocConsumer**

```dart
// lib/presentation/screens/beans/bean_list_screen.dart (update pattern)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../providers/beans_provider.dart'; // Remove after refactor
import '../../../features/beans/presentation/bloc/beans_bloc.dart';
import '../../../features/beans/presentation/bloc/beans_event.dart';
import '../../../features/beans/presentation/bloc/beans_state.dart';
import '../../widgets/bean_card.dart';

class BeanListScreen extends StatelessWidget {
  const BeanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Beans')),
      body: BlocConsumer<BeansBloc, BeansState>(
        listener: (context, state) {
          if (state is BeansError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BeansLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BeansSuccess) {
            if (state.beans.isEmpty) {
              return const Center(child: Text('No beans yet'));
            }
            return ListView.builder(
              itemCount: state.beans.length,
              itemBuilder: (context, index) {
                final bean = state.beans[index];
                return BeanCard(
                  bean: bean,
                  onTap: () => context.push('/beans/${bean.id}'),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/beans/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

- [ ] **Step 2: Update AddBeanScreen and BeanDetailScreen similarly**

- [ ] **Step 3: Commit**

```bash
git add lib/presentation/screens/beans/ && git commit -m "refactor(beans): update screens to use BLoC"
```

---

### Task 12: Update Brew Screens to use BLoC

**Files:**
- Modify: `lib/presentation/screens/brew/new_brew_screen.dart`
- Modify: `lib/presentation/screens/brew/brew_timer_screen.dart`
- Modify: `lib/presentation/screens/brew/brew_history_screen.dart`

- [ ] **Step 1-3: Update screens to use BrewBloc**

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/screens/brew/ && git commit -m "refactor(brew): update screens to use BLoC"
```

---

## Phase 6: Cleanup

### Task 13: Remove Riverpod Providers

**Files:**
- Delete: `lib/presentation/providers/beans_provider.dart`
- Delete: `lib/presentation/providers/brew_logs_provider.dart`
- Delete: `lib/presentation/providers/brew_timer_provider.dart`

- [ ] **Step 1: Remove provider files**

```bash
rm lib/presentation/providers/beans_provider.dart
rm lib/presentation/providers/brew_logs_provider.dart
rm lib/presentation/providers/brew_timer_provider.dart
```

- [ ] **Step 2: Commit**

```bash
git rm lib/presentation/providers/beans_provider.dart lib/presentation/providers/brew_logs_provider.dart lib/presentation/providers/brew_timer_provider.dart && git commit -m "refactor: remove Riverpod providers after BLoC migration"
```

---

## Summary

| Task | Description |
|------|-------------|
| 1 | Update pubspec.yaml with dependencies |
| 2 | Create Drift Database |
| 3 | Create Dependency Injection (get_it) |
| 4 | Create Beans Use Cases |
| 5 | Create Brew Use Cases |
| 6 | Create Beans Data Layer |
| 7 | Create Brew Data Layer |
| 8 | Create Beans BLoC |
| 9 | Create Brew BLoC |
| 10 | Update main.dart and app.dart |
| 11 | Update Bean Screens |
| 12 | Update Brew Screens |
| 13 | Remove Riverpod Providers |

---

## Self-Review Checklist

- [ ] All dependencies specified in pubspec.yaml
- [ ] Drift database generates .g.dart file
- [ ] get_it injection registers all dependencies
- [ ] Use Cases follow single responsibility
- [ ] BLoC pattern: Loading → Success/Error
- [ ] Equatable used on all Events/States
- [ ] Repository implementations match interfaces
- [ ] Screens updated to use BlocConsumer
- [ ] Old providers removed

---

## Execution Options

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
