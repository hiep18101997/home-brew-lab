# Brew Analytics Dashboard - Feature Specification

**Date**: 2026-04-15
**Status**: Draft

---

## 1. Overview

Thêm **Brew Analytics Dashboard** - một màn hình mới hiển thị insights và visualizations từ brew history data.

## 2. Screens

- New: `/analytics` route
- Add Analytics tab to bottom navigation

## 3. Dependencies

```yaml
fl_chart: ^0.66.0
```

## 4. Files to Create

- `lib/presentation/screens/analytics/analytics_screen.dart`
- `lib/presentation/providers/analytics_provider.dart`

## 5. Files to Modify

- `pubspec.yaml` - add fl_chart
- `lib/app.dart` - add route
- `lib/presentation/screens/home/home_screen.dart` - add tab

## 6. Features

### A. Summary Stats
- Total brews, Average rating, Favorite method, Beans used

### B. Brews Per Week Chart
- Bar chart (last 8 weeks)

### C. Method Distribution
- Pie chart

### D. Rating Trend
- Line chart (last 30 days)

### E. Bean Usage
- Consumption tracking, "Brews left" estimate
