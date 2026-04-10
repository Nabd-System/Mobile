import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ==================== Headings ====================
  static TextStyle heading1({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 30,
      color: color ?? AppColors.darkColor,
      fontWeight: fontWeight ?? FontWeight.bold,
    );
  }

  static TextStyle heading2({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 24,
      color: color ?? AppColors.darkColor,
      fontWeight: fontWeight ?? FontWeight.bold,
    );
  }

  static TextStyle heading3({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 20,
      color: color ?? AppColors.darkColor,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  // ==================== Body ====================
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 18,
      color: color ?? AppColors.darkColor,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16,
      color: color ?? AppColors.darkColor,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 14,
      color: color ?? AppColors.darkColor,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  // ==================== Caption ====================
  static TextStyle caption({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 12,
      color: color ?? AppColors.greyColor,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  // ==================== Button ====================
  static TextStyle button({Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: 16,
      color: color ?? AppColors.whiteColor,
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }
}
