import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  hoverColor: Color(0xff1876d0),
  hintColor: Color(0xff1876d0),
  scaffoldBackgroundColor: Colors.white,
  secondaryHeaderColor: Colors.black54,
  dialogBackgroundColor: Colors.grey[300],
  shadowColor: Colors.black.withOpacity(0.2),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light),
    elevation: 0,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xff1876d0),
    unselectedItemColor: Colors.black.withOpacity(0.5),
    selectedIconTheme: IconThemeData(
      size: 30,
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
  ),
);
