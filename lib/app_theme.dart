import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Palette
  static const Color primary = Color(0xFFA22525);
  static const Color secondaryAccent = Color(0xFF81E4AA);
  static const Color background = Color(0xFFFCFCFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFEE0000);
  static const Color onBackgroundText = Color(0xFF2C3E50);

  // Accents Palette
  static const Color waterBlue = Color(0xFF3498DB);
  static const Color sunGold = Color(0xFFF1C40F);
  static const Color blossomPink = Color(0xFFE84393);
  static const Color mysticFlora = Color(0xFF9B59B6);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondaryAccent,
        onSecondary: onBackgroundText,
        surface: surface,
        onSurface: onBackgroundText,
        error: error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 2,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme,
      ),
    );
  }
}