import 'package:flutter/material.dart';
import 'package:nabd/core/utils/colors.dart';
import 'package:nabd/core/utils/text_styles.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    this.width = double.infinity,
    this.height = 56,
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                side: const BorderSide(color: AppColors.darkColor),
                backgroundColor: bgColor ?? AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            onPressed: onPressed,
            child: Text(
              text,
              style:
                  getFont16TextStyle(color: textColor ?? AppColors.darkColor),
            )));
  }
}
