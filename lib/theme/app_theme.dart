import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central design tokens for the Rechitta app.
///
/// The look is a deep-black, high-contrast dark theme with an electric blue
/// accent and soft glows — mirroring the rechitta.com marketing site.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0C0D10);
  static const Color surfaceElevated = Color(0xFF141519);
  static const Color card = Color(0xFF16171C);

  // Brand blue
  static const Color blue = Color(0xFF1D6EF5);
  static const Color blueBright = Color(0xFF2F81FF);
  static const Color blueDeep = Color(0xFF0B3FA8);
  static const Color blueGlow = Color(0xFF2563EB);

  // Text
  static const Color textPrimary = Color(0xFFF5F6F8);
  static const Color textSecondary = Color(0xFF9BA0AB);
  static const Color textMuted = Color(0xFF62666F);

  // Accents used in cards / stats
  static const Color gold = Color(0xFFE0B15E);
  static const Color green = Color(0xFF35C48A);

  // Hairlines & borders
  static const Color border = Color(0xFF23252B);
  static const Color borderSoft = Color(0x14FFFFFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.blue,
        surface: AppColors.surface,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  /// Display font used for big headlines (geometric, tight).
  static TextStyle display({
    double size = 48,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.textPrimary,
    double letterSpacing = -1.0,
    double height = 1.02,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.5,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
