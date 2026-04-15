# Coffee Brewing Companion

Ứng dụng Flutter dành cho home barista để quản lý beans, log brews và theo dõi hướng dẫn pha chế với timer tích hợp.

## Tính năng

### Beans Management
- Lưu trữ thông tin beans: origin, roast level, flavor notes
- Chụp ảnh beans với background removal
- Mẫu dữ liệu 3 beans để test UI

### Brew Timer & Tracking
- Timer với các bước pha chế (bloom, pour, drawdown)
- Theo dõi thông số: grind size, water temperature, brew ratio, yield
- Lưu lịch sử brew sessions

### Brew Analytics Dashboard
- Thống kê tổng quan: tổng brews, beans, favorite method
- Biểu đồ brew theo thời gian
- Phân tích ratios và preferences

### Recipe Finder by Equipment
- Tìm kiếm công thức theo thiết bị xay (1Zpresso, Timemore, HELGE, v.v.)
- Lọc theo phương pháp pha (V60, Phin, Espresso, French Press, AeroPress, Cold Brew)
- 23+ mẫu máy xay với settings cho 6 brew methods

## Tech Stack

- **Flutter** `^3.11.4`
- **Riverpod** `^2.4.9` - State management
- **GoRouter** `^13.0.0` - Navigation
- **google_fonts** `^6.1.0` - Typography (Manrope, Noto Serif)
- **fl_chart** `^0.66.2` - Analytics charts
- **ML Kit** - Background removal cho ảnh beans

## Cấu trúc dự án

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # GoRouter configuration
├── core/                        # Theme, constants
├── domain/                      # Entities & repositories
│   ├── entities/                # Bean, BrewLog, BrewGuide, Recipe
│   └── repositories/            # Data interfaces
├── data/                        # Implementations
│   └── grinder_settings_repository.dart
└── presentation/
    ├── providers/               # Riverpod StateNotifiers
    ├── screens/                 # Full pages
    │   ├── home/                # Main navigation
    │   ├── beans/               # Bean inventory
    │   ├── brew/                # Brew timer & history
    │   ├── analytics/           # Dashboard
    │   ├── recipes/             # Recipe finder
    │   └── profile/             # Settings
    └── widgets/                 # Reusable components
```

## Phát triển

```bash
# Cài đặt dependencies
flutter pub get

# Chạy trên device/emulator
flutter run

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release
```

## Navigation

| Route | Screen |
|-------|--------|
| `/` | Splash |
| `/home` | Home (main shell) |
| `/beans` | Bean List |
| `/beans/add` | Add Bean |
| `/beans/:id` | Bean Detail |
| `/brew` | New Brew |
| `/brew/timer` | Brew Timer |
| `/brew/history` | Brew History |
| `/analytics` | Analytics Dashboard |
| `/recipes` | Recipe Finder |
| `/profile` | Profile Settings |

## CI/CD

GitHub Actions tự động build và deploy lên DeployGate khi push lên master branch.

## Giao diện

Dark mode default. Sử dụng Manrope cho body text và Noto Serif cho display text.

---

Made with Flutter + ❤️ for the Vietnamese coffee community
