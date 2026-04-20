import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancelTap,
  });

  final AppointmentModel appointment;
  final VoidCallback? onCancelTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          // Doctor Info Row
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: AppTextStyles.bodyMedium(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      appointment.clinicName,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 12),

          // Date & Time Row
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                appointment.formattedDate,
                style: AppTextStyles.bodySmall(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time,
                color: AppColors.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                appointment.formattedTime,
                style: AppTextStyles.bodySmall(
                  color: AppColors.darkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Cancel Button - فقط لو onCancelTap موجود
          if (onCancelTap != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancelTap,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.redColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.redColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String label;

    if (appointment.isScheduled) {
      bgColor = AppColors.primaryColor.withOpacity(0.1);
      textColor = AppColors.primaryColor;
      label = 'Scheduled';
    } else if (appointment.isCompleted) {
      bgColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      label = 'Completed';
    } else {
      bgColor = AppColors.redColor.withOpacity(0.1);
      textColor = AppColors.redColor;
      label = 'Cancelled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
