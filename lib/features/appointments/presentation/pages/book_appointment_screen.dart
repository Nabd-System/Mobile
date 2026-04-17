import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/core/widgets/custom_text_field.dart';
import 'package:nabd/features/appointments/presentation/bloc/book_appointment_bloc.dart';
import 'package:nabd/features/appointments/presentation/widgets/appointment_calendar.dart';
import 'package:nabd/features/appointments/presentation/widgets/appointment_dropdown.dart';
import 'package:nabd/features/appointments/presentation/widgets/steps_progress_bar.dart';
import 'package:nabd/features/appointments/presentation/widgets/time_slots_grid.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _notesController = TextEditingController();

  DateTime _focusedMonth = DateTime.now();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<BookAppointmentBloc, BookAppointmentState>(
        listener: (context, state) {
          // Success
          if (state.isBookingSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Appointment Booked!',
                        style: AppTextStyles.heading3(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your appointment has been confirmed successfully.',
                        style: AppTextStyles.bodySmall(
                          color: AppColors.greyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Done',
                        onPressed: () {
                          // ✅ نقفل الـ dialog الأول
                          Navigator.of(dialogContext).pop();
                          // ✅ نعمل reset للـ bloc
                          if (context.mounted) {
                            context.read<BookAppointmentBloc>().add(
                              ResetBookingState(),
                            );
                            _notesController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
          }

          // Error
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Steps Progress
                StepsProgressBar(
                  currentStep: state.completedSteps,
                  totalSteps: 4,
                ),

                // Select Clinic
                AppointmentDropdown<dynamic>(
                  label: 'Select Clinic',
                  hint: 'Select Clinic',
                  items: state.clinics,
                  itemLabel: (clinic) => clinic.name,
                  value: state.selectedClinic,
                  isLoading: state.isClinicsLoading,
                  onChanged: (clinic) {
                    if (clinic != null) {
                      context.read<BookAppointmentBloc>().add(
                        ClinicSelected(clinic: clinic),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Select Doctor
                AppointmentDropdown<dynamic>(
                  label: 'Select Doctor',
                  hint: 'Select Doctor',
                  items: state.doctors,
                  itemLabel: (doctor) =>
                      '${doctor.name} (${doctor.specialization})',
                  value: state.selectedDoctor,
                  isLoading: state.isDoctorsLoading,
                  isEnabled: state.selectedClinic != null,
                  onChanged: (doctor) {
                    if (doctor != null) {
                      context.read<BookAppointmentBloc>().add(
                        DoctorSelected(doctor: doctor),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Calendar
                AppointmentCalendar(
                  selectedDate: state.selectedDate,
                  focusedMonth: _focusedMonth,
                  onDateSelected: (date) {
                    context.read<BookAppointmentBloc>().add(
                      DateSelected(date: date),
                    );
                  },
                  onMonthChanged: (month) {
                    setState(() {
                      _focusedMonth = month;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Time Slots
                if (state.selectedDoctor != null &&
                    state.selectedDate != null) ...[
                  TimeSlotsGrid(
                    slots: state.filteredTimeSlots,
                    selectedSlot: state.selectedTimeSlot,
                    selectedPeriod: state.selectedPeriod,
                    isLoading: state.isTimeSlotsLoading,
                    onSlotSelected: (slot) {
                      context.read<BookAppointmentBloc>().add(
                        TimeSlotSelected(timeSlot: slot),
                      );
                    },
                    onPeriodChanged: (period) {
                      context.read<BookAppointmentBloc>().add(
                        PeriodChanged(period: period),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // Additional Notes
                CustomTextField(
                  controller: _notesController,
                  label: 'Additional Notes (Optional)',
                  hintText: 'e.g. Reason for visit, existing symptoms...',
                  maxLines: 3,
                  onChanged: (value) {
                    context.read<BookAppointmentBloc>().add(
                      NotesChanged(notes: value),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Confirm Button
                CustomButton(
                  text: 'Confirm Appointment',
                  isLoading: state.isBooking,
                  onPressed: state.isFormValid
                      ? () {
                          context.read<BookAppointmentBloc>().add(
                            BookAppointmentSubmitted(),
                          );
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
