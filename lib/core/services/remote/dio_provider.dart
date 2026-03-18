import 'package:dio/dio.dart';
import 'package:nabd/core/services/remote/endpoints.dart';

class DioProvider {
  static late Dio _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  static Future<Response> post({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    return await _dio.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }
}