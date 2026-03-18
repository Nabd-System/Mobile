import 'package:flutter/material.dart';
import 'package:nabd/core/constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//  void initState() {
//     super.initState();
//     String? token = AppLocalStorage.getData(AppLocalStorage.token);
//     Future.delayed(const Duration(seconds: 3), () {
//       if (token != null) {
//          pushWithReplacement(context, const NavBarWidget());
//        } else {
//          pushWithReplacement(context, const WelcomeScreen());
//        }
//     });
//   }
class _SplashScreenState extends State<SplashScreen> {
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
