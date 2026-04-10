import 'package:flutter/material.dart';
import 'package:nabd/features/appointments/presentation/pages/book_appointment_screen.dart';
import 'package:nabd/features/appointments/presentation/pages/my_appointments_screen.dart';
import 'package:nabd/features/home/presentation/pages/home_screen.dart';
import 'package:nabd/features/medical_records/presentation/pages/medical_records_screen.dart';
import 'package:nabd/features/profile/presentation/pages/patient_profile_screen.dart';
import 'package:nabd/features/main_layout/presentation/widgets/app_bottom_nav_bar.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => MainLayoutScreenState();
}

class MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = const [
    BookAppointmentScreen(),
    MyAppointmentsScreen(),
    HomeScreen(),
    MedicalRecordsScreen(),
    PatientProfileScreen(),
  ];

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: changeTab,
      ),
    );
  }
}
