import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/medical_records/data/models/allergy_model.dart';

class AllergyCard extends StatelessWidget {
  final AllergyModel allergy;
  final VoidCallback onTap;

  const AllergyCard({super.key, required this.allergy, required this.onTap});

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
                // Header: Type Badge + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(
                          allergy.allergenType,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getTypeIcon(allergy.allergenType),
                            size: 14,
                            color: _getTypeColor(allergy.allergenType),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            allergy.allergenType,
                            style: AppTextStyles.caption(
                              color: _getTypeColor(allergy.allergenType),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Date
                    Text(
                      DateFormat('MMM dd, yyyy').format(allergy.createAt),
                      style: AppTextStyles.caption(color: AppColors.greyColor),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Allergen Name + Icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: AppColors.redColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allergy.allergenName,
                            style: AppTextStyles.bodyMedium(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${allergy.allergenType} Allergy',
                            style: AppTextStyles.caption(
                              color: AppColors.greyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.greyColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'medication':
        return AppColors.redColor;
      case 'environmental':
        return Colors.green;
      case 'insect':
        return Colors.purple;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'medication':
        return Icons.medication;
      case 'environmental':
        return Icons.eco;
      case 'insect':
        return Icons.bug_report;
      default:
        return Icons.warning_amber;
    }
  }
}
