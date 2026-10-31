import 'package:flutter/material.dart';
import 'package:fridgy/core/local_storage/local_storage.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({required this._localStorage}) {
    _themeMode = _parse(_localStorage.getThemeMode());
  }

  final LocalStorage _localStorage;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _localStorage.setThemeMode(_serialize(mode));
    notifyListeners();
  }

  static ThemeMode _parse(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  static String _serialize(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
    }
  }
}
