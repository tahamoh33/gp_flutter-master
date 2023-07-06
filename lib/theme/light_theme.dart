import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  hoverColor: const Color(0xff1876d0),
  hintColor: const Color(0xff1876d0),
  scaffoldBackgroundColor: const Color(0xfff5fcfd),
  secondaryHeaderColor: Colors.black54,
  dialogBackgroundColor: Colors.grey[300],
  shadowColor: Colors.black.withOpacity(0.2),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Color(0xfff5fcfd),
        statusBarBrightness: Brightness.light),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xff1876d0),
    unselectedItemColor: Colors.black.withOpacity(0.5),
    selectedIconTheme: const IconThemeData(
      size: 30,
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
  ),
);
