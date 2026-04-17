import 'package:nabd/features/appointments/data/models/appointment_model.dart';
import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';

abstract class AppointmentsRepository {
  Future<List<ClinicModel>> getClinics();

  Future<List<DoctorModel>> getDoctorsByClinic(int clinicId);

  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required int doctorId,
    required int clinicId,
    required String date,
  });

  Future<void> bookAppointment({
    required int clinicId,
    required int doctorId,
    required String appointmentDate,
    required int appointmentType,
    required String fileNumber,
    String? notes,
  });

  // ✅ بقت method واحدة بدل اتنين
  Future<List<AppointmentModel>> getMyAppointments();

  Future<void> cancelAppointment(int appointmentId);
}