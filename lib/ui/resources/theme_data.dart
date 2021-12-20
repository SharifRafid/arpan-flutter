import 'package:flutter/material.dart';

final ThemeData mainThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColorBrightness: Brightness.light,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: MainColors.blue[500]),
  fontFamily: 'HindSiliguri'
);

class MainColors {
  MainColors._(); // this basically makes it so that you can instantiate this class
  static const _bluePrimaryValue = 0xFF0071BC;
  static const _whitePrimaryValue = 0xFFffffff;
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100:  Color(0xFFe0e0e0),
      200:  Color(0xFFe0e0e0),
      300:  Color(0xFFe0e0e0),
      400:  Color(0xFFe0e0e0),
      500:  Color(_bluePrimaryValue),
      600:  Color(0xFFe0e0e0),
      700:  Color(0xFFe0e0e0),
      800:  Color(0xFFe0e0e0),
      900:  Color(0xFFe0e0e0),
    },
  );
  static const MaterialColor white = MaterialColor(
    _whitePrimaryValue,
    <int, Color>{
      50: Color(0xFFffffff),
      100:  Color(0xFFffffff),
      200:  Color(0xFFffffff),
      300:  Color(0xFFffffff),
      400:  Color(0xFFffffff),
      500:  Color(_whitePrimaryValue),
      600:  Color(0xFFffffff),
      700:  Color(0xFFffffff),
      800:  Color(0xFFffffff),
      900:  Color(0xFFffffff),
    },
  );
}