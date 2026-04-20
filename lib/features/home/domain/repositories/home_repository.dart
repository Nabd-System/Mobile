import 'package:nabd/features/home/data/models/doctor_search_model.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';

abstract class HomeRepository {
  Future<List<DoctorSearchModel>> searchDoctors(String searchTerm);
  Future<AppointmentModel?> getUpcomingAppointment();
}
