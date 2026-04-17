import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class StepsProgressBar extends StatelessWidget {
  const StepsProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Steps Completed',
              style: AppTextStyles.bodySmall(color: AppColors.greyColor),
            ),
            Text(
              '$currentStep/$totalSteps',
              style: AppTextStyles.bodySmall(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            backgroundColor: AppColors.borderColor,
            color: AppColors.primaryColor,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
