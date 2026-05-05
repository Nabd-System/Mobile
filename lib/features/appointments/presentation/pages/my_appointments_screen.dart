import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';
import 'package:nabd/features/appointments/presentation/bloc/my_appointments_bloc.dart';
import 'package:nabd/features/appointments/presentation/widgets/appointment_card.dart';
import 'package:nabd/features/home/presentation/bloc/home_bloc.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyAppointmentsBloc>().add(LoadMyAppointments());
  }

  // ✅ بيجيب أول upcoming appointment صح
  void _syncHomeCard(List<AppointmentModel> appointments) {
    final upcoming = appointments.where((a) {
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      try {
        final date = DateTime.parse(a.appointmentDate);
        final dateOnly = DateTime(date.year, date.month, date.day);
        return !dateOnly.isBefore(todayOnly) &&
            !a.isCancelled &&
            !a.isCompleted;
      } catch (_) {
        return false;
      }
    }).toList();

    // أول upcoming appointment أو null لو مفيش
    final firstUpcoming = upcoming.isNotEmpty ? upcoming.first : null;

    context.read<HomeBloc>().add(
      SetUpcomingAppointmentEvent(appointment: firstUpcoming),
    );
  }

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
          listenWhen: (prev, curr) {
            // SnackBar بس لما الـ message يتغير فعلاً
            final successChanged =
                curr.successMessage != null &&
                curr.successMessage != prev.successMessage;
            final errorChanged =
                curr.errorMessage != null &&
                curr.errorMessage != prev.errorMessage;
            // syncHomeCard بس لما الـ loading يخلص
            final finishedLoading =
                prev.isLoading && !curr.isLoading && curr.errorMessage == null;
            return successChanged || errorChanged || finishedLoading;
          },
          listener: (context, state) {
            if (!state.isLoading && state.errorMessage == null) {
              _syncHomeCard(state.appointments);
            }
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
