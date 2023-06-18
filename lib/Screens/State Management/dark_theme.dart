import 'package:flutter/material.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleDarkTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}
