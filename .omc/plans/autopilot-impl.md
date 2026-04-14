# Clean Architecture Refactor - Implementation Plan

## Overview
Refactor the Coffee Brewing Companion Flutter app from hybrid Riverpod/BLoC to full Clean Architecture with BLoC state management and Drift database.

---

## Phase 1: Foundation Setup

### 1.1 Update Dependencies
**Files**: `pubspec.yaml`
**Changes**:
- Add `flutter_bloc: ^8.1.0`
- Add `equatable: ^2.0.5`
- Add `drift: ^2.30.0`
- Add `drift_flutter: ^0.2.8`
- Add `path_provider: ^2.1.5`
- Add `get_it: ^8.0.0`
- Remove `flutter_riverpod` (not needed)
- Remove `uuid` (Drift handles IDs)
**Add dev_dependencies**:
- `drift_dev: ^2.30.0`
- `build_runner: ^2.10.4`

### 1.2 Create Database Configuration
**File**: `lib/database.dart`
- Create Drift `AppDatabase` class
- Define `BeansTable` with auto-increment id, name, origin, roastLevel, flavorNotes, weightRemaining, createdAt
- Define `BrewLogsTable` with id, beanId, brewMethod, coffeeWeight, waterWeight, temperature, grindSize, brewTime, rating, notes, createdAt

### 1.3 Create Dependency Injection
**File**: `lib/injection.dart`
- Setup GetIt service locator
- Register AppDatabase as lazy singleton
- Register all datasources
- Register all repositories
- Register all use cases (factory)
- Register all BLoCs (factory)

### 1.4 Create Core Layer
**Files**:
- `lib/core/error/failures.dart` - Failure class for error handling
- `lib/core/error/exceptions.dart` - Exception classes
- `lib/core/constants/brew_methods.dart` - Keep existing
- `lib/core/constants/flavor_tags.dart` - Keep existing
- `lib/core/theme/app_theme.dart` - Keep existing

---

## Phase 2: Beans Feature

### 2.1 Domain Layer
**Files**:
- `lib/features/beans/domain/entities/bean.dart` - Bean entity (copy from existing)
- `lib/features/beans/domain/repositories/bean_repository.dart` - Abstract interface
- `lib/features/beans/domain/usecases/get_beans.dart`
- `lib/features/beans/domain/usecases/get_bean_by_id.dart`
- `lib/features/beans/domain/usecases/create_bean.dart`
- `lib/features/beans/domain/usecases/update_bean.dart`
- `lib/features/beans/domain/usecases/delete_bean.dart`

### 2.2 Data Layer
**Files**:
- `lib/features/beans/data/models/bean_dto.dart` - BeanDTO with toEntity(), fromEntity()
- `lib/features/beans/data/datasources/beans_drift_datasource.dart` - Drift data source
- `lib/features/beans/data/repositories/bean_repository_impl.dart` - Repository implementation

### 2.3 Presentation Layer
**Files**:
- `lib/features/beans/presentation/bloc/beans_event.dart` - Events: BeansRequested, BeanCreated, BeanDeleted, BeanUpdated
- `lib/features/beans/presentation/bloc/beans_state.dart` - States: BeansInitial, BeansLoading, BeansSuccess, BeansError
- `lib/features/beans/presentation/bloc/beans_bloc.dart` - BLoC implementation
- `lib/features/beans/presentation/screens/bean_list_screen.dart` - Main list screen
- `lib/features/beans/presentation/screens/bean_detail_screen.dart` - Detail screen
- `lib/features/beans/presentation/screens/add_bean_screen.dart` - Add/Edit screen
- `lib/features/beans/presentation/widgets/bean_card.dart` - Bean card widget (keep from existing)

---

## Phase 3: Brew Feature

### 3.1 Domain Layer
**Files**:
- `lib/features/brew/domain/entities/brew_log.dart`
- `lib/features/brew/domain/entities/brew_guide.dart`
- `lib/features/brew/domain/entities/recipe.dart`
- `lib/features/brew/domain/repositories/brew_repository.dart`
- `lib/features/brew/domain/usecases/get_brew_logs.dart`
- `lib/features/brew/domain/usecases/create_brew_log.dart`
- `lib/features/brew/domain/usecases/delete_brew_log.dart`

### 3.2 Data Layer
**Files**:
- `lib/features/brew/data/models/brew_log_dto.dart`
- `lib/features/brew/data/datasources/brew_logs_drift_datasource.dart`
- `lib/features/brew/data/repositories/brew_repository_impl.dart`

### 3.3 Presentation Layer
**Files**:
- `lib/features/brew/presentation/bloc/brew_event.dart`
- `lib/features/brew/presentation/bloc/brew_state.dart`
- `lib/features/brew/presentation/bloc/brew_bloc.dart`
- `lib/features/brew/presentation/screens/new_brew_screen.dart`
- `lib/features/brew/presentation/screens/brew_timer_screen.dart`
- `lib/features/brew/presentation/screens/brew_history_screen.dart`
- `lib/features/brew/presentation/widgets/brew_guide_card.dart`

---

## Phase 4: Shared Presentation

### 4.1 Screens
**Files**:
- `lib/presentation/screens/splash_screen.dart` - Keep existing
- `lib/presentation/screens/home/home_screen.dart` - Keep existing
- `lib/presentation/screens/home/widgets/home_content.dart` - Keep existing
- `lib/presentation/screens/profile/profile_screen.dart` - Keep existing

### 4.2 Shared Widgets
**Files**:
- `lib/presentation/widgets/rating_input.dart` - Keep existing
- `lib/presentation/widgets/sliders.dart` - Keep existing
- `lib/presentation/widgets/timer_display.dart` - Keep existing

### 4.3 Providers (timer-specific, not state management)
**Files**:
- `lib/presentation/providers/brew_timer_provider.dart` - Timer logic (not state management)

---

## Phase 5: App Configuration

### 5.1 Update GoRouter
**File**: `lib/app.dart`
- Update imports to use new screen locations
- Routes stay the same path structure

### 5.2 Update Main Entry
**File**: `lib/main.dart`
- Replace ProviderScope with MultiBlocProvider
- Call `setupDependencies()` before runApp
- Inject BeansBloc and BrewBloc

### 5.3 Update Theme
**File**: `lib/core/theme/app_theme.dart`
- Ensure dark mode default
- Keep google_fonts

---

## Phase 6: Code Generation & Build

### 6.1 Run Drift Code Generation
```bash
dart run build_runner build
```

### 6.2 Verify Build
```bash
flutter build apk --debug
```

### 6.3 Run Tests
```bash
flutter test
```

---

## File Deletion Checklist
Remove old files after migration:
- `lib/domain/` (old domain layer - will be replaced by features/domain/)
- `lib/presentation/providers/beans_provider.dart` (replaced by BLoC)
- `lib/presentation/providers/brew_logs_provider.dart` (replaced by BLoC)
- `lib/core/utils/extraction_calculator.dart` (if no longer used)

---

## Risk Mitigation
1. **Work in worktree**: Use `.worktrees/clean-arch-refactor/` to avoid disrupting master
2. **Incremental verification**: Build after each feature migration
3. **Keep screens working**: Presentation layer is last to change to minimize break risk
4. **Test after each phase**: Don't wait until end to test