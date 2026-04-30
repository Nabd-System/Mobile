import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/lab_result_model.dart';

class LabResultCard extends StatelessWidget {
  final LabResultModel labResult;
  final VoidCallback onTap;

  const LabResultCard({
    super.key,
    required this.labResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Category Badge + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Lab Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.science_outlined,
                            size: 14,
                            color: Colors.purple.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Lab Test',
                            style: AppTextStyles.caption(
                              color: Colors.purple.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Date
                    Text(
                      DateFormat('MMM dd, yyyy').format(labResult.createdAt),
                      style: AppTextStyles.caption(color: AppColors.greyColor),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Test Name + Icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.biotech_outlined,
                        size: 20,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labResult.name,
                            style: AppTextStyles.bodyMedium(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 12,
                                color: AppColors.greyColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('hh:mm a').format(labResult.createdAt),
                                style: AppTextStyles.caption(
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.greyColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}