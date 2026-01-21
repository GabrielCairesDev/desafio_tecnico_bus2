import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'persistence.service.dart';

class SharedPreferencesPersistence implements IPersistenceService {
  final SharedPreferences _prefs;

  SharedPreferencesPersistence(this._prefs);

  @override
  Future<bool> saveList(String key, List<Map<String, dynamic>> data) async {
    try {
      final jsonString = jsonEncode(data);
      return await _prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> loadList(String key) async {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) {
        return [];
      }
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .cast<Map<String, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> delete(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> exists(String key) async {
    return _prefs.containsKey(key);
  }
}
