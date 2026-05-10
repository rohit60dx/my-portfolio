// lib/utils/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF00D4FF);
  static const Color secondary = Color(0xFF7C3AED);
  static const Color accent = Color(0xFF06FFA5);
  static const Color bg = Color(0xFF050B15);
  static const Color bgCard = Color(0xFF0D1926);
  static const Color bgCard2 = Color(0xFF111827);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color border = Color(0xFF1E3A5F);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: bgCard,
        background: bg,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.orbitron(
              color: textPrimary,
              fontWeight: FontWeight.w900,
            ),
            displayMedium: GoogleFonts.orbitron(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ),
            headlineLarge: GoogleFonts.spaceGrotesk(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ),
            bodyLarge: GoogleFonts.inter(color: textPrimary, fontSize: 16),
            bodyMedium: GoogleFonts.inter(color: textSecondary, fontSize: 14),
          ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
    );
  }
}

// Gradient presets
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppTheme.primary, AppTheme.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppTheme.accent, AppTheme.primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0D1926), Color(0xFF111827)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
