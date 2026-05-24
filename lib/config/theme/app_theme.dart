import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF09090B); // Shadcn black
  static const Color backgroundColor = Color(0xFFFFFFFF); // Shadcn pure white
  static const Color borderColor = Color(0xFFE4E4E7); // Shadcn border gray
  static const Color textColor = Color(0xFF09090B);
  static const Color subtitleColor = Color(0xFF71717A); // Shadcn muted text

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      splashColor: Colors.transparent, // Disable ripples for Shadcn feel
      highlightColor: Colors.transparent,
      
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(color: textColor, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1.0),
        headlineMedium: GoogleFonts.inter(color: textColor, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.5),
        titleLarge: GoogleFonts.inter(color: textColor, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.5),
        bodyLarge: GoogleFonts.inter(color: textColor, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: subtitleColor, fontSize: 14),
      ),

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        surface: backgroundColor,
        onSurface: textColor,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          splashFactory: NoSplash.splashFactory, // Shadcn buttons don't ripple
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Shadcn h-10 px-4 py-2 equivalent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: borderColor, width: 1),
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent, // Shadcn inputs are transparent
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        hintStyle: GoogleFonts.inter(color: subtitleColor, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: subtitleColor, fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.never, // Shadcn prefers placeholders over floating labels
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primaryColor, width: 1.5), // Shadcn ring
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}