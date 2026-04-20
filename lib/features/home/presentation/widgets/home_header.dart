import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.userType,
    this.onAvatarTap,
  });

  final String userName;
  final String userType;
  final VoidCallback? onAvatarTap;

  /// أول حرفين من الاسم
  String get _initials {
    if (userName.trim().isEmpty) return 'U';

    final words = userName.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else {
      return userName.substring(0, userName.length >= 2 ? 2 : 1).toUpperCase();
    }
  }

  /// الاسم الأول فقط
  String get _firstName {
    if (userName.trim().isEmpty) return 'User';
    return userName.trim().split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _initials,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Name & Message
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hi $_firstName!',
                    style: AppTextStyles.heading3(fontWeight: FontWeight.bold),
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

        // Notifications
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
