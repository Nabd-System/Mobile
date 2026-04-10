import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 10,
    required this.text,
    this.bgColor,
    this.textColor,
    required this.onPressed,
    this.isLoading = false,
  });

  final double width;
  final double height;
  final Color? bgColor;
  final Color? textColor;
  final String text;
  final VoidCallback? onPressed;
  final double radius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? AppColors.primaryColor,
          disabledBackgroundColor: AppColors.greyColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.whiteColor,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.button(
                  color: textColor ?? AppColors.whiteColor,
                ),
              ),
      ),
    );
  }
}
