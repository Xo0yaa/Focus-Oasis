import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System v3 type scale.
/// See docs/DESIGN_SYSTEM_V3.pdf section V.
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
/// See docs/DESIGN_SYSTEM_V3.pdf section VI.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

class AppTheme {
  AppTheme._();

  // Core brand colors
  static const Color primaryColor = Color(0xFFE74C3C); // Active timer & main CTAs
  static const Color secondaryColor = Color(0xFF2ECC71); // Break state & success checks
  static const Color backgroundColor = Color(0xFFFCFCFC); // Main scaffold background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Cards, sheets & dialogs
  static const Color errorColor = Color(0xFFD9534F); // Reset outline & validation
  static const Color textColor = Color(0xFF2C3E50); // Titles & body text

  // Feature accent palette
  static const Color accentWater = Color(0xFF3498DB); // Water drop, bars, outlines
  static const Color accentSun = Color(0xFFF1C40F); // Daily streaks, New tags, badges
  static const Color accentBloom = Color(0xFFE84393); // Rare tags, collection bar
  static const Color accentFlora = Color(0xFF9B59B6); // Legendary tags

  // Tint tokens — existing colours at a fixed opacity. See Design System v3 section III.
  static const Color ringTrack = Color(0x26E74C3C); // primary at 15%
  static const Color thumbTint = Color(0x242ECC71); // secondary at 14%
  static const Color outline = Color(0x4D2C3E50); // onSurface at 30%
  static const Color hairline = Color(0x1F2C3E50); // onSurface at 12%
  static const Color disabledFill = Color(0x1F2C3E50); // onSurface at 12%
  static const Color disabledText = Color(0x732C3E50); // onSurface at 45%
  static const Color scrim = Color(0x802C3E50); // onSurface at 50%

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: textColor, // 5.23:1, passes AA
        tertiary: accentWater,
        onTertiary: Colors.white, // Water Blue is for icons/bars only, never text (3.15:1)
        error: errorColor,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: textColor,
      ),
      textTheme: TextTheme(
        displayLarge: OasisTextTheme.displayLarge,
        headlineSmall: OasisTextTheme.headlineSmall,
        bodyMedium: OasisTextTheme.bodyMedium,
        labelSmall: OasisTextTheme.labelSmall,
      ),
      // Material 3 washes every elevated surface (Card, AppBar, NavigationBar)
      // with a tint of colorScheme.primary by default. With primary = red,
      // that leaves white cards looking faintly pink instead of #FFFFFF —
      // a real difference from the flat colours in Design System v3, not
      // a mistake in the hex values themselves. surfaceTintColor:
      // Colors.transparent below turns that off everywhere.
      cardTheme: CardThemeData(
        color: surfaceColor,
        surfaceTintColor: Colors.transparent,
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
        elevation: 0,
        foregroundColor: textColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 76,
        indicatorColor: ringTrack,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return OasisTextTheme.labelSmall.copyWith(color: selected ? primaryColor : textColor);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? primaryColor : textColor, size: 24);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
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
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: surfaceColor,
          foregroundColor: textColor,
          selectedBackgroundColor: primaryColor,
          selectedForegroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          side: const BorderSide(color: outline, width: 1.5),
          textStyle: OasisTextTheme.buttonLabel,
        ),
      ),
    );
  }
}
