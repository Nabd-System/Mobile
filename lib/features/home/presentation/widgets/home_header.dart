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
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.accentColor,
          child: Icon(Icons.person, color: AppColors.primaryColor, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi $userName!',
                    style: AppTextStyles.heading3(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      userType,
                      style: AppTextStyles.caption(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'May you always in a good condition',
                style: AppTextStyles.caption(color: AppColors.greyColor),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: notifications
          },
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.darkColor,
          ),
        ),
      ],
    );
  }
}
