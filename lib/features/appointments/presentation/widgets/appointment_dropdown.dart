import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class AppointmentDropdown<T> extends StatelessWidget {
  const AppointmentDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemLabel,
    this.value,
    required this.onChanged,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String label;
  final String hint;
  final List<T> items;
  final String Function(T) itemLabel;
  final T? value;
  final void Function(T?) onChanged;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.accentColor : AppColors.borderColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 50,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    hint: Text(
                      hint,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.greyColor,
                      ),
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.greyColor,
                    ),
                    style: AppTextStyles.bodySmall(),
                    onChanged: isEnabled ? onChanged : null,
                    items: items.map((item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Text(itemLabel(item)),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }
}
