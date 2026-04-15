<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-15 -->

# core

## Purpose
Centralized theme, constants, and utility functions used throughout the app.

## Key Files

| File | Description |
|------|-------------|
| `theme/app_theme.dart` | Dark theme configuration with Material 3 design tokens |
| `constants/brew_methods.dart` | Brew method enum (V60, Chemex, Espresso, etc.) with defaults |
| `constants/flavor_tags.dart` | Predefined flavor tags for brew logs |
| `utils/extraction_calculator.dart` | TDS and extraction yield calculations |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `core/constants/` | Brew method enum and flavor tags |
| `core/theme/` | App-wide dark theme configuration |
| `core/utils/` | Extraction calculation utilities |

## For AI Agents

### Working In This Directory
- AppColors and AppTheme are imported from `app_theme.dart`
- All screens use `AppColors.background`, `AppColors.surfaceContainerLow`, etc.
- BrewMethod enum values have `displayName` and default doses/yields

### Color System
- Background: `#121212`
- Surface: `#1E1E1E`
- Primary: `#D4A574` (coffee brown)
- Secondary: `#8B6914` (dark gold)
- OnSurface: `#E8E8E8`

### Testing
- Theme changes can be verified by building the app

<!-- MANUAL: -->