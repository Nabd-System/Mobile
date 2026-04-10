import 'package:flutter/material.dart';
import 'package:nabd/core/constants/app_assets.dart';
import 'package:nabd/core/utils/navigation.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/features/auth/presentation/pages/login_screen.dart';
import 'package:nabd/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:nabd/features/onboarding/presentation/pages/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      String? token = AppLocalStorage.getData(AppLocalStorage.token);
      bool? seen = AppLocalStorage.getData(AppLocalStorage.onboardingSeen);

      if (token != null) {
        pushWithReplacement(context, const MainLayoutScreen());
      } else if (seen == true) {
        pushWithReplacement(context, const LoginScreen());
      } else {
        pushWithReplacement(context, const OnboardingScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppAssets.logoPng, width: 166, height: 179),
      ),
    );
  }
}
