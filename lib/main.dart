// lib/main.dart
import 'package:flutter/material.dart';
import 'package:nabd/app.dart';
import 'package:nabd/core/services/local/app_local_storage.dart';
import 'package:nabd/core/services/remote/dio_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalStorage.init();
  DioProvider.init();
  runApp(const App()); // ← بدل MainApp
}
