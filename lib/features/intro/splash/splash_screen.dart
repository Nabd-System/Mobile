import 'package:flutter/material.dart';
import 'package:nabd/core/constants/app_assets.dart';
import 'package:nabd/core/functions/navigation.dart';
import 'package:nabd/core/services/local/app_local_storage.dart';
import 'package:nabd/features/auth/presentation/page/login_screen.dart';
import 'package:nabd/features/home/presentation/page/home.dart';
import 'package:nabd/features/intro/onboarding/page/onboarding_screen.dart';

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
        pushWithReplacement(context, const Home());
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(AppAssets.logoPng, width: 166, height: 179),
            ),
          ],
        ),
      ),
    );
  }
}
