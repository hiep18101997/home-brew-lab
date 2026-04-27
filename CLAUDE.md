# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter app for home baristas to track coffee beans, log brews, and follow brew guides with an integrated timer.

## Common Commands

```bash
flutter pub get          # Install dependencies
flutter run             # Run on connected device/emulator
flutter test            # Run all tests
flutter test test/widget_test.dart  # Run a specific test
flutter build apk --debug   # Build debug APK (Android)
flutter build ios --debug    # Build debug IPA (iOS)
```

## Architecture

### State Management
- **BLoC** for state management via `flutter_bloc`
- BLoCs in `lib/features/{feature}/presentation/bloc/`

### Navigation
- **GoRouter** configured in `lib/app.dart`
- Routes: `/` (splash), `/home`, `/beans`, `/beans/add`, `/beans/:id`, `/brew`, `/brew/timer`, `/brew/history`, `/analytics`, `/recipes`, `/profile`

### Code Structure (Clean Architecture)
```
lib/
├── main.dart              # Entry point with MultiBlocProvider
├── app.dart               # GoRouter config, CoffeeBrewingApp
├── injection.dart         # GetIt dependency injection
├── database.dart          # Drift SQLite database
├── core/                  # Theme, constants, utilities, error handling
├── features/              # Feature modules (Clean Architecture)
│   ├── beans/
│   │   ├── domain/        # Entities, repositories, use cases
│   │   ├── data/          # DTOs, data sources, repository impls
│   │   └── presentation/ # BLoC, screens, widgets
│   ├── brew/
│   ├── recipe/
│   ├── grinder/
│   └── analytics/
└── presentation/          # Shared UI (navigation shell, shared widgets)
```

### Key Entities
- **Bean** - coffee bean with origin, roast level, flavor notes, weight
- **BrewLog** - individual brew session record with method, dose/yield, rating
- **BrewGuide** - predefined step-by-step brew guides
- **Recipe** - saved brewing recipes with grind settings
- **GrinderProfile** - grinder models with recommended settings per method
- **AnalyticsData** - aggregated brew statistics

### Theme
Dark mode default. Uses `google_fonts`. Light/dark configured in `lib/core/theme/app_theme.dart`.

## Tech Stack
- Flutter SDK `^3.11.4`
- flutter_bloc `^8.1.0` - State management
- equatable `^2.0.5` - Value equality
- drift `^2.30.0` - SQLite ORM
- drift_flutter `^0.2.8` - Drift Flutter integration
- get_it `^8.0.0` - Dependency injection
- go_router `^13.0.0` - Navigation
- google_fonts `^6.1.0` - Typography (Manrope + Noto Serif)
- fl_chart `^0.66.0` - Charts for analytics
- uuid `^4.2.1` - ID generation
