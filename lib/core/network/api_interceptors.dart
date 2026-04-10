import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/core/constants/storage_keys.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppLocalStorage.getData(StorageKeys.token);
    if (token != null && token.toString().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────');
    debugPrint('│ 🚀 REQUEST: ${options.method} ${options.uri}');
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
      '│ ✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    debugPrint('│ Data: ${response.data}');
    debugPrint('└──────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌──────────────────────────────────────');
    debugPrint(
      '│ ❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}',
    );
    debugPrint('│ Message: ${err.message}');
    debugPrint('│ Response: ${err.response?.data}');
    debugPrint('└──────────────────────────────────────');
    super.onError(err, handler);
  }
}
