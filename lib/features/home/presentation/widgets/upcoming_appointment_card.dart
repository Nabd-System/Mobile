import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.imageUrl,
    this.onTap,
  });

  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Doctor Info Row
            Row(
              children: [
                // Doctor Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.whiteColor.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.whiteColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),

                // Doctor Name & Specialty
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: AppTextStyles.bodyLarge(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        specialty,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.whiteColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date & Time Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.whiteColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: AppTextStyles.bodySmall(color: AppColors.whiteColor),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.access_time,
                    color: AppColors.whiteColor,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: AppTextStyles.bodySmall(color: AppColors.whiteColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
