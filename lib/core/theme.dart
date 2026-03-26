import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Naming is kept for compatibility with current widgets, but the palette is
  // tuned to Kamakura Shinsho's bright yellow-green brand direction.
  static const Color primaryBlue = Color(0xFF8FC31F);
  static const Color primaryBlueDeep = Color(0xFF5E8E12);
  static const Color primaryBlueSoft = Color(0xFFF2F8DE);
  static const Color accentGold = Color(0xFFD6E96A);
  static const Color accentGoldSoft = Color(0xFFF7FBD9);
  static const Color backgroundWhite = Color(0xFFFBFDF5);
  static const Color surfaceWhite = Colors.white;
  static const Color borderSoft = Color(0xFFDCE7BF);
  static const Color textPrimary = Color(0xFF304312);
  static const Color textSecondary = Color(0xFF6C7E42);
  static const Color successGreen = Color(0xFF2F7D5C);
  static const Color warningAmber = Color(0xFFC48A1A);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8FC31F),
      Color(0xFFB6D94C),
      Color(0xFFF3F8C9),
    ],
  );

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
        primaryContainer: primaryBlueSoft,
        secondaryContainer: accentGoldSoft,
        onSurface: textPrimary,
        outline: borderSoft,
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
        backgroundColor: backgroundWhite,
        foregroundColor: primaryBlue,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderSoft),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: primaryBlueSoft,
        selectedColor: accentGold.withValues(alpha: 0.18),
        labelStyle: textTheme.labelLarge,
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderSoft),
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
      dividerColor: borderSoft,
    );
  }
}
