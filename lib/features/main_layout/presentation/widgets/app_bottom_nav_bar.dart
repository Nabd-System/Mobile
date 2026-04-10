import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CircleNavBar(
        activeIndex: currentIndex,
        onTap: onTap,
        activeIcons: const [
          Icon(Icons.calendar_month, color: AppColors.whiteColor),
          Icon(Icons.event_note, color: AppColors.whiteColor),
          Icon(Icons.home_rounded, color: AppColors.whiteColor),
          Icon(Icons.folder, color: AppColors.whiteColor),
          Icon(Icons.person, color: AppColors.whiteColor),
        ],
        inactiveIcons: const [
          Icon(Icons.calendar_month_outlined, color: AppColors.greyColor),
          Icon(Icons.event_note_outlined, color: AppColors.greyColor),
          Icon(Icons.home_outlined, color: AppColors.greyColor),
          Icon(Icons.folder_outlined, color: AppColors.greyColor),
          Icon(Icons.person_outline, color: AppColors.greyColor),
        ],
        height: 70,
        circleWidth: 50,
        color: AppColors.whiteColor.withValues(alpha: 0.75),
        circleColor: AppColors.primaryColor,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.2),
        elevation: 8,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.all(Radius.circular(28)),
        tabCurve: Curves.easeOutBack,
        circleShadowColor: AppColors.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }
}
