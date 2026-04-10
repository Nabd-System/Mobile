import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {
  static late SharedPreferences _preferences;

  static const String token = 'token';
  static const String userType = 'userType';
  static const String onboardingSeen = 'onboardingSeen';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> cacheData(String key, dynamic value) async {
    if (value is String) await _preferences.setString(key, value);
    if (value is bool) await _preferences.setBool(key, value);
    if (value is int) await _preferences.setInt(key, value);
  }

  static dynamic getData(String key) {
    return _preferences.get(key);
  }

  static Future<void> removeData(String key) async {
    await _preferences.remove(key);
  }

  static Future<void> clearAll() async {
    await _preferences.clear();
  }
}
