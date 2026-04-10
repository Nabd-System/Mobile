import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/storage/hive_service.dart';
import 'package:nabd/core/constants/storage_keys.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';

class AuthLocalDatasource {
  Future<void> saveUserData(LoginResponseModel user) async {
    // Save token in SharedPreferences (quick access)
    await AppLocalStorage.cacheData(StorageKeys.token, user.accessToken);
    await AppLocalStorage.cacheData(
      StorageKeys.refreshToken,
      user.refreshToken,
    );
    await AppLocalStorage.cacheData(StorageKeys.userType, user.userType);
    await AppLocalStorage.cacheData(StorageKeys.userName, user.userName);

    // Save full user data in Hive (offline access)
    await HiveService.put(
      boxName: HiveService.userBox,
      key: 'current_user',
      value: user.toJson(),
    );
  }

  String? getToken() {
    return AppLocalStorage.getData(StorageKeys.token);
  }

  String? getUserType() {
    return AppLocalStorage.getData(StorageKeys.userType);
  }

  bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  LoginResponseModel? getCachedUser() {
    final data = HiveService.get(
      boxName: HiveService.userBox,
      key: 'current_user',
    );
    if (data != null) {
      return LoginResponseModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<void> clearUserData() async {
    await AppLocalStorage.removeData(StorageKeys.token);
    await AppLocalStorage.removeData(StorageKeys.refreshToken);
    await AppLocalStorage.removeData(StorageKeys.userType);
    await AppLocalStorage.removeData(StorageKeys.userName);
    await HiveService.clearBox(boxName: HiveService.userBox);
  }
}
