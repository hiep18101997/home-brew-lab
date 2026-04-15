<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-04-15 -->

# presentation/screens/home

## Purpose
Main navigation shell with bottom navigation bar containing 6 tabs.

## Key Files

| File | Description |
|------|-------------|
| `home_screen.dart` | Main scaffold with IndexedStack navigation |
| `widgets/home_content.dart` | Home tab dashboard content |

## For AI Agents

### Working In This Directory
- Uses `IndexedStack` to preserve screen state across tab switches
- `_PolishedNavBar` is custom bottom navigation with 6 items
- Navigation index controlled by `_currentIndex` state

### Tab Order
0. Home (HomeContent)
1. Beans (BeanListScreen)
2. History (BrewHistoryScreen)
3. Analytics (AnalyticsScreen)
4. Recipes (RecipeFinderScreen)
5. Profile (ProfileScreen)

<!-- MANUAL: -->