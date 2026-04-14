# Recipe Finder by Equipment - Feature Specification

**Date**: 2026-04-15
**Status**: Draft

---

## 1. Overview

Thêm mục **Recipe Finder** - cho phép user tìm kiếm và lọc công thức pha coffee theo:
- Máy pha (V60, Chemex, Espresso, AeroPress, French Press, Phin)
- Máy xay (bao gồm cả hãng Trung Quốc)
- Cỡ xay cho từng máy xay cụ thể

## 2. Grinder Brands (VN + International + Chinese)

### Taiwan/International
- **1Zpresso**: JX, JX-Pro, K-Plus, ZP6 Special
- **Commandante**: C40
- **Baratza**: Encore, Virtuoso
- **Hario**: Skerton, Mini Mill

### Chinese Brands
- **Timemore**: C2, C3, Slim, Black Mirror, Basil
- **HELGE**: H1, H2, H3
- **SSURE**: S1, S2, S3
- **巫师 (Wizard)**: M1, M2
- **Xiaomi**: Smart Grinder
- **CAFELATTI**: K1, K2

## 3. Files to Create

- `lib/domain/entities/grinder_profile.dart`
- `lib/data/grinder_settings_repository.dart`
- `lib/presentation/screens/recipes/recipe_finder_screen.dart`
- `lib/presentation/providers/grinder_settings_provider.dart`

## 4. Files to Modify

- `lib/app.dart` - Add `/recipes` route
- `lib/presentation/screens/home/home_screen.dart` - Add Recipes tab

## 5. UI Components

### Recipe Finder Screen
- Top: Method selector (chips) - all brew methods
- Middle: Grinder selection (Brand → Model dropdowns)
- Bottom: Recipe cards with grind settings

### Grinder Selection
- Brand dropdown (sorted by popularity)
- Model dropdown (dependent on brand)
- Shows recommended settings for selected method

### Recipe Card
- Method icon
- Dose/Yield
- Grind size (as clicks or number)
- Brew time
- Notes/tips
