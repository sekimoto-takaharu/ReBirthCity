import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryBlue = Color(0xFF005599);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color backgroundWhite = Color(0xFFFDFEFF);
  static const Color surfaceWhite = Colors.white;
  static const Color textPrimary = Color(0xFF16324A);
  static const Color textSecondary = Color(0xFF587085);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentGold,
        surface: surfaceWhite,
        brightness: Brightness.light,
      ).copyWith(
        tertiary: accentGold,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundWhite,
    );

    final textTheme = GoogleFonts.notoSansJpTextTheme(base.textTheme).apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: primaryBlue,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE3EBF2)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFFEAF3FA),
        selectedColor: accentGold.withValues(alpha: 0.18),
        labelStyle: textTheme.labelLarge,
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD6E3EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD6E3EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
