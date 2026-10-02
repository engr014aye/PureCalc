import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _prefKeyTheme = 'purecalc_is_dark_mode';

  // Default theme is strictly Light as per project requirements
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeController() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Defaults to false (Light Mode)
      _isDarkMode = prefs.getBool(_prefKeyTheme) ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKeyTheme, value);
    } catch (_) {}
  }
}
