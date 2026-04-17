import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';
import 'package:nabd/features/appointments/data/models/time_slot_model.dart';

class TimeSlotsGrid extends StatelessWidget {
  const TimeSlotsGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.selectedPeriod,
    required this.onSlotSelected,
    required this.onPeriodChanged,
    this.isLoading = false,
  });

  final List<TimeSlotModel> slots;
  final TimeSlotModel? selectedSlot;
  final String selectedPeriod;
  final void Function(TimeSlotModel) onSlotSelected;
  final void Function(String) onPeriodChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with AM/PM toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available Time',
              style: AppTextStyles.bodyMedium(fontWeight: FontWeight.w600),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: ['AM', 'PM'].map((period) {
                  final isSelected = selectedPeriod == period;
                  return GestureDetector(
                    onTap: () => onPeriodChanged(period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        period,
                        style: AppTextStyles.bodySmall(
                          color: isSelected
                              ? AppColors.whiteColor
                              : AppColors.greyColor,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Slots
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          )
        else if (slots.isEmpty)
          Center(
            child: Text(
              'No available slots',
              style: AppTextStyles.bodySmall(color: AppColors.greyColor),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final isSelected = selectedSlot?.slotStart == slot.slotStart;

              return GestureDetector(
                onTap: slot.isAvailable ? () => onSlotSelected(slot) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : slot.isAvailable
                        ? AppColors.accentColor
                        : AppColors.borderColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      slot.displayTime,
                      style: AppTextStyles.bodySmall(
                        color: isSelected
                            ? AppColors.whiteColor
                            : slot.isAvailable
                            ? AppColors.darkColor
                            : AppColors.greyColor,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
