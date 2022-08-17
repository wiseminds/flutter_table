import 'package:hive/hive.dart';

class Preference {
  static const perPage = 'per-page';
  late LazyBox box;

  static final Preference _singleton = Preference._();

  factory Preference() {
    return _singleton;
  }

  Preference._();

  bool _initialized = false;

  Future initStore() async {
    box = await Hive.openLazyBox('flutter-table-preference');
    _initialized = true;
  }

  Future<void> delete(String key) async {
    if (!_initialized) await initStore();
    return box.delete(key);
  }

  Future<bool> getBool(String key, bool defaultValue) async {
    if (!_initialized) await initStore();
    var result = await box.get(key, defaultValue: defaultValue);
    if (result != null && result is bool) return result;
    return defaultValue;
  }

  Future<int?> getInt(String key) async {
    if (!_initialized) await initStore();
    var result = await box.get(key);
    if (result is int) return result;
    return null;
  }

  Future<String?> getString(String key) async {
    if (!_initialized) await initStore();
    var result = await box.get(key);
    if (result is String) return result;
    return null;
  }

  Future<List<String>?> getStringList(String key) async {
    if (!_initialized) await initStore();
    var result = await box.get(key);
    if (result is List<String>) return result;
    return null;
  }

  Future<void> setBool(String key, bool value) async {
    if (!_initialized) await initStore();
    return box.put(key, value);
  }

  Future<void> setInt(String key, int value) async {
    if (!_initialized) await initStore();
    return box.put(key, value);
  }

  Future<void> setString(String key, String value) async {
    if (!_initialized) await initStore();
    return box.put(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    if (!_initialized) await initStore();
    box.put(key, value);
  }
}
