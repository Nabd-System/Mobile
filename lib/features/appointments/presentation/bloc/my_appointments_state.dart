part of 'my_appointments_bloc.dart';

class MyAppointmentsState {
  final List<AppointmentModel> appointments;
  final bool isLoading;
  final bool isCancelling;
  final String? errorMessage;
  final String? successMessage;

  const MyAppointmentsState({
    this.appointments = const [],
    this.isLoading = false,
    this.isCancelling = false,
    this.errorMessage,
    this.successMessage,
  });

  // Upcoming = Scheduled
  List<AppointmentModel> get upcomingAppointments =>
      appointments.where((a) => a.isScheduled).toList();

  // Past = Completed or Cancelled
  List<AppointmentModel> get pastAppointments =>
      appointments.where((a) => a.isCompleted || a.isCancelled).toList();

  MyAppointmentsState copyWith({
    List<AppointmentModel>? appointments,
    bool? isLoading,
    bool? isCancelling,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return MyAppointmentsState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}
