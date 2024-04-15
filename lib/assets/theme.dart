import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  // Theme Colors
  static const Color primaryColor = Color(0xFF2D3A3A); // Deep teal-like color
  static const Color secondaryColor = Color(0xFFEF7674); // Soft red
  static const Color tertiaryColor =
      Color(0xFFF4ECF8); // Adjusted for contrast with primary/secondary

  // Standard Colors
  static const Color nearlyWhite =
      Color(0xFFF4ECF8); // Very light peach, for background
  static const Color white = Color(0xFFFFFFFF);
  static const Color background =
      Color(0xFFF4ECF8); // Very light peach, used for app background

  // Updated to align with the new theme
  static const Color nearlyDarkRed =
      secondaryColor; // Using secondaryColor for consistency

  // Dark Theme Colors Adjusted to Match New Theme
  static const Color nearlyBlack = primaryColor; // Deep teal-like color
  static const Color grey =
      Color(0xFF4A5D69); // Slightly lighter than primaryColor for contrast
  static const Color darkGrey = Color(0xFF3A4B4F); // Darker shade for depth

  // Text Colors - Adjusted for readability on the new theme
  static const Color darkText =
      Color(0xFFEF7674); // Light color for contrast on dark backgrounds
  static const Color darkerText =
      Color.fromARGB(255, 0, 0, 0); // Slightly lighter for emphasis
  static const Color lightText =
      secondaryColor; // Soft red for highlights or links
  static const Color deactivatedText =
      Color(0xFFCFD8DC); // Greyish for less emphasis
  static const Color dismissibleBackground =
      Color(0xFF455A64); // Darker for dismissible elements
  static const Color spacer =
      nearlyWhite; // Very light peach, used as a spacer color
  static const String fontName = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    headlineLarge: display1, // This replaces the deprecated headline4
    headlineMedium: headline, // Considered as an alternative to headline5
    headlineSmall: title, // This replaces the deprecated headline6
    titleMedium: subtitle, // This replaces the deprecated subtitle2
    bodyMedium: body2, // This replaces the deprecated bodyText2
    bodySmall: body1, // This replaces the deprecated bodyText1
    labelSmall: caption, // This replaces the deprecated caption
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const double iconSize = 24.0;
   // Example icon size
  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}