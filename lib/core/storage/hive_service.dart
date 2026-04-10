import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();

  // ==================== Box Names ====================
  static const String userBox = 'user_box';
  static const String appointmentsBox = 'appointments_box';
  static const String visitsBox = 'visits_box';
  static const String labResultsBox = 'lab_results_box';
  static const String radiologyBox = 'radiology_box';
  static const String prescriptionsBox = 'prescriptions_box';
  static const String queueBox = 'queue_box';
  static const String settingsBox = 'settings_box';

  // ==================== Initialize ====================
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters here later
    // Hive.registerAdapter(UserModelAdapter());

    // Open boxes
    await Hive.openBox(userBox);
    await Hive.openBox(appointmentsBox);
    await Hive.openBox(visitsBox);
    await Hive.openBox(labResultsBox);
    await Hive.openBox(radiologyBox);
    await Hive.openBox(prescriptionsBox);
    await Hive.openBox(queueBox);
    await Hive.openBox(settingsBox);
  }

  // ==================== Generic Operations ====================

  // Save single item
  static Future<void> put({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  // Get single item
  static dynamic get({required String boxName, required String key}) {
    final box = Hive.box(boxName);
    return box.get(key);
  }

  // Save list of items
  static Future<void> putAll({
    required String boxName,
    required Map<String, dynamic> entries,
  }) async {
    final box = Hive.box(boxName);
    await box.putAll(entries);
  }

  // Get all items from box
  static List<dynamic> getAll({required String boxName}) {
    final box = Hive.box(boxName);
    return box.values.toList();
  }

  // Delete single item
  static Future<void> delete({
    required String boxName,
    required String key,
  }) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  // Clear entire box
  static Future<void> clearBox({required String boxName}) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  // Clear all boxes (for logout)
  static Future<void> clearAll() async {
    await Hive.box(userBox).clear();
    await Hive.box(appointmentsBox).clear();
    await Hive.box(visitsBox).clear();
    await Hive.box(labResultsBox).clear();
    await Hive.box(radiologyBox).clear();
    await Hive.box(prescriptionsBox).clear();
    await Hive.box(queueBox).clear();
  }

  // Check if box has data
  static bool hasData({required String boxName, required String key}) {
    final box = Hive.box(boxName);
    return box.containsKey(key);
  }
}
