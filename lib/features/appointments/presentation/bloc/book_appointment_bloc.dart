import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';
import 'package:nabd/features/appointments/domain/repositories/appointments_repository.dart';
import 'package:nabd/features/profile/domain/repositories/profile_repository.dart';
part 'book_appointment_event.dart';
part 'book_appointment_state.dart';

class BookAppointmentBloc
    extends Bloc<BookAppointmentEvent, BookAppointmentState> {
  final AppointmentsRepository repository;
  final ProfileRepository profileRepository;

  BookAppointmentBloc({
    required this.repository,
    required this.profileRepository,
  }) : super(const BookAppointmentState()) {
    on<LoadClinicsRequested>(_onLoadClinics);
    on<ResetBookingState>(_onResetBookingState);
    on<ClinicSelected>(_onClinicSelected);
    on<DoctorSelected>(_onDoctorSelected);
    on<DateSelected>(_onDateSelected);
    on<TimeSlotSelected>(_onTimeSlotSelected);
    on<NotesChanged>(_onNotesChanged);
    on<PeriodChanged>(_onPeriodChanged);
    on<BookAppointmentSubmitted>(_onBookAppointmentSubmitted);
  }

  // ==================== Load Clinics ====================
  Future<void> _onLoadClinics(
    LoadClinicsRequested event,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(state.copyWith(isClinicsLoading: true, clearError: true));
    try {
      final clinics = await repository.getClinics();
      emit(state.copyWith(clinics: clinics, isClinicsLoading: false));
    } on ServerException catch (e) {
      emit(state.copyWith(isClinicsLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isClinicsLoading: false,
          errorMessage: 'Failed to load clinics',
        ),
      );
    }
  }

  // ==================== Clinic Selected ====================
  Future<void> _onClinicSelected(
    ClinicSelected event,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedClinic: event.clinic,
        isDoctorsLoading: true,
        clearSelectedDoctor: true,
        clearSelectedTimeSlot: true,
        doctors: [],
        timeSlots: [],
      ),
    );

    try {
      final doctors = await repository.getDoctorsByClinic(event.clinic.id);
      emit(state.copyWith(doctors: doctors, isDoctorsLoading: false));
    } on ServerException catch (e) {
      emit(state.copyWith(isDoctorsLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isDoctorsLoading: false,
          errorMessage: 'Failed to load doctors',
        ),
      );
    }
  }

  // ==================== Doctor Selected ====================
  Future<void> _onDoctorSelected(
    DoctorSelected event,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDoctor: event.doctor,
        clearSelectedTimeSlot: true,
        timeSlots: [],
      ),
    );

    if (state.selectedDate != null) {
      await _loadTimeSlots(
        event.doctor.id,
        state.selectedClinic!.id,
        state.selectedDate!,
        emit,
      );
    }
  }

  // ==================== Date Selected ====================
  Future<void> _onDateSelected(
    DateSelected event,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDate: event.date,
        clearSelectedTimeSlot: true,
        timeSlots: [],
      ),
    );

    if (state.selectedDoctor != null) {
      await _loadTimeSlots(
        state.selectedDoctor!.id,
        state.selectedClinic!.id,
        event.date,
        emit,
      );
    }
  }

  // ==================== Load Time Slots ====================
  Future<void> _loadTimeSlots(
    int doctorId,
    int clinicId,
    DateTime date,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(state.copyWith(isTimeSlotsLoading: true));
    try {
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final slots = await repository.getAvailableTimeSlots(
        doctorId: doctorId,
        clinicId: clinicId,
        date: formattedDate,
      );
      emit(state.copyWith(timeSlots: slots, isTimeSlotsLoading: false));
    } on ServerException catch (e) {
      emit(state.copyWith(isTimeSlotsLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isTimeSlotsLoading: false,
          errorMessage: 'Failed to load time slots',
        ),
      );
    }
  }

  // ==================== Time Slot Selected ====================
  void _onTimeSlotSelected(
    TimeSlotSelected event,
    Emitter<BookAppointmentState> emit,
  ) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));
  }

  // ==================== Notes Changed ====================
  void _onNotesChanged(NotesChanged event, Emitter<BookAppointmentState> emit) {
    emit(state.copyWith(notes: event.notes));
  }

  // ==================== Period Changed ====================
  void _onPeriodChanged(
    PeriodChanged event,
    Emitter<BookAppointmentState> emit,
  ) {
    emit(
      state.copyWith(selectedPeriod: event.period, clearSelectedTimeSlot: true),
    );
  }

  // ==================== Book Appointment ====================
  Future<void> _onBookAppointmentSubmitted(
    BookAppointmentSubmitted event,
    Emitter<BookAppointmentState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isBooking: true, clearError: true));

    try {
      // جرب تجيب الـ fileNumber من الـ cache أول
      String fileNumber = profileRepository.getFileNumber() ?? '';

      // لو مش موجود → اجيبه من الـ API
      if (fileNumber.isEmpty) {
        final profile = await profileRepository.getProfile();
        fileNumber = profile.fileNumber;
      }

      // لو لسه فاضي → error
      if (fileNumber.isEmpty) {
        emit(
          state.copyWith(
            isBooking: false,
            errorMessage: 'Could not get your file number. Please try again.',
          ),
        );
        return;
      }

      final date = state.selectedDate!;
      final slot = state.selectedTimeSlot!;
      final time = slot.slotStart.substring(0, 5);
      final appointmentDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T$time:00';

      await repository.bookAppointment(
        clinicId: state.selectedClinic!.id,
        doctorId: state.selectedDoctor!.id,
        appointmentDate: appointmentDate,
        appointmentType: 1,
        fileNumber: fileNumber,
        notes: state.notes,
      );

      emit(state.copyWith(isBooking: false, isBookingSuccess: true));
    } on ServerException catch (e) {
      emit(state.copyWith(isBooking: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isBooking: false,
          errorMessage: 'Failed to book appointment',
        ),
      );
    }
  }

  // ==================== Reset State ====================
  Future<void> _onResetBookingState(
    ResetBookingState event,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(const BookAppointmentState());
    final clinics = await repository.getClinics();
    emit(BookAppointmentState(clinics: clinics));
  }
}
