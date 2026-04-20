import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/constants/app_assets.dart';
import 'package:nabd/core/storage/hive_service.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';
import 'package:nabd/features/home/presentation/bloc/home_bloc.dart';
import 'package:nabd/features/home/presentation/widgets/home_header.dart';
import 'package:nabd/features/home/presentation/widgets/doctor_search_bar.dart';
import 'package:nabd/features/home/presentation/widgets/doctor_search_result_card.dart';
import 'package:nabd/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:nabd/features/home/presentation/widgets/specializations_section.dart';
import 'package:nabd/features/home/presentation/widgets/health_tip_banner.dart';
import 'package:nabd/features/home/presentation/widgets/quick_actions_section.dart';
import 'package:nabd/features/queue/presentation/pages/queue_status_screen.dart';
import 'package:nabd/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:nabd/features/ai_chat/presentation/pages/ai_chat_screen.dart';
import 'package:nabd/features/ai_chat/presentation/widgets/floating_ai_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Load upcoming appointment
    context.read<HomeBloc>().add(GetUpcomingAppointmentEvent());
  }

  void _loadUserData() {
    final data = HiveService.get(
      boxName: HiveService.userBox,
      key: 'current_user',
    );

    if (data != null) {
      final user = LoginResponseModel.fromJson(Map<String, dynamic>.from(data));

      setState(() {
        _userName = user.fullNameEnglish.isNotEmpty
            ? user.fullNameEnglish
            : user.userName;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToTab(BuildContext context, int tabIndex) {
    final mainLayout = context.findAncestorStateOfType<MainLayoutScreenState>();
    if (mainLayout != null) {
      mainLayout.changeTab(tabIndex);
    }
  }

  void _goToProfile() {
    _navigateToTab(context, 4);
  }

  void _onDoctorTap(int doctorId) {
    _navigateToTab(context, 0);
  }

  void _openAiChat() {
    pushTo(context, const AiChatScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // ==================== Main Content ====================
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    context.read<HomeBloc>().add(GetUpcomingAppointmentEvent());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        HomeHeader(
                          userName: _userName,
                          userType: 'Patient',
                          onAvatarTap: _goToProfile,
                        ),
                        const SizedBox(height: 16),

                        // Search Bar
                        DoctorSearchBar(
                          controller: _searchController,
                          isLoading: state.isSearching,
                          onChanged: (query) {
                            context.read<HomeBloc>().add(
                              SearchDoctorsEvent(searchTerm: query),
                            );
                          },
                          onClear: () {
                            _searchController.clear();
                            context.read<HomeBloc>().add(ClearSearchEvent());
                          },
                        ),
                        const SizedBox(height: 16),

                        // ==================== Search Results ====================
                        if (state.showResults) ...[
                          if (state.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                state.errorMessage!,
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.redColor,
                                ),
                              ),
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search Results',
                                style: AppTextStyles.bodyMedium(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${state.searchResults.length} found',
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (state.hasResults)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.searchResults.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final doctor = state.searchResults[index];
                                return DoctorSearchResultCard(
                                  doctor: doctor,
                                  onTap: () => _onDoctorTap(doctor.doctorId),
                                );
                              },
                            )
                          else if (!state.isSearching)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: AppColors.greyColor.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No doctors found',
                                      style: AppTextStyles.bodyMedium(
                                        color: AppColors.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),
                        ],

                        // ==================== Normal Home Content ====================
                        if (!state.showResults) ...[
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

                          // Upcoming Appointment Card
                          _buildUpcomingAppointmentSection(state),

                          const SizedBox(height: 24),

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
                                onTap: _openAiChat,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hospital Clinic',
                                style: AppTextStyles.heading3(),
                              ),
                              TextButton(
                                onPressed: () {},
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

                          const HealthTipBanner(
                            title: 'Prevent the spread of COVID-19 Virus',
                            imageAsset: 'assets/images/nabdlogopng.png',
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            // ==================== Floating AI Button ====================
            FloatingAiButton(onTap: _openAiChat),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentSection(HomeState state) {
    // Loading
    if (state.isLoadingAppointment) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    // No upcoming appointment
    if (state.hasNoUpcoming || !state.hasUpcomingAppointment) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 40,
              color: AppColors.greyColor.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No upcoming appointments',
              style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _navigateToTab(context, 0),
              child: Text(
                'Book Now',
                style: AppTextStyles.bodySmall(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Has upcoming appointment
    final appointment = state.upcomingAppointment!;
    return UpcomingAppointmentCard(
      doctorName: 'Dr. ${appointment.doctorName}',
      specialty: appointment.clinicName,
      date: appointment.formattedDate,
      time: appointment.formattedTime,
      imageUrl: '',
      onTap: () {
        pushTo(context, const QueueStatusScreen());
      },
    );
  }
}
