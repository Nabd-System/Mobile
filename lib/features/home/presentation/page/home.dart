import 'package:flutter/material.dart';
import 'package:nabd/core/utils/colors.dart';
import 'package:nabd/core/utils/text_styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Home',
          style: getFont20TextStyle(
            color: AppColors.darkColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}