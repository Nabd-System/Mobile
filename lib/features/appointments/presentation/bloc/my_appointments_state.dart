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

  // ==================== Date Helpers ====================

  /// اليوم بدون وقت
  DateTime get _todayOnly {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// تحويل string لـ DateTime (التاريخ فقط)
  DateTime? _parseAppointmentDate(String value) {
    try {
      final date = DateTime.parse(value);
      return DateTime(date.year, date.month, date.day);
    } catch (_) {
      return null;
    }
  }

  // ==================== Upcoming ====================
  /// اليوم أو المستقبل + مش cancelled + مش completed
  List<AppointmentModel> get upcomingAppointments {
    final today = _todayOnly;
    return appointments.where((a) {
      final appointmentDate = _parseAppointmentDate(a.appointmentDate);
      if (appointmentDate == null) return false;
      return !appointmentDate.isBefore(today) &&
          !a.isCancelled &&
          !a.isCompleted;
    }).toList();
  }

  // ==================== Past ====================
  /// تاريخ قديم أو cancelled أو completed
  List<AppointmentModel> get pastAppointments {
    final today = _todayOnly;
    return appointments.where((a) {
      final appointmentDate = _parseAppointmentDate(a.appointmentDate);
      if (appointmentDate == null) {
        return a.isCancelled || a.isCompleted;
      }
      return appointmentDate.isBefore(today) || a.isCancelled || a.isCompleted;
    }).toList();
  }

  // ==================== Copy With ====================
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
