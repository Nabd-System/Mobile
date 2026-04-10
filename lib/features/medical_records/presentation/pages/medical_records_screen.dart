import 'package:flutter/material.dart';
import 'package:nabd/core/theme/app_text_styles.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Medical Records', style: AppTextStyles.heading3()),
      ),
    );
  }
}
