import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';
import 'package:nabd/features/appointments/domain/repositories/appointments_repository.dart';

part 'my_appointments_event.dart';
part 'my_appointments_state.dart';

class MyAppointmentsBloc
    extends Bloc<MyAppointmentsEvent, MyAppointmentsState> {
  final AppointmentsRepository repository;

  MyAppointmentsBloc({required this.repository})
    : super(const MyAppointmentsState()) {
    on<LoadMyAppointments>(_onLoadMyAppointments);
    on<CancelAppointmentRequested>(_onCancelAppointment);
  }

  // ==================== Load My Appointments ====================
  Future<void> _onLoadMyAppointments(
    LoadMyAppointments event,
    Emitter<MyAppointmentsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final appointments = await repository.getMyAppointments();
      emit(state.copyWith(appointments: appointments, isLoading: false));
    } on ServerException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load appointments',
        ),
      );
    }
  }

  // ==================== Cancel Appointment ====================
  Future<void> _onCancelAppointment(
    CancelAppointmentRequested event,
    Emitter<MyAppointmentsState> emit,
  ) async {
    emit(state.copyWith(isCancelling: true, clearError: true));
    try {
      await repository.cancelAppointment(event.appointmentId);

      final updated = state.appointments
          .where((a) => a.appointmentId != event.appointmentId)
          .toList();

      emit(
        state.copyWith(
          isCancelling: false,
          appointments: updated,
          successMessage: 'Appointment cancelled successfully',
        ),
      );
    } on ServerException catch (e) {
      emit(state.copyWith(isCancelling: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isCancelling: false,
          errorMessage: 'Failed to cancel appointment',
        ),
      );
    }
  }
}
