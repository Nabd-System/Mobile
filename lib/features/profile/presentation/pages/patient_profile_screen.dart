import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Patient Profile', style: AppTextStyles.heading3()),
      ),
    );
  }
}
