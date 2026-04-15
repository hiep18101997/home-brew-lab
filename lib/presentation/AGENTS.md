<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-15 -->

# presentation

## Purpose
UI layer containing Riverpod providers for state management, screens for each route, and reusable widgets.

## Key Files

| File | Description |
|------|-------------|
| `providers/beans_provider.dart` | StateNotifier for beans list with file persistence |
| `providers/brew_logs_provider.dart` | StateNotifier for brew logs with file persistence |
| `providers/brew_timer_provider.dart` | Timer state management for brew sessions |
| `providers/analytics_provider.dart` | Computed analytics from brew history |
| `providers/grinder_settings_provider.dart` | Riverpod for grinder settings data |
| `screens/home/home_screen.dart` | Main navigation with bottom nav bar |
| `screens/beans/bean_list_screen.dart` | Bean inventory list view |
| `screens/brew/brew_timer_screen.dart` | Active brew timer with step progression |
| `screens/recipes/recipe_finder_screen.dart` | Equipment-based recipe search |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `presentation/providers/` | Riverpod providers for state management |
| `presentation/screens/` | Full-page screens (home, beans, brew, profile, recipes) |
| `presentation/widgets/` | Reusable UI components |
| `presentation/screens/home/widgets/` | Home screen specific widgets |

## For AI Agents

### Working In This Directory
- Providers use `StateNotifier` with `AsyncValue<List<T>>` for loading/error/data states
- Screens use `ConsumerStatefulWidget` or `ConsumerWidget` with Riverpod
- GoRouter handles navigation - no manual Navigator.push

### Provider Patterns
```dart
// StateNotifier pattern
final someProvider = StateNotifierProvider<SomeNotifier, AsyncValue<List<Item>>>((ref) {
  return SomeNotifier(ref.watch(repositoryProvider));
});

// Reading in widget
final items = ref.watch(someProvider);
items.when(data: (list) => ..., loading: () => ..., error: (e, _) => ...);
```

### Navigation
- Screens are indexed in HomeScreen's `_screens` list
- Bottom nav uses `_PolishedNavBar` with 6 tabs

### Testing
- Provider tests can use overrideWith for testing different states
- Widget tests need `ProviderScope` wrapper

<!-- MANUAL: -->