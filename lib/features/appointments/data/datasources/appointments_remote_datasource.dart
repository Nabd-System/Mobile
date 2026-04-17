//import 'package:nabd/core/network/api_client.dart';
//import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';
import 'package:nabd/features/appointments/data/models/appointment_request_model.dart';

class AppointmentsRemoteDatasource {
  // ==================== Mock Data (يتبدل بالـ API لما تجهز) ====================

  Future<List<ClinicModel>> getClinics() async {
    // TODO: استبدل بـ API call لما الـ endpoint تجهز
    // final response = await ApiClient.get(endpoint: AppEndpoints.clinics);
    // return (response.data['data'] as List)
    //     .map((e) => ClinicModel.fromJson(e))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const ClinicModel(id: 1, name: 'Central Hospital'),
      const ClinicModel(id: 2, name: 'City Medical Lab'),
      const ClinicModel(id: 3, name: 'Green Clinic'),
    ];
  }

  Future<List<DoctorModel>> getDoctorsByClinic(int clinicId) async {
    // TODO: استبدل بـ API call لما الـ endpoint تجهز
    // final response = await ApiClient.get(
    //   endpoint: AppEndpoints.doctorsByClinic(clinicId),
    // );
    // return (response.data['data'] as List)
    //     .map((e) => DoctorModel.fromJson(e))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 500));
    return [
      DoctorModel(
        id: 1,
        name: 'Dr. Sara Smith',
        specialization: 'Senior Cardiologist',
        clinicId: clinicId,
      ),
      DoctorModel(
        id: 2,
        name: 'Dr. Michael Chen',
        specialization: 'General Medicine',
        clinicId: clinicId,
      ),
      DoctorModel(
        id: 3,
        name: 'Dr. Elena Rodriguez',
        specialization: 'Orthopedics',
        clinicId: clinicId,
      ),
    ];
  }

  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required int doctorId,
    required String date,
  }) async {
    // TODO: استبدل بـ API call لما الـ endpoint تجهز
    // final response = await ApiClient.get(
    //   endpoint: AppEndpoints.timeSlots,
    //   queryParameters: {'doctorId': doctorId, 'date': date},
    // );
    // return (response.data['data'] as List)
    //     .map((e) => TimeSlotModel.fromJson(e))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const TimeSlotModel(time: '9:00', isAvailable: true, period: 'AM'),
      const TimeSlotModel(time: '9:30', isAvailable: true, period: 'AM'),
      const TimeSlotModel(time: '10:00', isAvailable: false, period: 'AM'),
      const TimeSlotModel(time: '10:30', isAvailable: true, period: 'AM'),
      const TimeSlotModel(time: '11:00', isAvailable: true, period: 'AM'),
      const TimeSlotModel(time: '11:30', isAvailable: false, period: 'AM'),
      const TimeSlotModel(time: '1:00', isAvailable: true, period: 'PM'),
      const TimeSlotModel(time: '1:30', isAvailable: true, period: 'PM'),
      const TimeSlotModel(time: '2:00', isAvailable: true, period: 'PM'),
      const TimeSlotModel(time: '2:30', isAvailable: false, period: 'PM'),
      const TimeSlotModel(time: '3:00', isAvailable: true, period: 'PM'),
      const TimeSlotModel(time: '3:30', isAvailable: true, period: 'PM'),
    ];
  }

  Future<void> bookAppointment(AppointmentRequestModel request) async {
    // TODO: استبدل بـ API call لما الـ endpoint تجهز
    // await ApiClient.post(
    //   endpoint: AppEndpoints.bookAppointment,
    //   data: request.toJson(),
    // );

    await Future.delayed(const Duration(milliseconds: 800));
  }
}
