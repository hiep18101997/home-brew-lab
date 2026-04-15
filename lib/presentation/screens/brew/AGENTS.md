<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-15 -->

# presentation/screens/brew

## Purpose
Brew tracking screens - new brew configuration, active timer, and brew history.

## Key Files

| File | Description |
|------|-------------|
| `new_brew_screen.dart` | Configure brew parameters and start timer |
| `brew_timer_screen.dart` | Active brew timer with step progression |
| `brew_history_screen.dart` | List of past brew sessions |

## For AI Agents

### Working In This Directory
- `brewTimerProvider` manages active brew state with steps
- `brewLogsProvider` persists brew history to JSON
- Timer uses `SingleTickerProviderStateMixin` for pulse animation

### Brew Timer Flow
1. User configures in `new_brew_screen.dart`
2. `brewTimerProvider.startBrew()` initializes timer
3. `brew_timer_screen.dart` shows circular progress and current step
4. On finish, brew log saved via `brewLogsProvider.addBrewLog()`

<!-- MANUAL: -->