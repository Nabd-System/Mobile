import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/home/presentation/widgets/home_header.dart';
import 'package:nabd/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:nabd/features/home/presentation/widgets/specializations_section.dart';
import 'package:nabd/features/home/presentation/widgets/health_tip_banner.dart';
import 'package:nabd/features/queue/presentation/pages/queue_status_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HomeHeader(userName: 'Sara', userType: 'Patient'),
              const SizedBox(height: 24),

              // Upcoming Appointments
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Appointments',
                    style: AppTextStyles.heading3(),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: navigate to all appointments
                    },
                    child: Text(
                      'View All',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              UpcomingAppointmentCard(
                doctorName: 'Dr. Stone Gaze',
                specialty: 'Ear, Nose & Throat specialist',
                date: 'Wed, 10 Jan, 2025',
                time: 'Morning set: 11:00',
                imageUrl: '',
                onTap: () {
                  pushTo(context, const QueueStatusScreen());
                },
              ),
              const SizedBox(height: 24),

              // Hospital Clinic
              Text('Hospital Clinic', style: AppTextStyles.heading3()),
              const SizedBox(height: 12),
              const SpecializationsSection(),
              const SizedBox(height: 24),

              // Health Tips
              const HealthTipBanner(
                title: 'Prevent the spread of COVID-19',
                imageAsset: 'assets/images/nabdlogopng.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
