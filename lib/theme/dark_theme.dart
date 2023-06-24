import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  primaryColorDark: Colors.white,
  hoverColor: Color(0xff1876d0),
  hintColor: Color(0xff1876d0),
  scaffoldBackgroundColor: Colors.black,
  secondaryHeaderColor: Colors.white70,
  shadowColor: Colors.white.withOpacity(0.7),
  dialogBackgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Color(0xff1876d0),
    unselectedItemColor: Colors.white.withOpacity(0.5),
    selectedIconTheme: IconThemeData(
      size: 30,
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
  ),
  // text
);
