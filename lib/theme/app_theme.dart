import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System v3 type scale.
class OasisTextTheme {
  static final TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    textStyle: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1.2),
  );
  static final TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
  );
  static final TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.4),
  );
  static final TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, height: 1.4),
  );
  static final TextStyle buttonLabel = GoogleFonts.plusJakartaSans(
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.0),
  );
}

/// Spacing constants. Base unit 4px.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

class AppTheme {
  AppTheme._();

  // Updated Core brand colors matching your exact palette swatches
  static const Color primaryColor = Color(0xFFA22525);      // #A22525 (Primary)
  static const Color secondaryColor = Color(0xFF2ECC71);    // #2ECC71 (Secondary)
  static const Color backgroundColor = Color(0xFFFCFCFC);   // #FCFCFC (Background)
  static const Color surfaceColor = Color(0xFFFFFFFF);      // Cards & Sheets
  static const Color errorColor = Color(0xFFEE0000);        // #EE0000 (Error)
  static const Color textColor = Color(0xFF2C3E50);         // #2C3E50 (Text)

  // Feature accent palette matching your color sheet
  static const Color accentSun = Color(0xFFF1C40F);         // #F1C40F (Accent Yellow)
  static const Color accentWater = Color(0xFF3498DB);       // #3498DB (Accent Blue)
  static const Color accentBloom = Color(0xFFE84393);       // #E84393 (Accent Pink)
  static const Color accentFlora = Color(0xFF9B59B6);       // #9B59B6 (Accent Purple)

  // Tint tokens
  static const Color ringTrack = Color(0x26A22525);         // primary at 15%
  static const Color thumbTint = Color(0x242ECC71);         // secondary at 14%
  static const Color outline = Color(0x4D2C3E50);           // onSurface at 30%
  static const Color hairline = Color(0x1F2C3E50);          // onSurface at 12%
  static const Color disabledFill = Color(0x1F2C3E50);      // onSurface at 12%
  static const Color disabledText = Color(0x732C3E50);      // onSurface at 45%
  static const Color scrim = Color(0x802C3E50);             // onSurface at 50%

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: OasisTextTheme.displayLarge,
        headlineSmall: OasisTextTheme.headlineSmall,
        bodyMedium: OasisTextTheme.bodyMedium,
        labelSmall: OasisTextTheme.labelSmall,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        surfaceTintColor: Colors.transparent, // Prevents unwanted M3 pinkish washes
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: disabledFill,
          disabledForegroundColor: disabledText,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: OasisTextTheme.buttonLabel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: errorColor,
          side: const BorderSide(color: errorColor, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: OasisTextTheme.buttonLabel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}