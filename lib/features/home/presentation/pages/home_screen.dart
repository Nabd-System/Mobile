import 'package:flutter/material.dart';
import 'package:nabd/core/constants/app_assets.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/home/presentation/widgets/home_header.dart';
import 'package:nabd/features/home/presentation/widgets/doctor_search_bar.dart';
import 'package:nabd/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:nabd/features/home/presentation/widgets/specializations_section.dart';
import 'package:nabd/features/home/presentation/widgets/health_tip_banner.dart';
import 'package:nabd/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:nabd/features/queue/presentation/pages/queue_status_screen.dart';
import 'package:nabd/features/main_layout/presentation/pages/main_layout_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToTab(BuildContext context, int tabIndex) {
    final mainLayout = context.findAncestorStateOfType<MainLayoutScreenState>();
    if (mainLayout != null) {
      mainLayout.changeTab(tabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HomeHeader(userName: 'Sara', userType: 'Patient'),
              const SizedBox(height: 16),

              // Search Bar
              DoctorSearchBar(
                onSearch: (query) {
                  // TODO: search for doctor
                },
                onFilterTap: () {
                  // TODO: show filter options
                },
              ),
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
                    onPressed: () => _navigateToTab(context, 1),
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

              // Quick Actions
              QuickActionsSection(
                items: [
                  QuickActionItem(
                    title: 'Book an Appointment',
                    subtitle: 'Find & book doctors',
                    image: AppAssets.bookappointment,
                    onTap: () => _navigateToTab(context, 0),
                  ),
                  QuickActionItem(
                    title: 'My Medical Records',
                    subtitle: 'View your records',
                    image: AppAssets.medicalrecords,
                    onTap: () => _navigateToTab(context, 3),
                  ),
                  QuickActionItem(
                    title: 'Lab & Radiology',
                    subtitle: 'Check your results',
                    image: AppAssets.labres,
                    onTap: () => _navigateToTab(context, 3),
                  ),
                  QuickActionItem(
                    title: 'AI Health Assistant',
                    subtitle: 'Chat with AI',
                    image: AppAssets.aipc,
                    onTap: () {
                      // TODO: navigate to AI chat
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Hospital Clinic
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hospital Clinic', style: AppTextStyles.heading3()),
                  TextButton(
                    onPressed: () {
                      // TODO: view all
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
              const SpecializationsSection(),
              const SizedBox(height: 24),

              // Health Tips
              const HealthTipBanner(
                title: 'Prevent the spread of COVID-19 Virus',
                imageAsset: 'assets/images/nabdlogopng.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
