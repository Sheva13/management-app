import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _themeBoxName = 'settings';
const _themeKey = 'dark_mode';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = await Hive.openBox(_themeBoxName);
    final isDark = box.get(_themeKey, defaultValue: false) as bool;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final box = await Hive.openBox(_themeBoxName);
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    await box.put(_themeKey, !isDark);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final box = await Hive.openBox(_themeBoxName);
    state = mode;
    await box.put(_themeKey, mode == ThemeMode.dark);
  }
}
