
import 'package:flutter/material.dart';
import 'package:nabd/core/utils/colors.dart';

TextStyle getFont30TextStyle(
    {double? fontSize, Color? color, FontWeight? fontWeight}) {
  return TextStyle(
    fontSize: fontSize ?? 30,
    color: color ?? AppColors.darkColor,
  );
}

TextStyle getFont24TextStyle(
    {double? fontSize, Color? color, FontWeight? fontWeight}) {
  return TextStyle(
    fontSize: fontSize ?? 24,
    color: color ?? AppColors.darkColor,
  );
}

TextStyle getFont20TextStyle(
    {double? fontSize, Color? color, FontWeight? fontWeight}) {
  return TextStyle(
    fontSize: fontSize ?? 20,
    color: color ?? AppColors.greyColor,
  );
}

TextStyle getFont18TextStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontSize: fontSize ?? 18,
    color: color ?? AppColors.darkColor,
  );
}

TextStyle getFont16TextStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontSize: fontSize ?? 16,
    color: color ?? AppColors.darkColor,
  );
}

TextStyle getFont14TextStyle({double? fontSize, Color? color}) {
  return TextStyle(
    fontSize: fontSize ?? 14,
    color: color ?? AppColors.darkColor,
  );
}
