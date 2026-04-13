import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6F4E37),    // Coffee brown
        secondary: Color(0xFFD4A574), // Latte
        surface: Color(0xFFFFFBF5),   // Cream white
        onSurface: Color(0xFF1C1917),  // Dark brown
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );
  }

  // Dark Theme
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD4A574),    // Latte (amber accent on dark)
        secondary: Color(0xFF8B6914),  // Caramel
        surface: Color(0xFF1C1917),    // Dark brown
        onSurface: Color(0xFFFFFBF5),  // Cream white
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
}
