<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-15 -->

# domain

## Purpose
Business logic layer - entities defining data models and repository interfaces for data access.

## Key Files

| File | Description |
|------|-------------|
| `entities/bean.dart` | Coffee bean model with name, roaster, origin, weight |
| `entities/brew_log.dart` | Brew session record with method, dose, yield, rating |
| `entities/brew_guide.dart` | Brew method parameters (ratio, temperature, grind, steps) |
| `entities/grinder_profile.dart` | Grinder brand/settings for recipe matching |
| `entities/recipe.dart` | Saved brewing recipe |
| `repositories/bean_repository.dart` | Abstract interface for bean CRUD |
| `repositories/brew_repository.dart` | Abstract interface for brew log CRUD |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `domain/entities/` | Data models (Bean, BrewLog, BrewGuide, etc.) |
| `domain/repositories/` | Abstract repository interfaces |
| `domain/constants/` | Additional domain constants |

## For AI Agents

### Working In This Directory
- Entities are immutable data classes with `copyWith` methods
- Repository interfaces define async operations (getAll, create, update, delete)
- Implementations are in `lib/data/` directory

### Entity Patterns
- `Bean` has `weightRemaining` tracking for inventory
- `BrewLog` has `brewTime` as Duration and optional `rating` (1-5)
- `BrewGuide` contains step-by-step brewing instructions with water amounts

### Testing
- Entity changes should be tested via provider tests

<!-- MANUAL: -->