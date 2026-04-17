import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:nabd/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:nabd/features/profile/data/models/patient_profile_model.dart';
import 'package:nabd/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  final ProfileLocalDatasource localDatasource;

  ProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<PatientProfileModel> getProfile() async {
    try {
      final profile = await remoteDatasource.getPatientProfile();
      // Save locally
      await localDatasource.saveProfile(profile);
      return profile;
    } on ServerException {
      // لو فشل الـ API، نرجع الـ cached data
      final cached = localDatasource.getCachedProfile();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      final cached = localDatasource.getCachedProfile();
      if (cached != null) return cached;
      throw ServerException(message: 'Failed to load profile');
    }
  }

  @override
  PatientProfileModel? getCachedProfile() {
    return localDatasource.getCachedProfile();
  }

  @override
  String? getFileNumber() {
    return localDatasource.getFileNumber();
  }
}
