part of 'book_appointment_bloc.dart';

abstract class BookAppointmentEvent {}

class LoadClinicsRequested extends BookAppointmentEvent {}

class ResetBookingState extends BookAppointmentEvent {}

class ClinicSelected extends BookAppointmentEvent {
  final ClinicModel clinic;
  ClinicSelected({required this.clinic});
}

class DoctorSelected extends BookAppointmentEvent {
  final DoctorModel doctor;
  DoctorSelected({required this.doctor});
}

class DateSelected extends BookAppointmentEvent {
  final DateTime date;
  DateSelected({required this.date});
}

class TimeSlotSelected extends BookAppointmentEvent {
  final TimeSlotModel timeSlot;
  TimeSlotSelected({required this.timeSlot});
}

class NotesChanged extends BookAppointmentEvent {
  final String notes;
  NotesChanged({required this.notes});
}

class PeriodChanged extends BookAppointmentEvent {
  final String period;
  PeriodChanged({required this.period});
}

class BookAppointmentSubmitted extends BookAppointmentEvent {}
