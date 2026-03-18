import 'package:flutter/material.dart';
import 'package:nabd/core/utils/colors.dart';
import 'package:nabd/core/utils/text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.width = double.infinity,
    this.height = 56,
    this.radius = 10,
    required this.text,
    this.bgColor,
    this.textColor,
    required this.onPressed,
  });

  final double width;
  final double height;
  final Color? bgColor;
  final Color? textColor;
  final String text;
  final Function() onPressed;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: bgColor ?? AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                )),
            onPressed: onPressed,
            child: Text(
              text,
              style:
                  getFont16TextStyle(color: textColor ?? AppColors.whiteColor),
            )));
  }
}
