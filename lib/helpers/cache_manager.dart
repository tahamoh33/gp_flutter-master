import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static SharedPreferences? prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(String key, dynamic value) async {
    if (value is String) return prefs!.setString(key, value);
    if (value is int) return prefs!.setInt(key, value);
    if (value is double) return prefs!.setDouble(key, value);
    if (value is bool) {
      return prefs!.setBool(key, value);
    } else {
      return false;
    }
  }

  static dynamic getData(String key) {
    return prefs!.get(key);
  }

  static Future<bool> removeData(String key) async {
    return await prefs!.remove(key);
  }
}
