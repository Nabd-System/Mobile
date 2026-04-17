import 'package:nabd/features/profile/data/models/patient_profile_model.dart';

abstract class ProfileRepository {
  Future<PatientProfileModel> getProfile();
  PatientProfileModel? getCachedProfile();
  String? getFileNumber();
}
