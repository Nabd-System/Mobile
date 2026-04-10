import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName, required this.userType});

  final String userName;
  final String userType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.accentColor,
          child: Icon(Icons.person, color: AppColors.primaryColor, size: 28),
        ),
        const SizedBox(width: 12),

        // Name & Type
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $userName!',
                style: AppTextStyles.heading3(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  userType,
                  style: AppTextStyles.caption(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Notification Icon
        IconButton(
          onPressed: () {
            // TODO: notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.darkColor,
          ),
        ),

        // Search Icon
        IconButton(
          onPressed: () {
            // TODO: search
          },
          icon: const Icon(Icons.search, color: AppColors.darkColor),
        ),
      ],
    );
  }
}
