import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/appointments/data/datasources/appointments_remote_datasource.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';
import 'package:nabd/features/appointments/data/models/appointment_request_model.dart';
import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';
import 'package:nabd/features/appointments/domain/repositories/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDatasource remoteDatasource;

  AppointmentsRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ClinicModel>> getClinics() async {
    try {
      return await remoteDatasource.getClinics();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to load clinics');
    }
  }

  @override
  Future<List<DoctorModel>> getDoctorsByClinic(int clinicId) async {
    try {
      return await remoteDatasource.getDoctorsByClinic(clinicId);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to load doctors');
    }
  }

  @override
  Future<List<TimeSlotModel>> getAvailableTimeSlots({
    required int doctorId,
    required int clinicId,
    required String date,
  }) async {
    try {
      return await remoteDatasource.getAvailableTimeSlots(
        doctorId: doctorId,
        clinicId: clinicId,
        date: date,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to load time slots');
    }
  }

  @override
  Future<void> bookAppointment({
    required int clinicId,
    required int doctorId,
    required String appointmentDate,
    required int appointmentType,
    required String fileNumber,
    String? notes,
  }) async {
    try {
      final request = AppointmentRequestModel(
        doctorId: doctorId,
        clinicId: clinicId,
        appointmentDate: appointmentDate,
        appointmentType: appointmentType,
        notes: notes,
        fileNumber: fileNumber,
      );
      await remoteDatasource.bookAppointment(request);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to book appointment');
    }
  }

  @override
  Future<List<AppointmentModel>> getMyAppointments() async {
    try {
      return await remoteDatasource.getMyAppointments();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to load appointments');
    }
  }

  @override
  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await remoteDatasource.cancelAppointment(appointmentId);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to cancel appointment');
    }
  }
}
