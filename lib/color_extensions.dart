import 'dart:math';

import 'package:flutter/material.dart';

/// String Extensions
extension StringExtensions on String {
  /// Convert HexColor-String into Color Object
  Color toColor() {
    final hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

/// Color Extensions
extension ColorExtensions on Color {
  /// Convert Color to MaterialColor
  MaterialColor toMaterialColor() {
    return MaterialColor(value, <int, Color>{
      50: _tintColor(this, 0.9),
      100: _tintColor(this, 0.8),
      200: _tintColor(this, 0.6),
      300: _tintColor(this, 0.4),
      400: _tintColor(this, 0.2),
      500: this,
      600: _shadeColor(this, 0.1),
      700: _shadeColor(this, 0.2),
      800: _shadeColor(this, 0.3),
      900: _shadeColor(this, 0.4),
    });
  }

  int _tintValue(int value, double factor) =>
      max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color _tintColor(Color color, double factor) => Color.fromRGBO(
        _tintValue(color.red, factor),
        _tintValue(color.green, factor),
        _tintValue(color.blue, factor),
        1,
      );

  int _shadeValue(int value, double factor) =>
      max(0, min(value - (value * factor).round(), 255));

  Color _shadeColor(Color color, double factor) => Color.fromRGBO(
        _shadeValue(color.red, factor),
        _shadeValue(color.green, factor),
        _shadeValue(color.blue, factor),
        1,
      );
}
