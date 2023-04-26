import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var acmeFontFamily = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(245, 249, 41, 1),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.acmeTextTheme(),
);

var josefinSansFontFamily = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(245, 249, 41, 1),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.josefinSansTextTheme(),
);

var kanitFontFamily = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(245, 249, 41, 1),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.kanitTextTheme(),
);

var signikaFontFamily = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromRGBO(245, 249, 41, 1),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.signikaTextTheme(),
);

var styleSignika = GoogleFonts.signika(
    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
