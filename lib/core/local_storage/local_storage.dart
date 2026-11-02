import 'dart:convert';

import 'package:fridgy/core/local_storage/local_storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage({required this._prefs});

  final SharedPreferences _prefs;

  Future<void> setCachedUser(Map<String, dynamic> value) {
    return _prefs.setString(LocalStorageKeys.cachedUser, jsonEncode(value));
  }

  Map<String, dynamic>? getCachedUser() {
    final raw = _prefs.getString(LocalStorageKeys.cachedUser);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      _prefs.remove(LocalStorageKeys.cachedUser);
      return null;
    } catch (_) {
      _prefs.remove(LocalStorageKeys.cachedUser);
      return null;
    }
  }

  Future<void> clearCachedUser() {
    return _prefs.remove(LocalStorageKeys.cachedUser);
  }

  Future<void> setLastUserName(String value) {
    return _prefs.setString(LocalStorageKeys.lastUserName, value);
  }

  String? getLastUserName() {
    final value = _prefs.getString(LocalStorageKeys.lastUserName);
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  Future<void> setLocaleLanguage(String locale) {
    return _prefs.setString(LocalStorageKeys.localeLanguage, locale);
  }

  String getLocaleLanguage() {
    return _prefs.getString(LocalStorageKeys.localeLanguage) ?? 'en';
  }

  Future<void> setOnboardingCompleted({required bool value}) {
    return _prefs.setBool(LocalStorageKeys.onboardingCompleted, value);
  }

  bool getOnboardingCompleted() {
    return _prefs.getBool(LocalStorageKeys.onboardingCompleted) ?? false;
  }

  Future<void> setThemeMode(String value) {
    return _prefs.setString(LocalStorageKeys.themeMode, value);
  }

  String getThemeMode() {
    return _prefs.getString(LocalStorageKeys.themeMode) ?? 'light';
  }

  Future<void> setUnitsRegion(String value) {
    return _prefs.setString(LocalStorageKeys.unitsRegion, value);
  }

  String getUnitsRegion() {
    return _prefs.getString(LocalStorageKeys.unitsRegion) ?? 'egypt';
  }

  Future<void> setUnitsLanguage(String value) {
    return _prefs.setString(LocalStorageKeys.unitsLanguage, value);
  }

  String getUnitsLanguage() {
    return _prefs.getString(LocalStorageKeys.unitsLanguage) ?? 'en';
  }

  Future<void> setUnitsMeasurement(String value) {
    return _prefs.setString(LocalStorageKeys.unitsMeasurement, value);
  }

  String getUnitsMeasurement() {
    return _prefs.getString(LocalStorageKeys.unitsMeasurement) ?? 'metric';
  }

  Future<void> setUnitsCurrency(String value) {
    return _prefs.setString(LocalStorageKeys.unitsCurrency, value);
  }

  String getUnitsCurrency() {
    return _prefs.getString(LocalStorageKeys.unitsCurrency) ?? 'egp';
  }

  Future<void> setApiMode(String value) {
    return _prefs.setString(LocalStorageKeys.apiMode, value);
  }

  String? getApiMode() {
    return _prefs.getString(LocalStorageKeys.apiMode);
  }
}
