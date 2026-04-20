import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/core/widgets/custom_button.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_state.dart';
import 'package:nabd/features/auth/presentation/pages/login_screen.dart';
import 'package:nabd/features/profile/data/models/patient_profile_model.dart';
import 'package:nabd/features/profile/presentation/bloc/profile_bloc.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<PatientProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          pushAndRemoveUntil(context, const LoginScreen());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Patient Profile'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.redColor),
              tooltip: 'Logout',
              onPressed: () => _showLogoutDialog(context),
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }
            if (state is ProfileError) {
              return _buildErrorState(context, state.message);
            }
            if (state is ProfileLoaded) {
              return _buildContent(context, state.profile);
            }
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          },
        ),
      ),
    );
  }

  // ==================== Error State ====================
  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.redColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Try Again',
              width: 160,
              onPressed: () =>
                  context.read<ProfileBloc>().add(RefreshProfileEvent()),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Main Content ====================
  // ==================== Main Content ====================
  Widget _buildContent(BuildContext context, PatientProfileModel profile) {
    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        context.read<ProfileBloc>().add(RefreshProfileEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100, // ← padding من تحت عشان الـ nav bar
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Avatar ──
            _buildAvatar(profile.fullNameEnglish),
            const SizedBox(height: 16),

            // ── Name ──
            Text(profile.fullNameEnglish, style: AppTextStyles.heading3()),
            const SizedBox(height: 6),

            // ── Patient ID ──
            Text(
              'Patient ID: #${profile.fileNumber}',
              style: AppTextStyles.bodySmall(color: AppColors.primaryColor),
            ),
            const SizedBox(height: 28),

            // ── Personal Details Card ──
            _buildInfoCard(
              title: 'PERSONAL DETAILS',
              rows: [
                _InfoRow(label: 'Full Name', value: profile.fullNameEnglish),
                _InfoRow(label: 'File Number', value: profile.fileNumber),
                _InfoRow(
                  label: 'National ID',
                  value: profile.nationalId.isNotEmpty
                      ? 'ID-${profile.nationalId}'
                      : '-',
                ),
                _InfoRow(
                  label: 'Date of Birth',
                  value: _formatDate(profile.dateOfBirth),
                ),
                _InfoRow(label: 'Gender', value: profile.gender),
              ],
            ),
            const SizedBox(height: 16),

            // ── Contact & Medical Card ──
            _buildInfoCard(
              title: 'CONTACT & MEDICAL',
              rows: [
                _InfoRow(label: 'Phone', value: profile.phoneNumber ?? '-'),
                _InfoRow(label: 'Email', value: profile.email),
                _InfoRow(
                  label: 'Blood Type',
                  value: profile.bloodType ?? '-',
                  isChip: profile.bloodType != null,
                ),
                _InfoRow(
                  label: 'Insurance Type',
                  value: profile.insuranceType ?? '-',
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Logout Button ──
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: 'Log Out',
                  bgColor: AppColors.redColor,
                  isLoading: state is LogoutLoading,
                  onPressed: () => _showLogoutDialog(context),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }

  // ==================== Avatar ====================
  Widget _buildAvatar(String fullName) {
    final initials = fullName.trim().isNotEmpty
        ? fullName.trim().split(' ').take(2).map((w) => w[0]).join()
        : 'P';

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withOpacity(0.1),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          style: AppTextStyles.heading2(color: AppColors.primaryColor),
        ),
      ),
    );
  }

  // ==================== Info Card ====================
  Widget _buildInfoCard({required String title, required List<_InfoRow> rows}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              title,
              style: AppTextStyles.caption(
                color: AppColors.greyColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.borderColor),

          // Rows
          ...rows.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final isLast = index == rows.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        row.label,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.greyColor,
                        ),
                      ),
                      row.isChip
                          ? _buildBloodTypeChip(row.value)
                          : Flexible(
                              child: Text(
                                row.value,
                                textAlign: TextAlign.end,
                                style: AppTextStyles.bodySmall(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    color: AppColors.borderColor,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ==================== Blood Type Chip ====================
  Widget _buildBloodTypeChip(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        value,
        style: AppTextStyles.caption(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ==================== Logout Dialog ====================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out', style: AppTextStyles.heading3()),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: Text(
              'Log Out',
              style: AppTextStyles.bodyMedium(
                color: AppColors.redColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Helpers ====================
  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}

// ==================== Helper Class ====================
class _InfoRow {
  final String label;
  final String value;
  final bool isChip;

  _InfoRow({required this.label, required this.value, this.isChip = false});
}
