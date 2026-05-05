import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/radiology_model.dart';

class RadiologyCard extends StatelessWidget {
  final RadiologyModel radiology;
  final VoidCallback onTap;

  const RadiologyCard({
    super.key,
    required this.radiology,
    required this.onTap,
  });

  // ==================== Color & Icon by Type ====================
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'x-ray':
        return Colors.blue.shade600;
      case 'ct':
        return Colors.purple.shade600;
      case 'mri':
        return Colors.indigo.shade600;
      case 'ultrasound':
        return Colors.teal.shade600;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'x-ray':
        return Icons.monitor_heart_outlined;
      case 'ct':
        return Icons.rotate_90_degrees_ccw_outlined;
      case 'mri':
        return Icons.psychology_outlined;
      case 'ultrasound':
        return Icons.waves_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(radiology.reportType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== Icon ====================
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(radiology.reportType),
                size: 24,
                color: color,
              ),
            ),

            const SizedBox(width: 12),

            // ==================== Content ====================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Report Number + Status Badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          radiology.reportNumber,
                          style: AppTextStyles.bodySmall(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(radiology.reportStatus),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      radiology.reportType,
                      style: AppTextStyles.caption(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Findings Preview
                  Text(
                    radiology.findingsEn,
                    style: AppTextStyles.caption(
                      color: AppColors.darkGreyColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(radiology.reportDate),
                        style: AppTextStyles.caption(
                          color: AppColors.greyColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Status Badge ====================
  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    switch (status.toLowerCase()) {
      case 'finalized':
        badgeColor = Colors.green;
        break;
      case 'pending':
        badgeColor = Colors.orange;
        break;
      case 'amended':
        badgeColor = Colors.blue;
        break;
      default:
        badgeColor = AppColors.greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
