<!-- Generated: 2026-04-15 | Updated: 2026-04-15 -->

# home-brew-lab

## Purpose
Flutter application for home baristas to track coffee beans, log brews, follow brew guides with an integrated timer, and discover recipes by equipment.

## Key Files

| File | Description |
|------|-------------|
| `pubspec.yaml` | Flutter project manifest with dependencies |
| `lib/main.dart` | App entry point with ProviderScope |
| `lib/app.dart` | GoRouter configuration and CoffeeBrewingApp |
| `android/` | Android-specific configuration and build files |
| `CLAUDE.md` | Claude Code instructions for this codebase |
| `.github/workflows/deploy.yml` | GitHub Actions CI/CD for DeployGate deployment |

## Architecture

```
lib/
├── main.dart              # Entry point
├── app.dart               # GoRouter + theme
├── core/                  # Theme, constants, utilities
├── domain/                # Entities & repository interfaces
├── data/                  # Repository implementations
└── presentation/           # UI (providers, screens, widgets)
```

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `lib/core/` | App theme, constants, utilities (see `lib/core/AGENTS.md`) |
| `lib/domain/` | Business entities and repository interfaces (see `lib/domain/AGENTS.md`) |
| `lib/data/` | Repository implementations (see `lib/data/AGENTS.md`) |
| `lib/presentation/` | UI layer - providers, screens, widgets (see `lib/presentation/AGENTS.md`) |

## For AI Agents

### Working In This Project
- Run `flutter pub get` after modifying pubspec.yaml
- Use `flutter build apk --debug` for debug builds
- Dark mode is default - theme configured in `lib/core/theme/app_theme.dart`

### State Management
- Riverpod via `flutter_riverpod` for all state
- Providers in `lib/presentation/providers/`
- Never use setState for app-wide state

### Navigation
- GoRouter configured in `lib/app.dart`
- Routes: `/` (splash), `/home`, `/beans`, `/beans/add`, `/beans/:id`, `/brew`, `/brew/timer`, `/brew/history`, `/profile`, `/recipes`

### Testing
- `flutter test` - run all tests
- `flutter test test/widget_test.dart` - run specific test

### Deployment
- GitHub Actions workflow at `.github/workflows/deploy.yml`
- DeployGate upload via REST API on push to master
- Requires `DEPLOYGATE_API_TOKEN` secret in GitHub repo

## Dependencies

### Key Packages
- `flutter_riverpod: ^2.4.9` - State management
- `go_router: ^13.0.0` - Navigation
- `google_fonts: ^6.1.0` - Typography (Noto Serif, Manrope)
- `uuid: ^4.2.1` - ID generation
- `intl: ^0.18.1` - Date formatting
- `path_provider: ^2.1.0` - File system paths
- `fl_chart: ^0.65.0` - Analytics charts

### Build Tools
- Flutter SDK `^3.11.4`
- Android Gradle plugin with Java 19

<!-- MANUAL: Coffee Brewing Companion - Vietnamese coffee community app -->