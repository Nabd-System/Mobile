import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/profile/data/models/patient_profile_model.dart';

class ProfileRemoteDatasource {
  Future<PatientProfileModel> getPatientProfile() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.patientProfile);
    return PatientProfileModel.fromJson(response.data['data']);
  }
}
