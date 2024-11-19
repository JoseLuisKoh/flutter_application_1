import 'package:flutter/material.dart';
import 'package:flutter_application_1/themes/dark_mode.dart';
import 'package:flutter_application_1/themes/ligth_mode.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ligthMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == ligthMode) {
      themeData = darkMode;
    } else {
      themeData = ligthMode;
    }
  }
}
