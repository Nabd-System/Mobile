// import 'package:shared_preferences/shared_preferences.dart';

// class AppLocalStorage {
//   static late SharedPreferences _preferences;

//   static String token = 'token';

//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }

//   static cacheData(String key, dynamic value) {
//     if (value is String) {
//       _preferences.setString(key, value);
//     } else if (value is bool) {
//       _preferences.setBool(key, value);
//     } else if (value is int) {
//       _preferences.setInt(key, value);
//     } else if (value is double) {
//       _preferences.setDouble(key, value);
//     } else {
//       _preferences.setStringList(key, value);
//     }
//   }

//   static dynamic getData(String key) {
//     return _preferences.get(key);
//   }

//   // إضافة function لمسح data معينة
//   static Future<bool> removeData(String key) async {
//     return await _preferences.remove(key);
//   }

//   // إضافة function لمسح كل الـ data (optional)
//   static Future<bool> clearAllData() async {
//     return await _preferences.clear();
//   }
// }
