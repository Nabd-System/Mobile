import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/home/data/models/doctor_search_model.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';

class HomeRemoteDatasource {
  Future<List<DoctorSearchModel>> searchDoctors(String searchTerm) async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.doctorSearch,
      queryParameters: {'searchTerm': searchTerm},
    );

    final data = response.data['data'];
    if (data == null) return [];

    return (data as List).map((e) => DoctorSearchModel.fromJson(e)).toList();
  }

  Future<AppointmentModel?> getUpcomingAppointment() async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.upcomingAppointment,
    );

    final data = response.data['data'];
    if (data == null) return null;

    return AppointmentModel.fromJson(data);
  }
}
