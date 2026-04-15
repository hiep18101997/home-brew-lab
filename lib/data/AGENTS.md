<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-04-15 -->

# data

## Purpose
Repository implementations for data persistence and external data sources.

## Key Files

| File | Description |
|------|-------------|
| `grinder_settings_repository.dart` | Pre-populated grinder profiles for recipe matching |

## For AI Agents

### Working In This Directory
- Contains concrete repository implementations
- FilePersistentBeanRepository uses JSON files in app documents directory
- FilePersistentBrewRepository saves brew logs as JSON

### Persistence
- Beans: `beans_data.json` in app documents directory
- Brew logs: `brew_logs_data.json` in app documents directory
- Images: stored in `beans/` subdirectory

### Testing
- Run app to verify data persistence across restarts

<!-- MANUAL: -->