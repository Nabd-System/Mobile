import 'package:dio/dio.dart';
import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/profile/data/models/patient_profile_model.dart';

class ProfileRemoteDatasource {
  Future<PatientProfileModel> getPatientProfile() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.patientProfile);
    return PatientProfileModel.fromJson(response.data['data']);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final formData = FormData.fromMap({
      'OldPassword': oldPassword,
      'NewPassword': newPassword,
    });

    final response = await ApiClient.patch(
      endpoint: AppEndpoints.changePassword,
      data: formData,
    );

    if (response.data['isSuccess'] == false) {
      throw Exception(response.data['message'] ?? 'Something went wrong');
    }
  }
}
