part of 'book_appointment_bloc.dart';

class BookAppointmentState {
  final List<ClinicModel> clinics;
  final List<DoctorModel> doctors;
  final List<TimeSlotModel> timeSlots;
  final ClinicModel? selectedClinic;
  final DoctorModel? selectedDoctor;
  final DateTime? selectedDate;
  final TimeSlotModel? selectedTimeSlot;
  final String selectedPeriod;
  final String notes;
  final String fileNumber;
  final bool isClinicsLoading;
  final bool isDoctorsLoading;
  final bool isTimeSlotsLoading;
  final bool isBooking;
  final bool isBookingSuccess;
  final String? errorMessage;

  const BookAppointmentState({
    this.clinics = const [],
    this.doctors = const [],
    this.timeSlots = const [],
    this.selectedClinic,
    this.selectedDoctor,
    this.selectedDate,
    this.selectedTimeSlot,
    this.selectedPeriod = 'AM',
    this.notes = '',
    this.fileNumber = '',
    this.isClinicsLoading = false,
    this.isDoctorsLoading = false,
    this.isTimeSlotsLoading = false,
    this.isBooking = false,
    this.isBookingSuccess = false,
    this.errorMessage,
  });

  int get completedSteps {
    int steps = 0;
    if (selectedClinic != null) steps++;
    if (selectedDoctor != null) steps++;
    if (selectedDate != null) steps++;
    if (selectedTimeSlot != null) steps++;
    return steps;
  }

  bool get isFormValid =>
      selectedClinic != null &&
      selectedDoctor != null &&
      selectedDate != null &&
      selectedTimeSlot != null;

  
  List<TimeSlotModel> get filteredTimeSlots =>
      timeSlots.where((slot) => slot.period == selectedPeriod).toList();

  BookAppointmentState copyWith({
    List<ClinicModel>? clinics,
    List<DoctorModel>? doctors,
    List<TimeSlotModel>? timeSlots,
    ClinicModel? selectedClinic,
    DoctorModel? selectedDoctor,
    DateTime? selectedDate,
    TimeSlotModel? selectedTimeSlot,
    String? selectedPeriod,
    String? notes,
    String? fileNumber,
    bool? isClinicsLoading,
    bool? isDoctorsLoading,
    bool? isTimeSlotsLoading,
    bool? isBooking,
    bool? isBookingSuccess,
    String? errorMessage,
    bool clearSelectedDoctor = false,
    bool clearSelectedTimeSlot = false,
    bool clearError = false,
  }) {
    return BookAppointmentState(
      clinics: clinics ?? this.clinics,
      doctors: doctors ?? this.doctors,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedClinic: selectedClinic ?? this.selectedClinic,
      selectedDoctor: clearSelectedDoctor
          ? null
          : selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: clearSelectedTimeSlot
          ? null
          : selectedTimeSlot ?? this.selectedTimeSlot,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      notes: notes ?? this.notes,
      fileNumber: fileNumber ?? this.fileNumber,
      isClinicsLoading: isClinicsLoading ?? this.isClinicsLoading,
      isDoctorsLoading: isDoctorsLoading ?? this.isDoctorsLoading,
      isTimeSlotsLoading: isTimeSlotsLoading ?? this.isTimeSlotsLoading,
      isBooking: isBooking ?? this.isBooking,
      isBookingSuccess: isBookingSuccess ?? this.isBookingSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
