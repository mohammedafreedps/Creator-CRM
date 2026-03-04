import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(){
    return ThemeData();
  }

  static ThemeData dark(){
    return ThemeData.dark();
  }
}



// colorScheme: ColorScheme(
//   brightness: Brightness.light,

//   // PRIMARY
//   primary: ...,
//   onPrimary: ...,
//   primaryContainer: ...,
//   onPrimaryContainer: ...,

//   // SECONDARY
//   secondary: ...,
//   onSecondary: ...,
//   secondaryContainer: ...,
//   onSecondaryContainer: ...,

//   // TERTIARY
//   tertiary: ...,
//   onTertiary: ...,
//   tertiaryContainer: ...,
//   onTertiaryContainer: ...,

//   // ERROR
//   error: ...,
//   onError: ...,
//   errorContainer: ...,
//   onErrorContainer: ...,

//   // SURFACE
//   surface: ...,
//   onSurface: ...,

//   // OUTLINE
//   outline: ...,
//   outlineVariant: ...,

//   // INVERSE
//   inverseSurface: ...,
//   onInverseSurface: ...,
//   inversePrimary: ...,

//   // SPECIAL
//   shadow: ...,
//   scrim: ...,
//   surfaceTint: ...,
// );