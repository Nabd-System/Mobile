import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/storage/hive_service.dart';
import 'package:nabd/core/constants/storage_keys.dart';
import 'package:nabd/features/profile/data/models/patient_profile_model.dart';

class ProfileLocalDatasource {
  // Save profile in Hive
  Future<void> saveProfile(PatientProfileModel profile) async {
    await HiveService.put(
      boxName: HiveService.userBox,
      key: 'patient_profile',
      value: profile.toJson(),
    );
    // Save fileNumber in SharedPrefs للوصول السريع
    await AppLocalStorage.cacheData(StorageKeys.fileNumber, profile.fileNumber);
  }

  // Get cached profile
  PatientProfileModel? getCachedProfile() {
    final data = HiveService.get(
      boxName: HiveService.userBox,
      key: 'patient_profile',
    );
    if (data != null) {
      return PatientProfileModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // Get fileNumber directly
  String? getFileNumber() {
    return AppLocalStorage.getData(StorageKeys.fileNumber);
  }

  // Clear profile
  Future<void> clearProfile() async {
    await HiveService.delete(
      boxName: HiveService.userBox,
      key: 'patient_profile',
    );
    await AppLocalStorage.removeData(StorageKeys.fileNumber);
  }
}
