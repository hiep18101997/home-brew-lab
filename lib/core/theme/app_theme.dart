import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Design System: "The Articulated Pour" Dark Mode
class AppColors {
  // Backgrounds
  static const background = Color(0xFF161312);     // Deep Espresso
  static const surfaceContainerLowest = Color(0xFF100E0D);
  static const surfaceContainerLow = Color(0xFF1E1B1A);
  static const surfaceContainer = Color(0xFF221F1E);
  static const surfaceContainerHigh = Color(0xFF2D2928);
  static const surfaceContainerHighest = Color(0xFF383433);
  static const surfaceBright = Color(0xFF3C3837);
  static const surfaceDim = Color(0xFF161312);

  // Primary
  static const primary = Color(0xFFCFC4C0);
  static const primaryContainer = Color(0xFF322C29);
  static const onPrimary = Color(0xFF352F2D);
  static const onPrimaryContainer = Color(0xFF9C928F);
  static const primaryFixed = Color(0xFFECE0DC);
  static const primaryFixedDim = Color(0xFFCFC4C0);

  // Secondary (Golden Amber - CTAs)
  static const secondary = Color(0xFFFFD799);
  static const secondaryContainer = Color(0xFFFEB300);
  static const onSecondary = Color(0xFF432C00);
  static const onSecondaryContainer = Color(0xFF6A4800);
  static const secondaryFixed = Color(0xFFFFDEAC);
  static const secondaryFixedDim = Color(0xFFFFBA38);

  // Tertiary
  static const tertiary = Color(0xFFE4BEB2);
  static const tertiaryContainer = Color(0xFF3E271E);
  static const onTertiary = Color(0xFF422B22);
  static const onTertiaryContainer = Color(0xFFAE8D81);
  static const tertiaryFixed = Color(0xFFFFDBCE);
  static const tertiaryFixedDim = Color(0xFFE4BEB2);

  // Text
  static const onSurface = Color(0xFFE9E1DF);
  static const onSurfaceVariant = Color(0xFFD3C3C0);

  // Error
  static const error = Color(0xFFFFB4AB);
  static const errorContainer = Color(0xFF93000A);
  static const onError = Color(0xFF690005);
  static const onErrorContainer = Color(0xFFFFDAD6);

  // Utility
  static const outline = Color(0xFF9C8D8B);
  static const outlineVariant = Color(0xFF504442);
  static const surfaceTint = Color(0xFFCFC4C0);
  static const inverseSurface = Color(0xFFE9E1DF);
  static const inverseOnSurface = Color(0xFF33302E);
  static const inversePrimary = Color(0xFF655D5A);
}

class AppTheme {
  // Dark Theme
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.background,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLow,
        indicatorColor: AppColors.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        contentTextStyle: TextStyle(color: AppColors.onSurface),
      ),
    );
  }

  // Light Theme - minimal implementation
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryContainer,
        onPrimary: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.background,
        onSurface: AppColors.onSurface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.notoSerif(
        fontSize: 72,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        letterSpacing: -2,
      ),
      displayMedium: GoogleFonts.notoSerif(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        letterSpacing: -1,
      ),
      displaySmall: GoogleFonts.notoSerif(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      headlineLarge: GoogleFonts.notoSerif(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      headlineMedium: GoogleFonts.notoSerif(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      headlineSmall: GoogleFonts.notoSerif(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}
