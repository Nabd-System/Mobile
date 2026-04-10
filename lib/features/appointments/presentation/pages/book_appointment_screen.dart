import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Book Appointment', style: AppTextStyles.heading3()),
      ),
    );
  }
}
