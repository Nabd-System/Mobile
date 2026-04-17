import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/appointments/presentation/bloc/my_appointments_bloc.dart';
import 'package:nabd/features/appointments/presentation/widgets/appointment_card.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.greyColor,
            indicatorColor: AppColors.primaryColor,
            labelStyle: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: BlocConsumer<MyAppointmentsBloc, MyAppointmentsState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: Colors.green,
                ),
              );
            }
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
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            return TabBarView(
              children: [
                // ==================== Upcoming Tab ====================
                _buildAppointmentsList(
                  context: context,
                  appointments: state.upcomingAppointments,
                  emptyMessage: 'No upcoming appointments',
                  isUpcoming: true,
                ),

                // ==================== Past Tab ====================
                _buildAppointmentsList(
                  context: context,
                  appointments: state.pastAppointments,
                  emptyMessage: 'No past appointments',
                  isUpcoming: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppointmentsList({
    required BuildContext context,
    required List appointments,
    required String emptyMessage,
    required bool isUpcoming,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.calendar_today_outlined : Icons.history,
              size: 64,
              color: AppColors.borderColor,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        context.read<MyAppointmentsBloc>().add(LoadMyAppointments());
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100,
        ),
        itemCount: appointments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return AppointmentCard(
            appointment: appointment,
            onCancelTap: isUpcoming
                ? () => _showCancelDialog(context, appointment.appointmentId)
                : null,
          );
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancel Appointment',
          style: AppTextStyles.heading3(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to cancel this appointment?',
          style: AppTextStyles.bodySmall(color: AppColors.greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'No',
              style: AppTextStyles.bodySmall(color: AppColors.greyColor),
            ),
          ),
          TextButton(
            onPressed: () {
              final bloc = context.read<MyAppointmentsBloc>();
              Navigator.of(dialogContext).pop();
              bloc.add(
                CancelAppointmentRequested(appointmentId: appointmentId),
              );
            },
            child: Text(
              'Yes, Cancel',
              style: AppTextStyles.bodySmall(
                color: AppColors.redColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
