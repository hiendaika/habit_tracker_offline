import 'package:flutter/material.dart';
import 'package:habit_tracker_offline/theme/dark_mode.dart';
import 'package:habit_tracker_offline/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //Initialize light mode
  ThemeData _themeData = lightMode;

  //get current theme
  ThemeData get themeData => _themeData;

  //is dark mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    //Set theme data
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
