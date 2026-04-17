import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';

abstract class AppointmentsRepository {
  // Clinics
  Future<List<ClinicModel>> getClinics();

  // Doctors
  Future<List<DoctorModel>> getDoctorsByClinic(int clinicId);

  // Time Slots
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required int doctorId,
    required String date,
  });

  // Book
  Future<void> bookAppointment({
    required int clinicId,
    required int doctorId,
    required String date,
    required String time,
    String? notes,
  });
}
