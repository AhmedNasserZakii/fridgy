import 'package:shared_preferences/shared_preferences.dart';

class RecentSearchesLocalDataSource {
  RecentSearchesLocalDataSource({required this._prefs});

  static const _key = 'recent_searches';
  static const _maxItems = 5;

  final SharedPreferences _prefs;

  List<String> getRecent() {
    return List<String>.from(_prefs.getStringList(_key) ?? const []);
  }

  Future<void> add(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final existing = getRecent();
    final lower = trimmed.toLowerCase();
    existing.removeWhere((e) => e.toLowerCase() == lower);
    existing.insert(0, trimmed);
    if (existing.length > _maxItems) {
      existing.removeRange(_maxItems, existing.length);
    }
    await _prefs.setStringList(_key, existing);
  }

  Future<void> clear() => _prefs.remove(_key);
}
