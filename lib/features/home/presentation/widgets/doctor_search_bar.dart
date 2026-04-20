import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class DoctorSearchBar extends StatelessWidget {
  const DoctorSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.onFilterTap,
    this.isLoading = false,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;
  final VoidCallback onClear;
  final VoidCallback? onFilterTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Doctors Dropdown
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Doctors',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        // const SizedBox(width: 8),

        // Search Field
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                // Text Field
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      hintText: 'Search doctors...',
                      hintStyle: AppTextStyles.bodySmall(
                        color: AppColors.greyColor,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      isDense: true,
                    ),
                    style: AppTextStyles.bodySmall(),
                  ),
                ),

                // Loading / Clear / Search Icon
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildSuffixIcon(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuffixIcon() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryColor,
        ),
      );
    }

    if (controller.text.isNotEmpty) {
      return GestureDetector(
        onTap: onClear,
        child: const Icon(Icons.close, color: AppColors.greyColor, size: 20),
      );
    }

    return const Icon(Icons.search, color: AppColors.greyColor, size: 20);
  }
}
