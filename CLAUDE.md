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
- **Riverpod** for state management via `flutter_riverpod`
- Providers in `lib/presentation/providers/`

### Navigation
- **GoRouter** configured in `lib/app.dart`
- Routes: `/` (splash), `/home`, `/beans`, `/beans/add`, `/beans/:id`, `/brew`, `/brew/timer`, `/brew/history`, `/profile`

### Code Structure
```
lib/
├── main.dart              # Entry point with ProviderScope
├── app.dart               # GoRouter config, CoffeeBrewingApp
├── core/                  # Theme, constants, utilities
├── domain/                # Entities & repositories (data layer)
│   ├── entities/          # Bean, BrewLog, BrewGuide, Recipe
│   └── repositories/      # BeanRepository, BrewRepository
└── presentation/          # UI layer
    ├── providers/         # Riverpod providers (state)
    ├── screens/           # Full pages
    └── widgets/           # Reusable components
```

### Key Entities
- **Bean** - coffee bean with origin, roast level, flavor notes
- **BrewLog** - individual brew session record
- **BrewGuide** - brewing method parameters (ratio, temperature, grind)
- **Recipe** - saved brewing recipe

### Theme
Dark mode default. Uses `google_fonts`. Light/dark configured in `lib/core/theme/app_theme.dart`.

## Tech Stack
- Flutter SDK `^3.11.4`
- flutter_riverpod `^2.4.9`
- go_router `^13.0.0`
- google_fonts `^6.1.0`
- uuid `^4.2.1`
- intl `^0.18.1`
