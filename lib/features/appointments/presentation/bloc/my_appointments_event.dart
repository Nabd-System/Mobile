part of 'my_appointments_bloc.dart';

abstract class MyAppointmentsEvent {}

class LoadMyAppointments extends MyAppointmentsEvent {}

class CancelAppointmentRequested extends MyAppointmentsEvent {
  final int appointmentId;
  CancelAppointmentRequested({required this.appointmentId});
}
