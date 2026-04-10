import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class QueueStatusScreen extends StatelessWidget {
  const QueueStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue Status')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Doctor Info
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.accentColor,
              child: Icon(
                Icons.person,
                color: AppColors.primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Dr. Stone Gaze',
              style: AppTextStyles.heading3(fontWeight: FontWeight.bold),
            ),
            Text(
              'Ear, Nose & Throat specialist',
              style: AppTextStyles.bodySmall(color: AppColors.greyColor),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'WAITING',
                style: AppTextStyles.caption(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Queue Number
            Text(
              'Your Number',
              style: AppTextStyles.bodyMedium(color: AppColors.greyColor),
            ),
            const SizedBox(height: 8),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '12',
                  style: AppTextStyles.heading1(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Estimated Time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoBox('09', 'Current'),
                const SizedBox(width: 16),
                _buildInfoBox('25', 'Est. Minutes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading2(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption()),
        ],
      ),
    );
  }
}
