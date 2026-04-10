import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkInfo {
  static final InternetConnection _checker = InternetConnection();

  static Future<bool> get isConnected async {
    return await _checker.hasInternetAccess;
  }

  static Stream<InternetStatus> get onStatusChange {
    return _checker.onStatusChange;
  }
}
