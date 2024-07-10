import 'package:flutter/material.dart';

import 'color_extensions.dart';

/// Light and Dark App Theme
class AppTheme {
  /// Get Pacifico Font Name
  static String get pacificoFontName => 'Pacifico';

  /// Get light theme
  static ThemeData get light {
    final lightTheme = ThemeData.light(useMaterial3: false);

    final lightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: AppColors.blueMaterial,
      backgroundColor: Colors.white,
    );

    return lightTheme.copyWith(
      primaryColor: AppColors.blueMaterial,
      colorScheme: lightColorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: pacificoFontName,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: lightTheme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStatePropertyAll(AppColors.blue),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: lightTheme.outlinedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStatePropertyAll(AppColors.blue),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.blue,
        focusColor: Colors.red,
      ),
    );
  }

  /// Get dark theme
  static ThemeData get dark {
    final darkTheme = ThemeData.dark(useMaterial3: true);
    final darkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: AppColors.blueMaterial,
      backgroundColor: Colors.black,
    );
    return darkTheme.copyWith(
      colorScheme: darkColorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.background,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: pacificoFontName,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: darkTheme.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStatePropertyAll(AppColors.blue),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: darkTheme.outlinedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStatePropertyAll(AppColors.blue),
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.blue,
        focusColor: Colors.red,
      ),
      iconTheme: IconThemeData(
        color: darkColorScheme.onBackground,
      ),
      primaryIconTheme: IconThemeData(
        color: darkColorScheme.onBackground,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              MaterialStatePropertyAll(darkColorScheme.onBackground),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: darkColorScheme.onBackground,
        suffixIconColor: darkColorScheme.onBackground,
      ),
    );
  }
}

/// Default App Color definition
// ignore_for_file: public_member_api_docs
class AppColors {
  static Color get blue => '#3A98B9'.toColor();
  static Color get beigeLight => '#FFF1DC'.toColor();
  static Color get beige => '#E8D5C4'.toColor();
  static Color get grey => '#EEEEEE'.toColor();

  static MaterialColor get blueMaterial => blue.toMaterialColor();
  static MaterialColor get beigeLightMaterial => beigeLight.toMaterialColor();
  static MaterialColor get beigeMaterial => beige.toMaterialColor();
  static MaterialColor get greyMaterial => grey.toMaterialColor();
}
