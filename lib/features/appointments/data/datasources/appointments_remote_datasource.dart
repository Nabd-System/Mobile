import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';
import 'package:nabd/features/appointments/data/models/appointment_request_model.dart';
import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';

class AppointmentsRemoteDatasource {
  // ==================== Clinics ====================
  Future<List<ClinicModel>> getClinics() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.clinics);
    final data = response.data['data'] as List;
    return data.map((e) => ClinicModel.fromJson(e)).toList();
  }

  // ==================== Doctors ====================
  Future<List<DoctorModel>> getDoctorsByClinic(int clinicId) async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.doctors,
      queryParameters: {'Clinic': clinicId},
    );
    final data = response.data['data'] as List;
    return data.map((e) => DoctorModel.fromJson(e)).toList();
  }

  // ==================== Available Slots ====================
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required int doctorId,
    required int clinicId,
    required String date,
  }) async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.availableSlots,
      queryParameters: {
        'DoctorId': doctorId,
        'ClinicId': clinicId,
        'Date': date,
      },
    );
    final data = response.data['data'] as List;
    return data.map((e) => TimeSlotModel.fromJson(e)).toList();
  }

  // ==================== Book Appointment ====================
  Future<void> bookAppointment(AppointmentRequestModel request) async {
    await ApiClient.post(
      endpoint: AppEndpoints.bookAppointment,
      data: request.toJson(),
    );
  }

  // ==================== My Appointments ====================
  Future<List<AppointmentModel>> getMyAppointments() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.myAppointments);
    final data = response.data['data'] as List;
    return data.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  // ==================== Cancel Appointment ====================
  Future<void> cancelAppointment(int appointmentId) async {
    // TODO: استبدل بـ endpoint لما تجهز
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
