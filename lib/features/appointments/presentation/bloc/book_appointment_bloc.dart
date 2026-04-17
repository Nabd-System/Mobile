import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/appointments/data/models/clinic_model.dart';
import 'package:nabd/features/appointments/data/models/doctor_model.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';
import 'package:nabd/features/appointments/domain/repositories/appointments_repository.dart';

part 'book_appointment_event.dart';
part 'book_appointment_state.dart';

class BookAppointmentBloc
    extends Bloc<BookAppointmentEvent, BookAppointmentState> {
  final AppointmentsRepository repository;

  BookAppointmentBloc({required this.repository})
    : super(const BookAppointmentState()) {
    on<LoadClinicsRequested>(_onLoadClinics);
    on<ResetBookingState>(_onResetBookingState); // ← ضيف ده
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
    // لما بيختار كلينيك جديد، بنشيل الدكتور المختار ونجيب الدكاترة
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

    // لو في تاريخ مختار، نجيب الـ time slots
    if (state.selectedDate != null) {
      await _loadTimeSlots(event.doctor.id, state.selectedDate!, emit);
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

    // لو في دكتور مختار، نجيب الـ time slots
    if (state.selectedDoctor != null) {
      await _loadTimeSlots(state.selectedDoctor!.id, event.date, emit);
    }
  }

  // ==================== Load Time Slots ====================
  Future<void> _loadTimeSlots(
    int doctorId,
    DateTime date,
    Emitter<BookAppointmentState> emit,
  ) async {
    emit(state.copyWith(isTimeSlotsLoading: true));
    try {
      final slots = await repository.getAvailableTimeSlots(
        doctorId: doctorId,
        date: '${date.year}-${date.month}-${date.day}',
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
      await repository.bookAppointment(
        clinicId: state.selectedClinic!.id,
        doctorId: state.selectedDoctor!.id,
        date:
            '${state.selectedDate!.year}-${state.selectedDate!.month}-${state.selectedDate!.day}',
        time: state.selectedTimeSlot!.time,
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
    // Reset كل حاجة وارجع للحالة الأولى
    emit(const BookAppointmentState());
    // reload الكلينيكس
    final clinics = await repository.getClinics();
    emit(BookAppointmentState(clinics: clinics));
  }
}
