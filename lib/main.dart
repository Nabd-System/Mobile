import 'package:flutter/material.dart';
import 'package:nabd/core/services/local/app_local_storage.dart';
import 'package:nabd/core/services/remote/dio_provider.dart';
import 'package:nabd/features/intro/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  
  await AppLocalStorage.init();
  DioProvider.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}