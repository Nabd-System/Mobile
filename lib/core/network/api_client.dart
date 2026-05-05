import 'package:dio/dio.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/core/network/api_interceptors.dart';
import 'package:nabd/core/network/endpoints.dart';

class ApiClient {
  static late Dio _dio;

  static Dio get dio => _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);
  }

  // ==================== GET ====================
  static Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== POST ====================
  static Future<Response> post({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== PUT ====================
  static Future<Response> put({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== PATCH ====================
  static Future<Response> patch({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== DELETE ====================
  static Future<Response> delete({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== Error Handler ====================
  static Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Connection timeout. Please try again',
        );

      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');

      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response);

      case DioExceptionType.cancel:
        return ServerException(message: 'Request was cancelled');

      default:
        return ServerException(
          message: 'Something went wrong. Please try again',
        );
    }
  }

  static Exception _handleStatusCode(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['title'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return ServerException(message: message, statusCode: 400);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return UnauthorizedException(message: 'Access denied');
      case 404:
        return ServerException(message: 'Not found', statusCode: 404);
      case 409:
        return ServerException(message: message, statusCode: 409);
      case 422:
        return ServerException(message: message, statusCode: 422);
      case 500:
        return ServerException(
          message: 'Server error. Please try later',
          statusCode: 500,
        );
      default:
        return ServerException(message: message, statusCode: statusCode);
    }
  }
}
