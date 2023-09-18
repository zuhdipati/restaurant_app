import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFFFFFFF);
const Color secondaryColor = Color(0xFF6B38FB);

final TextTheme myTextTheme = TextTheme(
  headlineMedium:
      GoogleFonts.merriweather(fontSize: 32, fontWeight: FontWeight.w400),
  headlineSmall: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w400),
  bodyLarge: GoogleFonts.roboto(
      fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.roboto(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.roboto(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  labelMedium: GoogleFonts.roboto(
      fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.roboto(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
