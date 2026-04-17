import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class AppointmentCalendar extends StatelessWidget {
  const AppointmentCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.focusedMonth,
    required this.onMonthChanged,
  });

  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;
  final DateTime focusedMonth;
  final void Function(DateTime) onMonthChanged;

  static const List<String> _weekDays = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
  ];

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(focusedMonth);
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          // Month Header
          Row(
            children: [
              GestureDetector(
                onTap: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month - 1),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.primaryColor,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${_months[focusedMonth.month - 1]} ${focusedMonth.year}',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onMonthChanged(
                  DateTime(focusedMonth.year, focusedMonth.month + 1),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Week Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.map((day) {
              return SizedBox(
                width: 36,
                child: Text(
                  day,
                  style: AppTextStyles.caption(
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: daysInMonth + startingWeekday,
            itemBuilder: (context, index) {
              if (index < startingWeekday) {
                return const SizedBox.shrink();
              }

              final day = index - startingWeekday + 1;
              final date = DateTime(focusedMonth.year, focusedMonth.month, day);

              final isSelected =
                  selectedDate != null &&
                  selectedDate!.year == date.year &&
                  selectedDate!.month == date.month &&
                  selectedDate!.day == date.day;

              final isToday =
                  today.year == date.year &&
                  today.month == date.month &&
                  today.day == date.day;

              final isPast = date.isBefore(
                DateTime(today.year, today.month, today.day),
              );

              return GestureDetector(
                onTap: isPast ? null : () => onDateSelected(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primaryColor)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.whiteColor
                            : isPast
                            ? AppColors.borderColor
                            : AppColors.darkColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
