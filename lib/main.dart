import 'package:flutter/material.dart';
import 'package:nabd/app/app.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/storage/hive_service.dart';
import 'package:nabd/core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocalStorage.init();
  await HiveService.init();
  ApiClient.init();
  runApp(const App());
}
