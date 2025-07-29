import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themePrefKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePrefKey) ?? ThemeMode.system.index;
    state = ThemeMode.values[themeIndex];
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, mode.index);
  }

  void toggleTheme(bool isDarkMode) {
    final newTheme = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;
    _saveTheme(newTheme);
  }

  void setSystemTheme() {
    state = ThemeMode.system;
    _saveTheme(ThemeMode.system);
  }
}
