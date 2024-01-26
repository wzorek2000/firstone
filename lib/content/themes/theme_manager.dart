import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class ThemeManager extends ChangeNotifier {
  static const _themePrefKey = 'selectedIndex';
  ThemeData _themeData = MyThemes.themes.first;
  int _themeIndex = 0;

  int get themeIndex => _themeIndex;
  ThemeData get themeData => _themeData;

  ThemeManager() {
    loadSavedTheme();
  }

  void setTheme(int index) async {
    _themeData = MyThemes.themes[index];
    _themeIndex = index;

    notifyListeners();

    await _saveThemeIndex(index);
  }

  Future<void> _saveThemeIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themePrefKey, index);
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _themeIndex = prefs.getInt(_themePrefKey) ?? 0;

    if (_themeIndex >= 0 && _themeIndex < MyThemes.themes.length) {
      _themeData = MyThemes.themes[_themeIndex];
      notifyListeners();
    }
  }
}
