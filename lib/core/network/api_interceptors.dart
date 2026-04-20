import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nabd/core/constants/storage_keys.dart';
import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/storage/hive_service.dart';
import 'package:nabd/core/utils/navigation_service.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';
import 'package:nabd/features/auth/presentation/pages/login_screen.dart';

class AuthInterceptor extends Interceptor {
  static bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppLocalStorage.getData(StorageKeys.token);
    if (token != null && token.toString().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshRequest = err.requestOptions.path.contains(
      AppEndpoints.refreshToken,
    );

    // لو 401 ومش refresh request ومش بنعمل refresh حاليًا
    if (isUnauthorized && !isRefreshRequest && !_isRefreshing) {
      _isRefreshing = true;

      final refreshed = await _tryRefreshToken();

      _isRefreshing = false;

      if (refreshed) {
        // Refresh نجح → أعد الـ request الأصلي
        try {
          final newToken = AppLocalStorage.getData(StorageKeys.token);
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final response = await ApiClient.dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (retryError) {
          // لو فشل مرة تانية → logout
          await _clearSessionAndNavigateToLogin();
          return handler.next(err);
        }
      } else {
        // Refresh فشل → logout
        await _clearSessionAndNavigateToLogin();
      }
    }

    super.onError(err, handler);
  }

  /// محاولة refresh token
  Future<bool> _tryRefreshToken() async {
    try {
      debugPrint(' Attempting to refresh token...');

      final response = await ApiClient.dio.post(AppEndpoints.refreshToken);

      if (response.statusCode == 200 && response.data['isSuccess'] == true) {
        final user = LoginResponseModel.fromJson(response.data['data']);

        // حفظ الـ tokens الجديدة
        await AppLocalStorage.cacheData(StorageKeys.token, user.accessToken);
        await AppLocalStorage.cacheData(
          StorageKeys.refreshToken,
          user.refreshToken,
        );
        await AppLocalStorage.cacheData(StorageKeys.userType, user.userType);
        await AppLocalStorage.cacheData(StorageKeys.userName, user.userName);

        await HiveService.put(
          boxName: HiveService.userBox,
          key: 'current_user',
          value: user.toJson(),
        );

        debugPrint(' Token refreshed successfully!');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint(' Failed to refresh token: $e');
      return false;
    }
  }

  /// مسح الـ session والرجوع لـ login
  Future<void> _clearSessionAndNavigateToLogin() async {
    debugPrint(' Session expired. Logging out...');

    // مسح SharedPreferences
    await AppLocalStorage.removeData(StorageKeys.token);
    await AppLocalStorage.removeData(StorageKeys.refreshToken);
    await AppLocalStorage.removeData(StorageKeys.userType);
    await AppLocalStorage.removeData(StorageKeys.userName);
    await AppLocalStorage.removeData(StorageKeys.fileNumber);

    // مسح Hive
    await HiveService.clearAll();

    // Navigate to Login
    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────');
    debugPrint('│  REQUEST: ${options.method} ${options.uri}');
    debugPrint('│ Headers: ${options.headers}');
    if (options.data != null) {
      debugPrint('│ Body: ${options.data}');
    }
    debugPrint('└──────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────');
    debugPrint(
      '│  RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    debugPrint('│ Data: ${response.data}');
    debugPrint('└──────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────');
    debugPrint(
      '│  ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}',
    );
    debugPrint('│ Message: ${err.message}');
    debugPrint('│ Response: ${err.response?.data}');
    debugPrint('└──────────────────────────────────────');
    super.onError(err, handler);
  }
}
