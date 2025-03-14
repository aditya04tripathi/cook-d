import 'package:flutter/material.dart';

const textColor = Color(0xFF080f0a);
const backgroundColor = Color(0xFFf3faf5);
const primaryColor = Color(0xFF0d471f);
const primaryFgColor = Color(0xFFf3faf5);
const secondaryColor = Color(0xFF97e6b0);
const secondaryFgColor = Color(0xFF080f0a);
const accentColor = Color(0xFF50e27e);
const accentFgColor = Color(0xFF080f0a);

final theme = ThemeData(
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: primaryFgColor,
    secondary: secondaryColor,
    onSecondary: secondaryFgColor,
    tertiary: accentColor,
    onTertiary: accentFgColor,
    surface: backgroundColor,
    onSurface: textColor,
    error: Color(0xffB3261E),
    onError: Color(0xffFFFFFF),
    inversePrimary: primaryFgColor,
    inverseSurface: primaryColor,
  ),
);
