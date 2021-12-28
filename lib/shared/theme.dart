import 'package:flutter/material.dart';

import './shared_method.dart';

// Color Theme
const primaryColor = Color(0xFFFF8848);
const secondaryColor = Color(0xFFFFDDCB);
const backgroundColor = Color(0xFFF0F0F0);
// const backgroundColor = Color(0xFFFFF9F5);
const altBackgroundColor = Color(0xFFF6F8FC);
const errorColor = Color(0xFFEA4D49);
const surfaceColor = Colors.white;
const blackColor = Color(0xFF130F26);
const textColor = Color(0xFF081D43);
const hintColor = Color(0xFF52617B);
const disableColor = Color(0xFF9CA5B4);

// Generate material color for primary color.
MaterialColor primarySwatch = generateMaterialColor(primaryColor);

// ThemeData variable to theming the app.
ThemeData kLightTheme = ThemeData(
  fontFamily: 'Nunito',
  backgroundColor: backgroundColor,
  scaffoldBackgroundColor: backgroundColor,
  hintColor: hintColor,
  disabledColor: disableColor,
  primarySwatch: primarySwatch,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: primarySwatch,
    accentColor: secondaryColor,
    errorColor: errorColor,
    backgroundColor: backgroundColor,
    brightness: Brightness.light,
  ).copyWith(
    primary: primarySwatch,
    secondary: secondaryColor,
    surface: surfaceColor,
    onSurface: textColor,
    onPrimary: Colors.white,
    onError: Colors.white,
    onBackground: blackColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      onPrimary: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    ),
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(
      fontSize: 24,
      letterSpacing: 0,
      color: textColor,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      letterSpacing: 0,
      color: hintColor,
      fontWeight: FontWeight.w300,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      letterSpacing: 0,
      color: textColor,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    ),
    bodyText1: TextStyle(
      fontSize: 18,
      letterSpacing: 0,
      color: textColor,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      letterSpacing: 0,
      color: hintColor,
      fontWeight: FontWeight.w300,
      overflow: TextOverflow.ellipsis,
    ),
  ),
);

// caption: TextStyle(
//   height: 1.7,
//   fontSize: 13,
//   letterSpacing: 0,
//   color: backgroundColor,
//   fontWeight: FontWeight.w600,
//   overflow: TextOverflow.ellipsis,
// ),
// button: TextStyle(
//   fontSize: 16,
//   letterSpacing: 0,
//   height: 1.7,
//   color: primaryColor,
//   fontWeight: FontWeight.w600,
//   overflow: TextOverflow.ellipsis,
// ),
