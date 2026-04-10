import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('My Appointments', style: AppTextStyles.heading3()),
      ),
    );
  }
}
